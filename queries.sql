-- Project Queries

-- Get all projects ordered by creation date
SELECT * FROM projects 
ORDER BY created_at DESC;

-- Get featured projects
SELECT * FROM projects 
WHERE featured = true 
ORDER BY created_at DESC;

-- Get projects by category
SELECT * FROM projects 
WHERE category = :category 
ORDER BY created_at DESC;

-- Get projects with specific technology
SELECT * FROM projects 
WHERE :technology = ANY(technologies) 
ORDER BY created_at DESC;

-- Get project count by category
SELECT category, COUNT(*) as project_count 
FROM projects 
GROUP BY category 
ORDER BY project_count DESC;

-- Get latest projects with limited fields
SELECT title, description, image_path, category 
FROM projects 
ORDER BY created_at DESC 
LIMIT 3;

-- Search projects by title or description
SELECT * FROM projects 
WHERE title ILIKE '%' || :search_term || '%' 
   OR description ILIKE '%' || :search_term || '%' 
ORDER BY created_at DESC;

-- Contact Form Queries

-- Get recent contact submissions
SELECT * FROM contact_submissions 
ORDER BY submitted_at DESC 
LIMIT 10;

-- Get unresponded contact submissions
SELECT * FROM contact_submissions 
WHERE responded = false 
ORDER BY submitted_at ASC;

-- Get submission statistics by date
SELECT 
    DATE(submitted_at) as submission_date,
    COUNT(*) as submission_count
FROM contact_submissions 
GROUP BY DATE(submitted_at)
ORDER BY submission_date DESC;

-- Get contact submissions by status
SELECT status, COUNT(*) as status_count 
FROM contact_submissions 
GROUP BY status;

-- Analytics Queries

-- Get daily project views
SELECT 
    DATE(timestamp) as view_date,
    project_id,
    COUNT(*) as view_count
FROM project_views 
GROUP BY DATE(timestamp), project_id
ORDER BY view_date DESC;

-- Get most viewed projects
SELECT 
    p.title,
    COUNT(pv.id) as view_count
FROM projects p
LEFT JOIN project_views pv ON p.id = pv.project_id
GROUP BY p.id, p.title
ORDER BY view_count DESC;

-- Get technology usage across projects
SELECT 
    UNNEST(technologies) as technology,
    COUNT(*) as usage_count
FROM projects
GROUP BY technology
ORDER BY usage_count DESC;

-- Administrative Queries

-- Get inactive projects (no updates in last 6 months)
SELECT * FROM projects
WHERE updated_at < NOW() - INTERVAL '6 months'
ORDER BY updated_at DESC;

-- Get projects without images
SELECT * FROM projects
WHERE image_path IS NULL OR image_path = '';

-- Get projects without GitHub links
SELECT * FROM projects
WHERE github_url IS NULL OR github_url = '';

-- Maintenance Queries

-- Delete old contact submissions
DELETE FROM contact_submissions
WHERE submitted_at < NOW() - INTERVAL '1 year'
AND status = 'completed';

-- Update project timestamps
UPDATE projects
SET updated_at = NOW()
WHERE id = :project_id;

-- Mark all pending submissions as reviewed
UPDATE contact_submissions
SET status = 'reviewed'
WHERE status = 'pending';
