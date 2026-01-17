// User Types
export interface User {
  id: string;
  email: string;
  full_name?: string;
  phone?: string;
  created_at: string;
}

// Tax Profile Types
export type WorkType = "salary_earner" | "freelancer" | "small_business";

export interface TaxProfile {
  id: string;
  user_id: string;
  work_type: WorkType;
  income_range_min: number;
  income_range_max: number;
  location: string;
  created_at: string;
  updated_at: string;
}

export interface TaxProfileInput {
  work_type: WorkType;
  income_range_min: number;
  income_range_max: number;
  location: string;
}

// Tax Rules Types
export type ExemptionStatus = "exempt" | "taxable";
export type Priority = "high" | "medium" | "low";

export interface TaxRule {
  id: string;
  rule_code: string;
  applies_to: WorkType[];
  income_min: number;
  income_max: number;
  tax_rate: number;
  exemption_status: ExemptionStatus;
  title: string;
  explanation: string;
  obligations: string[];
  active: boolean;
  action_item_templates?: ActionItemTemplate[];
}

export interface ActionItemTemplate {
  id: string;
  tax_rule_id: string;
  title: string;
  description: string;
  priority: Priority;
  due_in_days: number;
  sort_order: number;
}

// User Action Items
export interface UserActionItem {
  id: string;
  user_id: string;
  tax_rule_id: string;
  title: string;
  description: string;
  priority: Priority;
  due_date: string;
  completed: boolean;
  completed_at?: string;
  created_at: string;
}

// Notification Device
export interface NotificationDevice {
  id: string;
  user_id: string;
  player_id: string;
  platform: "ios" | "android";
  active: boolean;
  created_at: string;
}

// Income Range Options
export interface IncomeRange {
  label: string;
  min: number;
  max: number;
}

// Nigerian States
export const NIGERIAN_STATES = [
  "Abia",
  "Adamawa",
  "Akwa Ibom",
  "Anambra",
  "Bauchi",
  "Bayelsa",
  "Benue",
  "Borno",
  "Cross River",
  "Delta",
  "Ebonyi",
  "Edo",
  "Ekiti",
  "Enugu",
  "FCT Abuja",
  "Gombe",
  "Imo",
  "Jigawa",
  "Kaduna",
  "Kano",
  "Katsina",
  "Kebbi",
  "Kogi",
  "Kwara",
  "Lagos",
  "Nasarawa",
  "Niger",
  "Ogun",
  "Ondo",
  "Osun",
  "Oyo",
  "Plateau",
  "Rivers",
  "Sokoto",
  "Taraba",
  "Yobe",
  "Zamfara",
] as const;

// Income Range Options for Form
export const INCOME_RANGES: IncomeRange[] = [
  { label: "Below ₦800,000", min: 0, max: 800000 },
  { label: "₦800,001 - ₦1,500,000", min: 800001, max: 1500000 },
  { label: "₦1,500,001 - ₦3,000,000", min: 1500001, max: 3000000 },
  { label: "₦3,000,001 - ₦12,000,000", min: 3000001, max: 12000000 },
  { label: "₦12,000,001 - ₦25,000,000", min: 12000001, max: 25000000 },
  { label: "Above ₦25,000,000", min: 25000001, max: 100000000 },
];

// Work Type Options for Form
export const WORK_TYPE_OPTIONS = [
  { label: "Salary Earner / Employee", value: "salary_earner" },
  { label: "Freelancer / Gig Worker", value: "freelancer" },
  { label: "Small Business Owner", value: "small_business" },
] as const;

// Tax Check Result
export interface TaxCheckResult {
  rule: TaxRule;
  actionItems: UserActionItem[];
}

// Auth State
export interface AuthState {
  user: User | null;
  session: any | null;
  isLoading: boolean;
  isAuthenticated: boolean;
}

// App State
export interface AppState {
  taxProfile: TaxProfile | null;
  currentTaxRule: TaxRule | null;
  actionItems: UserActionItem[];
}
