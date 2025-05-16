require('dotenv').config();
const express = require('express');
const nodemailer = require('nodemailer');
const path = require('path');
const rateLimit = require('express-rate-limit');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { sequelize } = require('./models');
const Project = require('./models/Project');

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors({
    origin: process.env.NODE_ENV === 'production' 
        ? process.env.ALLOWED_ORIGIN 
        : 'http://localhost:3000'
}));

// Logging middleware
app.use(morgan('combined'));

// Rate limiting
const limiter = rateLimit({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 900000, // 15 minutes
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);

// Middleware
app.use(express.json({ limit: '10kb' })); // Limit payload size
app.use(express.urlencoded({ extended: false }));

// Serve static files with caching headers
app.use(express.static(path.join(__dirname, '../'), {
    maxAge: '1d',
    setHeaders: (res, path) => {
        if (path.endsWith('.html')) {
            res.setHeader('Cache-Control', 'no-cache');
        }
    }
}));

// Project routes
app.get('/api/projects', async (req, res) => {
    try {
        const projects = await Project.findAll({
            order: [['created_at', 'DESC']]
        });
        res.json(projects);
    } catch (error) {
        console.error('Error fetching projects:', error);
        res.status(500).json({ error: 'Failed to fetch projects' });
    }
});

app.get('/api/projects/:id', async (req, res) => {
    try {
        const project = await Project.findByPk(req.params.id);
        if (!project) {
            return res.status(404).json({ error: 'Project not found' });
        }
        res.json(project);
    } catch (error) {
        console.error('Error fetching project:', error);
        res.status(500).json({ error: 'Failed to fetch project' });
    }
});

app.get('/api/projects/category/:category', async (req, res) => {
    try {
        const projects = await Project.findAll({
            where: { category: req.params.category },
            order: [['created_at', 'DESC']]
        });
        res.json(projects);
    } catch (error) {
        console.error('Error fetching projects by category:', error);
        res.status(500).json({ error: 'Failed to fetch projects' });
    }
});

// Email configuration
const createTransporter = () => {
    return nodemailer.createTransport({
        host: process.env.SMTP_HOST,
        port: process.env.SMTP_PORT,
        secure: process.env.SMTP_SECURE === 'true',
        auth: {
            user: process.env.SMTP_USER,
            pass: process.env.SMTP_PASS
        }
    });
};

// Validate email format
const isValidEmail = (email) => {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
};

// Sanitize input
const sanitizeInput = (str) => {
    return str.replace(/[<>]/g, '');
};

// Contact form endpoint
app.post('/api/contact', async (req, res) => {
    try {
        const { name, email, message } = req.body;

        // Server-side validation
        if (!name || !email || !message) {
            return res.status(400).json({
                success: false,
                error: 'Please provide all required fields'
            });
        }

        if (!isValidEmail(email)) {
            return res.status(400).json({
                success: false,
                error: 'Please provide a valid email address'
            });
        }

        // Sanitize inputs
        const sanitizedName = sanitizeInput(name);
        const sanitizedMessage = sanitizeInput(message);

        // Create transporter for each request
        const transporter = createTransporter();

        // Prepare email content
        const mailOptions = {
            from: process.env.SMTP_FROM_EMAIL,
            to: process.env.CONTACT_EMAIL,
            subject: `Portfolio Contact Form: Message from ${sanitizedName}`,
            html: `
                <h2>New Contact Form Submission</h2>
                <p><strong>Name:</strong> ${sanitizedName}</p>
                <p><strong>Email:</strong> ${email}</p>
                <h3>Message:</h3>
                <p>${sanitizedMessage.replace(/\n/g, '<br>')}</p>
            `,
            replyTo: email
        };

        // Send email
        await transporter.sendMail(mailOptions);

        // Send success response
        res.status(200).json({
            success: true,
            message: 'Your message has been sent successfully'
        });

    } catch (error) {
        console.error('Contact form error:', error);
        
        // Send appropriate error message based on error type
        const errorMessage = error.code === 'ECONNREFUSED'
            ? 'Unable to connect to email server. Please try again later.'
            : 'Failed to send message. Please try again later.';
            
        res.status(500).json({
            success: false,
            error: errorMessage
        });
    }
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        success: false,
        error: 'Resource not found'
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Server error:', err);
    
    // Don't expose internal error details in production
    const errorMessage = process.env.NODE_ENV === 'production'
        ? 'Something went wrong on the server'
        : err.message;
        
    res.status(500).json({
        success: false,
        error: errorMessage
    });
});

// Database connection and server start
sequelize.sync()
    .then(() => {
        console.log('Database connected successfully');
        app.listen(PORT, () => {
            console.log(`Server running on port ${PORT}`);
            console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
        });
    })
    .catch(err => {
        console.error('Unable to connect to the database:', err);
    }); 