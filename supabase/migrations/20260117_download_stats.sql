-- Download Statistics Table
-- Tracks APK downloads from landing page

CREATE TABLE IF NOT EXISTS download_stats (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    platform TEXT NOT NULL DEFAULT 'android',
    source TEXT DEFAULT 'landing_page',
    user_agent TEXT,
    ip_country TEXT,
    downloaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE download_stats ENABLE ROW LEVEL SECURITY;

-- Allow anonymous inserts (for tracking downloads)
CREATE POLICY "Allow anonymous inserts" ON download_stats
    FOR INSERT TO anon
    WITH CHECK (true);

-- Only allow authenticated users to view stats
CREATE POLICY "Authenticated users can view stats" ON download_stats
    FOR SELECT TO authenticated
    USING (true);

-- Create index for faster queries
CREATE INDEX idx_download_stats_date ON download_stats(downloaded_at);
CREATE INDEX idx_download_stats_platform ON download_stats(platform);

-- View for daily download counts
CREATE OR REPLACE VIEW daily_downloads AS
SELECT
    DATE(downloaded_at) as date,
    platform,
    COUNT(*) as downloads
FROM download_stats
GROUP BY DATE(downloaded_at), platform
ORDER BY date DESC;
