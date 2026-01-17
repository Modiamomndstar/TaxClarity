module.exports = function (api) {
  // Cache based on the platform
  api.cache.using(() => process.env.EXPO_PLATFORM || "default");

  return {
    presets: [
      [
        "babel-preset-expo",
        {
          // CRITICAL: Use 'default' instead of 'hermes-stable' to avoid import.meta
          // This is the key setting to fix web compatibility
          unstable_transformProfile: "default",
          // Use automatic JSX runtime
          jsxRuntime: "automatic",
        },
      ],
    ],
    env: {
      // Specific settings for web builds
      production: {
        plugins: [],
      },
    },
  };
};
