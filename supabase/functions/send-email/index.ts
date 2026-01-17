// Supabase Edge Function: send-email
// Sends emails using Resend API
// Use cases: Welcome emails, tax reminders, deadline alerts, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY") ?? "";

// Email templates
const templates = {
  welcome: (name: string) => ({
    subject: "Welcome to TaxClarity NG! 🎉",
    html: `
      <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="text-align: center; margin-bottom: 30px;">
          <h1 style="color: #008751; margin: 0;">TaxClarity NG</h1>
          <p style="color: #666; margin: 5px 0;">Your Personal Tax Guide</p>
        </div>

        <h2 style="color: #333;">Welcome, ${name}! 👋</h2>

        <p style="color: #555; line-height: 1.6;">
          Thank you for joining TaxClarity NG. We're here to help you understand
          Nigeria's 2026 tax reforms in simple, clear language.
        </p>

        <div style="background: #f8f9fa; border-left: 4px solid #008751; padding: 15px; margin: 20px 0;">
          <h3 style="color: #008751; margin-top: 0;">Get Started:</h3>
          <ul style="color: #555; line-height: 1.8;">
            <li>Complete your tax profile for personalized guidance</li>
            <li>Explore what the new reforms mean for you</li>
            <li>Get action items and deadline reminders</li>
          </ul>
        </div>

        <p style="color: #555; line-height: 1.6;">
          If you have any questions, just reply to this email or use the in-app chat.
        </p>

        <p style="color: #555;">
          Best regards,<br/>
          <strong>The TaxClarity NG Team</strong>
        </p>

        <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;" />

        <p style="color: #999; font-size: 12px; text-align: center;">
          TaxClarity NG - Making Nigerian Taxes Simple<br/>
          <a href="https://modiamomndstar.github.io/TaxClarity/" style="color: #008751;">Visit our website</a>
        </p>
      </div>
    `,
  }),

  reminder: (
    name: string,
    taskTitle: string,
    dueDate: string,
    daysLeft: number
  ) => ({
    subject: `⏰ Tax Reminder: ${taskTitle} due ${
      daysLeft === 0 ? "today!" : `in ${daysLeft} days`
    }`,
    html: `
      <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="text-align: center; margin-bottom: 30px;">
          <h1 style="color: #008751; margin: 0;">TaxClarity NG</h1>
        </div>

        <h2 style="color: #333;">Hi ${name},</h2>

        <div style="background: ${
          daysLeft === 0 ? "#fff3cd" : daysLeft <= 3 ? "#f8d7da" : "#d4edda"
        };
                    border-radius: 8px; padding: 20px; margin: 20px 0;">
          <h3 style="color: ${
            daysLeft === 0 ? "#856404" : daysLeft <= 3 ? "#721c24" : "#155724"
          }; margin-top: 0;">
            ${
              daysLeft === 0
                ? "🚨 Due Today!"
                : daysLeft <= 3
                ? "⚠️ Urgent Reminder"
                : "📅 Upcoming Deadline"
            }
          </h3>
          <p style="font-size: 18px; color: #333; margin: 10px 0;">
            <strong>${taskTitle}</strong>
          </p>
          <p style="color: #666;">
            Due Date: <strong>${dueDate}</strong>
          </p>
        </div>

        <p style="color: #555; line-height: 1.6;">
          Open the TaxClarity NG app to view details and complete this action item.
        </p>

        <p style="color: #555;">
          Best regards,<br/>
          <strong>TaxClarity NG</strong>
        </p>

        <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;" />

        <p style="color: #999; font-size: 12px; text-align: center;">
          You're receiving this because you enabled email reminders in TaxClarity NG.
        </p>
      </div>
    `,
  }),

  deadlineAlert: (name: string, deadline: string, description: string) => ({
    subject: `🔔 Important Tax Deadline: ${deadline}`,
    html: `
      <div style="font-family: 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="text-align: center; margin-bottom: 30px;">
          <h1 style="color: #008751; margin: 0;">TaxClarity NG</h1>
        </div>

        <h2 style="color: #333;">Hi ${name},</h2>

        <div style="background: #e3f2fd; border-left: 4px solid #2196f3; padding: 15px; margin: 20px 0;">
          <h3 style="color: #1976d2; margin-top: 0;">📢 Tax Deadline Alert</h3>
          <p style="font-size: 18px; color: #333; margin: 10px 0;">
            <strong>${deadline}</strong>
          </p>
          <p style="color: #666; line-height: 1.6;">
            ${description}
          </p>
        </div>

        <p style="color: #555; line-height: 1.6;">
          Make sure you're prepared! Open TaxClarity NG to see how this affects you.
        </p>

        <p style="color: #555;">
          Best regards,<br/>
          <strong>TaxClarity NG</strong>
        </p>
      </div>
    `,
  }),

  custom: (subject: string, htmlContent: string) => ({
    subject,
    html: htmlContent,
  }),
};

interface EmailRequest {
  to: string;
  template: "welcome" | "reminder" | "deadlineAlert" | "custom";
  data: Record<string, any>;
}

async function sendEmail(
  to: string,
  subject: string,
  html: string
): Promise<{ success: boolean; error?: string; id?: string }> {
  if (!RESEND_API_KEY) {
    console.error("RESEND_API_KEY not configured");
    return { success: false, error: "Email service not configured" };
  }

  try {
    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        // Use your verified domain in production, or onboarding@resend.dev for testing
        from:
          Deno.env.get("RESEND_FROM_EMAIL") ||
          "TaxClarity NG <onboarding@resend.dev>",
        to: [to],
        subject,
        html,
      }),
    });

    const result = await response.json();

    if (!response.ok) {
      console.error("Resend API error:", result);
      return {
        success: false,
        error: result.message || "Failed to send email",
      };
    }

    console.log("Email sent successfully:", result);
    return { success: true, id: result.id };
  } catch (error) {
    console.error("Error sending email:", error);
    return { success: false, error: error.message };
  }
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { to, template, data }: EmailRequest = await req.json();

    if (!to || !template) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: to, template" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    let emailContent: { subject: string; html: string };

    switch (template) {
      case "welcome":
        emailContent = templates.welcome(data.name || "there");
        break;

      case "reminder":
        emailContent = templates.reminder(
          data.name || "there",
          data.taskTitle || "Action Required",
          data.dueDate || "Soon",
          data.daysLeft ?? 7
        );
        break;

      case "deadlineAlert":
        emailContent = templates.deadlineAlert(
          data.name || "there",
          data.deadline || "Upcoming deadline",
          data.description || "Check the app for details."
        );
        break;

      case "custom":
        if (!data.subject || !data.html) {
          return new Response(
            JSON.stringify({
              error: "Custom template requires subject and html",
            }),
            {
              status: 400,
              headers: { ...corsHeaders, "Content-Type": "application/json" },
            }
          );
        }
        emailContent = templates.custom(data.subject, data.html);
        break;

      default:
        return new Response(
          JSON.stringify({ error: `Unknown template: ${template}` }),
          {
            status: 400,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
    }

    const result = await sendEmail(to, emailContent.subject, emailContent.html);

    if (result.success) {
      return new Response(
        JSON.stringify({ success: true, messageId: result.id }),
        {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    } else {
      return new Response(
        JSON.stringify({ success: false, error: result.error }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }
  } catch (error) {
    console.error("Function error:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
