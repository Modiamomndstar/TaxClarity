// Supabase Edge Function: send-reminders
// Sends push notifications for upcoming action item due dates
// This function should be triggered by a cron job (e.g., daily at 9am)

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// OneSignal API configuration
const ONESIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID") ?? "";
const ONESIGNAL_REST_API_KEY = Deno.env.get("ONESIGNAL_REST_API_KEY") ?? "";

interface ActionItemWithUser {
  id: string;
  user_id: string;
  title: string;
  description: string;
  priority: string;
  due_date: string;
  completed: boolean;
}

interface NotificationDevice {
  player_id: string;
  platform: string;
}

async function sendOneSignalNotification(
  playerIds: string[],
  title: string,
  body: string,
  data?: Record<string, any>
): Promise<boolean> {
  if (!ONESIGNAL_APP_ID || !ONESIGNAL_REST_API_KEY) {
    console.log("OneSignal not configured, skipping notification");
    return false;
  }

  try {
    const response = await fetch("https://onesignal.com/api/v1/notifications", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Basic ${ONESIGNAL_REST_API_KEY}`,
      },
      body: JSON.stringify({
        app_id: ONESIGNAL_APP_ID,
        include_player_ids: playerIds,
        headings: { en: title },
        contents: { en: body },
        data: data || {},
      }),
    });

    const result = await response.json();
    console.log("OneSignal response:", result);
    return response.ok;
  } catch (error) {
    console.error("Error sending OneSignal notification:", error);
    return false;
  }
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Create Supabase client with service role key
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const today = new Date();
    const todayStr = today.toISOString().split("T")[0];

    // Calculate dates for reminders (7 days, 3 days, and due today)
    const sevenDaysLater = new Date(today);
    sevenDaysLater.setDate(sevenDaysLater.getDate() + 7);
    const sevenDaysStr = sevenDaysLater.toISOString().split("T")[0];

    const threeDaysLater = new Date(today);
    threeDaysLater.setDate(threeDaysLater.getDate() + 3);
    const threeDaysStr = threeDaysLater.toISOString().split("T")[0];

    // Fetch action items that are due today, in 3 days, or in 7 days (and not completed)
    const { data: actionItems, error: itemsError } = await supabase
      .from("user_action_items")
      .select("*")
      .eq("completed", false)
      .in("due_date", [todayStr, threeDaysStr, sevenDaysStr]);

    if (itemsError) {
      console.error("Error fetching action items:", itemsError);
      return new Response(
        JSON.stringify({ error: "Failed to fetch action items" }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    if (!actionItems || actionItems.length === 0) {
      return new Response(
        JSON.stringify({ message: "No reminders to send", sent: 0 }),
        {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    console.log(`Found ${actionItems.length} action items for reminders`);

    // Group action items by user
    const userActionItems: Map<string, ActionItemWithUser[]> = new Map();
    for (const item of actionItems) {
      const items = userActionItems.get(item.user_id) || [];
      items.push(item);
      userActionItems.set(item.user_id, items);
    }

    let notificationsSent = 0;

    // Process each user
    for (const [userId, items] of userActionItems) {
      // Fetch user's notification devices
      const { data: devices, error: devicesError } = await supabase
        .from("notification_devices")
        .select("player_id, platform")
        .eq("user_id", userId)
        .eq("active", true);

      if (devicesError || !devices || devices.length === 0) {
        console.log(`No devices found for user ${userId}`);
        continue;
      }

      const playerIds = devices.map((d: NotificationDevice) => d.player_id);

      // Send notification for each action item
      for (const item of items) {
        let title = "TaxClarity NG Reminder";
        let body = "";

        if (item.due_date === todayStr) {
          title = "⚠️ Action Due Today!";
          body = `"${item.title}" is due today. Complete it to stay compliant.`;
        } else if (item.due_date === threeDaysStr) {
          title = "📅 Action Due in 3 Days";
          body = `"${item.title}" is due in 3 days. Don't forget to complete it.`;
        } else if (item.due_date === sevenDaysStr) {
          title = "📋 Upcoming Action";
          body = `"${item.title}" is due in 7 days. Start planning now.`;
        }

        const sent = await sendOneSignalNotification(playerIds, title, body, {
          actionItemId: item.id,
          type: "reminder",
        });

        if (sent) {
          notificationsSent++;

          // Log notification in history
          await supabase.from("notification_history").insert({
            user_id: userId,
            action_item_id: item.id,
            title,
            body,
            status: "sent",
          });
        }
      }
    }

    return new Response(
      JSON.stringify({
        message: "Reminders processed",
        usersNotified: userActionItems.size,
        notificationsSent,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Error in send-reminders:", error);
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
