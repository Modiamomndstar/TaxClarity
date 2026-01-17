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

    // CRITICAL: Use JavaScriptCore instead of Hermes to avoid import.meta errors on web
    jsEngine: "jsc",

    splash: {
      image: "./assets/splash.png",
      resizeMode: "contain",
      backgroundColor: "#008751",
    },
    assetBundlePatterns: ["**/*"],
    ios: {
      supportsTablet: true,
      bundleIdentifier: "com.taxclarity.ng",
      jsEngine: "jsc",
    },
    android: {
      adaptiveIcon: {
        foregroundImage: "./assets/adaptive-icon.png",
        backgroundColor: "#008751",
      },
      package: "com.taxclarity.ng",
      jsEngine: "jsc",
    },
    web: {
      favicon: "./assets/favicon.png",
      bundler: "metro",
      output: "single",
      // Force non-Hermes for web
      build: {
        babel: {
          include: ["@expo/vector-icons"],
        },
      },
    },
    plugins: [],

    // Extra configuration
    extra: {
      // Ensure we're not using Hermes transforms
      eas: {
        projectId: "taxclarity-ng",
      },
    },
  },
};
