import React, { useState } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { Button } from '../../../shared/components';
import { colors, spacing, typography } from '../../../theme';
import { useAuthStore } from '../../../store';

const ConfirmationPendingScreen: React.FC = () => {
  const [loading, setLoading] = useState(false);
  const resend = useAuthStore((s) => (s as any).resendVerification);

  const onResend = async () => {
    try {
      setLoading(true);
      await resend();
      Alert.alert('Verification Sent', 'Check your inbox for the verification link.');
    } catch (err: any) {
      Alert.alert('Unable to resend', err.message || 'Try again later');
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Almost there — check your email 📧</Text>
      <Text style={styles.body}>
        We sent a verification link to your email address. Open the message and follow the
        instructions to complete registration.
      </Text>

      <Button title="Resend verification email" onPress={onResend} loading={loading} />

      <Text style={styles.tip}>
        If you didn't receive the email, check your spam folder or request a new link.
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing.lg,
    justifyContent: 'center',
    backgroundColor: colors.white,
  },
  title: {
    fontSize: typography.h3,
    fontWeight: '700',
    marginBottom: spacing.md,
    color: colors.textPrimary,
  },
  body: {
    fontSize: typography.body,
    color: colors.textSecondary,
    marginBottom: spacing.lg,
  },
  tip: {
    marginTop: spacing.lg,
    color: colors.textMuted,
    fontSize: typography.caption,
    textAlign: 'center',
  },
});

export default ConfirmationPendingScreen;
