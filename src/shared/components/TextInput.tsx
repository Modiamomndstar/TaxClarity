import React, { useState } from 'react';
import {
  View,
  TextInput as RNTextInput,
  Text,
  StyleSheet,
  TextInputProps as RNTextInputProps,
  TouchableOpacity,
} from 'react-native';
import { colors, spacing, borderRadius, typography } from '../../theme';

interface TextInputProps extends RNTextInputProps {
  label?: string;
  error?: string;
  helperText?: string;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
  isPassword?: boolean;
}

export const TextInput: React.FC<TextInputProps> = ({
  label,
  error,
  helperText,
  leftIcon,
  rightIcon,
  isPassword = false,
  style,
  ...props
}) => {
  const [isFocused, setIsFocused] = useState(false);
  const [isPasswordVisible, setIsPasswordVisible] = useState(false);

  const containerStyles = [
    styles.inputContainer,
    isFocused && styles.inputContainerFocused,
    error && styles.inputContainerError,
  ];

  return (
    <View style={styles.container}>
      {label && <Text style={styles.label}>{label}</Text>}

      <View style={containerStyles}>
        {leftIcon && <View style={styles.leftIcon}>{leftIcon}</View>}

        <RNTextInput
          style={[styles.input, style]}
          placeholderTextColor={colors.textMuted}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          secureTextEntry={isPassword && !isPasswordVisible}
          {...props}
        />

        {isPassword ? (
          <TouchableOpacity
            style={styles.rightIcon}
            onPress={() => setIsPasswordVisible(!isPasswordVisible)}
          >
            <Text style={styles.passwordToggle}>
              {isPasswordVisible ? 'Hide' : 'Show'}
            </Text>
          </TouchableOpacity>
        ) : (
          rightIcon && <View style={styles.rightIcon}>{rightIcon}</View>
        )}
      </View>

      {error && <Text style={styles.errorText}>{error}</Text>}
      {helperText && !error && <Text style={styles.helperText}>{helperText}</Text>}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: spacing.md,
  },
  label: {
    fontSize: typography.bodySmall,
    fontWeight: typography.medium,
    color: colors.textPrimary,
    marginBottom: spacing.xs,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: borderRadius.md,
    paddingHorizontal: spacing.md,
  },
  inputContainerFocused: {
    borderColor: colors.primary,
    borderWidth: 2,
  },
  inputContainerError: {
    borderColor: colors.error,
  },
  input: {
    flex: 1,
    paddingVertical: spacing.md,
    fontSize: typography.body,
    color: colors.textPrimary,
  },
  leftIcon: {
    marginRight: spacing.sm,
  },
  rightIcon: {
    marginLeft: spacing.sm,
  },
  passwordToggle: {
    color: colors.primary,
    fontSize: typography.bodySmall,
    fontWeight: typography.medium,
  },
  errorText: {
    fontSize: typography.caption,
    color: colors.error,
    marginTop: spacing.xs,
  },
  helperText: {
    fontSize: typography.caption,
    color: colors.textSecondary,
    marginTop: spacing.xs,
  },
});

export default TextInput;
