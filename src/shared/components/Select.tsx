import React, { useState } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  Modal,
  FlatList,
  StyleSheet,
} from 'react-native';
import { colors, spacing, borderRadius, typography, shadows } from '../../theme';

interface Option {
  label: string;
  value: string | number;
}

interface SelectProps {
  label?: string;
  placeholder?: string;
  options: Option[];
  value?: string | number;
  onChange: (value: string | number) => void;
  error?: string;
}

export const Select: React.FC<SelectProps> = ({
  label,
  placeholder = 'Select an option',
  options,
  value,
  onChange,
  error,
}) => {
  const [isOpen, setIsOpen] = useState(false);

  const selectedOption = options.find((opt) => opt.value === value);

  const handleSelect = (option: Option) => {
    onChange(option.value);
    setIsOpen(false);
  };

  return (
    <View style={styles.container}>
      {label && <Text style={styles.label}>{label}</Text>}

      <TouchableOpacity
        style={[styles.selectButton, error && styles.selectButtonError]}
        onPress={() => setIsOpen(true)}
      >
        <Text style={[styles.selectText, !selectedOption && styles.placeholder]}>
          {selectedOption ? selectedOption.label : placeholder}
        </Text>
        <Text style={styles.chevron}>▼</Text>
      </TouchableOpacity>

      {error && <Text style={styles.errorText}>{error}</Text>}

      <Modal
        visible={isOpen}
        transparent
        animationType="fade"
        onRequestClose={() => setIsOpen(false)}
      >
        <TouchableOpacity
          style={styles.overlay}
          activeOpacity={1}
          onPress={() => setIsOpen(false)}
        >
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={styles.modalTitle}>{label || 'Select an option'}</Text>
              <TouchableOpacity onPress={() => setIsOpen(false)}>
                <Text style={styles.closeButton}>✕</Text>
              </TouchableOpacity>
            </View>

            <FlatList
              data={options}
              keyExtractor={(item) => String(item.value)}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={[
                    styles.optionItem,
                    item.value === value && styles.optionItemSelected,
                  ]}
                  onPress={() => handleSelect(item)}
                >
                  <Text
                    style={[
                      styles.optionText,
                      item.value === value && styles.optionTextSelected,
                    ]}
                  >
                    {item.label}
                  </Text>
                  {item.value === value && (
                    <Text style={styles.checkmark}>✓</Text>
                  )}
                </TouchableOpacity>
              )}
              style={styles.optionsList}
            />
          </View>
        </TouchableOpacity>
      </Modal>
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
  selectButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: borderRadius.md,
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.md,
  },
  selectButtonError: {
    borderColor: colors.error,
  },
  selectText: {
    fontSize: typography.body,
    color: colors.textPrimary,
    flex: 1,
  },
  placeholder: {
    color: colors.textMuted,
  },
  chevron: {
    fontSize: 12,
    color: colors.textSecondary,
    marginLeft: spacing.sm,
  },
  errorText: {
    fontSize: typography.caption,
    color: colors.error,
    marginTop: spacing.xs,
  },
  overlay: {
    flex: 1,
    backgroundColor: colors.overlay,
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: colors.white,
    borderTopLeftRadius: borderRadius.xl,
    borderTopRightRadius: borderRadius.xl,
    maxHeight: '70%',
    ...shadows.large,
  },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: spacing.lg,
    borderBottomWidth: 1,
    borderBottomColor: colors.divider,
  },
  modalTitle: {
    fontSize: typography.h5,
    fontWeight: typography.semibold,
    color: colors.textPrimary,
  },
  closeButton: {
    fontSize: 20,
    color: colors.textSecondary,
    padding: spacing.xs,
  },
  optionsList: {
    paddingBottom: spacing.xl,
  },
  optionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.lg,
    borderBottomWidth: 1,
    borderBottomColor: colors.divider,
  },
  optionItemSelected: {
    backgroundColor: colors.primaryLight + '20',
  },
  optionText: {
    fontSize: typography.body,
    color: colors.textPrimary,
  },
  optionTextSelected: {
    color: colors.primary,
    fontWeight: typography.semibold,
  },
  checkmark: {
    fontSize: 18,
    color: colors.primary,
    fontWeight: typography.bold,
  },
});

export default Select;
