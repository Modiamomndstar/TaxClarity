import { create } from "zustand";
import { supabase } from "../config/supabase";
import type {
  User,
  TaxProfile,
  TaxRule,
  UserActionItem,
  TaxProfileInput,
} from "../types";

// Auth Store
interface AuthStore {
  user: User | null;
  session: any | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  initialize: () => Promise<void>;
  signUp: (email: string, password: string, fullName: string) => Promise<void>;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  setUser: (user: User | null) => void;
  setSession: (session: any | null) => void;
}

export const useAuthStore = create<AuthStore>((set, get) => ({
  user: null,
  session: null,
  isLoading: true,
  isAuthenticated: false,

  initialize: async () => {
    try {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (session?.user) {
        set({
          user: {
            id: session.user.id,
            email: session.user.email!,
            full_name: session.user.user_metadata?.full_name,
            created_at: session.user.created_at,
          },
          session,
          isAuthenticated: true,
          isLoading: false,
        });
      } else {
        set({ isLoading: false });
      }

      // Listen for auth changes
      supabase.auth.onAuthStateChange((_event, session) => {
        if (session?.user) {
          set({
            user: {
              id: session.user.id,
              email: session.user.email!,
              full_name: session.user.user_metadata?.full_name,
              created_at: session.user.created_at,
            },
            session,
            isAuthenticated: true,
          });
        } else {
          set({ user: null, session: null, isAuthenticated: false });
        }
      });
    } catch (error) {
      console.error("Error initializing auth:", error);
      set({ isLoading: false });
    }
  },

  signUp: async (email: string, password: string, fullName: string) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { full_name: fullName },
      },
    });
    if (error) throw error;
    if (data.user) {
      set({
        user: {
          id: data.user.id,
          email: data.user.email!,
          full_name: fullName,
          created_at: data.user.created_at,
        },
        session: data.session,
        isAuthenticated: true,
      });
    }
  },

  signIn: async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) throw error;
    if (data.user) {
      set({
        user: {
          id: data.user.id,
          email: data.user.email!,
          full_name: data.user.user_metadata?.full_name,
          created_at: data.user.created_at,
        },
        session: data.session,
        isAuthenticated: true,
      });
    }
  },

  signOut: async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    set({ user: null, session: null, isAuthenticated: false });
  },

  setUser: (user) => set({ user }),
  setSession: (session) => set({ session }),
}));

// App Store - Tax Profile and Action Items
interface AppStore {
  taxProfile: TaxProfile | null;
  currentTaxRule: TaxRule | null;
  actionItems: UserActionItem[];
  isLoading: boolean;

  // Tax Profile Actions
  fetchTaxProfile: () => Promise<void>;
  saveTaxProfile: (profile: TaxProfileInput) => Promise<void>;

  // Tax Check Actions
  checkTaxApplicability: (profile: TaxProfileInput) => Promise<TaxRule>;

  // Action Items
  fetchActionItems: () => Promise<void>;
  toggleActionItemComplete: (
    itemId: string,
    completed: boolean
  ) => Promise<void>;
  subscribeToActionItems: () => () => void;

  // Setters
  setTaxProfile: (profile: TaxProfile | null) => void;
  setCurrentTaxRule: (rule: TaxRule | null) => void;
  setActionItems: (items: UserActionItem[]) => void;
}

export const useAppStore = create<AppStore>((set, get) => ({
  taxProfile: null,
  currentTaxRule: null,
  actionItems: [],
  isLoading: false,

  fetchTaxProfile: async () => {
    const user = useAuthStore.getState().user;
    if (!user) return;

    set({ isLoading: true });
    try {
      const { data, error } = await supabase
        .from("tax_profiles")
        .select("*")
        .eq("user_id", user.id)
        .single();

      if (error && error.code !== "PGRST116") throw error;
      set({ taxProfile: data, isLoading: false });
    } catch (error) {
      console.error("Error fetching tax profile:", error);
      set({ isLoading: false });
    }
  },

  saveTaxProfile: async (profile: TaxProfileInput) => {
    const user = useAuthStore.getState().user;
    if (!user) throw new Error("User not authenticated");

    const { data, error } = await supabase
      .from("tax_profiles")
      .upsert(
        {
          user_id: user.id,
          work_type: profile.work_type,
          income_range_min: profile.income_range_min,
          income_range_max: profile.income_range_max,
          location: profile.location,
          updated_at: new Date().toISOString(),
        },
        { onConflict: "user_id" }
      )
      .select()
      .single();

    if (error) throw error;
    set({ taxProfile: data });
  },

  checkTaxApplicability: async (profile: TaxProfileInput) => {
    const user = useAuthStore.getState().user;
    if (!user) throw new Error("User not authenticated");

    // Query tax rules directly from database (instead of Edge Function)
    const { data: rules, error: rulesError } = await supabase
      .from("tax_rules")
      .select("*")
      .eq("active", true);

    if (rulesError) throw rulesError;

    console.log("Available rules:", rules?.length);
    console.log("Looking for work_type:", profile.work_type);
    console.log("Income range:", profile.income_range_min, "-", profile.income_range_max);

    // Find matching rule based on profile
    // Use the user's MAX income to find the appropriate tax bracket
    const matchingRule = rules?.find((rule: any) => {
      const appliesToMatch = rule.applies_to.includes(profile.work_type);
      // Check if user's income falls within this rule's bracket
      // Use income_range_max to determine which bracket they fall into
      const incomeMatch =
        profile.income_range_max >= rule.income_min &&
        profile.income_range_max <= rule.income_max;
      console.log(`Rule ${rule.rule_code}: applies=${appliesToMatch}, income=${incomeMatch}`);
      return appliesToMatch && incomeMatch;
    });

    if (!matchingRule) {
      // Default rule if no match found
      const defaultRule: TaxRule = {
        id: "default",
        rule_code: "DEFAULT",
        applies_to: [profile.work_type],
        income_min: profile.income_range_min,
        income_max: profile.income_range_max,
        tax_rate: 0,
        exemption_status: "taxable",
        title: "Standard Tax Applies",
        explanation:
          "Based on your profile, standard tax rules apply. Please consult with a tax professional for specific guidance.",
        obligations: [
          "Register with your State Internal Revenue Service",
          "Keep records of your income and expenses",
          "File annual tax returns",
        ],
        active: true,
        created_at: new Date().toISOString(),
      };
      set({ currentTaxRule: defaultRule });
      return defaultRule;
    }

    // Fetch action item templates for this rule
    const { data: templates, error: templatesError } = await supabase
      .from("action_item_templates")
      .select("*")
      .eq("tax_rule_id", matchingRule.id)
      .order("sort_order", { ascending: true });

    if (templatesError) {
      console.error("Error fetching templates:", templatesError);
    }

    // Create user action items from templates
    if (templates && templates.length > 0) {
      // First, delete any existing action items for this user to prevent duplicates
      const { error: deleteError } = await supabase
        .from("user_action_items")
        .delete()
        .eq("user_id", user.id);

      if (deleteError) {
        console.error("Error deleting existing action items:", deleteError);
      }

      const actionItemsToInsert = templates.map((template: any) => ({
        user_id: user.id,
        tax_rule_id: matchingRule.id,
        title: template.title,
        description: template.description,
        priority: template.priority,
        due_date: new Date(
          Date.now() + template.due_in_days * 24 * 60 * 60 * 1000
        )
          .toISOString()
          .split("T")[0],
        completed: false,
      }));

      const { data: insertedItems, error: insertError } = await supabase
        .from("user_action_items")
        .insert(actionItemsToInsert)
        .select();

      if (insertError) {
        console.error("Error creating action items:", insertError);
      } else {
        set({ actionItems: insertedItems || [] });
      }
    }

    set({ currentTaxRule: matchingRule });
    return matchingRule;
  },

  fetchActionItems: async () => {
    const user = useAuthStore.getState().user;
    if (!user) return;

    set({ isLoading: true });
    try {
      const { data, error } = await supabase
        .from("user_action_items")
        .select("*")
        .eq("user_id", user.id)
        .order("priority", { ascending: true })
        .order("due_date", { ascending: true });

      if (error) throw error;
      set({ actionItems: data || [], isLoading: false });
    } catch (error) {
      console.error("Error fetching action items:", error);
      set({ isLoading: false });
    }
  },

  toggleActionItemComplete: async (itemId: string, completed: boolean) => {
    const { data, error } = await supabase
      .from("user_action_items")
      .update({
        completed,
        completed_at: completed ? new Date().toISOString() : null,
      })
      .eq("id", itemId)
      .select()
      .single();

    if (error) throw error;

    // Update local state optimistically
    const items = get().actionItems.map((item) =>
      item.id === itemId
        ? { ...item, completed, completed_at: data.completed_at }
        : item
    );
    set({ actionItems: items });
  },

  subscribeToActionItems: () => {
    const user = useAuthStore.getState().user;
    if (!user) return () => {};

    const subscription = supabase
      .channel("user_action_items_changes")
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "user_action_items",
          filter: `user_id=eq.${user.id}`,
        },
        (payload) => {
          // Refetch action items on any change
          get().fetchActionItems();
        }
      )
      .subscribe();

    return () => {
      subscription.unsubscribe();
    };
  },

  setTaxProfile: (profile) => set({ taxProfile: profile }),
  setCurrentTaxRule: (rule) => set({ currentTaxRule: rule }),
  setActionItems: (items) => set({ actionItems: items }),
}));
