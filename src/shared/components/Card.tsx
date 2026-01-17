import React from 'react';
import { View, Text, StyleSheet, ViewStyle } from 'react-native';
import { colors, spacing, borderRadius, typography, shadows } from '../../theme';

interface CardProps {
  children: React.ReactNode;
  title?: string;
  subtitle?: string;
  variant?: 'default' | 'elevated' | 'outlined';
  style?: ViewStyle;
}

export const Card: React.FC<CardProps> = ({
  children,
  title,
  subtitle,
  variant = 'default',
  style,
}) => {
  const cardStyles = [
    styles.card,
    variant === 'elevated' && styles.elevated,
    variant === 'outlined' && styles.outlined,
    style,
  ];

  return (
    <View style={cardStyles}>
      {(title || subtitle) && (
        <View style={styles.header}>
          {title && <Text style={styles.title}>{title}</Text>}
          {subtitle && <Text style={styles.subtitle}>{subtitle}</Text>}
        </View>
      )}
      {children}
    </View>
  );
};

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.white,
    borderRadius: borderRadius.lg,
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  elevated: {
    ...shadows.medium,
  },
  outlined: {
    borderWidth: 1,
    borderColor: colors.border,
  },
  header: {
    marginBottom: spacing.md,
  },
  title: {
    fontSize: typography.h5,
    fontWeight: typography.semibold,
    color: colors.textPrimary,
  },
  subtitle: {
    fontSize: typography.bodySmall,
    color: colors.textSecondary,
    marginTop: spacing.xs,
  },
});

export default Card;
