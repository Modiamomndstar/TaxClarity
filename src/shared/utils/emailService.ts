// Email Service - Uses Supabase Edge Function with Resend
import { supabase } from "../config/supabase";

export type EmailTemplate = "welcome" | "reminder" | "deadlineAlert" | "custom";

interface WelcomeEmailData {
  name: string;
}

interface ReminderEmailData {
  name: string;
  taskTitle: string;
  dueDate: string;
  daysLeft: number;
}

interface DeadlineAlertData {
  name: string;
  deadline: string;
  description: string;
}

interface CustomEmailData {
  subject: string;
  html: string;
}

type EmailData =
  | WelcomeEmailData
  | ReminderEmailData
  | DeadlineAlertData
  | CustomEmailData;

interface SendEmailResult {
  success: boolean;
  messageId?: string;
  error?: string;
}

/**
 * Send an email using the Resend-powered Edge Function
 * @param to - Recipient email address
 * @param template - Email template to use
 * @param data - Template-specific data
 */
export async function sendEmail(
  to: string,
  template: EmailTemplate,
  data: EmailData
): Promise<SendEmailResult> {
  try {
    const { data: result, error } = await supabase.functions.invoke(
      "send-email",
      {
        body: { to, template, data },
      }
    );

    if (error) {
      console.error("Email function error:", error);
      return { success: false, error: error.message };
    }

    return result as SendEmailResult;
  } catch (error: any) {
    console.error("Failed to send email:", error);
    return { success: false, error: error.message || "Unknown error" };
  }
}

/**
 * Send a welcome email to a new user
 */
export async function sendWelcomeEmail(
  email: string,
  name: string
): Promise<SendEmailResult> {
  return sendEmail(email, "welcome", { name });
}

/**
 * Send a task reminder email
 */
export async function sendReminderEmail(
  email: string,
  name: string,
  taskTitle: string,
  dueDate: string,
  daysLeft: number
): Promise<SendEmailResult> {
  return sendEmail(email, "reminder", { name, taskTitle, dueDate, daysLeft });
}

/**
 * Send a tax deadline alert email
 */
export async function sendDeadlineAlertEmail(
  email: string,
  name: string,
  deadline: string,
  description: string
): Promise<SendEmailResult> {
  return sendEmail(email, "deadlineAlert", { name, deadline, description });
}

/**
 * Send a custom email
 */
export async function sendCustomEmail(
  email: string,
  subject: string,
  html: string
): Promise<SendEmailResult> {
  return sendEmail(email, "custom", { subject, html });
}
