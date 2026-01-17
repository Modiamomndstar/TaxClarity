// TaxClarity NG Theme - Nigerian-inspired colors

export const colors = {
  // Primary Colors (Nigerian Green)
  primary: "#008751",
  primaryDark: "#006B40",
  primaryLight: "#4CAF50",

  // Secondary Colors
  secondary: "#1E3A5F",
  secondaryLight: "#2E5077",

  // Status Colors
  success: "#28A745",
  warning: "#FFC107",
  error: "#DC3545",
  info: "#17A2B8",

  // Exemption Status Colors
  exempt: "#28A745",
  taxable: "#FF9800",

  // Priority Colors
  priorityHigh: "#DC3545",
  priorityMedium: "#FFC107",
  priorityLow: "#6C757D",

  // Neutral Colors
  white: "#FFFFFF",
  black: "#000000",
  background: "#F8F9FA",
  surface: "#FFFFFF",
  border: "#E0E0E0",
  divider: "#EEEEEE",

  // Text Colors
  textPrimary: "#212529",
  textSecondary: "#6C757D",
  textLight: "#FFFFFF",
  textMuted: "#ADB5BD",

  // Overlay
  overlay: "rgba(0, 0, 0, 0.5)",
};

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};

export const borderRadius = {
  sm: 4,
  md: 8,
  lg: 12,
  xl: 16,
  full: 9999,
};

export const typography = {
  // Font Sizes
  h1: 32,
  h2: 28,
  h3: 24,
  h4: 20,
  h5: 18,
  body: 16,
  bodySmall: 14,
  caption: 12,

  // Font Weights
  regular: "400" as const,
  medium: "500" as const,
  semibold: "600" as const,
  bold: "700" as const,
};

export const shadows = {
  small: {
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  medium: {
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 4,
  },
  large: {
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 8,
  },
};

export default {
  colors,
  spacing,
  borderRadius,
  typography,
  shadows,
};
