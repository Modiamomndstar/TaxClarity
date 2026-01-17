// Learn more https://docs.expo.dev/guides/customizing-metro
const { getDefaultConfig } = require("expo/metro-config");

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

// CRITICAL: Force non-Hermes transform for web platform
// This addresses the "Cannot use 'import.meta' outside a module" error

// 1. Disable Hermes parser
config.transformer = {
  ...config.transformer,
  hermesParser: false,
  // Force default (non-Hermes) transform profile
  unstable_transformProfile: "default",
  getTransformOptions: async () => ({
    transform: {
      experimentalImportSupport: false,
      inlineRequires: true,
    },
  }),
};

// 2. Configure resolver for web
config.resolver = {
  ...config.resolver,
  sourceExts: [...config.resolver.sourceExts, "mjs", "cjs"],
  // Ensure web platform resolution
  resolverMainFields: ["browser", "main", "module"],
};

// 3. Override server to rewrite Hermes-related URL parameters for web
config.server = {
  ...config.server,
  rewriteRequestUrl: (url) => {
    // For web platform requests, remove Hermes engine parameters
    if (url.includes("platform=web")) {
      let newUrl = url;
      // Remove Hermes engine
      newUrl = newUrl.replace(/transform\.engine=hermes/g, "transform.engine=");
      // Change transform profile from hermes-stable to default
      newUrl = newUrl.replace(
        /unstable_transformProfile=hermes-stable/g,
        "unstable_transformProfile=default"
      );
      return newUrl;
    }
    return url;
  },
};

module.exports = config;
