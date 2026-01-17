// app.config.js - Dynamic configuration for Expo
// This overrides app.json and provides more control

export default {
  expo: {
    name: "TaxClarity NG",
    slug: "taxclarity-ng",
    version: "1.0.0",
    orientation: "portrait",
    icon: "./assets/icon.png",
    userInterfaceStyle: "light",

    // Use Hermes for mobile (recommended for SDK 54), JSC causes issues
    // jsEngine setting removed - use default Hermes

    splash: {
      image: "./assets/splash.png",
      resizeMode: "contain",
      backgroundColor: "#008751",
    },
    assetBundlePatterns: ["**/*"],
    ios: {
      supportsTablet: true,
      bundleIdentifier: "com.taxclarity.ng",
    },
    android: {
      adaptiveIcon: {
        foregroundImage: "./assets/adaptive-icon.png",
        backgroundColor: "#008751",
      },
      package: "com.taxclarity.ng",
      // Use Hermes (default) for Android - more stable
    },
    web: {
      favicon: "./assets/favicon.png",
      bundler: "metro",
      output: "single",
    },
    plugins: ["expo-font"],

    // EAS configuration
    extra: {
      eas: {
        projectId: "033f5853-ca6a-479b-ad25-e822c80b6a5a",
      },
      // Supabase configuration - these will be available in the built app
      supabaseUrl:
        process.env.EXPO_PUBLIC_SUPABASE_URL ||
        "https://vwuhpsxincuwhztcyfre.supabase.co",
      supabaseAnonKey:
        process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY ||
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3dWhwc3hpbmN1d2h6dGN5ZnJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1ODE5MzMsImV4cCI6MjA4NDE1NzkzM30.DfE-BNtJhyRG2o9wl1dBa-c3kSNEOoTwBLTwEPhrP94",
    },
  },
};
