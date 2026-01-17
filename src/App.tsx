import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ActivityIndicator,
  StatusBar,
} from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { AppNavigator } from './navigation';
import { useAuthStore } from './store';
import { colors, typography } from './theme';

const App: React.FC = () => {
  const [isReady, setIsReady] = useState(false);
  const initialize = useAuthStore((state) => state.initialize);
  const isLoading = useAuthStore((state) => state.isLoading);

  useEffect(() => {
    const initApp = async () => {
      try {
        await initialize();
      } catch (error) {
        console.error('Failed to initialize app:', error);
      } finally {
        setIsReady(true);
      }
    };

    initApp();
  }, [initialize]);

  // Show splash/loading screen while initializing
  if (!isReady || isLoading) {
    return (
      <View style={styles.loadingContainer}>
        <StatusBar barStyle="dark-content" backgroundColor={colors.white} />
        <View style={styles.logoContainer}>
          <Text style={styles.logoEmoji}>🇳🇬</Text>
        </View>
        <Text style={styles.appName}>TaxClarity NG</Text>
        <Text style={styles.tagline}>Understanding tax, simplified</Text>
        <ActivityIndicator
          size="large"
          color={colors.primary}
          style={styles.loader}
        />
      </View>
    );
  }

  return (
    <SafeAreaProvider>
      <StatusBar barStyle="dark-content" backgroundColor={colors.white} />
      <AppNavigator />
    </SafeAreaProvider>
  );
};

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

export default App;
