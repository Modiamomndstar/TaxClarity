-- ============================================
-- DIAGNOSTIC QUERIES - RUN THESE FIRST
-- ============================================

-- 1. Check how many tax rules exist
SELECT COUNT(*) as rule_count FROM tax_rules;

-- 2. See all tax rules with their work types
SELECT id, rule_code, applies_to, income_min, income_max, tax_rate, exemption_status
FROM tax_rules
ORDER BY applies_to, income_min;

-- 3. Check action item templates per rule
SELECT
  r.rule_code,
  r.applies_to,
  COUNT(t.id) as template_count
FROM tax_rules r
LEFT JOIN action_item_templates t ON t.tax_rule_id = r.id
GROUP BY r.id, r.rule_code, r.applies_to
ORDER BY r.applies_to, r.rule_code;

-- 4. Check if there are action items for your user and what rule they belong to
SELECT
  uai.title,
  uai.priority,
  r.rule_code,
  r.applies_to
FROM user_action_items uai
LEFT JOIN tax_rules r ON r.id = uai.tax_rule_id
ORDER BY uai.created_at DESC
LIMIT 20;

-- ============================================
-- FIX: DELETE ALL EXISTING DATA AND RESEED
-- ============================================

-- First, delete user action items (they will be regenerated)
DELETE FROM user_action_items;

-- Delete existing templates
DELETE FROM action_item_templates;

-- Delete existing rules
DELETE FROM tax_rules;

-- Now run the seed file (002_seed_tax_rules.sql) to repopulate

-- ============================================
-- AFTER RESEEDING, VERIFY WITH:
-- ============================================

-- Should show 8 rules
SELECT rule_code, applies_to, income_min, income_max FROM tax_rules ORDER BY applies_to, income_min;

-- Should show templates for each rule
SELECT
  r.rule_code,
  r.applies_to[1] as work_type,
  t.title,
  t.sort_order
FROM tax_rules r
JOIN action_item_templates t ON t.tax_rule_id = r.id
ORDER BY r.applies_to, r.income_min, t.sort_order;
