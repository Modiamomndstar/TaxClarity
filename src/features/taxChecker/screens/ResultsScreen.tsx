import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
} from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Button, Card } from '../../../shared/components';
import { useAppStore } from '../../../store';
import { colors, spacing, typography, borderRadius, shadows } from '../../../theme';

type ResultsScreenProps = {
  navigation: NativeStackNavigationProp<any>;
};

export const ResultsScreen: React.FC<ResultsScreenProps> = ({ navigation }) => {
  const { currentTaxRule, taxProfile, actionItems } = useAppStore();

  if (!currentTaxRule) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>No tax information available</Text>
          <Button
            title="Go Back"
            onPress={() => navigation.goBack()}
            variant="primary"
          />
        </View>
      </SafeAreaView>
    );
  }

  const isExempt = currentTaxRule.exemption_status === 'exempt';

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Status Card */}
        <View style={[styles.statusCard, isExempt ? styles.exemptCard : styles.taxableCard]}>
          <View style={styles.statusIcon}>
            <Text style={styles.statusIconText}>
              {isExempt ? '✓' : '📋'}
            </Text>
          </View>
          <Text style={styles.statusTitle}>Your Tax Status</Text>
          <View style={[styles.statusBadge, isExempt ? styles.exemptBadge : styles.taxableBadge]}>
            <Text style={styles.statusBadgeText}>
              {isExempt ? 'TAX EXEMPT' : 'TAXABLE'}
            </Text>
          </View>
          {!isExempt && (
            <Text style={styles.taxRateText}>
              Tax Rate: {currentTaxRule.tax_rate}%
            </Text>
          )}
        </View>

        {/* Explanation Card */}
        <Card title="What This Means" variant="elevated" style={styles.card}>
          <Text style={styles.explanationText}>
            {currentTaxRule.explanation}
          </Text>
        </Card>

        {/* Obligations Card (if taxable) */}
        {currentTaxRule.obligations && currentTaxRule.obligations.length > 0 && (
          <Card title="Your Obligations" variant="elevated" style={styles.card}>
            {currentTaxRule.obligations.map((obligation, index) => (
              <View key={index} style={styles.obligationItem}>
                <View style={styles.bulletPoint} />
                <Text style={styles.obligationText}>{obligation}</Text>
              </View>
            ))}
          </Card>
        )}

        {/* Summary Card */}
        <Card title="Your Profile Summary" variant="outlined" style={styles.card}>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Work Type</Text>
            <Text style={styles.summaryValue}>
              {taxProfile?.work_type.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}
            </Text>
          </View>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Income Range</Text>
            <Text style={styles.summaryValue}>
              ₦{(taxProfile?.income_range_min || 0).toLocaleString()} - ₦{(taxProfile?.income_range_max || 0).toLocaleString()}
            </Text>
          </View>
          <View style={styles.summaryRow}>
            <Text style={styles.summaryLabel}>Location</Text>
            <Text style={styles.summaryValue}>{taxProfile?.location}</Text>
          </View>
        </Card>

        {/* Action Items Preview */}
        {actionItems.length > 0 && (
          <Card title="Your Next Steps" subtitle={`${actionItems.length} action items`} variant="elevated" style={styles.card}>
            {actionItems.slice(0, 3).map((item, index) => (
              <View key={item.id} style={styles.actionPreview}>
                <View style={[styles.priorityDot, styles[`priority${item.priority}`]]} />
                <Text style={styles.actionPreviewText} numberOfLines={1}>
                  {item.title}
                </Text>
              </View>
            ))}
            {actionItems.length > 3 && (
              <Text style={styles.moreActions}>
                +{actionItems.length - 3} more actions
              </Text>
            )}
          </Card>
        )}
      </ScrollView>

      {/* Bottom Button */}
      <View style={styles.buttonContainer}>
        <Button
          title="View Action Checklist"
          onPress={() => navigation.navigate('Checklist')}
          variant="primary"
          size="large"
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
  scrollContent: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
  },
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: spacing.lg,
  },
  errorText: {
    fontSize: typography.body,
    color: colors.textSecondary,
    marginBottom: spacing.lg,
  },
  statusCard: {
    borderRadius: borderRadius.xl,
    padding: spacing.xl,
    alignItems: 'center',
    marginBottom: spacing.lg,
    ...shadows.medium,
  },
  exemptCard: {
    backgroundColor: colors.exempt,
  },
  taxableCard: {
    backgroundColor: colors.taxable,
  },
  statusIcon: {
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: spacing.md,
  },
  statusIconText: {
    fontSize: 32,
  },
  statusTitle: {
    fontSize: typography.h4,
    fontWeight: typography.medium,
    color: colors.white,
    marginBottom: spacing.sm,
  },
  statusBadge: {
    paddingVertical: spacing.xs,
    paddingHorizontal: spacing.lg,
    borderRadius: borderRadius.full,
    marginBottom: spacing.sm,
  },
  exemptBadge: {
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
  },
  taxableBadge: {
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
  },
  statusBadgeText: {
    fontSize: typography.h4,
    fontWeight: typography.bold,
    color: colors.white,
  },
  taxRateText: {
    fontSize: typography.body,
    color: colors.white,
    opacity: 0.9,
  },
  card: {
    marginBottom: spacing.md,
  },
  explanationText: {
    fontSize: typography.body,
    color: colors.textPrimary,
    lineHeight: 24,
  },
  obligationItem: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: spacing.sm,
  },
  bulletPoint: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: colors.primary,
    marginTop: 8,
    marginRight: spacing.sm,
  },
  obligationText: {
    flex: 1,
    fontSize: typography.body,
    color: colors.textPrimary,
  },
  summaryRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: spacing.sm,
    borderBottomWidth: 1,
    borderBottomColor: colors.divider,
  },
  summaryLabel: {
    fontSize: typography.bodySmall,
    color: colors.textSecondary,
  },
  summaryValue: {
    fontSize: typography.bodySmall,
    fontWeight: typography.medium,
    color: colors.textPrimary,
  },
  actionPreview: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: spacing.sm,
  },
  priorityDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    marginRight: spacing.sm,
  },
  priorityhigh: {
    backgroundColor: colors.priorityHigh,
  },
  prioritymedium: {
    backgroundColor: colors.priorityMedium,
  },
  prioritylow: {
    backgroundColor: colors.priorityLow,
  },
  actionPreviewText: {
    flex: 1,
    fontSize: typography.bodySmall,
    color: colors.textPrimary,
  },
  moreActions: {
    fontSize: typography.caption,
    color: colors.primary,
    marginTop: spacing.sm,
  },
  buttonContainer: {
    padding: spacing.lg,
    backgroundColor: colors.white,
    ...shadows.small,
  },
});

export default ResultsScreen;
