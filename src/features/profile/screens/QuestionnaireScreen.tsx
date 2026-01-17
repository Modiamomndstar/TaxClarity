import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  Alert,
  TouchableOpacity,
} from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Button, Select, Card } from '../../../shared/components';
import { useAppStore, useAuthStore } from '../../../store';
import { colors, spacing, typography, borderRadius } from '../../../theme';
import {
  WORK_TYPE_OPTIONS,
  INCOME_RANGES,
  NIGERIAN_STATES,
  TaxProfileInput,
  WorkType,
} from '../../../types';

type QuestionnaireScreenProps = {
  navigation: NativeStackNavigationProp<any>;
};

const STEPS = [
  { id: 1, title: 'Work Type', description: 'What best describes your work?' },
  { id: 2, title: 'Income Range', description: 'What is your annual income?' },
  { id: 3, title: 'Location', description: 'Which state do you live in?' },
];

export const QuestionnaireScreen: React.FC<QuestionnaireScreenProps> = ({
  navigation,
}) => {
  const [currentStep, setCurrentStep] = useState(0);
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState<Partial<TaxProfileInput>>({});

  const { saveTaxProfile, checkTaxApplicability } = useAppStore();
  const user = useAuthStore((state) => state.user);

  const updateFormData = (key: keyof TaxProfileInput, value: any) => {
    setFormData((prev) => ({ ...prev, [key]: value }));
  };

  const canProceed = () => {
    switch (currentStep) {
      case 0:
        return !!formData.work_type;
      case 1:
        return formData.income_range_min !== undefined;
      case 2:
        return !!formData.location;
      default:
        return false;
    }
  };

  const handleNext = () => {
    if (currentStep < STEPS.length - 1) {
      setCurrentStep((prev) => prev + 1);
    } else {
      handleSubmit();
    }
  };

  const handleBack = () => {
    if (currentStep > 0) {
      setCurrentStep((prev) => prev - 1);
    }
  };

  const handleSubmit = async () => {
    if (!canProceed()) return;

    setIsLoading(true);
    try {
      const profileData: TaxProfileInput = {
        work_type: formData.work_type as WorkType,
        income_range_min: formData.income_range_min!,
        income_range_max: formData.income_range_max!,
        location: formData.location!,
      };

      // Save profile and check tax applicability
      await saveTaxProfile(profileData);
      await checkTaxApplicability(profileData);

      // Navigate to results
      navigation.replace('Results');
    } catch (error: any) {
      Alert.alert(
        'Error',
        error.message || 'Failed to process your information'
      );
    } finally {
      setIsLoading(false);
    }
  };

  const handleIncomeSelect = (index: number) => {
    const range = INCOME_RANGES[index];
    setFormData((prev) => ({
      ...prev,
      income_range_min: range.min,
      income_range_max: range.max,
    }));
  };

  const renderStepContent = () => {
    switch (currentStep) {
      case 0:
        return (
          <View style={styles.optionsContainer}>
            {WORK_TYPE_OPTIONS.map((option) => (
              <TouchableOpacity
                key={option.value}
                style={[
                  styles.optionCard,
                  formData.work_type === option.value && styles.optionCardSelected,
                ]}
                onPress={() => updateFormData('work_type', option.value)}
              >
                <View style={styles.optionIcon}>
                  <Text style={styles.optionIconText}>
                    {option.value === 'salary_earner' ? '💼' :
                     option.value === 'freelancer' ? '💻' : '🏪'}
                  </Text>
                </View>
                <Text
                  style={[
                    styles.optionLabel,
                    formData.work_type === option.value && styles.optionLabelSelected,
                  ]}
                >
                  {option.label}
                </Text>
                {formData.work_type === option.value && (
                  <View style={styles.checkmark}>
                    <Text style={styles.checkmarkText}>✓</Text>
                  </View>
                )}
              </TouchableOpacity>
            ))}
          </View>
        );

      case 1:
        return (
          <View style={styles.optionsContainer}>
            {INCOME_RANGES.map((range, index) => (
              <TouchableOpacity
                key={index}
                style={[
                  styles.incomeCard,
                  formData.income_range_min === range.min && styles.incomeCardSelected,
                ]}
                onPress={() => handleIncomeSelect(index)}
              >
                <Text
                  style={[
                    styles.incomeLabel,
                    formData.income_range_min === range.min && styles.incomeLabelSelected,
                  ]}
                >
                  {range.label}
                </Text>
                {formData.income_range_min === range.min && (
                  <View style={styles.checkmarkSmall}>
                    <Text style={styles.checkmarkTextSmall}>✓</Text>
                  </View>
                )}
              </TouchableOpacity>
            ))}
          </View>
        );

      case 2:
        return (
          <View style={styles.selectContainer}>
            <Select
              label="State of Residence"
              placeholder="Select your state"
              options={NIGERIAN_STATES.map((state) => ({
                label: state,
                value: state,
              }))}
              value={formData.location}
              onChange={(value) => updateFormData('location', value as string)}
            />
          </View>
        );

      default:
        return null;
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Progress Bar */}
      <View style={styles.progressContainer}>
        <View style={styles.progressBar}>
          <View
            style={[
              styles.progressFill,
              { width: `${((currentStep + 1) / STEPS.length) * 100}%` },
            ]}
          />
        </View>
        <Text style={styles.progressText}>
          Step {currentStep + 1} of {STEPS.length}
        </Text>
      </View>

      <ScrollView
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.stepTitle}>{STEPS[currentStep].title}</Text>
          <Text style={styles.stepDescription}>
            {STEPS[currentStep].description}
          </Text>
        </View>

        {/* Step Content */}
        {renderStepContent()}
      </ScrollView>

      {/* Navigation Buttons */}
      <View style={styles.buttonContainer}>
        {currentStep > 0 && (
          <Button
            title="Back"
            onPress={handleBack}
            variant="outline"
            style={styles.backButton}
          />
        )}
        <Button
          title={currentStep === STEPS.length - 1 ? 'Check My Tax Status' : 'Continue'}
          onPress={handleNext}
          disabled={!canProceed()}
          loading={isLoading}
          style={styles.nextButton}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  progressContainer: {
    padding: spacing.lg,
    backgroundColor: colors.white,
  },
  progressBar: {
    height: 8,
    backgroundColor: colors.border,
    borderRadius: 4,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: colors.primary,
    borderRadius: 4,
  },
  progressText: {
    fontSize: typography.caption,
    color: colors.textSecondary,
    marginTop: spacing.sm,
    textAlign: 'center',
  },
  scrollContent: {
    flexGrow: 1,
    padding: spacing.lg,
  },
  header: {
    marginBottom: spacing.xl,
  },
  stepTitle: {
    fontSize: typography.h2,
    fontWeight: typography.bold,
    color: colors.textPrimary,
    marginBottom: spacing.sm,
  },
  stepDescription: {
    fontSize: typography.body,
    color: colors.textSecondary,
  },
  optionsContainer: {
    gap: spacing.md,
  },
  optionCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderRadius: borderRadius.lg,
    padding: spacing.lg,
    borderWidth: 2,
    borderColor: colors.border,
  },
  optionCardSelected: {
    borderColor: colors.primary,
    backgroundColor: colors.primary + '08',
  },
  optionIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: colors.background,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: spacing.md,
  },
  optionIconText: {
    fontSize: 24,
  },
  optionLabel: {
    flex: 1,
    fontSize: typography.body,
    fontWeight: typography.medium,
    color: colors.textPrimary,
  },
  optionLabelSelected: {
    color: colors.primary,
  },
  checkmark: {
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkmarkText: {
    color: colors.white,
    fontWeight: typography.bold,
    fontSize: 16,
  },
  incomeCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: colors.white,
    borderRadius: borderRadius.md,
    padding: spacing.lg,
    borderWidth: 2,
    borderColor: colors.border,
  },
  incomeCardSelected: {
    borderColor: colors.primary,
    backgroundColor: colors.primary + '08',
  },
  incomeLabel: {
    fontSize: typography.body,
    color: colors.textPrimary,
  },
  incomeLabelSelected: {
    color: colors.primary,
    fontWeight: typography.semibold,
  },
  checkmarkSmall: {
    width: 24,
    height: 24,
    borderRadius: 12,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkmarkTextSmall: {
    color: colors.white,
    fontWeight: typography.bold,
    fontSize: 14,
  },
  selectContainer: {
    marginTop: spacing.md,
  },
  buttonContainer: {
    flexDirection: 'row',
    padding: spacing.lg,
    backgroundColor: colors.white,
    gap: spacing.md,
  },
  backButton: {
    flex: 1,
  },
  nextButton: {
    flex: 2,
  },
});

export default QuestionnaireScreen;
