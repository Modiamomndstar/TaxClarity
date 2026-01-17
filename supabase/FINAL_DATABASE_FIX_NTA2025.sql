-- ============================================
-- TAXCLARITY NG - FINAL DATABASE FIX
-- Based on Nigeria Tax Act 2025 (NTA 2025)
-- and Nigeria Tax Administration Act 2025 (NTAA)
-- Source: Official NRS & LIRS Documentation
-- Effective: January 1, 2026
-- ============================================

-- Step 1: Delete all existing data
DELETE FROM user_action_items;
DELETE FROM action_item_templates;
DELETE FROM tax_rules;

-- ============================================
-- OFFICIAL PIT TAX RATES (NTA 2025)
-- ₦0 - ₦800,000 = 0%
-- ₦800,001 - ₦3,000,000 = 15%
-- ₦3,000,001 - ₦12,000,000 = 18%
-- ₦12,000,001 - ₦25,000,000 = 21%
-- ₦25,000,001 - ₦50,000,000 = 23%
-- Above ₦50,000,000 = 25%
-- ============================================

-- ============================================
-- SALARY EARNER TAX RULES
-- Employers deduct PAYE and remit to State IRS
-- Filing deadline: March 31 annually
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
  'Zero Tax Band - No PAYE Required (NTA 2025)',
  'Under the Nigeria Tax Act 2025, your annual income of ₦800,000 or below falls in the 0% tax band. This means NO personal income tax should be deducted from your salary. Your employer should NOT be making any PAYE deductions. If they are, this is an error that needs to be corrected. You can still obtain a Tax ID for future needs, and should keep all payslips as proof of your income level.',
  ARRAY['Verify zero PAYE on payslips', 'Keep payslips for 6 years (Section 31 NTAA)', 'Obtain Tax ID (optional but recommended)'],
  true
);

-- Rule 2: Salary Earner - 15% Band (₦800,001 - ₦3,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_TAX_002',
  ARRAY['salary_earner'],
  800001,
  3000000,
  15,
  'taxable',
  '15% Tax Band (NTA 2025)',
  'Your income above ₦800,000 is taxed at 15% under NTA 2025. For example, if you earn ₦2,000,000 annually: First ₦800,000 = ₦0 tax, remaining ₦1,200,000 × 15% = ₦180,000 tax. Your employer deducts this monthly via PAYE and remits to LIRS by the 10th of each month (Section 14 NTAA). You can reduce taxable income with reliefs: pension contributions (up to 25% of salary), rent payments (20% relief up to ₦500,000), and National Housing Fund contributions.',
  ARRAY['Verify monthly PAYE deductions', 'Obtain Tax ID', 'Claim allowable reliefs', 'Get Form H1 after year-end', 'File annual return by March 31 if additional income'],
  true
);

-- Rule 3: Salary Earner - 18% Band (₦3,000,001 - ₦12,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_TAX_003',
  ARRAY['salary_earner'],
  3000001,
  12000000,
  18,
  'taxable',
  '18% Tax Band (NTA 2025)',
  'Your income is taxed progressively: 0% on first ₦800,000, 15% on next ₦2,200,000 (= ₦330,000), then 18% on income above ₦3,000,000. For example, ₦5,000,000 salary: ₦0 + ₦330,000 + (₦2,000,000 × 18%) = ₦690,000 annual tax. Your employer handles PAYE deductions. Claim all available reliefs to reduce your tax burden. You MUST file an annual return by March 31 (Section 13 NTAA), especially if you have additional income sources.',
  ARRAY['Verify PAYE deductions monthly', 'Register on LIRS e-Tax portal', 'Claim pension and rent reliefs', 'Request Form H1 from employer', 'File annual return by March 31'],
  true
);

-- Rule 4: Salary Earner - Higher Bands (₦12,000,001+)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'SALARY_TAX_004',
  ARRAY['salary_earner'],
  12000001,
  100000000,
  21,
  'taxable',
  'Higher Tax Bands 21-25% (NTA 2025)',
  'High income is taxed progressively: 0% (₦0-800K), 15% (₦800K-3M), 18% (₦3M-12M), 21% (₦12M-25M), 23% (₦25M-50M), 25% (above ₦50M). Your employer calculates and deducts the correct PAYE. At this level, proper documentation of reliefs is essential. Consider: pension (up to 25% of salary), rent relief (20% up to ₦500,000), mortgage interest, and life insurance premiums. Filing annual returns is MANDATORY.',
  ARRAY['Review PAYE calculations', 'Maximize relief claims', 'File annual return by March 31 (mandatory)', 'Obtain Tax Clearance Certificate', 'Keep records for 6 years'],
  true
);

-- ============================================
-- FREELANCER / SELF-EMPLOYED TAX RULES
-- Must self-assess and pay directly
-- Same PIT rates apply on profits after expenses
-- Filing deadline: March 31 annually
-- ============================================

-- Rule 5: Freelancer - EXEMPT (≤ ₦800,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_EXEMPT_001',
  ARRAY['freelancer'],
  0,
  800000,
  0,
  'exempt',
  'Zero Tax Band - Self-Employed (NTA 2025)',
  'Your net income (after business expenses) of ₦800,000 or below falls in the 0% tax band. However, unlike salary earners, you MUST still register with the tax authority and obtain a Tax ID (Section 4 NTAA). Failure to register attracts ₦50,000 penalty (Section 100 NTAA). You should file a nil return annually by March 31. Keep records of all income and expenses for 6 years (Section 31 NTAA). Deductible expenses include: internet/data costs, equipment, software subscriptions, home office costs, marketing expenses.',
  ARRAY['Register for Tax ID (mandatory)', 'Track all income and expenses', 'Keep records for 6 years', 'File nil return by March 31'],
  true
);

-- Rule 6: Freelancer - 15% Band (₦800,001 - ₦3,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_TAX_002',
  ARRAY['freelancer'],
  800001,
  3000000,
  15,
  'taxable',
  '15% Tax Band - Self-Employed (NTA 2025)',
  'Your taxable income (gross income minus business expenses) above ₦800,000 is taxed at 15%. Example: ₦2,500,000 income - ₦500,000 expenses = ₦2,000,000 taxable. Tax = 0% on ₦800,000 + 15% on ₦1,200,000 = ₦180,000. You self-assess and pay this with your annual return by March 31 (Section 34 NTAA). If clients deduct Withholding Tax (5-10%), this is credited against your tax. You can use the simplified return form if eligible (Section 15 NTAA).',
  ARRAY['Register for Tax ID', 'Track income and expenses', 'Calculate tax quarterly', 'Credit Withholding Tax deductions', 'File and pay by March 31'],
  true
);

-- Rule 7: Freelancer - 18% Band (₦3,000,001 - ₦12,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_TAX_003',
  ARRAY['freelancer'],
  3000001,
  12000000,
  18,
  'taxable',
  '18% Tax Band - Self-Employed (NTA 2025)',
  'Progressive tax applies: 0% (₦0-800K) + 15% (₦800K-3M) + 18% (₦3M-12M). Example: ₦5,000,000 income - ₦1,000,000 expenses = ₦4,000,000 taxable. Tax = ₦0 + ₦330,000 + (₦1,000,000 × 18%) = ₦510,000. At this level, professional accounting software is recommended. Make quarterly estimated payments to avoid a large year-end bill. Digital platforms may report your earnings to NRS (Section 79 NTAA). If turnover exceeds ₦50 million, you must register for VAT.',
  ARRAY['Use accounting software', 'Make quarterly tax payments', 'Register for VAT if turnover > ₦50M', 'File annual return by March 31', 'Disclose tax planning arrangements (Section 30 NTAA)'],
  true
);

-- Rule 8: Freelancer - Higher Bands (₦12,000,001+)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'FREELANCER_TAX_004',
  ARRAY['freelancer'],
  12000001,
  100000000,
  21,
  'taxable',
  'Higher Tax Bands 21-25% - Self-Employed (NTA 2025)',
  'High income is taxed progressively up to 25% on income above ₦50 million. At this level: 1) Professional accounting is essential, 2) Quarterly estimated payments are critical, 3) VAT registration is likely mandatory (if turnover > ₦50M), 4) Consider incorporating as a company for potential 0% CIT on turnover up to ₦50M. All anti-avoidance rules apply (Sections 46-47 NTAA). A tax consultant is optional but may help optimize legally.',
  ARRAY['Maintain professional accounting', 'Make quarterly tax payments', 'Register for VAT (mandatory if > ₦50M)', 'Consider business incorporation', 'File and pay by March 31'],
  true
);

-- ============================================
-- SMALL BUSINESS (COMPANY) TAX RULES
-- Small company: Turnover ≤ ₦50M = 0% CIT
-- Above ₦50M: 30% CIT + 4% development levy
-- VAT exempt if turnover ≤ ₦50M
-- ============================================

-- Rule 9: Small Business - CIT EXEMPT (≤ ₦50,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'BUSINESS_EXEMPT_001',
  ARRAY['small_business'],
  0,
  50000000,
  0,
  'exempt',
  'Small Company - 0% CIT (NTA 2025)',
  'Under NTA 2025, incorporated companies with annual turnover of ₦50 million or below AND fixed assets of ₦250 million or below qualify as "small companies" and pay 0% Company Income Tax. You are also EXEMPT from VAT registration and filing. However, you MUST: 1) Register with CAC, 2) Obtain a business Tax ID from NRS, 3) File annual nil returns within 6 months of year-end (Section 11 NTAA), 4) Maintain proper books. If you have employees, you must deduct and remit their PAYE to the State IRS and pension to approved PFAs.',
  ARRAY['Register with CAC', 'Obtain business Tax ID', 'File annual nil CIT return', 'Maintain financial records', 'Handle employee PAYE if applicable'],
  true
);

-- Rule 10: Medium Business - CIT TAXABLE (> ₦50,000,000)
INSERT INTO tax_rules (rule_code, applies_to, income_min, income_max, tax_rate, exemption_status, title, explanation, obligations, active)
VALUES (
  'BUSINESS_TAX_002',
  ARRAY['small_business'],
  50000001,
  1000000000,
  30,
  'taxable',
  'Company Income Tax 30% (NTA 2025)',
  'Companies with turnover above ₦50 million pay 30% CIT on taxable profits plus 4% Development Levy (replacing old TET, NASENI levies). You MUST register for VAT (7.5%) and file monthly returns by the 21st. File CIT returns with audited financial statements within 6 months of year-end. Late CIT filing attracts ₦10 million penalty plus daily charges (Section 128 NTAA). Professional accounting support is strongly recommended at this level, though not legally required.',
  ARRAY['Register for VAT (mandatory)', 'File monthly VAT returns', 'File annual CIT return (audited)', 'Pay 4% Development Levy', 'Ensure employee PAYE/pension compliance'],
  true
);

-- ============================================
-- ACTION ITEM TEMPLATES - SALARY EARNER EXEMPT
-- Detailed self-service instructions
-- ============================================

-- SALARY_EXEMPT_001 Actions (≤ ₦800,000)
INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Check your payslip for PAYE deductions',
  'WHAT TO DO: Look at your latest payslip. Find the "PAYE" or "Tax" deduction line. It should show ₦0 or no deduction at all.

WHY: Under NTA 2025, income up to ₦800,000 annually has 0% tax. No PAYE should be deducted.

IF PAYE IS BEING DEDUCTED:
1. Calculate your annual salary (monthly × 12)
2. If it''s ₦800,000 or below, the deduction is wrong
3. Write to your HR/Payroll department
4. Reference: "Nigeria Tax Act 2025 - 0% band for income up to ₦800,000"
5. Request correction and refund of any wrongly deducted amounts

KEEP: Save this payslip and any correspondence for your records.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Organize and save all payslips',
  'WHAT TO DO: Collect all your 2026 payslips (January onwards).

HOW TO ORGANIZE:
1. Create a folder (physical or digital) labeled "Tax Records 2026"
2. Save payslips in order by month
3. For digital: Take clear photos or scan to PDF
4. Store in cloud (Google Drive, iCloud) for backup

WHY THIS MATTERS:
- Payslips prove your income level
- If NRS/LIRS ever questions your status, you have evidence
- Required to keep for 6 years (Section 31 NTAA)

TIP: At year end, add up all payslips to confirm total is ≤ ₦800,000.',
  'medium', 30, 2
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Get your Tax ID (TIN) - Optional but useful',
  'WHAT TO DO: Register for a Tax Identification Number online.

STEP-BY-STEP REGISTRATION:
1. Go to https://taxid.jrb.gov.ng/
2. Click "Individual Registration"
3. Have ready: BVN, NIN, Date of Birth, Valid ID, Proof of address
4. Enter your BVN and Date of Birth to start
5. Fill in all required fields accurately
6. Submit and note your Tax ID number

WHY GET ONE:
- Required for many bank transactions
- Needed for government contracts/tenders
- Required for property registration
- Makes future tax matters easier

COST: FREE
TIME: 10-15 minutes online',
  'low', 60, 3
FROM tax_rules WHERE rule_code = 'SALARY_EXEMPT_001';

-- ============================================
-- ACTION ITEM TEMPLATES - SALARY EARNER 15% BAND
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Verify your monthly PAYE is correct',
  'WHAT TO DO: Check that the PAYE deduction on your payslip matches the correct calculation.

HOW TO CALCULATE (Example for ₦2,000,000 annual salary):
1. First ₦800,000 = ₦0 tax (0% band)
2. Remaining ₦1,200,000 × 15% = ₦180,000 annual tax
3. Monthly PAYE = ₦180,000 ÷ 12 = ₦15,000

YOUR CALCULATION:
1. Take your annual salary: ₦_______
2. Subtract ₦800,000: ₦_______
3. Multiply by 15%: ₦_______ (annual tax)
4. Divide by 12: ₦_______ (monthly PAYE)

RELIEFS THAT REDUCE TAX:
- Pension contributions (auto-deducted)
- Rent payments (20% relief up to ₦500,000 - tell your employer)

IF INCORRECT: Contact HR/Payroll with your calculation.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register for your Tax ID (TIN)',
  'WHAT TO DO: Get your Tax Identification Number if you don''t have one.

STEP-BY-STEP:
1. Visit https://taxid.jrb.gov.ng/
2. Click "Individual Registration"
3. Prepare: BVN, NIN, Date of Birth, Valid ID (passport/driver''s license/NIN slip), Proof of address (utility bill)
4. Enter BVN and DOB to begin
5. Complete all fields - use your official name as on BVN
6. Upload ID documents if requested
7. Submit application
8. Note your Tax ID (format: 12345678-0001)

TIMELINE: Usually instant to 24 hours
COST: FREE

AFTER REGISTRATION:
- Give Tax ID to your employer for records
- Keep Tax ID safe - you''ll need it for filings',
  'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register on LIRS e-Tax Portal',
  'WHAT TO DO: Create an account on the Lagos State tax portal for future filings.

STEP-BY-STEP:
1. Go to https://etax.lirs.net/
2. Click "Sign Up" or "Register"
3. Select "Individual Taxpayer"
4. Enter your Tax ID (get this first if you don''t have it)
5. Fill in personal details: Name, Email, Phone
6. Create a strong password (save it somewhere safe!)
7. Verify your email address
8. Log in to confirm account works

WHY REGISTER NOW:
- Required for filing annual returns
- Check your tax status anytime
- Download Tax Clearance Certificate (TCC)
- Track employer PAYE remittances

NOTE: If not in Lagos, use your State IRS portal instead.',
  'high', 21, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Gather documents for relief claims',
  'WHAT TO DO: Collect proof of expenses that reduce your taxable income.

RELIEFS YOU CAN CLAIM:

1. PENSION CONTRIBUTIONS (automatic)
   - Check payslip shows pension deduction
   - Get annual statement from your PFA

2. RENT RELIEF (20% of rent, max ₦500,000 relief)
   - Keep rent receipts or bank transfer evidence
   - Get tenancy agreement copy
   - Landlord details (name, address)

3. NATIONAL HOUSING FUND (if contributing)
   - Get contribution statement

4. LIFE INSURANCE PREMIUMS
   - Policy documents and payment receipts

HOW TO USE:
- Give documents to employer for PAYE adjustment, OR
- Claim when filing annual return for refund

ORGANIZE:
- Create folder "Tax Reliefs 2026"
- Store copies of all documents',
  'medium', 30, 4
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Request Form H1 from employer (after December)',
  'WHAT TO DO: After December 2026, get your annual tax certificate from your employer.

WHAT IS FORM H1:
- Official document showing total salary earned
- Shows all PAYE deducted throughout the year
- Needed for filing your annual return

HOW TO GET IT:
1. Email/write to HR or Payroll department
2. Subject: "Request for Form H1 - Tax Year 2026"
3. Include: Your full name, Employee ID, Department
4. Request by end of January 2027

WHAT TO CHECK ON FORM H1:
- Your name and Tax ID are correct
- Total earnings matches your payslips
- Total PAYE deducted is accurate
- Employer''s Tax ID is shown

IF ERRORS: Request correction before filing your return.

DEADLINE: Get this before March to file on time.',
  'medium', 75, 5
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual tax return by March 31, 2027',
  'WHAT TO DO: Submit your annual Personal Income Tax return.

WHEN: Before March 31, 2027 (Section 13 NTAA)
PENALTY FOR LATE FILING: ₦100,000 + ₦10,000 per month (Section 101 NTAA)

STEP-BY-STEP FILING:
1. Log in to https://etax.lirs.net/
2. Navigate to "File Return" or "Annual Return"
3. Select tax year 2026
4. Download Form A (Self-Assessment form)
5. Fill in:
   - Personal details and Tax ID
   - Employment income from Form H1
   - Any other income (rental, business)
   - Deductions and reliefs claimed
   - Tax already paid (PAYE from Form H1)
6. Calculate: Tax due minus PAYE = Balance (refund or pay)
7. Upload Form A and supporting documents
8. Submit electronically

IF YOU OWE TAX: Pay via the portal or bank
IF OVERPAID: Apply for refund (Section 55 NTAA)

AFTER FILING: Download confirmation receipt. Keep for records.',
  'high', 73, 6
FROM tax_rules WHERE rule_code = 'SALARY_TAX_002';

-- ============================================
-- ACTION ITEM TEMPLATES - SALARY EARNER 18% BAND
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Verify PAYE calculation for your income level',
  'WHAT TO DO: Confirm your payslip shows correct PAYE for the 18% band.

HOW TAX IS CALCULATED (Example: ₦5,000,000 salary):
1. First ₦800,000 × 0% = ₦0
2. Next ₦2,200,000 (₦800K to ₦3M) × 15% = ₦330,000
3. Remaining ₦2,000,000 × 18% = ₦360,000
4. TOTAL ANNUAL TAX = ₦690,000
5. Monthly PAYE = ₦57,500

YOUR CALCULATION:
1. Annual salary: ₦_______
2. Tax on first ₦800K: ₦0
3. Tax on ₦800K-₦3M portion: ₦_______ × 15% = ₦_______
4. Tax on amount above ₦3M: ₦_______ × 18% = ₦_______
5. Total annual: ₦_______ ÷ 12 = ₦_______ monthly

NOTE: Pension contributions and other reliefs reduce taxable income before this calculation.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register on LIRS e-Tax Portal',
  'WHAT TO DO: Set up your account for tax filings.

STEP-BY-STEP:
1. Visit https://etax.lirs.net/
2. Click "Sign Up" / "New Registration"
3. Choose "Individual Taxpayer"
4. Enter your Tax ID number
5. Fill personal details accurately
6. Create password (write it down safely!)
7. Verify email
8. Complete registration

AFTER REGISTRATION:
- Explore the dashboard
- Check if previous filings exist
- Verify your employer''s PAYE remittances appear

IF NOT IN LAGOS: Find your State IRS portal:
- FCT: www.fct-irs.gov.ng
- Rivers: www.rirs.gov.ng
- Oyo: www.oyostateirs.ng
(Search "[Your State] Internal Revenue Service portal")',
  'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Collect all relief documentation',
  'WHAT TO DO: Gather proof for all tax reliefs you can claim.

DOCUMENT CHECKLIST:

✓ PENSION (Automatic - reduces taxable income)
  - Request statement from your PFA
  - Shows contributions for the year

✓ RENT RELIEF (20% of rent paid, max ₦500,000)
  - Tenancy agreement copy
  - Rent receipts or bank transfer proof
  - Landlord details

✓ MORTGAGE INTEREST (for owner-occupied home)
  - Bank mortgage statement
  - Interest paid during year

✓ NATIONAL HOUSING FUND
  - Contribution statements

✓ LIFE INSURANCE
  - Policy documents
  - Premium payment receipts

✓ NHIS CONTRIBUTIONS
  - Deduction statements

HOW TO USE THESE:
Option 1: Give to employer for adjusted PAYE
Option 2: Claim when filing annual return

CREATE: "2026 Tax Reliefs" folder with all documents.',
  'medium', 30, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Get Form H1 after year-end',
  'WHAT TO DO: Request your annual tax deduction certificate.

TIMING: January-February 2027

HOW TO REQUEST:
1. Email HR/Payroll: "Please provide my Form H1 for tax year 2026"
2. Include: Full name, Employee ID, Tax ID
3. Follow up if not received within 2 weeks

WHAT FORM H1 CONTAINS:
- Your total 2026 earnings
- All PAYE deducted
- Reliefs applied
- Employer''s Tax ID and details

VERIFY WHEN RECEIVED:
□ Name spelled correctly
□ Tax ID is accurate
□ Earnings match your payslips total
□ PAYE matches your payslip deductions total

ERRORS: Request correction immediately - you need accurate H1 for filing.',
  'high', 75, 4
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual return by March 31',
  'WHAT TO DO: Submit your 2026 tax return to LIRS.

DEADLINE: March 31, 2027 (Section 13 NTAA)
LATE PENALTY: ₦100,000 + ₦10,000/month (Section 101)

STEP-BY-STEP:
1. Log in to https://etax.lirs.net/
2. Go to "File Return" → "Annual Return" → 2026
3. Download Form A
4. Complete all sections:
   - Personal info and Tax ID
   - Employment income (from Form H1)
   - Other income (rental, investments, side business)
   - Reliefs and deductions
   - PAYE already paid
5. Calculate balance due or refund
6. Scan/upload: Form H1, relief documents
7. Submit online
8. Pay any balance via portal or bank

PAYMENT OPTIONS:
- Online: Card payment on portal
- Bank: Generate payment reference, pay at any bank
- Installments: Request payment plan if needed

KEEP: Download and save submission receipt.',
  'high', 73, 5
FROM tax_rules WHERE rule_code = 'SALARY_TAX_003';

-- ============================================
-- ACTION ITEM TEMPLATES - SALARY EARNER HIGH INCOME
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Understand your progressive tax calculation',
  'WHAT TO DO: Know exactly how your tax is calculated across all bands.

TAX BANDS (NTA 2025):
₦0 - ₦800,000 = 0%
₦800,001 - ₦3,000,000 = 15%
₦3,000,001 - ₦12,000,000 = 18%
₦12,000,001 - ₦25,000,000 = 21%
₦25,000,001 - ₦50,000,000 = 23%
Above ₦50,000,000 = 25%

EXAMPLE (₦15,000,000 salary):
1. ₦800,000 × 0% = ₦0
2. ₦2,200,000 × 15% = ₦330,000
3. ₦9,000,000 × 18% = ₦1,620,000
4. ₦3,000,000 × 21% = ₦630,000
TOTAL = ₦2,580,000 annual / ₦215,000 monthly

IMPORTANT: Pension contributions and reliefs reduce your taxable income BEFORE this calculation, potentially moving you to a lower band.',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'SALARY_TAX_004';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Maximize all available reliefs',
  'WHAT TO DO: Ensure you''re claiming every relief to reduce taxable income.

RELIEF CHECKLIST:

1. PENSION CONTRIBUTIONS (up to 25% of salary)
   ✓ Confirm deduction on payslip
   ✓ Get annual PFA statement

2. RENT RELIEF (20% of rent, max ₦500,000)
   ✓ Provide rent receipts to employer
   ✓ OR claim on annual return

3. MORTGAGE INTEREST (owner-occupied home)
   ✓ Get bank interest statement

4. LIFE INSURANCE PREMIUMS
   ✓ Keep payment receipts

5. NATIONAL HOUSING FUND
   ✓ Get contribution proof

6. VOLUNTARY PENSION CONTRIBUTIONS
   ✓ Additional pension = additional relief

ACTION: Meet with HR to ensure all reliefs are reflected in PAYE calculation. Provide documentation.

POTENTIAL SAVINGS: At 21-25% rates, ₦500,000 relief = ₦105,000-₦125,000 tax saved!',
  'high', 14, 2
FROM tax_rules WHERE rule_code = 'SALARY_TAX_004';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up for annual filing (mandatory)',
  'WHAT TO DO: At your income level, annual filing is MANDATORY, even with PAYE.

REQUIRED SETUP:
1. Register on LIRS portal: https://etax.lirs.net/
2. Obtain Tax ID if you don''t have one
3. Set calendar reminder for March 1, 2027 to start filing

DOCUMENTS TO COLLECT THROUGHOUT YEAR:
□ All monthly payslips
□ Bank statements (for other income)
□ Investment income statements
□ Rental income records (if any)
□ All relief documentation
□ Form H1 (get in January)

CREATE FILING FOLDER NOW:
- Physical or digital folder "Tax Filing 2026"
- Add documents as you receive them
- Review quarterly to ensure nothing missing

WHY MANDATORY: Section 13 NTAA requires annual returns. Non-filing = ₦100,000 + ₦10,000/month penalty.',
  'high', 21, 3
FROM tax_rules WHERE rule_code = 'SALARY_TAX_004';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Apply for Tax Clearance Certificate (TCC)',
  'WHAT TO DO: Get your TCC - often needed for contracts and transactions.

WHAT IS TCC:
- Official proof you''re tax compliant
- Valid for 1 year
- Required for: government contracts, property transactions, certain licenses

HOW TO APPLY (after filing):
1. Log in to https://etax.lirs.net/
2. Navigate to "Tax Clearance Certificate"
3. Apply for TCC for 2026
4. System verifies you''ve filed and paid
5. Download TCC if approved

REQUIREMENTS:
- Tax ID
- Filed returns for last 3 years
- No outstanding tax debt

IF ISSUES:
- Clear any outstanding payments first
- Contact LIRS helpdesk for assistance

KEEP: Multiple copies - digital and printed.',
  'medium', 90, 4
FROM tax_rules WHERE rule_code = 'SALARY_TAX_004';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual return by March 31 (mandatory)',
  'WHAT TO DO: File your 2026 return before deadline.

DEADLINE: March 31, 2027
PENALTY: ₦100,000 + ₦10,000 per additional month

FILING CHECKLIST:
□ Form H1 from employer
□ All payslips
□ Other income documentation
□ Relief evidence
□ Tax ID
□ Previous year TCC (if available)

STEP-BY-STEP:
1. Log in: https://etax.lirs.net/
2. Select "File Return" → 2026
3. Complete Form A with all income sources
4. Enter reliefs and deductions
5. Calculate: Total tax - PAYE paid = Balance
6. Upload all supporting documents
7. Submit return
8. Pay balance or apply for refund
9. Download confirmation receipt

DECLARE ALL INCOME: Rental, investments, side business, foreign income (if resident). Under-declaration attracts penalties.

PAYMENT: Can be made online, bank transfer, or installment plan if needed.',
  'high', 73, 5
FROM tax_rules WHERE rule_code = 'SALARY_TAX_004';

-- ============================================
-- ACTION ITEM TEMPLATES - FREELANCER EXEMPT
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register for Tax ID (MANDATORY for self-employed)',
  'WHAT TO DO: Get your Tax Identification Number - this is REQUIRED by law.

LEGAL REQUIREMENT: Section 4 NTAA makes registration mandatory for all taxable persons.
PENALTY FOR NOT REGISTERING: ₦50,000 (Section 100 NTAA)

STEP-BY-STEP REGISTRATION:
1. Go to https://taxid.jrb.gov.ng/
2. Click "Individual Registration"
3. Prepare documents:
   - BVN (Bank Verification Number)
   - NIN (National Identification Number)
   - Valid ID (passport, driver''s license, or NIN slip)
   - Proof of address (utility bill, bank statement)
   - Passport photograph

4. Enter BVN and Date of Birth
5. Fill all required fields using your official name
6. Select "Self-Employed" or "Sole Proprietor" as employment type
7. Enter business details if prompted
8. Submit application
9. Note your Tax ID immediately

TIME: Usually instant to 24 hours
COST: FREE

AFTER REGISTRATION: Keep Tax ID safe - needed for all tax matters and many bank transactions.',
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up income and expense tracking system',
  'WHAT TO DO: Create a simple system to record all money coming in and going out.

WHY THIS MATTERS:
- Proves your income is below ₦800,000
- Required by law to keep records (Section 31 NTAA)
- Makes filing much easier

SIMPLE TRACKING OPTIONS:

Option 1: SPREADSHEET (Free)
Create columns: Date | Description | Income | Expense | Category
Use Google Sheets or Excel
Update weekly

Option 2: WAVE APP (Free)
Download Wave at waveapps.com
Connect bank account
Auto-tracks transactions
Creates reports

Option 3: NOTEBOOK (Simple)
Ruled notebook
Record each transaction as it happens
Separate pages for income vs expenses

WHAT TO TRACK:
Income: Client name, date, amount, payment method
Expenses: Date, what purchased, amount, receipt number

DEDUCTIBLE EXPENSES (reduce taxable income):
- Internet/data bundles
- Phone (% used for work)
- Computer/equipment
- Software subscriptions
- Home office costs
- Marketing/advertising
- Transportation for client meetings',
  'medium', 21, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Organize invoices and receipts',
  'WHAT TO DO: Keep organized records of all invoices sent and receipts received.

INVOICES (Money you''re owed/received):
1. Create invoice template with:
   - Your name, address, Tax ID
   - Client name and details
   - Description of work
   - Amount charged
   - Date and invoice number
   - Bank details for payment

2. Save copy of every invoice sent
3. Note when payment received

RECEIPTS (Money you spent):
1. Keep ALL receipts for business expenses
2. Digital: Take photo immediately after purchase
3. Physical: Store in envelope by month

ORGANIZATION SYSTEM:
Folder structure:
📁 2026 Tax Records
  📁 Invoices Sent
  📁 Income Received
  📁 Expenses - Receipts
  📁 Bank Statements

FREE TOOLS:
- Google Drive for cloud storage
- CamScanner app for receipt photos
- Wave for automated tracking

RETENTION: Keep for 6 years (Section 31 NTAA)',
  'low', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File nil return by March 31, 2027',
  'WHAT TO DO: Submit a "nil return" even though you owe no tax.

WHY FILE A NIL RETURN:
- Keeps your tax record clean
- Required by Section 13 NTAA
- Avoids questions later
- Can get Tax Clearance Certificate

HOW TO FILE:

For Lagos Residents:
1. Go to https://etax.lirs.net/
2. Log in or register with Tax ID
3. Select "File Return" → 2026
4. Download Form A
5. Fill in:
   - Personal details
   - Total income: ₦_______ (your actual income)
   - Expenses: ₦_______
   - Taxable income: ₦_______ (must be ≤ ₦800,000)
   - Tax due: ₦0
6. Upload income/expense records as proof
7. Submit online

For Other States:
Use your State Internal Revenue Service portal

DEADLINE: March 31, 2027
If late: ₦100,000 + ₦10,000/month penalty

KEEP: Download and save submission confirmation.',
  'medium', 180, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_EXEMPT_001';

-- ============================================
-- ACTION ITEM TEMPLATES - FREELANCER 15% BAND
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register for Tax ID (MANDATORY)',
  'WHAT TO DO: Get your Tax Identification Number immediately.

LEGAL REQUIREMENT: All self-employed persons MUST register (Section 4 NTAA)
PENALTY: ₦50,000 for failure to register (Section 100 NTAA)

REGISTRATION STEPS:
1. Visit https://taxid.jrb.gov.ng/
2. Click "Individual Registration"
3. Have ready:
   - BVN and NIN
   - Date of Birth
   - Valid government ID
   - Proof of address (utility bill dated within 3 months)
   - Passport photo

4. Enter BVN and DOB to start
5. Select occupation: "Self-Employed" / "Freelancer"
6. Complete all fields with accurate information
7. Submit and receive your Tax ID

AFTER REGISTRATION:
- Record Tax ID in safe place
- Use on all invoices
- Inform clients (some may need to deduct Withholding Tax)',
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up proper accounting system',
  'WHAT TO DO: Track all income and expenses systematically.

CHOOSE A METHOD:

1. WAVE ACCOUNTING (Free - Recommended)
   - Visit waveapps.com
   - Create free account
   - Connect bank account
   - Automatically imports transactions
   - Creates income/expense reports
   - Generates invoices

2. SPREADSHEET SYSTEM
   - Google Sheets (free) or Excel
   - Create columns: Date | Description | Amount | Type (Income/Expense) | Category
   - Update at least weekly
   - Sum totals monthly

3. ZOHO INVOICE (Free tier)
   - Professional invoicing
   - Expense tracking
   - Reports for tax filing

EXPENSE CATEGORIES TO TRACK:
- Internet & Data
- Phone bills (work portion)
- Software/subscriptions
- Equipment (laptop, phone)
- Travel for work
- Home office (% of rent/utilities)
- Marketing/advertising
- Professional development
- Bank charges

INCOME TO TRACK:
- Client name
- Amount received
- Date received
- Invoice number
- Withholding Tax deducted (if any)',
  'high', 21, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Calculate and set aside tax quarterly',
  'WHAT TO DO: Estimate your tax each quarter and save that amount.

WHY QUARTERLY:
- Avoid huge year-end payment shock
- Easier to manage cash flow
- Some prefer to pay quarterly to NRS

HOW TO CALCULATE:

Each quarter, calculate:
1. Total income received: ₦_______
2. Total expenses: ₦_______
3. Net income: ₦_______ (Income - Expenses)
4. Annualize: ₦_______ × (4 ÷ quarters passed)
5. Check if above ₦800,000 threshold

If above threshold:
6. Taxable amount: Annual estimate - ₦800,000 = ₦_______
7. Tax estimate: ₦_______ × 15% = ₦_______
8. Set aside this amount in savings!

EXAMPLE (Q2 - 6 months in):
- Income so far: ₦1,200,000
- Expenses: ₦200,000
- Net: ₦1,000,000
- Annualized: ₦2,000,000
- Taxable: ₦1,200,000 (above 800K)
- Tax estimate: ₦180,000
- Set aside: ₦180,000 in separate account

TIP: Open separate "Tax Savings" account. Transfer tax estimate monthly.',
  'high', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Track Withholding Tax deductions from clients',
  'WHAT TO DO: Record when clients deduct Withholding Tax (WHT) from payments.

WHAT IS WHT:
- Some clients (especially companies/government) deduct 5-10% tax before paying you
- This is credited against your annual tax
- You need WHT credit notes as proof

WHEN CLIENTS DEDUCT WHT:
- Payment for services: 10% WHT
- Payment for supply of goods: 5% WHT
- Contract payments: 5% WHT

WHAT TO DO:
1. When client pays less than invoiced, ask: "Did you deduct WHT?"
2. Request WHT credit note/certificate
3. Record: Date, Client, Amount deducted, Credit note number

EXAMPLE:
- You invoice ₦100,000
- Client pays ₦90,000
- WHT deducted: ₦10,000
- Get credit note for ₦10,000

AT YEAR END:
- Total all WHT credits
- Subtract from your tax liability
- Attach credit notes to your tax return

KEEP: All WHT certificates for 6 years. Submit copies with annual return.',
  'medium', 45, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File and pay annual tax by March 31',
  'WHAT TO DO: Submit your annual return and pay any tax owed.

DEADLINE: March 31, 2027 (Section 13 NTAA)
PENALTY: ₦100,000 + ₦10,000/month late

STEP-BY-STEP FILING:

1. GATHER DOCUMENTS:
   □ Tax ID
   □ Bank statements for the year
   □ Income records/invoices
   □ Expense receipts/records
   □ WHT credit notes from clients
   □ Relief documents (rent, pension)

2. CALCULATE YOUR TAX:
   Total Income: ₦_______
   - Total Expenses: ₦_______
   = Net Income: ₦_______
   - ₦800,000 (exempt): ₦_______
   = Taxable Income: ₦_______
   × 15% = Tax Due: ₦_______
   - WHT Credits: ₦_______
   = BALANCE TO PAY: ₦_______

3. FILE ONLINE:
   - Log in: https://etax.lirs.net/
   - Select "File Return" → 2026
   - Complete Form A with all details
   - Upload supporting documents
   - Submit return

4. PAY TAX:
   - Pay online via portal
   - Or generate reference and pay at bank
   - Keep payment receipt

5. CONFIRMATION:
   - Download submission receipt
   - Save for records',
  'high', 180, 5
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_002';

-- ============================================
-- ACTION ITEM TEMPLATES - FREELANCER 18% BAND
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up professional accounting system',
  'WHAT TO DO: At this income level, you need proper accounting software.

RECOMMENDED OPTIONS:

1. WAVE (Free)
   - waveapps.com
   - Full accounting features
   - Bank connection
   - Invoicing
   - Financial reports

2. ZOHO BOOKS (From ₦5,000/month)
   - Professional features
   - Inventory if selling products
   - Multiple currencies for foreign clients

3. QUICKBOOKS (From ₦8,000/month)
   - Industry standard
   - Excellent reports
   - Accountant access

SET UP CHECKLIST:
□ Create account
□ Set up chart of accounts
□ Connect bank accounts
□ Create invoice template with Tax ID
□ Set up expense categories
□ Enable receipt capture

CRITICAL TRACKING:
- All income by source
- All expenses by category
- Withholding Tax received
- Quarterly totals
- Running profit calculation

BANK ACCOUNT: Open dedicated business account. Don''t mix personal and business funds.',
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Make quarterly estimated tax payments',
  'WHAT TO DO: Pay estimated tax quarterly to avoid large year-end bills.

QUARTERLY DEADLINES:
- Q1 (Jan-Mar): Due March 31
- Q2 (Apr-Jun): Due June 30
- Q3 (Jul-Sep): Due September 30
- Q4 (Oct-Dec): Due December 31

HOW TO CALCULATE QUARTERLY PAYMENT:

1. Estimate full year income: ₦_______
2. Estimate expenses: ₦_______
3. Estimated net income: ₦_______

4. Calculate annual tax:
   - 0% on first ₦800,000: ₦0
   - 15% on ₦800K-₦3M: ₦330,000 max
   - 18% on ₦3M-₦12M: (Your amount - ₦3M) × 18%

5. Divide by 4 = Quarterly payment

EXAMPLE (₦6,000,000 net income):
- ₦800K × 0% = ₦0
- ₦2.2M × 15% = ₦330,000
- ₦3M × 18% = ₦540,000
- Annual: ₦870,000
- Quarterly: ₦217,500

HOW TO PAY:
1. Log in to LIRS/State IRS portal
2. Select "Make Payment"
3. Choose "Estimated Tax Payment"
4. Enter amount
5. Pay via card or bank transfer
6. KEEP ALL RECEIPTS',
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Check if VAT registration required',
  'WHAT TO DO: Determine if your turnover requires VAT registration.

VAT THRESHOLD: ₦50 million annual turnover

IF YOUR TURNOVER IS BELOW ₦50M:
- VAT registration is OPTIONAL
- You don''t charge VAT to clients
- You can''t claim VAT refunds on purchases

IF YOUR TURNOVER EXCEEDS ₦50M:
- VAT registration is MANDATORY
- Charge 7.5% VAT on all taxable services
- File monthly VAT returns by 21st
- You can claim input VAT on business purchases

HOW TO CHECK:
Add up all your income (not profit, but total revenue)
If approaching ₦50M, prepare for VAT

VAT REGISTRATION PROCESS:
1. Visit NRS portal: www.nrs.gov.ng
2. Apply for VAT registration
3. Receive VAT registration number
4. Start charging 7.5% on invoices
5. File monthly returns by 21st
6. Remit VAT collected minus VAT paid

NOTE: Digital platforms may report your earnings to NRS (Section 79 NTAA). Don''t underreport.',
  'medium', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual return by March 31',
  'WHAT TO DO: Submit complete annual return with all documentation.

DEADLINE: March 31, 2027
PENALTY: ₦100,000 + ₦10,000/month (Section 101 NTAA)

DOCUMENT CHECKLIST:
□ Tax ID
□ Complete income records
□ All expense receipts/records
□ Bank statements (full year)
□ Withholding Tax credit notes
□ Relief documents
□ Quarterly payment receipts

FILING STEPS:

1. Calculate final tax:
   Gross Income: ₦_______
   - Expenses: ₦_______
   = Net Income: ₦_______

   Tax calculation:
   ₦0-800K × 0% = ₦0
   ₦800K-3M × 15% = ₦_______
   ₦3M+ × 18% = ₦_______
   Total Tax: ₦_______
   - WHT Credits: ₦_______
   - Quarterly Payments: ₦_______
   = Balance: ₦_______

2. Log in: https://etax.lirs.net/
3. Complete Form A
4. Attach all documents
5. Submit online
6. Pay any balance
7. Download receipt

REFUND: If you overpaid, apply via portal (Section 55 NTAA)',
  'high', 90, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_003';

-- ============================================
-- ACTION ITEM TEMPLATES - FREELANCER HIGH INCOME
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up professional accounting (mandatory at this level)',
  'WHAT TO DO: Implement full professional accounting system.

AT YOUR INCOME LEVEL (₦12M+):
- You''re in the 21-25% tax bands
- Professional records are essential
- Errors can be very costly

RECOMMENDED SETUP:

1. ACCOUNTING SOFTWARE (Required):
   - QuickBooks Online
   - Zoho Books
   - Sage
   Choose one and use consistently

2. SEPARATE BANK ACCOUNT (Required):
   - Business-only account
   - All income deposited here
   - All expenses paid from here
   - Makes tracking simple

3. BOOKKEEPER (Recommended):
   - Hire part-time bookkeeper
   - Or use online bookkeeping service
   - They enter transactions, you review
   - Cost: ₦30,000-₦100,000/month

4. TAX CONSULTANT (Optional but wise):
   - Find CITN-registered practitioner
   - They optimize your tax position
   - Handle compliance
   - Represent you if audited

WHAT TO TRACK:
- Every income source
- Every expense with receipt
- Asset purchases
- Depreciation
- Foreign income (if any)
- All tax payments made',
  'high', 14, 1
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_004';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Establish quarterly tax payment schedule',
  'WHAT TO DO: Set up and follow quarterly estimated tax payments.

YOUR TAX BANDS:
₦12M - ₦25M: 21%
₦25M - ₦50M: 23%
Above ₦50M: 25%

QUARTERLY CALCULATION EXAMPLE (₦20M net income):
- ₦800K × 0% = ₦0
- ₦2.2M × 15% = ₦330,000
- ₦9M × 18% = ₦1,620,000
- ₦8M × 21% = ₦1,680,000
- Annual Tax: ₦3,630,000
- Quarterly: ₦907,500

PAYMENT SCHEDULE:
| Quarter | Period | Due Date | Amount |
|---------|--------|----------|--------|
| Q1 | Jan-Mar | Mar 31 | ₦907,500 |
| Q2 | Apr-Jun | Jun 30 | ₦907,500 |
| Q3 | Jul-Sep | Sep 30 | ₦907,500 |
| Q4 | Oct-Dec | Dec 31 | ₦907,500 |

HOW TO PAY:
1. Log in to State IRS portal
2. Generate payment reference
3. Pay via bank transfer
4. Save all receipts

SET REMINDERS: Calendar alerts 1 week before each deadline.',
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_004';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register for VAT (likely mandatory)',
  'WHAT TO DO: At ₦12M+ income, check if VAT registration is needed.

VAT THRESHOLD: ₦50 million annual turnover

EVEN IF BELOW THRESHOLD:
- Some clients require vendors to be VAT-registered
- Registration can be beneficial for input VAT claims

VAT REGISTRATION STEPS:
1. Visit www.nrs.gov.ng
2. Navigate to VAT Registration
3. Prepare documents:
   - Tax ID
   - Business registration (if applicable)
   - Bank account details
   - Proof of business address
4. Complete application form
5. Submit online
6. Receive VAT registration number

AFTER REGISTRATION:
- Add 7.5% VAT to all invoices
- Collect VAT from clients
- Claim input VAT on business purchases
- File monthly by 21st
- Remit net VAT (collected minus paid)

LATE VAT FILING: ₦100,000 first month + ₦50,000/additional month

RECORDS: Keep all VAT invoices for 6 years.',
  'high', 30, 3
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_004';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Consider business incorporation',
  'WHAT TO DO: Evaluate if incorporating as a company makes sense.

WHY CONSIDER INCORPORATION:

1. TAX BENEFIT:
   - Companies with turnover ≤ ₦50M pay 0% CIT
   - You as director take salary (PIT applies)
   - Remaining profits can be retained at 0%
   - Dividends have lower effective rate

2. LIMITED LIABILITY:
   - Company is separate legal entity
   - Personal assets protected
   - Looks more professional

3. GROWTH:
   - Easier to raise investment
   - Simpler to add partners
   - Better for large contracts

INCORPORATION PROCESS:
1. Reserve name at CAC (cac.gov.ng)
2. Prepare Memorandum/Articles
3. Pay incorporation fees (from ₦100,000)
4. Receive RC number
5. Register for company Tax ID
6. Open company bank account

ONGOING REQUIREMENTS:
- Annual returns to CAC
- CIT filings (nil if under ₦50M)
- Separate accounting
- Audited accounts (if above threshold)

CONSULT: Speak with a lawyer or accountant before deciding.',
  'medium', 60, 4
FROM tax_rules WHERE rule_code = 'FREELANCER_TAX_004';

-- ============================================
-- ACTION ITEM TEMPLATES - SMALL BUSINESS EXEMPT
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register your business with CAC',
  'WHAT TO DO: Formally register your business with Corporate Affairs Commission.

REGISTRATION OPTIONS:

1. BUSINESS NAME (Sole Proprietor/Partnership)
   - Simpler, cheaper
   - Cost: ₦10,000 - ₦25,000
   - Personal liability for debts
   - File PIT (not CIT)

2. LIMITED COMPANY (Incorporated)
   - Limited liability
   - Cost: ₦100,000+
   - More professional
   - File CIT (0% if under ₦50M turnover)

ONLINE REGISTRATION (CAC):
1. Visit https://pre.cac.gov.ng/
2. Create account
3. Search and reserve business name
4. Complete registration form
5. Upload required documents:
   - ID of proprietor(s)/directors
   - Passport photos
   - Proof of address
6. Pay registration fee
7. Submit application
8. Receive certificate (usually 24-48 hours)

AFTER REGISTRATION:
- Get certified copies of documents
- Keep certificate safe
- Use registered name on all documents
- Proceed to Tax ID registration',
  'high', 21, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Obtain business Tax ID from NRS',
  'WHAT TO DO: Register your business for a Tax Identification Number.

FOR INCORPORATED COMPANIES:
1. Visit NRS portal: www.nrs.gov.ng
2. Select "Company Registration"
3. Prepare documents:
   - CAC Certificate
   - Memorandum & Articles
   - Directors'' Tax IDs
   - Company address proof
   - Bank account details
4. Complete application
5. Receive Company Tax ID

FOR SOLE PROPRIETOR/BUSINESS NAME:
- Use personal Tax ID for business
- Register at State IRS (e.g., LIRS) for state taxes

USES OF BUSINESS TAX ID:
- All tax filings
- Opening company bank accounts
- Government contracts
- Vendor registrations
- Getting Tax Clearance Certificate

KEEP SAFE: Tax ID is permanent. Use on all business documents.

LINK TO BANK: Inform your bank of your Tax ID for automatic WHT processing.',
  'high', 30, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Understand your 0% CIT status',
  'WHAT TO DO: Know your tax benefits and requirements as a small company.

SMALL COMPANY DEFINITION (NTA 2025):
- Annual turnover: ₦50 million or below
- Fixed assets: ₦250 million or below (excluding land)
- Not a professional services firm

YOUR BENEFITS:
✓ 0% Company Income Tax
✓ Exempt from VAT registration
✓ Can file statement of accounts (not full audit)
✓ 4% Development Levy does NOT apply

YOUR OBLIGATIONS:
✓ Still must register for Tax ID
✓ Still must file annual returns (nil)
✓ Still must keep proper records
✓ Must handle employee PAYE if applicable

WHAT IF TURNOVER EXCEEDS ₦50M:
- You become a medium company
- 30% CIT applies
- VAT registration required
- 4% Development Levy applies
- Audited accounts required

MONITOR: Track turnover monthly. Plan ahead if approaching ₦50M.',
  'high', 7, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up business bookkeeping',
  'WHAT TO DO: Establish a proper system to track business finances.

MINIMUM REQUIREMENTS (Section 31 NTAA):
- Record all transactions
- Keep records for 6 years
- Records must support tax returns

SIMPLE SETUP FOR SMALL BUSINESS:

1. OPEN BUSINESS BANK ACCOUNT
   - Separate from personal
   - All business income here
   - All business expenses here

2. CHOOSE ACCOUNTING METHOD
   Option A: Spreadsheet
   - Google Sheets/Excel
   - Columns: Date, Description, Income, Expense, Category
   - Monthly totals

   Option B: Wave App (Free)
   - waveapps.com
   - Connect bank account
   - Auto-imports transactions
   - Creates financial reports

   Option C: QuickBooks/Zoho
   - More features
   - Monthly subscription

3. KEEP ALL RECEIPTS
   - Photo receipts immediately
   - Store in cloud/folder
   - Label clearly

4. MONTHLY RECONCILIATION
   - Match records to bank statement
   - Correct any errors
   - Know your turnover

5. QUARTERLY REVIEW
   - Check if approaching ₦50M
   - Review profit/loss
   - Plan for taxes',
  'medium', 30, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Handle employee taxes correctly (if applicable)',
  'WHAT TO DO: If you have employees, manage their tax obligations.

YOUR RESPONSIBILITIES:

1. PAYE (Personal Income Tax):
   - Calculate tax on each employee''s salary
   - Apply NTA 2025 rates (0% on first ₦800K)
   - Deduct from salary monthly
   - Remit to State IRS by 10th of following month
   - Penalty for non-deduction: 40% of amount (Section 105 NTAA)

2. PENSION CONTRIBUTIONS:
   - Employee: Minimum 8% of basic salary
   - Employer: Minimum 10% of basic salary
   - Total: Minimum 18%
   - Remit monthly to employee''s PFA

3. NHF (National Housing Fund):
   - 2.5% of basic salary
   - Deduct and remit to Federal Mortgage Bank

PAYE CALCULATION EXAMPLE (₦1,500,000 annual salary):
- Taxable above ₦800K: ₦700,000
- Annual PAYE: ₦700,000 × 15% = ₦105,000
- Monthly PAYE: ₦8,750

RECORDS TO KEEP:
- Each employee''s salary details
- Tax calculations
- Payment remittance receipts
- Annual Form H1 for each employee

AT YEAR END:
- Issue Form H1 to each employee
- File employer annual return',
  'high', 45, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual nil CIT return',
  'WHAT TO DO: Submit your annual company tax return to NRS.

DEADLINE: 6 months after your accounting year-end
Example: December year-end → File by June 30

WHAT TO FILE:
- CIT Return showing ₦0 tax
- Statement of accounts (not full audit for small companies)
- Computation of profits

STEP-BY-STEP:

1. PREPARE FINANCIAL STATEMENTS:
   - Income statement (profit & loss)
   - Balance sheet
   - Notes to accounts
   (Statement of accounts format OK for small companies)

2. LOG IN TO NRS PORTAL:
   - www.nrs.gov.ng or firs.gov.ng (transitioning)
   - Navigate to CIT Return

3. COMPLETE RETURN:
   - Company details and Tax ID
   - Accounting period
   - Turnover (must be ≤ ₦50M)
   - Net profit
   - CIT calculated: ₦0

4. UPLOAD DOCUMENTS:
   - Financial statements
   - Tax computation
   - Director details

5. SUBMIT:
   - Submit online
   - Download receipt
   - Keep for records

PENALTY FOR LATE FILING: ₦10 million + daily charges (Section 128 NTAA)

KEEP: Maintain records for 6 years in case of audit.',
  'medium', 180, 6
FROM tax_rules WHERE rule_code = 'BUSINESS_EXEMPT_001';

-- ============================================
-- ACTION ITEM TEMPLATES - MEDIUM/LARGE BUSINESS
-- ============================================

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Engage professional accountant',
  'WHAT TO DO: At turnover above ₦50M, professional accounting is essential.

WHY YOU NEED PROFESSIONAL HELP:
- 30% CIT requires accurate profit calculation
- Audited accounts are mandatory
- VAT compliance is complex
- Penalties are severe (₦10M+ for late CIT filing)
- Anti-avoidance rules apply

WHAT TO LOOK FOR:

1. CHARTERED ACCOUNTANT
   - Member of ICAN or ANAN
   - Experience with your industry
   - Can prepare audited accounts
   - Handles CIT filings

2. TAX CONSULTANT (Optional but recommended)
   - CITN registered
   - Specializes in tax planning
   - Maximizes legal deductions
   - Represents you in disputes

SERVICES NEEDED:
□ Monthly bookkeeping
□ Quarterly financial review
□ VAT return preparation (monthly)
□ CIT planning and filing
□ Annual audit
□ Payroll management

COST RANGE:
- Small accounting firm: ₦50,000 - ₦200,000/month
- Medium firm: ₦200,000 - ₦500,000/month

FINDING HELP:
- Ask for referrals from business peers
- Check ICAN directory: ican.org.ng
- Check CITN directory: citn.org',
  'high', 7, 1
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Register for VAT immediately',
  'WHAT TO DO: VAT registration is MANDATORY for companies above ₦50M turnover.

VAT BASICS:
- Rate: 7.5%
- You CHARGE VAT on sales
- You CLAIM VAT on business purchases
- Remit the difference monthly

REGISTRATION STEPS:
1. Visit www.nrs.gov.ng
2. Navigate to VAT Registration
3. Prepare:
   - Company Tax ID
   - CAC Certificate
   - Directors'' details
   - Bank account information
   - Business address proof
4. Complete application form
5. Submit online
6. Receive VAT Registration Number

AFTER REGISTRATION:
- Add VAT number to invoices
- Charge 7.5% VAT on all taxable supplies
- Invoice format must include:
  * Your VAT number
  * VAT amount shown separately
  * Sequential invoice number
  * Date

INPUT VAT:
- Keep all purchase invoices with VAT
- Claim input VAT monthly
- NTA 2025: Full recovery on services and capital expenditure now allowed',
  'high', 21, 2
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Set up monthly VAT filing system',
  'WHAT TO DO: Establish process for monthly VAT compliance.

VAT FILING DEADLINE: 21st of the following month
PENALTY: ₦100,000 first month + ₦50,000/additional month

MONTHLY PROCESS:

1. DURING THE MONTH:
   - Issue proper VAT invoices
   - Collect VAT on all sales
   - Keep all purchase invoices with VAT

2. MONTH END (By 15th):
   - Calculate Output VAT (VAT collected)
   - Calculate Input VAT (VAT paid on purchases)
   - Net VAT = Output - Input

3. FILE RETURN (By 21st):
   - Log in to NRS portal
   - Navigate to VAT Return
   - Enter month''s figures
   - Upload summary and invoices
   - Submit return

4. PAY (With return):
   - Pay net VAT via portal
   - Or generate reference and pay at bank
   - Keep payment receipt

VAT CALCULATION EXAMPLE:
- Sales for month: ₦10,000,000
- Output VAT (7.5%): ₦750,000
- Purchases: ₦4,000,000
- Input VAT (7.5%): ₦300,000
- VAT Payable: ₦450,000

CALENDAR: Set reminder for 18th each month to start preparation.',
  'high', 21, 3
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Plan for 30% CIT payment',
  'WHAT TO DO: Prepare for Company Income Tax at 30%.

CIT OBLIGATIONS:
- 30% on taxable profits
- Plus 4% Development Levy (on profits)
- Effective rate: ~34%

QUARTERLY ESTIMATED PAYMENTS:
- Pay estimated CIT quarterly
- Based on prior year or estimated current year
- Reduces year-end burden

CALCULATION:
Turnover: ₦_______
- Costs and Expenses: ₦_______
- Capital Allowances: ₦_______
= Taxable Profit: ₦_______
× 30% = CIT: ₦_______
+ 4% Dev Levy = ₦_______
TOTAL: ₦_______

DEDUCTIBLE EXPENSES:
- Staff salaries and benefits
- Rent and utilities
- Marketing and advertising
- Professional fees
- Bad debts (written off)
- Depreciation (via capital allowances)
- Interest on business loans

NON-DEDUCTIBLE:
- Personal expenses of directors
- Fines and penalties
- Donations (except to approved list)
- Entertainment (limited)

TAX PLANNING:
- Review expenses for deductibility
- Claim all capital allowances
- Time major purchases strategically',
  'high', 30, 4
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Arrange for annual statutory audit',
  'WHAT TO DO: Engage auditors for your mandatory annual audit.

REQUIREMENT: Companies above small company threshold must file AUDITED financial statements.

WHEN TO ENGAGE AUDITORS:
- At least 3 months before year-end
- Allows planning and interim work
- Avoids year-end rush

AUDIT PROCESS:
1. Engagement letter signed
2. Interim audit (during year)
3. Year-end stocktake observation
4. Final audit (after year-end)
5. Draft accounts review
6. Final signed accounts

WHAT AUDITORS NEED:
□ Complete accounting records
□ Bank statements and reconciliations
□ Fixed asset register
□ Inventory records
□ Debtors and creditors listings
□ Director/shareholder details
□ Minutes of board meetings
□ Prior year audited accounts

CHOOSING AUDITORS:
- Must be registered with ICAN/ANAN
- Experience in your industry preferred
- Get quotes from 2-3 firms
- Consider rotation (good governance)

COST: Typically ₦500,000 - ₦2,000,000+ depending on complexity

TIMELINE: Final signed accounts needed by filing deadline (6 months after year-end)',
  'high', 90, 5
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'File annual CIT return with audited accounts',
  'WHAT TO DO: Submit Company Income Tax return to NRS.

DEADLINE: 6 months after accounting year-end
LATE FILING PENALTY: ₦10 million + daily charges (Section 128 NTAA)

DOCUMENTS REQUIRED:
□ Audited financial statements
□ CIT computation
□ Capital allowance schedules
□ Tax payment receipts
□ VAT returns summary
□ Employee list and PAYE summary
□ Related party disclosures

FILING STEPS:

1. PREPARE TAX COMPUTATION:
   - Start with audited profit
   - Add back non-allowable expenses
   - Deduct non-taxable income
   - Apply capital allowances
   = Taxable profit
   × 30% = CIT
   + 4% Development Levy

2. RECONCILE PAYMENTS:
   - List all quarterly payments made
   - Credit WHT on income received
   = Balance payable or refund

3. LOG IN TO NRS PORTAL:
   - Company profile section
   - Navigate to CIT Return

4. COMPLETE RETURN:
   - Fill all schedules
   - Upload audited accounts
   - Upload computations

5. PAY BALANCE:
   - Pay any outstanding amount
   - Keep payment receipt

6. SUBMIT:
   - Submit return
   - Download confirmation
   - Keep for records',
  'high', 180, 6
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

INSERT INTO action_item_templates (tax_rule_id, title, description, priority, due_in_days, sort_order)
SELECT id,
  'Ensure complete employee compliance',
  'WHAT TO DO: Verify all employee tax and pension obligations are met.

YOUR OBLIGATIONS:

1. PAYE (Personal Income Tax):
   - Calculate using NTA 2025 rates
   - Income ≤ ₦800K = 0%
   - Deduct monthly
   - Remit to State IRS by 10th
   - Penalty: 40% of unremitted amount

2. PENSION (PRA 2014):
   - Employee: Minimum 8%
   - Employer: Minimum 10%
   - Remit to employee''s chosen PFA
   - Monthly by end of month

3. NHF (National Housing Fund):
   - 2.5% of basic salary
   - Remit to Federal Mortgage Bank

4. NSITF (NSITF Act):
   - 1% of payroll
   - Employer contribution

5. ITF (Industrial Training Fund):
   - 1% of annual payroll (if 5+ employees)

MONTHLY CHECKLIST:
□ Calculate PAYE for all employees
□ Deduct from salaries
□ Remit to State IRS by 10th
□ Remit pension by month-end
□ Remit NHF monthly
□ Keep all receipts

ANNUAL REQUIREMENTS:
□ Issue Form H1 to each employee
□ File employer annual return
□ Reconcile PAYE remittances

NON-COMPLIANCE RISK: NRS can enforce collection directly from company bank accounts (Section 64 NTAA).',
  'high', 14, 7
FROM tax_rules WHERE rule_code = 'BUSINESS_TAX_002';

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- After running the script, verify with:

-- Check rules created:
-- SELECT rule_code, applies_to[1] as category,
--        income_min, income_max, tax_rate || '%' as rate,
--        exemption_status, title
-- FROM tax_rules ORDER BY applies_to, income_min;

-- Check action items per rule:
-- SELECT r.rule_code, r.title, COUNT(t.id) as actions
-- FROM tax_rules r
-- LEFT JOIN action_item_templates t ON t.tax_rule_id = r.id
-- GROUP BY r.id, r.rule_code, r.title
-- ORDER BY r.applies_to, r.income_min;

-- Total counts:
-- SELECT 'Tax Rules' as type, COUNT(*) as count FROM tax_rules
-- UNION ALL
-- SELECT 'Action Templates', COUNT(*) FROM action_item_templates;
