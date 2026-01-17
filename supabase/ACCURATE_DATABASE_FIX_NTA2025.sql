-- ============================================
-- TAXCLARITY NG - ACCURATE DATABASE FIX
-- Based on Nigeria Tax Act 2025 (NTA 2025)
-- Source: Official NRS Website (nrs.gov.ng)
-- Last Updated: January 2026
-- ============================================

-- Step 1: Delete all existing data
DELETE FROM user_action_items;
DELETE FROM action_item_templates;
DELETE FROM tax_rules;

-- ============================================
-- SALARY EARNER TAX RULES (Based on NTA 2025)
-- Key: Income ≤ ₦800,000 = EXEMPT
-- Progressive bands apply above ₦800,000
-- CRA (Consolidated Relief Allowance) removed
-- New reliefs: Rent, mortgage interest
-- ============================================

-- Rule 1: Salary Earner - EXEMPT (≤ ₦800,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_EXEMPT_001',
  ARRAY['salary_earner'],
  0,
  800000,
  0,
  'exempt',
  'Low Income Exemption (NTA 2025)',
  'Great news! Under the Nigeria Tax Act 2025, salary earners with annual income of ₦800,000 or below are completely EXEMPT from personal income tax. This is a major relief introduced to support low-income workers. Your employer should not deduct any PAYE from your salary. Keep your payslips as proof of your income level in case of any queries.',
  ARRAY['No PAYE should be deducted', 'Keep payslips as income proof', 'Obtain Tax ID (still recommended)'],
  true
);

-- Rule 2: Salary Earner - TAXABLE (₦800,001 - ₦2,200,000) - First taxable band ~7%
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_TAX_002',
  ARRAY['salary_earner'],
  800001,
  2200000,
  7,
  'taxable',
  'First Taxable Band (NTA 2025)',
  'Your income above ₦800,000 falls in the first taxable band under NTA 2025. Tax is calculated on your income ABOVE the ₦800,000 exemption threshold using progressive rates. Your employer deducts PAYE monthly. Note: The old Consolidated Relief Allowance (CRA) has been REMOVED, but new reliefs for rent and mortgage interest on owner-occupied homes are now available.',
  ARRAY['Verify PAYE deductions monthly', 'Register with NRS for Tax ID', 'File annual return by March 31', 'Claim rent/mortgage reliefs if applicable'],
  true
);

-- Rule 3: Salary Earner - TAXABLE (₦2,200,001 - ₦50,000,000) - Higher bands up to 25%
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_TAX_003',
  ARRAY['salary_earner'],
  2200001,
  100000000,
  18,
  'taxable',
  'Higher Income Tax Bands (NTA 2025)',
  'Your income is in the higher tax bands under NTA 2025 with progressive rates up to 25% on income above certain thresholds. Your employer handles PAYE deductions. You MUST file annual returns by March 31. You may be eligible for reliefs including: pension contributions, rent payments, mortgage interest on owner-occupied homes, and life insurance premiums.',
  ARRAY['File annual return by March 31 (mandatory)', 'Review PAYE deductions on payslips', 'Claim allowable reliefs', 'Register on NRS Self-Service Portal', 'Obtain Form H1 from employer after year-end'],
  true
);

-- ============================================
-- FREELANCER / SELF-EMPLOYED TAX RULES
-- Same PIT thresholds apply
-- Must register with NRS for Tax ID
-- Self-assessment and quarterly payments
-- ============================================

-- Rule 4: Freelancer - EXEMPT (≤ ₦800,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_EXEMPT_001',
  ARRAY['freelancer'],
  0,
  800000,
  0,
  'exempt',
  'Freelancer Low Income Exemption (NTA 2025)',
  'Under NTA 2025, freelancers/self-employed individuals earning ₦800,000 or below annually are EXEMPT from personal income tax. However, unlike salary earners, you MUST register with the Nigeria Revenue Service (NRS) and obtain a Tax ID. This is mandatory for ALL self-employed persons regardless of income. Keep records of all income and expenses.',
  ARRAY['Register with NRS for Tax ID (mandatory)', 'Keep income and expense records', 'Save all invoices and receipts', 'File nil return annually'],
  true
);

-- Rule 5: Freelancer - TAXABLE (₦800,001 - ₦3,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_TAX_002',
  ARRAY['freelancer'],
  800001,
  3000000,
  10,
  'taxable',
  'Freelancer Standard Tax (NTA 2025)',
  'Your freelance income above ₦800,000 is taxable under NTA 2025. As a self-employed person, YOU are responsible for calculating and paying your taxes (not an employer). You should make estimated quarterly tax payments to avoid a large year-end bill. File your annual return within 6 months of your accounting year-end.',
  ARRAY['Register with NRS as self-employed', 'Obtain Tax ID', 'Make quarterly estimated payments', 'File annual return (6 months after year-end)', 'Keep detailed income and expense records', 'Issue invoices for all work'],
  true
);

-- Rule 6: Freelancer - HIGH INCOME (₦3,000,001+)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_TAX_003',
  ARRAY['freelancer'],
  3000001,
  100000000,
  20,
  'taxable',
  'High-Income Freelancer (NTA 2025)',
  'Your freelance income above ₦3 million places you in higher tax bands (up to 25%). At this level, engaging a tax professional is strongly recommended. Note: If your annual turnover exceeds ₦100 million, you may need to consider Company Income Tax rules. Capital gains from asset sales are now taxed as part of your income tax (no separate 10% rate).',
  ARRAY['Engage a tax consultant', 'Register with NRS', 'Make quarterly estimated payments', 'Maintain professional accounting records', 'Consider business incorporation', 'File annual return with supporting documents'],
  true
);

-- ============================================
-- SMALL BUSINESS (COMPANY) TAX RULES
-- NTA 2025 Key Change:
-- 0% CIT for companies with turnover ≤ ₦100,000,000
-- (Previously was ₦25M - this is a MAJOR change!)
-- 30% CIT for turnover > ₦100,000,000
-- Small companies EXEMPT from VAT
-- ============================================

-- Rule 7: Small Business - CIT EXEMPT (≤ ₦100,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'BUSINESS_EXEMPT_001',
  ARRAY['small_business'],
  0,
  100000000,
  0,
  'exempt',
  'Small Company CIT Exemption (NTA 2025)',
  'IMPORTANT UPDATE: Under NTA 2025, companies with annual turnover of ₦100 million or below are EXEMPT from Company Income Tax (CIT). This is a significant increase from the previous ₦25 million threshold! You are also EXEMPT from VAT registration and filing. However, you must still: register with CAC, obtain a business Tax ID from NRS, maintain proper financial records, and file annual nil returns. If you have employees, you must deduct and remit their PAYE and pension contributions.',
  ARRAY['Register with CAC', 'Obtain business Tax ID from NRS', 'File annual nil CIT return', 'NO VAT registration required', 'Maintain financial records', 'Remit employee PAYE if applicable', 'Remit employee pension if applicable'],
  true
);

-- Rule 8: Medium/Large Business - CIT TAXABLE (> ₦100,000,000) - 30%
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'BUSINESS_TAX_002',
  ARRAY['small_business'],
  100000001,
  1000000000,
  30,
  'taxable',
  'Company Income Tax 30% (NTA 2025)',
  'Companies with annual turnover above ₦100 million pay Company Income Tax at 30% under NTA 2025. At this level, professional tax and accounting support is essential. You must register for VAT (7.5%), file monthly VAT returns by the 21st, implement e-invoicing/fiscalisation, and file audited annual returns within 6 months of year-end. The 4% Development Levy also applies (replacing previous TET, NASENI, etc.).',
  ARRAY['Engage tax consultant/accountant', 'Register for VAT (mandatory)', 'File monthly VAT returns by 21st', 'Implement e-invoicing', 'File quarterly CIT estimates', 'Submit audited financial statements', 'File annual CIT return (6 months after year-end)', 'Pay 4% Development Levy', 'Ensure employee PAYE/pension compliance'],
  true
);

-- ============================================
-- ACTION ITEM TEMPLATES - SALARY EARNER
-- Based on NTA 2025 requirements
-- ============================================

-- Templates for SALARY_EXEMPT_001 (Exempt - ≤ ₦800,000)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Confirm no PAYE is being deducted',
  'Check your payslip to confirm your employer is NOT deducting PAYE. Under NTA 2025, income of ₦800,000 or below is exempt. If PAYE is being deducted incorrectly, notify your HR/payroll department immediately with reference to the NTA 2025 exemption provision.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Save all payslips as proof',
  'Organize and save all your payslips (digital or physical) from 2026. These serve as evidence that your annual income is within the ₦800,000 exemption threshold if the NRS ever asks for verification. Store for at least 6 years.',
  'medium', 30, 2
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Consider getting a Tax ID',
  'While not strictly required for exempt employees, having a Tax Identification Number (Tax ID) from NRS is useful for various transactions and future needs. Visit nrs.gov.ng or taxid.nrs.gov.ng to register.',
  'low', 60, 3
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

-- Templates for SALARY_TAX_002 (₦800,001 - ₦2,200,000)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Verify PAYE deductions on payslip',
  'Check your payslip to confirm PAYE is being correctly deducted. Under NTA 2025, only income ABOVE ₦800,000 is taxed. The old CRA (Consolidated Relief Allowance) has been removed. If you''re paying rent, you may qualify for the new rent relief - speak to your employer or tax advisor.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register on NRS Self-Service Portal',
  'Create an account at nrs.gov.ng to access tax services. Click "Taxpayer" > "Self-Service Portal". You''ll need your BVN, valid email, and phone number. This replaces the old TaxPro Max portal following the FIRS to NRS transition.',
  'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Get your Tax ID',
  'Obtain or verify your Tax Identification Number (Tax ID) at taxid.nrs.gov.ng. Your Tax ID is required for all tax filings and is now critical for many transactions including bank account operations.',
  'high', 21, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Request Form H1 after year-end',
  'After December 2026, request your Form H1 (annual tax deduction certificate) from your employer. This document shows all PAYE deducted and is required for filing your annual return. Deadline: Get this before March to file on time.',
  'medium', 75, 4
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual tax return by March 31',
  'Submit your annual Personal Income Tax return by March 31, 2027 (90 days after year-end). Use the NRS Self-Service Portal to file electronically. Even though your employer deducts PAYE, you are still required to file a return.',
  'high', 73, 5
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

-- Templates for SALARY_TAX_003 (₦2,200,001+)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Review monthly PAYE deductions',
  'At your income level, PAYE is calculated using progressive bands up to 25%. Check your payslip monthly to ensure deductions are correct. Remember: The first ₦800,000 is exempt. Only income above this is taxed.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register on NRS Portal',
  'If you haven''t already, register at nrs.gov.ng for access to all tax services. The old FIRS/TaxPro Max has transitioned to NRS. You''ll need your BVN, Tax ID, email, and phone number.',
  'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Gather relief documents',
  'Collect documents for allowable reliefs under NTA 2025: Pension contribution statements, Rent receipts (new relief!), Mortgage interest statements for owner-occupied home (new!), Life insurance premiums. These can reduce your taxable income.',
  'medium', 30, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Request Form H1 from employer',
  'After year-end, request your Form H1 (annual tax deduction certificate) from your employer. This summarizes all PAYE deducted and is essential for filing your annual return.',
  'high', 75, 4
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual return by March 31',
  'File your annual PIT return by March 31, 2027 via the NRS Self-Service Portal. Include your Form H1, evidence of reliefs claimed, and any other income sources. Late filing attracts penalties.',
  'high', 73, 5
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

-- ============================================
-- ACTION ITEM TEMPLATES - FREELANCER
-- ============================================

-- Templates for FREELANCER_EXEMPT_001 (≤ ₦800,000)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register with NRS for Tax ID (Mandatory)',
  'IMPORTANT: Unlike salary earners, ALL self-employed/freelancers MUST register with NRS and obtain a Tax ID, even if your income is below ₦800,000. Visit taxid.nrs.gov.ng to register. You''ll need your BVN, NIN, and valid ID.',
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up income tracking',
  'Create a system to track all income received: date, client name, amount, payment method. This proves you''re below the ₦800,000 exemption threshold. Use a spreadsheet, Wave app, or any simple tool. Keep for at least 6 years.',
  'medium', 21, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Organize invoices and receipts',
  'Create folders (digital or physical) for all invoices you send and receipts for business expenses. Even though you''re exempt, NRS may ask for documentation. Good record-keeping now saves headaches later.',
  'low', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File nil return annually',
  'Even with no tax liability, file a nil return with NRS by the deadline (6 months after your accounting year-end). This keeps you compliant and avoids queries.',
  'medium', 180, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

-- Templates for FREELANCER_TAX_002 (₦800,001 - ₦3,000,000)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register with NRS as self-employed',
  'Complete your registration at nrs.gov.ng. Navigate to "Taxpayer" > "Self-Service Portal" and register as an individual (self-employed). Have your BVN, NIN, Tax ID, business address, and bank details ready.',
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Calculate quarterly tax estimates',
  'Estimate your tax liability and make quarterly payments to avoid a large year-end bill. Calculate tax on income above ₦800,000 using progressive rates. Payment deadlines: Q1 (March 31), Q2 (June 30), Q3 (Sept 30), Q4 (Dec 31). Use NRS portal for payments.',
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Open dedicated business account',
  'Open a separate bank account for your freelance income. This separates personal and business finances, simplifies tax calculations, and provides clear audit trails. Most banks offer SME/business accounts with minimal requirements.',
  'medium', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Implement proper invoicing',
  'Use consistent invoices with: your name/business name, address, Tax ID, client details, description of work, amount, date, and bank details. Keep copies of ALL invoices. Apps like Wave, Zoho Invoice, or even Word/Excel templates work well.',
  'medium', 21, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual return (6 months after year-end)',
  'File your annual PIT return within 6 months of your accounting year-end via the NRS Self-Service Portal. For calendar year-end, file by June 30, 2027. Include income records, expense documentation, and payment evidence.',
  'high', 180, 5
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

-- Templates for FREELANCER_TAX_003 (₦3,000,001+)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Engage a tax consultant',
  'At your income level (₦3M+), professional tax advice is essential. Find a Chartered Tax Practitioner through the Chartered Institute of Taxation of Nigeria (CITN) at citn.org. A good consultant can legally optimize your tax position and ensure compliance.',
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up quarterly tax payments',
  'Work with your tax consultant to calculate and schedule quarterly estimated tax payments. At higher income levels, these are substantial. Pay via NRS portal. Late payments attract interest charges.',
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Implement professional accounting',
  'At this level, proper accounting software is essential. Consider QuickBooks, Sage, Zoho Books, or Wave. If budget allows, engage a bookkeeper. Accurate records are critical for tax filing and potential NRS audits.',
  'high', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Consider business incorporation',
  'Discuss with your consultant whether incorporating as a Limited Company makes sense. Under NTA 2025, companies with turnover up to ₦100M pay 0% CIT - a significant benefit. Weigh pros/cons including limited liability and compliance costs.',
  'medium', 60, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

-- ============================================
-- ACTION ITEM TEMPLATES - SMALL BUSINESS
-- ============================================

-- Templates for BUSINESS_EXEMPT_001 (≤ ₦100,000,000 - CIT EXEMPT)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register with CAC',
  'If not already registered, complete your business registration with Corporate Affairs Commission (CAC). Options: Business Name (₦10,000-₦25,000) or Limited Company (from ₦100,000). Visit cac.gov.ng for online registration. This is required before getting a business Tax ID.',
  'high', 21, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Obtain business Tax ID from NRS',
  'Register your business at nrs.gov.ng to get your business Tax Identification Number. You''ll need: CAC certificate, directors'' details, business address, and bank account. This is separate from your personal Tax ID.',
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Understand your CIT exemption',
  'IMPORTANT: Under NTA 2025, your business with turnover ≤ ₦100 million is EXEMPT from Company Income Tax. You are also EXEMPT from VAT registration. This is a major benefit - the threshold increased from ₦25M! However, you must still file nil returns.',
  'high', 7, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up basic bookkeeping',
  'Even with CIT exemption, maintain proper financial records. Use accounting software (Wave is free, or QuickBooks, Zoho Books). At minimum, keep a cash book recording all money in and out. Good records prove your turnover is under ₦100M.',
  'medium', 30, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Learn employee tax obligations',
  'If you have employees, you MUST: 1) Deduct PAYE from their salaries (using NTA 2025 rates - income ≤₦800K exempt), 2) Remit PAYE monthly to your State IRS, 3) Deduct pension contributions (minimum 18% combined), 4) Remit pension to an approved PFA. Non-compliance attracts heavy penalties.',
  'medium', 45, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual nil CIT return',
  'Even with zero CIT liability, file an annual nil return with NRS. Deadline: 6 months after your accounting year-end (June 30 for December year-end). Small companies can submit a statement of accounts instead of audited financials.',
  'medium', 180, 6
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

-- Templates for BUSINESS_TAX_002 (> ₦100,000,000 - CIT 30%)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Engage tax consultant/accountant immediately',
  'At turnover above ₦100 million, professional tax management is essential. Engage a CITN-registered tax consultant and a qualified accountant. They''ll handle CIT planning, VAT compliance, e-invoicing setup, and audits.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register for VAT (Mandatory)',
  'Companies above the small company threshold MUST register for VAT at nrs.gov.ng. VAT rate is 7.5%. You''ll charge VAT on taxable supplies and can recover input VAT on purchases. Under NTA 2025, input VAT on services and capital expenditure is now fully recoverable.',
  'high', 21, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Implement e-invoicing/fiscalisation',
  'NTA 2025 mandates e-invoicing for VAT-registered businesses. Implement the fiscalisation system through NRS at einvoice.firs.gov.ng. All VAT invoices must include: Tax ID, sequential invoice number, supplier details, VAT amount and rate.',
  'high', 30, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up monthly VAT filing',
  'VAT returns must be filed monthly by the 21st of the following month. Calculate output VAT (collected) minus input VAT (paid) to determine amount payable or refundable. File via NRS portal. Late filing: ₦100,000 first month, ₦50,000 each subsequent month.',
  'high', 21, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Plan for CIT at 30%',
  'Company Income Tax is 30% of taxable profits. Work with your accountant to: 1) Make quarterly advance CIT payments, 2) Maximize allowable deductions, 3) Claim capital allowances on assets, 4) Plan for the 4% Development Levy (replaces old TET, NASENI, IT levy, etc.).',
  'high', 30, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Arrange for annual audit',
  'Companies above the small company threshold must file AUDITED financial statements with NRS. Engage a chartered accountant for your year-end audit. Start the process at least 3 months before your filing deadline. Deadline: 6 months after year-end.',
  'high', 90, 6
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Ensure employee compliance',
  'Review that PAYE deductions use NTA 2025 rates (income ≤₦800K exempt). Confirm pension contributions are being remitted monthly to approved PFAs. Non-compliance penalties: up to 10% of unpaid amounts plus interest. NRS can enforce collection through banks.',
  'high', 14, 7
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

-- ============================================
-- VERIFICATION QUERY
-- Run this after the script to confirm setup:
-- ============================================
-- SELECT
--   r.rule_code,
--   r.applies_to[1] as work_type,
--   r.income_min,
--   r.income_max,
--   r.tax_rate || '%' as rate,
--   r.exemption_status,
--   COUNT(t.id) as action_items
-- FROM tax_rules r
-- LEFT JOIN action_item_templates t ON t.tax_rule_id = r.id
-- GROUP BY r.id
-- ORDER BY r.applies_to, r.income_min;
