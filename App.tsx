import 'react-native-gesture-handler';
import 'react-native-url-polyfill/auto';
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, StatusBar, Platform } from 'react-native';
import { SafeAreaProvider, initialWindowMetrics } from 'react-native-safe-area-context';
import { AppNavigator } from './src/navigation';
import { useAuthStore } from './src/store';
import { colors, typography } from './src/theme';

// Web-specific styles
const webStyles = Platform.OS === 'web' ? {
  position: 'fixed' as const,
  top: 0,
  left: 0,
  right: 0,
  bottom: 0,
  width: '100%',
  height: '100%',
} : {};

export default function App() {
  const [isReady, setIsReady] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const initialize = useAuthStore((state) => state.initialize);
  const isLoading = useAuthStore((state) => state.isLoading);

  useEffect(() => {
    const initApp = async () => {
      try {
        await initialize();
      } catch (err: any) {
        console.error('Failed to initialize app:', err);
        setError(err?.message || 'Failed to initialize');
      } finally {
        setIsReady(true);
      }
    };

    // Add a small delay for web to ensure DOM is ready
    if (Platform.OS === 'web') {
      setTimeout(initApp, 100);
    } else {
      initApp();
    }
  }, [initialize]);

  // Show error if initialization failed
  if (error) {
    return (
      <View style={[styles.loadingContainer, webStyles]}>
        <StatusBar barStyle="dark-content" backgroundColor={colors.white} />
        <Text style={styles.appName}>⚠️ Error</Text>
        <Text style={styles.tagline}>{error}</Text>
      </View>
    );
  }

  // Show splash/loading screen while initializing
  if (!isReady || isLoading) {
    return (
      <View style={[styles.loadingContainer, webStyles]}>
        <StatusBar barStyle="dark-content" backgroundColor={colors.white} />
        <View style={styles.logoContainer}>
          <Text style={styles.logoEmoji}>🇳🇬</Text>
        </View>
        <Text style={styles.appName}>TaxClarity NG</Text>
        <Text style={styles.tagline}>Understanding tax, simplified</Text>
        <ActivityIndicator size="large" color={colors.primary} style={styles.loader} />
      </View>
    );
  }

  return (
    <View style={[{ flex: 1 }, webStyles]}>
      <SafeAreaProvider initialMetrics={initialWindowMetrics}>
        <StatusBar barStyle="dark-content" backgroundColor={colors.white} />
        <AppNavigator />
      </SafeAreaProvider>
    </View>
  );
}

const styles = StyleSheet.create({
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.white,
  },
  logoContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: colors.primary + '15',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 24,
  },
  logoEmoji: {
    fontSize: 50,
  },
  appName: {
    fontSize: typography.h1,
    fontWeight: typography.bold,
    color: colors.primary,
    marginBottom: 8,
  },
  tagline: {
    fontSize: typography.body,
    color: colors.textSecondary,
    marginBottom: 32,
  },
  loader: {
    marginTop: 16,
  },
});
