-- Function to get project statistics
CREATE OR REPLACE FUNCTION get_project_stats()
RETURNS TABLE (
    total_projects INTEGER,
    featured_projects INTEGER,
    total_views INTEGER,
    most_viewed_project VARCHAR,
    most_used_technology VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    WITH stats AS (
        SELECT
            (SELECT COUNT(*) FROM projects) as total_projects,
            (SELECT COUNT(*) FROM projects WHERE featured = true) as featured_projects,
            (SELECT COUNT(*) FROM project_views) as total_views,
            (
                SELECT title
                FROM projects p
                LEFT JOIN project_views pv ON p.id = pv.project_id
                GROUP BY p.id, p.title
                ORDER BY COUNT(pv.id) DESC
                LIMIT 1
            ) as most_viewed_project,
            (
                SELECT technology
                FROM (
                    SELECT UNNEST(technologies) as technology
                    FROM projects
                ) t
                GROUP BY technology
                ORDER BY COUNT(*) DESC
                LIMIT 1
            ) as most_used_technology
    )
    SELECT * FROM stats;
END;
$$ LANGUAGE plpgsql;

-- Function to search projects by technology
CREATE OR REPLACE FUNCTION search_projects_by_tech(tech_name VARCHAR)
RETURNS TABLE (
    id INTEGER,
    title VARCHAR,
    description TEXT,
    technologies TEXT[],
    category VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.title, p.description, p.technologies, p.category
    FROM projects p
    WHERE tech_name = ANY(p.technologies)
    ORDER BY p.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to get contact submission statistics
CREATE OR REPLACE FUNCTION get_contact_stats(days INTEGER)
RETURNS TABLE (
    submission_date DATE,
    submission_count INTEGER,
    response_rate NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        DATE(submitted_at),
        COUNT(*),
        ROUND(
            (COUNT(*) FILTER (WHERE responded = true))::NUMERIC /
            COUNT(*)::NUMERIC * 100,
            2
        )
    FROM contact_submissions
    WHERE submitted_at >= NOW() - (days || ' days')::INTERVAL
    GROUP BY DATE(submitted_at)
    ORDER BY DATE(submitted_at) DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to update project timestamps
CREATE OR REPLACE FUNCTION update_project_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for project updates
CREATE TRIGGER project_timestamp_trigger
    BEFORE UPDATE ON projects
    FOR EACH ROW
    EXECUTE FUNCTION update_project_timestamp();

-- Function to clean old project views
CREATE OR REPLACE FUNCTION clean_old_project_views(days INTEGER)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM project_views
    WHERE timestamp < NOW() - (days || ' days')::INTERVAL;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to get project view trends
CREATE OR REPLACE FUNCTION get_project_view_trends(days INTEGER)
RETURNS TABLE (
    project_title VARCHAR,
    view_count INTEGER,
    trend_percentage NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH current_period AS (
        SELECT p.title, COUNT(pv.id) as views
        FROM projects p
        LEFT JOIN project_views pv ON p.id = pv.project_id
        WHERE pv.timestamp >= NOW() - (days || ' days')::INTERVAL
        GROUP BY p.id, p.title
    ),
    previous_period AS (
        SELECT p.title, COUNT(pv.id) as views
        FROM projects p
        LEFT JOIN project_views pv ON p.id = pv.project_id
        WHERE pv.timestamp >= NOW() - (days * 2 || ' days')::INTERVAL
        AND pv.timestamp < NOW() - (days || ' days')::INTERVAL
        GROUP BY p.id, p.title
    )
    SELECT 
        cp.title,
        cp.views,
        CASE 
            WHEN pp.views = 0 THEN 100
            ELSE ROUND((cp.views - pp.views)::NUMERIC / pp.views * 100, 2)
        END as trend
    FROM current_period cp
    LEFT JOIN previous_period pp ON cp.title = pp.title
    ORDER BY cp.views DESC;
END;
$$ LANGUAGE plpgsql; 