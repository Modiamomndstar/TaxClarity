import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { format, differenceInDays, isPast } from 'date-fns';
import { Button, Card } from '../../../shared/components';
import { useAppStore, useAuthStore } from '../../../store';
import { colors, spacing, typography, borderRadius, shadows } from '../../../theme';
import { UserActionItem, Priority } from '../../../types';

type ChecklistScreenProps = {
  navigation: NativeStackNavigationProp<any>;
};

export const ChecklistScreen: React.FC<ChecklistScreenProps> = ({ navigation }) => {
  const { actionItems, fetchActionItems, toggleActionItemComplete, subscribeToActionItems } = useAppStore();
  const signOut = useAuthStore((state) => state.signOut);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    fetchActionItems();
    const unsubscribe = subscribeToActionItems();
    return () => unsubscribe();
  }, []);

  const completedCount = actionItems.filter((item) => item.completed).length;
  const progressPercentage = actionItems.length > 0
    ? Math.round((completedCount / actionItems.length) * 100)
    : 0;

  const handleToggleComplete = async (item: UserActionItem) => {
    try {
      await toggleActionItemComplete(item.id, !item.completed);
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to update item');
    }
  };

  const handleSignOut = async () => {
    Alert.alert(
      'Sign Out',
      'Are you sure you want to sign out?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Sign Out',
          style: 'destructive',
          onPress: async () => {
            try {
              await signOut();
            } catch (error: any) {
              Alert.alert('Error', error.message);
            }
          },
        },
      ]
    );
  };

  const getPriorityColor = (priority: Priority) => {
    switch (priority) {
      case 'high':
        return colors.priorityHigh;
      case 'medium':
        return colors.priorityMedium;
      case 'low':
        return colors.priorityLow;
      default:
        return colors.textSecondary;
    }
  };

  const getDueDateInfo = (dueDate: string) => {
    const date = new Date(dueDate);
    const daysUntil = differenceInDays(date, new Date());
    const isOverdue = isPast(date) && daysUntil < 0;

    let label = '';
    let color = colors.textSecondary;

    if (isOverdue) {
      label = 'Overdue';
      color = colors.error;
    } else if (daysUntil === 0) {
      label = 'Due today';
      color = colors.warning;
    } else if (daysUntil <= 7) {
      label = `${daysUntil} days left`;
      color = colors.warning;
    } else if (daysUntil <= 30) {
      label = `${daysUntil} days left`;
      color = colors.info;
    } else {
      label = format(date, 'MMM d, yyyy');
      color = colors.textSecondary;
    }

    return { label, color };
  };

  const groupedItems = {
    high: actionItems.filter((item) => item.priority === 'high'),
    medium: actionItems.filter((item) => item.priority === 'medium'),
    low: actionItems.filter((item) => item.priority === 'low'),
  };

  const renderActionItem = (item: UserActionItem) => {
    const dueDateInfo = getDueDateInfo(item.due_date);

    return (
      <TouchableOpacity
        key={item.id}
        style={[styles.actionItem, item.completed && styles.actionItemCompleted]}
        onPress={() => handleToggleComplete(item)}
        activeOpacity={0.7}
      >
        <View style={styles.checkboxContainer}>
          <View style={[styles.checkbox, item.completed && styles.checkboxChecked]}>
            {item.completed && <Text style={styles.checkboxIcon}>✓</Text>}
          </View>
        </View>

        <View style={styles.actionContent}>
          <Text style={[styles.actionTitle, item.completed && styles.actionTitleCompleted]}>
            {item.title}
          </Text>
          <Text style={styles.actionDescription} numberOfLines={2}>
            {item.description}
          </Text>
          <View style={styles.actionMeta}>
            <View style={[styles.priorityBadge, { backgroundColor: getPriorityColor(item.priority) + '20' }]}>
              <Text style={[styles.priorityText, { color: getPriorityColor(item.priority) }]}>
                {item.priority.toUpperCase()}
              </Text>
            </View>
            <Text style={[styles.dueDate, { color: dueDateInfo.color }]}>
              {dueDateInfo.label}
            </Text>
          </View>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.headerTitle}>Your Action Checklist</Text>
          <Text style={styles.headerSubtitle}>
            {completedCount} of {actionItems.length} completed
          </Text>
        </View>
        <TouchableOpacity onPress={handleSignOut} style={styles.signOutButton}>
          <Text style={styles.signOutText}>Sign Out</Text>
        </TouchableOpacity>
      </View>

      {/* Progress Card */}
      <View style={styles.progressCard}>
        <View style={styles.progressHeader}>
          <Text style={styles.progressTitle}>Progress</Text>
          <Text style={styles.progressPercent}>{progressPercentage}%</Text>
        </View>
        <View style={styles.progressBar}>
          <View
            style={[
              styles.progressFill,
              { width: `${progressPercentage}%` },
              progressPercentage === 100 && styles.progressComplete,
            ]}
          />
        </View>
        {progressPercentage === 100 && (
          <View style={styles.completeBanner}>
            <Text style={styles.completeBannerText}>
              🎉 Congratulations! You're on track to stay compliant!
            </Text>
          </View>
        )}
      </View>

      <ScrollView
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* High Priority */}
        {groupedItems.high.length > 0 && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <View style={[styles.sectionDot, { backgroundColor: colors.priorityHigh }]} />
              <Text style={styles.sectionTitle}>High Priority</Text>
              <Text style={styles.sectionCount}>{groupedItems.high.length}</Text>
            </View>
            {groupedItems.high.map(renderActionItem)}
          </View>
        )}

        {/* Medium Priority */}
        {groupedItems.medium.length > 0 && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <View style={[styles.sectionDot, { backgroundColor: colors.priorityMedium }]} />
              <Text style={styles.sectionTitle}>Medium Priority</Text>
              <Text style={styles.sectionCount}>{groupedItems.medium.length}</Text>
            </View>
            {groupedItems.medium.map(renderActionItem)}
          </View>
        )}

        {/* Low Priority */}
        {groupedItems.low.length > 0 && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <View style={[styles.sectionDot, { backgroundColor: colors.priorityLow }]} />
              <Text style={styles.sectionTitle}>Low Priority</Text>
              <Text style={styles.sectionCount}>{groupedItems.low.length}</Text>
            </View>
            {groupedItems.low.map(renderActionItem)}
          </View>
        )}

        {/* Empty State */}
        {actionItems.length === 0 && (
          <View style={styles.emptyState}>
            <Text style={styles.emptyIcon}>📋</Text>
            <Text style={styles.emptyTitle}>No action items yet</Text>
            <Text style={styles.emptyDescription}>
              Complete the questionnaire to get your personalized action checklist
            </Text>
            <Button
              title="Start Questionnaire"
              onPress={() => navigation.navigate('Questionnaire')}
              variant="primary"
              style={styles.emptyButton}
            />
          </View>
        )}
      </ScrollView>

      {/* Bottom Button */}
      {actionItems.length > 0 && (
        <View style={styles.buttonContainer}>
          <Button
            title="View Tax Summary"
            onPress={() => navigation.navigate('Results')}
            variant="outline"
          />
        </View>
      )}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: spacing.lg,
    backgroundColor: colors.white,
    ...shadows.small,
  },
  headerTitle: {
    fontSize: typography.h4,
    fontWeight: typography.bold,
    color: colors.textPrimary,
  },
  headerSubtitle: {
    fontSize: typography.bodySmall,
    color: colors.textSecondary,
    marginTop: spacing.xs,
  },
  signOutButton: {
    padding: spacing.sm,
  },
  signOutText: {
    fontSize: typography.bodySmall,
    color: colors.error,
    fontWeight: typography.medium,
  },
  progressCard: {
    backgroundColor: colors.white,
    margin: spacing.lg,
    borderRadius: borderRadius.lg,
    padding: spacing.lg,
    ...shadows.small,
  },
  progressHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  progressTitle: {
    fontSize: typography.body,
    fontWeight: typography.medium,
    color: colors.textPrimary,
  },
  progressPercent: {
    fontSize: typography.h4,
    fontWeight: typography.bold,
    color: colors.primary,
  },
  progressBar: {
    height: 12,
    backgroundColor: colors.border,
    borderRadius: 6,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: colors.primary,
    borderRadius: 6,
  },
  progressComplete: {
    backgroundColor: colors.success,
  },
  completeBanner: {
    backgroundColor: colors.success + '15',
    borderRadius: borderRadius.md,
    padding: spacing.md,
    marginTop: spacing.md,
  },
  completeBannerText: {
    fontSize: typography.bodySmall,
    color: colors.success,
    textAlign: 'center',
    fontWeight: typography.medium,
  },
  scrollContent: {
    padding: spacing.lg,
    paddingTop: 0,
  },
  section: {
    marginBottom: spacing.lg,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  sectionDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
    marginRight: spacing.sm,
  },
  sectionTitle: {
    fontSize: typography.body,
    fontWeight: typography.semibold,
    color: colors.textPrimary,
    flex: 1,
  },
  sectionCount: {
    fontSize: typography.bodySmall,
    color: colors.textSecondary,
    backgroundColor: colors.border,
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
    borderRadius: borderRadius.full,
  },
  actionItem: {
    flexDirection: 'row',
    backgroundColor: colors.white,
    borderRadius: borderRadius.lg,
    padding: spacing.md,
    marginBottom: spacing.sm,
    ...shadows.small,
  },
  actionItemCompleted: {
    backgroundColor: colors.success + '10',
  },
  checkboxContainer: {
    marginRight: spacing.md,
    paddingTop: 2,
  },
  checkbox: {
    width: 24,
    height: 24,
    borderRadius: borderRadius.sm,
    borderWidth: 2,
    borderColor: colors.border,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkboxChecked: {
    backgroundColor: colors.success,
    borderColor: colors.success,
  },
  checkboxIcon: {
    color: colors.white,
    fontSize: 14,
    fontWeight: typography.bold,
  },
  actionContent: {
    flex: 1,
  },
  actionTitle: {
    fontSize: typography.body,
    fontWeight: typography.medium,
    color: colors.textPrimary,
    marginBottom: spacing.xs,
  },
  actionTitleCompleted: {
    textDecorationLine: 'line-through',
    color: colors.textSecondary,
  },
  actionDescription: {
    fontSize: typography.bodySmall,
    color: colors.textSecondary,
    marginBottom: spacing.sm,
  },
  actionMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  priorityBadge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
    borderRadius: borderRadius.sm,
  },
  priorityText: {
    fontSize: typography.caption,
    fontWeight: typography.semibold,
  },
  dueDate: {
    fontSize: typography.caption,
  },
  emptyState: {
    alignItems: 'center',
    paddingVertical: spacing.xxl,
  },
  emptyIcon: {
    fontSize: 64,
    marginBottom: spacing.lg,
  },
  emptyTitle: {
    fontSize: typography.h4,
    fontWeight: typography.semibold,
    color: colors.textPrimary,
    marginBottom: spacing.sm,
  },
  emptyDescription: {
    fontSize: typography.body,
    color: colors.textSecondary,
    textAlign: 'center',
    paddingHorizontal: spacing.xl,
    marginBottom: spacing.lg,
  },
  emptyButton: {
    minWidth: 200,
  },
  buttonContainer: {
    padding: spacing.lg,
    backgroundColor: colors.white,
    ...shadows.small,
  },
});

export default ChecklistScreen;
