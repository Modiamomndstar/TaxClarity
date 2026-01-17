-- ============================================
-- TAXCLARITY NG - ANALYTICS TABLES
-- Run this in Supabase SQL Editor to enable tracking
-- ============================================

-- 1. Download Statistics Table
CREATE TABLE IF NOT EXISTS download_stats (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    platform VARCHAR(50) DEFAULT 'android',
    source VARCHAR(100),
    user_agent TEXT,
    ip_country VARCHAR(100),
    ip_city VARCHAR(100),
    referrer TEXT
);

-- 2. Page View Statistics Table  
CREATE TABLE IF NOT EXISTS page_views (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    page VARCHAR(255),
    referrer TEXT,
    user_agent TEXT,
    screen_width INTEGER,
    screen_height INTEGER,
    session_id VARCHAR(100)
);

-- 3. Enable Row Level Security but allow anonymous inserts
ALTER TABLE download_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_views ENABLE ROW LEVEL SECURITY;

-- Allow anonymous users to INSERT (for tracking from landing page)
CREATE POLICY "Allow anonymous insert on download_stats" 
ON download_stats FOR INSERT 
TO anon 
WITH CHECK (true);

CREATE POLICY "Allow anonymous insert on page_views" 
ON page_views FOR INSERT 
TO anon 
WITH CHECK (true);

-- Only authenticated users can read (for admin dashboard)
CREATE POLICY "Allow authenticated read on download_stats" 
ON download_stats FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Allow authenticated read on page_views" 
ON page_views FOR SELECT 
TO authenticated 
USING (true);

-- 4. Create helpful views for analytics dashboard
CREATE OR REPLACE VIEW download_summary AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as downloads,
    COUNT(DISTINCT source) as unique_sources
FROM download_stats
GROUP BY DATE(created_at)
ORDER BY date DESC;

CREATE OR REPLACE VIEW page_view_summary AS
SELECT 
    DATE(created_at) as date,
    page,
    COUNT(*) as views,
    COUNT(DISTINCT session_id) as unique_visitors
FROM page_views
GROUP BY DATE(created_at), page
ORDER BY date DESC, views DESC;

-- 5. Function to get total downloads
CREATE OR REPLACE FUNCTION get_total_downloads()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM download_stats);
END;
$$ LANGUAGE plpgsql;

-- 6. Function to get downloads by date range
CREATE OR REPLACE FUNCTION get_downloads_by_range(start_date DATE, end_date DATE)
RETURNS TABLE(date DATE, downloads BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT DATE(created_at), COUNT(*)
    FROM download_stats
    WHERE DATE(created_at) BETWEEN start_date AND end_date
    GROUP BY DATE(created_at)
    ORDER BY DATE(created_at);
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VERIFICATION: Check tables were created
-- ============================================
-- SELECT table_name FROM information_schema.tables 
-- WHERE table_schema = 'public' 
-- AND table_name IN ('download_stats', 'page_views');
