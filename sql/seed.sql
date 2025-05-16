-- Sample admin user (password: admin123)
INSERT INTO users (username, email, password_hash, role) VALUES
('admin', 'admin@example.com', '$2a$10$rM7D.Q.F2kzQq7f4z.Xpm.T8U8TN9QF/X3HAZ8UE.B9YuLh1xJlt2', 'admin');

-- Sample projects
INSERT INTO projects (title, description, image_path, technologies, github_url, live_url, category, featured) VALUES
(
    'E-commerce Dashboard',
    'A responsive admin dashboard built with React and Material-UI, featuring real-time sales analytics and inventory management.',
    'img/IMG_213.jpeg',
    ARRAY['React', 'Material-UI', 'Node.js', 'Express', 'MongoDB'],
    'https://github.com/username/ecommerce-dashboard',
    'https://demo-dashboard.example.com',
    'full-stack',
    true
),
(
    'Weather Application',
    'A modern weather application using OpenWeather API, built with Node.js and Express, providing detailed weather forecasts and alerts.',
    'img/IMG_466.jpeg',
    ARRAY['Node.js', 'Express', 'OpenWeather API', 'Bootstrap'],
    'https://github.com/username/weather-app',
    'https://weather-app.example.com',
    'back-end',
    true
),
(
    'Task Management System',
    'A collaborative task management platform featuring real-time updates, user authentication, and team workspace organization.',
    'img/IMG_689.jpeg',
    ARRAY['React', 'Node.js', 'Socket.io', 'PostgreSQL'],
    'https://github.com/username/task-manager',
    'https://task-app.example.com',
    'full-stack',
    false
);

-- Sample contact submissions
INSERT INTO contact_submissions (name, email, message, status, ip_address, user_agent) VALUES
(
    'John Doe',
    'john@example.com',
    'Hi, I''d love to discuss a potential collaboration on an e-commerce project.',
    'pending',
    '192.168.1.1',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
),
(
    'Jane Smith',
    'jane@example.com',
    'Your portfolio is impressive! Are you available for freelance work?',
    'responded',
    '192.168.1.2',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
);

-- Sample project views
INSERT INTO project_views (project_id, ip_address, user_agent) VALUES
(1, '192.168.1.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(1, '192.168.1.2', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'),
(2, '192.168.1.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(3, '192.168.1.3', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15'); 