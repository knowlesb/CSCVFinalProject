-- Initialize portfolio database

-- Create database if it doesn't exist
CREATE DATABASE portfolio_db;

-- Connect to the database
\c portfolio_db

-- Set timezone
SET timezone = 'UTC';

-- Load schema
\i schema.sql

-- Load functions
\i functions.sql

-- Load sample data
\i seed.sql

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO current_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO current_user;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_projects_created_at ON projects(created_at);
CREATE INDEX IF NOT EXISTS idx_contact_submissions_submitted_at ON contact_submissions(submitted_at);
CREATE INDEX IF NOT EXISTS idx_project_views_timestamp ON project_views(timestamp);

-- Vacuum analyze for query optimization
VACUUM ANALYZE; 