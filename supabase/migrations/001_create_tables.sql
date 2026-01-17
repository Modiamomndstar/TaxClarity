-- TaxClarity NG Database Schema
-- Run this in Supabase SQL Editor to create all tables

-- ============================================
-- 1. TAX PROFILES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tax_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  work_type VARCHAR(50) NOT NULL CHECK (work_type IN ('salary_earner', 'freelancer', 'small_business')),
  income_range_min DECIMAL(15,2) NOT NULL,
  income_range_max DECIMAL(15,2) NOT NULL,
  location VARCHAR(100) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE tax_profiles ENABLE ROW LEVEL SECURITY;

-- Users can only manage their own profile
CREATE POLICY "Users can manage own profile" ON tax_profiles
  FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- 2. TAX RULES TABLE (Static data, public read)
-- ============================================
CREATE TABLE IF NOT EXISTS tax_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rule_code VARCHAR(50) UNIQUE NOT NULL,
  applies_to VARCHAR(50)[] NOT NULL,
  income_min DECIMAL(15,2) NOT NULL,
  income_max DECIMAL(15,2) NOT NULL,
  tax_rate DECIMAL(5,2) NOT NULL,
  exemption_status VARCHAR(20) NOT NULL CHECK (exemption_status IN ('exempt', 'taxable')),
  title VARCHAR(255) NOT NULL,
  explanation TEXT NOT NULL,
  obligations TEXT[],
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE tax_rules ENABLE ROW LEVEL SECURITY;

-- Public can read active tax rules
CREATE POLICY "Public read active tax rules" ON tax_rules
  FOR SELECT USING (active = true);

-- ============================================
-- 3. ACTION ITEM TEMPLATES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS action_item_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tax_rule_id UUID REFERENCES tax_rules(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  priority VARCHAR(20) NOT NULL CHECK (priority IN ('high', 'medium', 'low')),
  due_in_days INTEGER NOT NULL,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE action_item_templates ENABLE ROW LEVEL SECURITY;

-- Public can read templates
CREATE POLICY "Public read templates" ON action_item_templates
  FOR SELECT USING (true);

-- ============================================
-- 4. USER ACTION ITEMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS user_action_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  tax_rule_id UUID REFERENCES tax_rules(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  priority VARCHAR(20) NOT NULL CHECK (priority IN ('high', 'medium', 'low')),
  due_date DATE NOT NULL,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE user_action_items ENABLE ROW LEVEL SECURITY;

-- Users can only manage their own action items
CREATE POLICY "Users can manage own action items" ON user_action_items
  FOR ALL USING (auth.uid() = user_id);

-- Index for faster queries
CREATE INDEX IF NOT EXISTS idx_user_action_items_user_id ON user_action_items(user_id);
CREATE INDEX IF NOT EXISTS idx_user_action_items_due_date ON user_action_items(due_date);

-- ============================================
-- 5. NOTIFICATION DEVICES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS notification_devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  player_id VARCHAR(500) NOT NULL,
  platform VARCHAR(20) NOT NULL CHECK (platform IN ('ios', 'android')),
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, player_id)
);

-- Enable RLS
ALTER TABLE notification_devices ENABLE ROW LEVEL SECURITY;

-- Users can manage their own devices
CREATE POLICY "Users manage own devices" ON notification_devices
  FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- 6. NOTIFICATION HISTORY TABLE (Optional, for tracking)
-- ============================================
CREATE TABLE IF NOT EXISTS notification_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  action_item_id UUID REFERENCES user_action_items(id) ON DELETE SET NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  status VARCHAR(20) DEFAULT 'sent' CHECK (status IN ('sent', 'failed', 'opened')),
  sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE notification_history ENABLE ROW LEVEL SECURITY;

-- Users can read their own notification history
CREATE POLICY "Users read own notifications" ON notification_history
  FOR SELECT USING (auth.uid() = user_id);

-- ============================================
-- 7. UPDATED_AT TRIGGER FUNCTION
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to tax_profiles
DROP TRIGGER IF EXISTS update_tax_profiles_updated_at ON tax_profiles;
CREATE TRIGGER update_tax_profiles_updated_at
  BEFORE UPDATE ON tax_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to notification_devices
DROP TRIGGER IF EXISTS update_notification_devices_updated_at ON notification_devices;
CREATE TRIGGER update_notification_devices_updated_at
  BEFORE UPDATE ON notification_devices
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
