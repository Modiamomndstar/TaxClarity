-- ============================================
-- TAXCLARITY NG - COMPLETE DATABASE FIX
-- Run this entire script in Supabase SQL Editor
-- This will reset all data and create correct rules
-- ============================================

-- Step 1: Delete all existing data
DELETE FROM user_action_items;
DELETE FROM action_item_templates;
DELETE FROM tax_rules;

-- Step 2: Set all tax_profiles to NULL to force re-questionnaire
-- (Optional - comment out if you want to keep user profiles)
-- DELETE FROM tax_profiles;

-- ============================================
-- SALARY EARNER TAX RULES (3 rules)
-- ============================================

-- Rule 1: Salary Earner - Exempt (Below ₦800,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_EXEMPT_001',
  ARRAY['salary_earner'],
  0,
  800000,
  0,
  'exempt',
  'Low Income Salary Earner Exemption',
  'Great news! As a salary earner with annual income below ₦800,000, you are completely exempt from personal income tax under the 2026 tax reforms. This exemption was introduced to reduce the tax burden on low-income workers. You do not need to pay any income tax, but it''s good practice to keep your payslips as proof of your income level.',
  ARRAY['Keep payslips as income proof'],
  true
);

-- Rule 2: Salary Earner - Lower Middle (₦800,001 - ₦1,500,000) - 7%
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_TAX_002',
  ARRAY['salary_earner'],
  800001,
  1500000,
  7,
  'taxable',
  'Lower Middle Income Tax Bracket',
  'Your annual income falls in the ₦800,001 to ₦1,500,000 bracket. Under the 2026 progressive tax system, you are taxed at 7% on your taxable income. Your employer should be deducting this as PAYE (Pay As You Earn) from your monthly salary. You are required to file an annual tax return to confirm your tax status.',
  ARRAY['Ensure employer deducts PAYE correctly', 'File annual tax returns', 'Keep copies of payslips and tax deduction statements'],
  true
);

-- Rule 3: Salary Earner - Middle to High (₦1,500,001 - ₦25,000,000) - 15%
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_TAX_003',
  ARRAY['salary_earner'],
  1500001,
  100000000,
  15,
  'taxable',
  'Middle to High Income Tax Bracket',
  'Your income is in the ₦1.5 million+ range. The 2026 reforms apply a 15% tax rate to this bracket. Your employer handles PAYE deductions, but you must file annual returns and may be eligible for certain deductions like pension contributions (up to 8%), mortgage interest, and health insurance premiums.',
  ARRAY['File annual tax returns before March 31', 'Review PAYE deductions monthly', 'Claim eligible deductions', 'Register on FIRS TaxPro Max portal'],
  true
);

-- ============================================
-- FREELANCER TAX RULES (3 rules)
-- ============================================

-- Rule 4: Freelancer - Exempt (Below ₦800,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_EXEMPT_001',
  ARRAY['freelancer'],
  0,
  800000,
  0,
  'exempt',
  'Freelancer Low Income Exemption',
  'As a freelancer earning below ₦800,000 annually, you are exempt from income tax under the 2026 reforms. However, unlike salary earners, you must still register with FIRS to obtain a Tax Identification Number (TIN). This is mandatory for all self-employed individuals regardless of income level.',
  ARRAY['Register with FIRS for TIN', 'Keep records of all income', 'Save invoices and receipts'],
  true
);

-- Rule 5: Freelancer - Standard (₦800,001 - ₦3,000,000) - 10%
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_TAX_002',
  ARRAY['freelancer'],
  800001,
  3000000,
  10,
  'taxable',
  'Freelancer Standard Tax Rate',
  'Your freelance income between ₦800,001 and ₦3,000,000 is subject to 10% tax. As a self-employed person, you are responsible for calculating and paying your own taxes. The 2026 reforms require quarterly estimated tax payments to spread your tax burden throughout the year.',
  ARRAY['Register as self-employed with FIRS', 'Pay quarterly estimated taxes', 'File annual tax returns', 'Keep detailed income and expense records', 'Issue invoices for all work'],
  true
);

-- Rule 6: Freelancer - High Income (₦3,000,001+) - 18%
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_TAX_003',
  ARRAY['freelancer'],
  3000001,
  100000000,
  18,
  'taxable',
  'High-Income Freelancer Tax Bracket',
  'Your income above ₦3 million puts you in the 18% tax bracket. At this level, it''s highly recommended to work with a tax professional. If your turnover exceeds ₦25 million, you must register for VAT. Consider incorporating as a company for tax efficiency.',
  ARRAY['Engage a tax consultant', 'Pay quarterly estimated taxes', 'Consider VAT registration if above ₦25M', 'Maintain professional accounting records', 'File annual returns with supporting documents'],
  true
);

-- ============================================
-- SMALL BUSINESS TAX RULES (2 rules)
-- ============================================

-- Rule 7: Small Business - Exempt (Below ₦25,000,000 turnover)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'BUSINESS_EXEMPT_001',
  ARRAY['small_business'],
  0,
  25000000,
  0,
  'exempt',
  'Small Business Turnover Exemption',
  'Your business with annual turnover below ₦25 million qualifies for Company Income Tax (CIT) exemption under the 2026 reforms. This is a significant benefit for small businesses. You must still register with CAC and FIRS, maintain proper books, and file nil returns annually.',
  ARRAY['Register business with CAC', 'Obtain business TIN from FIRS', 'File annual nil returns', 'Maintain proper financial records', 'Remit employee PAYE if you have staff'],
  true
);

-- Rule 8: Small Business - Taxable (₦25,000,001+) - 20% CIT
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'BUSINESS_TAX_002',
  ARRAY['small_business'],
  25000001,
  100000000,
  20,
  'taxable',
  'Small/Medium Business Tax Rate',
  'Your business turnover above ₦25 million attracts a 20% Company Income Tax rate under the 2026 reforms. Professional tax and accounting support is essential. You must file quarterly returns, make advance tax payments, and register for VAT.',
  ARRAY['Engage a tax consultant', 'File quarterly CIT returns', 'Make advance tax payments', 'Submit audited financial statements', 'Register for VAT', 'Remit employee PAYE and pension', 'File annual returns before June 30'],
  true
);

-- ============================================
-- ACTION ITEM TEMPLATES - SALARY EARNER
-- ============================================

-- Templates for SALARY_EXEMPT_001 (Low income salary earner - exempt)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Verify exemption status with employer', 
  'Confirm with your HR department that your tax status is set to "exempt" in their payroll system. Under the 2026 reforms, salary earners below ₦800,000/year are exempt from PAYE. Request written confirmation from HR.', 
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Organize your payslips', 
  'Save all your 2026 payslips (physical or digital). These serve as proof that your annual income stays below the ₦800,000 exemption threshold. Store them in a safe place for at least 6 years.', 
  'medium', 30, 2
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

-- Templates for SALARY_TAX_002 (₦800,001 - ₦1,500,000 at 7%)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Verify PAYE deductions on payslip', 
  'Check your latest payslip to confirm 7% PAYE is being deducted from your taxable income. Your taxable income is your gross salary minus pension contributions (up to 8%) and other allowable deductions. If the deduction seems wrong, speak to HR immediately.', 
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Register on FIRS TaxPro Max', 
  'Create an account at taxpromax.firs.gov.ng to access your Tax Identification Number (TIN) and file returns online. You''ll need your BVN, email, and phone number. This portal is essential for all tax matters.', 
  'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Request tax deduction certificate', 
  'After year-end (December), ask your employer for Form H1 - your annual tax deduction certificate. This document shows all PAYE deducted on your behalf and is required for filing your annual returns.', 
  'medium', 90, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

-- Templates for SALARY_TAX_003 (₦1,500,001+ at 15%)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Review monthly PAYE deductions', 
  'At your income level, 15% PAYE should be deducted from your taxable income each month. Check your payslip monthly. Taxable income = Gross salary - Pension contribution - Other approved deductions.', 
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Register on FIRS TaxPro Max portal', 
  'If you haven''t already, create your account at taxpromax.firs.gov.ng. This is mandatory for filing your annual tax return. You''ll need your BVN, valid email, and phone number.', 
  'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Gather documents for tax deductions', 
  'Collect documents that can reduce your taxable income: Pension contribution statements (up to 8% of salary), Health insurance receipts, Life insurance premiums, Mortgage interest statements. Keep these organized for your tax filing.', 
  'medium', 30, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'File annual tax return', 
  'Submit your annual Personal Income Tax return before March 31, 2027. Even though your employer deducts PAYE, you''re still required to file a return. Use TaxPro Max or visit your State Internal Revenue Service.', 
  'high', 73, 4
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

-- ============================================
-- ACTION ITEM TEMPLATES - FREELANCER
-- ============================================

-- Templates for FREELANCER_EXEMPT_001 (Below ₦800,000 - exempt)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Register with FIRS for TIN', 
  'Even though you''re exempt from income tax, all self-employed individuals must have a Tax Identification Number. Visit taxpromax.firs.gov.ng to register. You''ll need your BVN, NIN, and a valid ID.', 
  'high', 21, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Set up income tracking system', 
  'Create a simple spreadsheet to track all income you receive: date, client name, amount, and payment method. This proves you''re below the ₦800,000 threshold. Apps like Wave or simple Excel work well.', 
  'medium', 14, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Organize invoices and receipts', 
  'Create a folder (Google Drive, physical folder, or cloud storage) to save all invoices you send to clients and receipts for business expenses. This documentation is essential if FIRS ever asks for proof.', 
  'low', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

-- Templates for FREELANCER_TAX_002 (₦800,001 - ₦3,000,000 at 10%)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Register as self-employed with FIRS', 
  'Complete your self-employment registration at taxpromax.firs.gov.ng. Select "Individual" then "Self-Employed". You''ll receive your TIN and can begin filing. Have your BVN, NIN, and business address ready.', 
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Calculate your quarterly tax payment', 
  'Under 2026 rules, freelancers pay tax quarterly. Calculate 10% of your estimated quarterly income and set it aside. Payment deadlines: Q1 (Apr 30), Q2 (Jul 31), Q3 (Oct 31), Q4 (Jan 31). Late payment attracts penalties.', 
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Open a separate business account', 
  'Open a dedicated bank account for your freelance income. This separates personal and business money, making tax calculation much easier. Most banks offer SME accounts with low minimum balances.', 
  'medium', 21, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Create a proper invoicing system', 
  'Use a consistent invoice template with your name/business name, address, TIN, client details, description of work, amount, and date. Apps like Wave, Zoho Invoice, or even a Word template work well. Keep copies of all invoices.', 
  'medium', 14, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

-- Templates for FREELANCER_TAX_003 (₦3,000,001+ at 18%)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Engage a tax consultant', 
  'At your income level (₦3M+), professional tax advice is essential. Find a registered tax practitioner through the Chartered Institute of Taxation of Nigeria (CITN) directory. They can help optimize your tax position legally.', 
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Review VAT registration requirements', 
  'If your annual turnover exceeds ₦25 million, you MUST register for VAT. Even if below, voluntary registration may benefit you (input VAT recovery). Check your total revenue and consult your tax advisor.', 
  'high', 21, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Set up professional accounting', 
  'At this income level, you need proper accounting software. Consider QuickBooks, Sage, or Xero. If budget allows, hire a part-time bookkeeper. Proper records are essential for tax filing and potential audits.', 
  'high', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Consider business incorporation', 
  'Discuss with your tax consultant whether registering a Limited Liability Company (LLC) offers benefits. Company profits are taxed at 20% (vs 18% individual), but there are other advantages like limited liability and easier access to business contracts.', 
  'medium', 60, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

-- ============================================
-- ACTION ITEM TEMPLATES - SMALL BUSINESS
-- ============================================

-- Templates for BUSINESS_EXEMPT_001 (Below ₦25M - CIT exempt)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Register your business with CAC', 
  'If not already registered, complete your business registration with Corporate Affairs Commission (CAC). You can register as Business Name (₦10,000-₦25,000) or Limited Company (from ₦100,000). Visit cac.gov.ng for online registration.', 
  'high', 21, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Obtain your business TIN', 
  'Register your business for Tax Identification Number at taxpromax.firs.gov.ng. You''ll need your CAC registration certificate, directors'' details, and business address. This is different from your personal TIN.', 
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Set up basic bookkeeping', 
  'Even though you''re CIT exempt, you must maintain financial records. Use accounting software like Wave (free) or QuickBooks to track income and expenses. At minimum, keep a cash book recording all money in and out.', 
  'medium', 30, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Learn about employee tax obligations', 
  'If you have employees, you MUST deduct and remit PAYE and pension contributions. PAYE is paid monthly to your state IRS. Pension (minimum 18% of basic + housing + transport) goes to an approved PFA. Non-compliance attracts heavy penalties.', 
  'medium', 45, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'File annual nil CIT return', 
  'Even with zero tax liability, you must file an annual Company Income Tax return (nil return) with FIRS. The deadline is 6 months after your financial year end. For December year-end, file by June 30.', 
  'low', 180, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

-- Templates for BUSINESS_TAX_002 (₦25M+ at 20% CIT)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Engage a tax consultant immediately', 
  'At your turnover level (₦25M+), professional tax management is non-negotiable. Find a CITN-registered tax consultant or a reputable accounting firm. They''ll help with tax planning, compliance, and audits.', 
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Register for VAT', 
  'Businesses with turnover above ₦25 million MUST register for VAT. Apply on the FIRS portal. You''ll charge 7.5% VAT on taxable supplies and can recover input VAT on business purchases. Monthly returns are due by the 21st.', 
  'high', 21, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Set up quarterly CIT payments', 
  'Companies must pay Company Income Tax in quarterly installments based on estimated annual profit. Work with your accountant to calculate and schedule payments to avoid year-end cash flow pressure.', 
  'high', 30, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Implement proper accounting software', 
  'At this level, you need professional accounting software like QuickBooks, Sage, or Odoo. Consider hiring a full-time or part-time accountant. Proper financial management is critical for tax compliance and business decisions.', 
  'high', 30, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Plan for annual audit', 
  'Companies with turnover above ₦10 million should have audited financial statements. Engage a chartered accountant for your year-end audit. Start the process at least 3 months before your filing deadline.', 
  'medium', 60, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id, 
  'Ensure employee tax compliance', 
  'Review that PAYE deductions (using the new 2026 rates) are calculated correctly for all employees. Confirm pension contributions are being remitted monthly. Non-compliance can result in penalties up to 10% of unpaid amounts plus interest.', 
  'high', 14, 6
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

-- ============================================
-- VERIFICATION - Run this to confirm setup
-- ============================================
-- SELECT 
--   r.rule_code,
--   r.applies_to[1] as work_type,
--   r.income_min,
--   r.income_max,
--   r.tax_rate,
--   COUNT(t.id) as action_count
-- FROM tax_rules r
-- LEFT JOIN action_item_templates t ON t.tax_rule_id = r.id
-- GROUP BY r.id
-- ORDER BY r.applies_to, r.income_min;
