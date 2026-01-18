import React from 'react';
import { Platform } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { useAuthStore } from '../store';
import { colors } from '../theme';

// Auth Screens
import { WelcomeScreen, RegisterScreen, LoginScreen, ConfirmationPendingScreen } from '../features/auth/screens';

// Profile Screens
import { QuestionnaireScreen } from '../features/profile/screens';

// Tax Checker Screens
import { ResultsScreen } from '../features/taxChecker/screens';

// Action Guide Screens
import { ChecklistScreen } from '../features/actionGuide/screens';

// Navigation Types
export type AuthStackParamList = {
  Welcome: undefined;
  Register: undefined;
  Login: undefined;
};

export type MainStackParamList = {
  Questionnaire: undefined;
  Results: undefined;
  Checklist: undefined;
};

const AuthStack = createStackNavigator<AuthStackParamList>();
const MainStack = createStackNavigator<MainStackParamList>();

// Auth Navigator - For unauthenticated users
const AuthNavigator: React.FC = () => {
  return (
    <AuthStack.Navigator
      screenOptions={{
        headerShown: false,
        cardStyle: { backgroundColor: colors.white },
      }}
    >
      <AuthStack.Screen name="Welcome" component={WelcomeScreen} />
      <AuthStack.Screen
        name="Register"
        component={RegisterScreen}
        options={{
          headerShown: true,
          title: 'Create Account',
          headerBackTitle: 'Back',
          headerTintColor: colors.primary,
          headerStyle: { backgroundColor: colors.white },
          headerShadowVisible: false,
        }}
      />
      <AuthStack.Screen
        name="ConfirmationPending"
        component={ConfirmationPendingScreen}
        options={{
          headerShown: true,
          title: 'Verify Email',
          headerBackTitle: 'Back',
          headerTintColor: colors.primary,
          headerStyle: { backgroundColor: colors.white },
          headerShadowVisible: false,
        }}
      />
      <AuthStack.Screen
        name="Login"
        component={LoginScreen}
        options={{
          headerShown: true,
          title: 'Sign In',
          headerBackTitle: 'Back',
          headerTintColor: colors.primary,
          headerStyle: { backgroundColor: colors.white },
          headerShadowVisible: false,
        }}
      />
    </AuthStack.Navigator>
  );
};

// Main Navigator - For authenticated users
const MainNavigator: React.FC = () => {
  return (
    <MainStack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.white },
        headerTintColor: colors.primary,
        headerLeftContainerStyle: { paddingLeft: 8 },
        cardStyle: { backgroundColor: colors.background },
      }}
    >
      <MainStack.Screen
        name="Questionnaire"
        component={QuestionnaireScreen}
        options={{
          title: 'Tax Profile Setup',
          headerBackVisible: false,
        }}
      />
      <MainStack.Screen
        name="Results"
        component={ResultsScreen}
        options={{
          title: 'Your Tax Status',
          headerBackVisible: false,
        }}
      />
      <MainStack.Screen
        name="Checklist"
        component={ChecklistScreen}
        options={{
          headerShown: false,
        }}
      />
    </MainStack.Navigator>
  );
};

// Linking configuration for web
const linking = {
  prefixes: ['http://localhost:8081', 'taxclarity://'],
  config: {
    screens: {
      Welcome: '',
      Register: 'register',
      Login: 'login',
      Questionnaire: 'questionnaire',
      Results: 'results',
      Checklist: 'checklist',
    },
  },
};

// Root Navigator - Switches between Auth and Main based on auth state
export const AppNavigator: React.FC = () => {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  return (
    <NavigationContainer
      linking={linking}
      documentTitle={{
        formatter: (options, route) =>
          `${options?.title ?? route?.name} - TaxClarity NG`,
      }}
    >
      {isAuthenticated ? <MainNavigator /> : <AuthNavigator />}
    </NavigationContainer>
  );
};

export default AppNavigator;
