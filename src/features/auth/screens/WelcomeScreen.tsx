import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  Image,
  StatusBar,
} from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Button } from '../../../shared/components';
import { colors, spacing, typography } from '../../../theme';

type WelcomeScreenProps = {
  navigation: NativeStackNavigationProp<any>;
};

export const WelcomeScreen: React.FC<WelcomeScreenProps> = ({ navigation }) => {
  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor={colors.white} />

      <View style={styles.content}>
        {/* Logo and Branding */}
        <View style={styles.header}>
          <View style={styles.logoContainer}>
            <Text style={styles.logoText}>🇳🇬</Text>
          </View>
          <Text style={styles.appName}>TaxClarity NG</Text>
          <Text style={styles.tagline}>
            Understanding Nigeria's 2026 tax reforms in minutes
          </Text>
        </View>

        {/* Value Proposition */}
        <View style={styles.features}>
          <FeatureItem
            icon="✓"
            text="Know if the new tax laws apply to you"
          />
          <FeatureItem
            icon="✓"
            text="Get clear, jargon-free explanations"
          />
          <FeatureItem
            icon="✓"
            text="Follow simple steps to stay compliant"
          />
        </View>

        {/* CTA Buttons */}
        <View style={styles.buttons}>
          <Button
            title="Get Started"
            onPress={() => navigation.navigate('Register')}
            variant="primary"
            size="large"
            style={styles.primaryButton}
          />
          <Button
            title="I already have an account"
            onPress={() => navigation.navigate('Login')}
            variant="ghost"
            size="medium"
          />
        </View>
      </View>

      {/* Footer */}
      <View style={styles.footer}>
        <Text style={styles.footerText}>
          No tax consultant needed • Free to use
        </Text>
      </View>
    </SafeAreaView>
  );
};

const FeatureItem: React.FC<{ icon: string; text: string }> = ({ icon, text }) => (
  <View style={styles.featureItem}>
    <View style={styles.featureIcon}>
      <Text style={styles.featureIconText}>{icon}</Text>
    </View>
    <Text style={styles.featureText}>{text}</Text>
  </View>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.white,
  },
  content: {
    flex: 1,
    paddingHorizontal: spacing.lg,
    justifyContent: 'center',
  },
  header: {
    alignItems: 'center',
    marginBottom: spacing.xxl,
  },
  logoContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: colors.primary + '15',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: spacing.lg,
  },
  logoText: {
    fontSize: 50,
  },
  appName: {
    fontSize: typography.h1,
    fontWeight: typography.bold,
    color: colors.primary,
    marginBottom: spacing.sm,
  },
  tagline: {
    fontSize: typography.body,
    color: colors.textSecondary,
    textAlign: 'center',
    paddingHorizontal: spacing.lg,
  },
  features: {
    marginBottom: spacing.xxl,
  },
  featureItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  featureIcon: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: colors.success + '20',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: spacing.md,
  },
  featureIconText: {
    fontSize: 16,
    color: colors.success,
    fontWeight: typography.bold,
  },
  featureText: {
    fontSize: typography.body,
    color: colors.textPrimary,
    flex: 1,
  },
  buttons: {
    gap: spacing.sm,
  },
  primaryButton: {
    marginBottom: spacing.sm,
  },
  footer: {
    paddingVertical: spacing.lg,
    alignItems: 'center',
  },
  footerText: {
    fontSize: typography.caption,
    color: colors.textMuted,
  },
});

export default WelcomeScreen;
