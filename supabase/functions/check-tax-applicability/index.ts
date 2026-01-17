// Supabase Edge Function: check-tax-applicability
// Matches user profile to tax rules and generates action items

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface TaxCheckRequest {
  workType: "salary_earner" | "freelancer" | "small_business";
  incomeMin: number;
  incomeMax: number;
  location: string;
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Get request body
    const { workType, incomeMin, incomeMax, location }: TaxCheckRequest =
      await req.json();

    // Validate input
    if (
      !workType ||
      incomeMin === undefined ||
      incomeMax === undefined ||
      !location
    ) {
      return new Response(
        JSON.stringify({
          error:
            "Missing required fields: workType, incomeMin, incomeMax, location",
        }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Create Supabase client with service role key
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Get user from auth header
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authorization header" }),
        {
          status: 401,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const token = authHeader.replace("Bearer ", "");
    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser(token);

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: "Invalid or expired token" }),
        {
          status: 401,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Find matching tax rule
    // Query tax rules that apply to the user's work type and income range
    const { data: taxRules, error: rulesError } = await supabase
      .from("tax_rules")
      .select(
        `
        *,
        action_item_templates (*)
      `
      )
      .eq("active", true)
      .contains("applies_to", [workType])
      .lte("income_min", incomeMax)
      .gte("income_max", incomeMin)
      .order("income_min", { ascending: true })
      .limit(1);

    if (rulesError) {
      console.error("Error fetching tax rules:", rulesError);
      return new Response(
        JSON.stringify({ error: "Failed to fetch tax rules" }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    if (!taxRules || taxRules.length === 0) {
      return new Response(
        JSON.stringify({
          error: "No matching tax rule found for your profile",
        }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const matchedRule = taxRules[0];

    // Delete existing action items for this user
    await supabase.from("user_action_items").delete().eq("user_id", user.id);

    // Generate user action items from templates
    const actionItemsToInsert =
      matchedRule.action_item_templates?.map((template: any) => {
        const dueDate = new Date();
        dueDate.setDate(dueDate.getDate() + template.due_in_days);

        return {
          user_id: user.id,
          tax_rule_id: matchedRule.id,
          title: template.title,
          description: template.description,
          priority: template.priority,
          due_date: dueDate.toISOString().split("T")[0],
          completed: false,
        };
      }) || [];

    // Insert new action items
    let insertedActionItems: any[] = [];
    if (actionItemsToInsert.length > 0) {
      const { data: insertedItems, error: insertError } = await supabase
        .from("user_action_items")
        .insert(actionItemsToInsert)
        .select();

      if (insertError) {
        console.error("Error inserting action items:", insertError);
        return new Response(
          JSON.stringify({ error: "Failed to create action items" }),
          {
            status: 500,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      insertedActionItems = insertedItems || [];
    }

    // Return the matched rule and generated action items
    // Remove templates from response to reduce payload size
    const { action_item_templates, ...ruleWithoutTemplates } = matchedRule;

    return new Response(
      JSON.stringify({
        rule: ruleWithoutTemplates,
        actionItems: insertedActionItems,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Error in check-tax-applicability:", error);
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
