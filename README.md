# Portfolio Website

A modern, responsive portfolio website with a contact form functionality and enhanced security features.

## Features

- Responsive design
- Contact form with email notifications
- Project gallery with filtering
- Mobile-friendly navigation
- Accessibility features
- Enhanced security with rate limiting and CORS
- Production-ready configuration
- Comprehensive error handling
- Request logging

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd portfolio-website
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
   Create a `.env` file with the following configuration:
```
# Server Configuration
PORT=3000
NODE_ENV=development

# Security
ALLOWED_ORIGIN=http://localhost:3000

# SMTP Configuration
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-email@example.com
SMTP_PASS=your-smtp-password
SMTP_FROM_EMAIL=your-email@example.com

# Contact Form Configuration
CONTACT_EMAIL=your-email@example.com

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000  # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100  # Maximum requests per window
```

4. Start the development server:
```bash
npm run dev
```

5. For production:
```bash
npm run prod
```

## Security Features

### Rate Limiting
The API endpoints are protected with rate limiting:
- 100 requests per 15 minutes window per IP
- Customizable through environment variables

### CORS Protection
- Development: Allows localhost:3000
- Production: Requires ALLOWED_ORIGIN environment variable

### Additional Security
- Helmet.js for secure HTTP headers
- Request size limiting
- Input sanitization
- Production error handling
- Secure static file serving with cache control

## SMTP Configuration

The contact form uses Nodemailer to send emails. You can use various SMTP services:

### Gmail
```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
```
Note: For Gmail, you'll need to use an App Password if 2FA is enabled.

### Outlook/Office 365
```
SMTP_HOST=smtp.office365.com
SMTP_PORT=587
SMTP_SECURE=false
```

### Custom SMTP Server
Configure according to your provider's specifications.

## Development

- `npm run dev`: Starts development server with hot reload
- `npm run prod`: Starts production server with optimized settings
- `npm start`: Alias for `npm run prod`
- `npm test`: Runs tests (when implemented)

## Directory Structure

```
portfolio-website/
├── server/
│   └── server.js
├── css/
│   └── styles.css
├── js/
│   └── app.js
├── images/
├── index.html
├── about.html
├── projects.html
├── contact.html
├── package.json
└── README.md
```

## Error Handling

The server implements comprehensive error handling:
- Custom 404 handler for missing routes
- Production vs development error messages
- SMTP connection error handling
- Rate limit exceeded notifications
- Input validation errors
- Sanitized error responses

## Logging

Request logging is implemented using Morgan:
- HTTP method
- URL
- Status code
- Response time
- Request size

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 