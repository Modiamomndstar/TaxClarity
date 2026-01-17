-- TaxClarity NG Seed Data
-- Run this after creating tables to populate tax rules

-- ============================================
-- Clear existing data (optional, for fresh start)
-- ============================================
-- DELETE FROM action_item_templates;
-- DELETE FROM tax_rules;

-- ============================================
-- SALARY EARNER TAX RULES
-- ============================================

-- Rule 1: Salary Earner - Exempt (Below ₦800,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'SALARY_EXEMPT_001',
  ARRAY['salary_earner'],
  0,
  800000,
  0,
  'exempt',
  'Low Income Salary Earner Exemption',
  'Great news! As a salary earner with annual income below ₦800,000, you are completely exempt from personal income tax under the 2026 tax reforms. This exemption was introduced to reduce the tax burden on low-income workers. You do not need to pay any income tax, but it''s good practice to keep your payslips as proof of your income level.',
  ARRAY['Keep payslips as income proof']
);

-- Rule 2: Salary Earner - Taxable (₦800,001 - ₦1,500,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'SALARY_TAX_002',
  ARRAY['salary_earner'],
  800001,
  1500000,
  7,
  'taxable',
  'Lower Middle Income Tax Bracket',
  'Your annual income falls in the ₦800,001 to ₦1,500,000 bracket. Under the 2026 progressive tax system, you are taxed at 7% on your taxable income. Your employer should be deducting this as PAYE (Pay As You Earn) from your monthly salary. You are required to file an annual tax return to confirm your tax status.',
  ARRAY['Ensure employer deducts PAYE correctly', 'File annual tax returns', 'Keep copies of payslips and tax deduction statements']
);

-- Rule 3: Salary Earner - Higher Income (₦1,500,001 - ₦12,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'SALARY_TAX_003',
  ARRAY['salary_earner'],
  1500001,
  12000000,
  15,
  'taxable',
  'Middle Income Tax Bracket',
  'Your income is in the ₦1.5 million to ₦12 million range. The 2026 reforms apply a 15% tax rate to this bracket. Your employer handles PAYE deductions, but you must file annual returns and may be eligible for certain deductions like pension contributions, mortgage interest, and health insurance premiums.',
  ARRAY['File annual tax returns before March 31', 'Review PAYE deductions monthly', 'Claim eligible deductions', 'Register on FIRS TaxPro Max portal']
);

-- ============================================
-- FREELANCER TAX RULES
-- ============================================

-- Rule 4: Freelancer - Exempt (Below ₦800,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'FREELANCER_EXEMPT_001',
  ARRAY['freelancer'],
  0,
  800000,
  0,
  'exempt',
  'Freelancer Low Income Exemption',
  'As a freelancer earning below ₦800,000 annually, you are exempt from income tax under the 2026 reforms. However, unlike salary earners, you must still register with FIRS to obtain a Tax Identification Number (TIN). This is mandatory for all self-employed individuals regardless of income level.',
  ARRAY['Register with FIRS for TIN', 'Keep records of all income', 'Save invoices and receipts']
);

-- Rule 5: Freelancer - Taxable (₦800,001 - ₦3,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'FREELANCER_TAX_002',
  ARRAY['freelancer'],
  800001,
  3000000,
  10,
  'taxable',
  'Freelancer Standard Tax Rate',
  'Your freelance income between ₦800,001 and ₦3,000,000 is subject to 10% tax. As a self-employed person, you are responsible for calculating and paying your own taxes. The 2026 reforms require quarterly estimated tax payments to spread your tax burden throughout the year and avoid a large payment at year-end.',
  ARRAY['Register as self-employed with FIRS', 'Pay quarterly estimated taxes', 'File annual tax returns', 'Keep detailed income and expense records', 'Issue invoices for all work']
);

-- Rule 6: Freelancer - Higher Income (₦3,000,001 - ₦25,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'FREELANCER_TAX_003',
  ARRAY['freelancer'],
  3000001,
  25000000,
  18,
  'taxable',
  'High-Income Freelancer Tax Bracket',
  'Congratulations on your success! Your income above ₦3 million puts you in the 18% tax bracket. At this level, it''s highly recommended to work with a tax professional. You may need to register for VAT if your turnover exceeds ₦25 million. Consider setting up a proper business structure for better tax efficiency.',
  ARRAY['Engage a tax consultant', 'Pay quarterly estimated taxes', 'Consider VAT registration', 'Maintain professional accounting records', 'File annual returns with supporting documents']
);

-- ============================================
-- SMALL BUSINESS TAX RULES
-- ============================================

-- Rule 7: Small Business - Exempt (Below ₦25,000,000 turnover)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'BUSINESS_EXEMPT_001',
  ARRAY['small_business'],
  0,
  25000000,
  0,
  'exempt',
  'Small Business Turnover Exemption',
  'Your business with annual turnover below ₦25 million qualifies for Company Income Tax (CIT) exemption under the 2026 reforms. This is a significant benefit designed to support small businesses. However, you must still register with CAC and FIRS, maintain proper books, and file nil returns annually.',
  ARRAY['Register business with CAC', 'Obtain business TIN from FIRS', 'File annual nil returns', 'Maintain proper financial records', 'Remit employee PAYE if you have staff']
);

-- Rule 8: Small Business - Taxable (₦25,000,001 - ₦100,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations)
VALUES (
  'BUSINESS_TAX_002',
  ARRAY['small_business'],
  25000001,
  100000000,
  20,
  'taxable',
  'Small/Medium Business Tax Rate',
  'Your business turnover between ₦25 million and ₦100 million attracts a 20% Company Income Tax rate under the 2026 reforms. At this level, professional tax and accounting support is essential. You must file quarterly returns, make advance tax payments, and may need to register for VAT.',
  ARRAY['Engage a tax consultant', 'File quarterly CIT returns', 'Make advance tax payments', 'Submit audited financial statements', 'Register for VAT if applicable', 'Remit employee PAYE and pension', 'File annual returns before June 30']
);

-- ============================================
-- ACTION ITEM TEMPLATES FOR EACH RULE
-- ============================================

-- Templates for SALARY_EXEMPT_001
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Verify exemption status with employer', 'Confirm with your HR department that they have updated your tax status to ''exempt'' in their payroll system. Request a written confirmation.', 'high', 14, 1
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Keep income proof documents', 'Organize and save all your payslips from 2026. These serve as proof that your annual income stays below ₦800,000.', 'medium', 30, 2
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

-- Templates for SALARY_TAX_002
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Verify PAYE deductions on payslip', 'Check your latest payslip to confirm 7% PAYE is being deducted. If not, speak to HR immediately.', 'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Register on FIRS TaxPro Max', 'Create an account at taxpromax.firs.gov.ng to access your TIN and file returns online.', 'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Request tax deduction certificate', 'Ask your employer for your annual tax deduction certificate (Form H1) after year-end.', 'medium', 90, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

-- Templates for SALARY_TAX_003
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Review monthly PAYE deductions', 'Check that 15% is being deducted from your taxable income each month.', 'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Register on FIRS portal', 'Set up your TaxPro Max account if you haven''t already.', 'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Gather deduction documents', 'Collect pension statements, health insurance receipts, and mortgage documents for potential deductions.', 'medium', 30, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'File annual tax return', 'Submit your annual tax return before March 31, 2027 deadline.', 'high', 365, 4
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

-- Templates for FREELANCER_EXEMPT_001
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Register with FIRS for TIN', 'Even though you''re exempt, registration is mandatory. Visit taxpromax.firs.gov.ng to apply.', 'high', 21, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Set up income tracking system', 'Create a simple spreadsheet or use an app to track all income you receive.', 'medium', 14, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Organize invoices and receipts', 'Create a folder (physical or digital) to store all invoices and payment receipts.', 'low', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

-- Templates for FREELANCER_TAX_002
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Register as self-employed on FIRS', 'Complete self-employment registration at taxpromax.firs.gov.ng.', 'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Calculate quarterly tax payment', 'Estimate 10% of your quarterly income and prepare for payment.', 'high', 30, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Set up business bank account', 'Open a dedicated account for business income to simplify tracking.', 'medium', 21, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Create invoicing system', 'Use a proper invoicing system to document all client payments.', 'medium', 14, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

-- Templates for FREELANCER_TAX_003
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Engage a tax consultant', 'At this income level, professional tax advice is essential. Find a registered tax practitioner.', 'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Review VAT registration requirements', 'Check if your turnover requires VAT registration (threshold is ₦25 million).', 'high', 21, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Set up professional accounting', 'Implement proper bookkeeping software or hire an accountant.', 'high', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Consider business incorporation', 'Discuss with your tax consultant whether incorporating as a limited company offers benefits.', 'medium', 60, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

-- Templates for BUSINESS_EXEMPT_001
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Register business with CAC', 'Complete business name or company registration at Corporate Affairs Commission.', 'high', 21, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Obtain business TIN', 'Register your business for Tax Identification Number on FIRS portal.', 'high', 30, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Set up bookkeeping system', 'Implement basic accounting to track income and expenses properly.', 'medium', 30, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Understand employee tax obligations', 'If you have employees, learn about PAYE and pension deduction requirements.', 'medium', 45, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'File annual nil returns', 'Submit nil returns to FIRS annually, even though you''re exempt.', 'low', 365, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

-- Templates for BUSINESS_TAX_002
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Engage tax consultant immediately', 'At this turnover level, professional tax management is essential.', 'high', 7, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Register for VAT', 'Turnover above ₦25 million requires VAT registration. Apply on FIRS portal.', 'high', 21, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Set up quarterly CIT payments', 'Arrange with your accountant for advance Company Income Tax payments.', 'high', 30, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Implement accounting software', 'Use professional accounting software for proper financial management.', 'high', 30, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Prepare for annual audit', 'Engage an auditor for your year-end financial statements.', 'medium', 60, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 'Review employee compliance', 'Ensure PAYE and pension remittances are up to date for all employees.', 'high', 14, 6
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Run this to verify the seed data was inserted correctly:
-- SELECT r.rule_code, r.title, r.exemption_status, COUNT(t.id) as template_count
-- FROM tax_rules r
-- LEFT JOIN action_item_templates t ON t.tax_rule_id = r.id
-- GROUP BY r.id
-- ORDER BY r.rule_code;
