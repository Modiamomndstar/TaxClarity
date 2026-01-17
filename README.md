# TaxClarity NG 🇳🇬

A mobile application to help Nigerians understand and comply with the 2026 tax reforms.

## Features

- 🔐 **User Authentication** - Email/Password registration and login
- 📋 **Tax Profile Questionnaire** - Simple 3-step form to capture work type, income, and location
- 🔍 **Tax Status Check** - Personalized tax applicability results based on user profile
- ✅ **Action Checklist** - Step-by-step guidance for tax compliance
- 🔔 **Smart Reminders** - Push notifications for deadlines and actions

## Tech Stack

- **Frontend:** React Native (Expo) + TypeScript
- **Backend:** Supabase (PostgreSQL, Auth, Edge Functions, Realtime)
- **State Management:** Zustand
- **Navigation:** React Navigation 6.x
- **Forms:** React Hook Form + Zod

## Project Structure

```
src/
├── config/         # App configuration (Supabase client)
├── features/       # Feature-based modules
│   ├── auth/       # Welcome, Register, Login screens
│   ├── profile/    # Questionnaire screen
│   ├── taxChecker/ # Results screen
│   └── actionGuide/# Checklist screen
├── navigation/     # React Navigation setup
├── shared/         # Shared components (Button, TextInput, etc.)
├── store/          # Zustand state management
├── theme/          # Colors and typography
└── types/          # TypeScript type definitions

supabase/
├── functions/      # Edge Functions
│   ├── check-tax-applicability/
│   └── send-reminders/
└── migrations/     # SQL migrations
    ├── 001_create_tables.sql
    └── 002_seed_tax_rules.sql
```

---

## 🚀 Step-by-Step Setup Instructions

### Prerequisites

Make sure you have the following installed:

- **Node.js** (v18 or higher) - https://nodejs.org
- **Git** - https://git-scm.com
- **Expo CLI** - Will be installed with dependencies
- **Expo Go App** - Download on your phone from App Store/Play Store

---

### Step 1: Set Up Supabase Backend

1. **Create a Supabase Account**
   - Go to https://supabase.com
   - Click "Start your project" and sign up (free tier available)

2. **Create a New Project**
   - Click "New Project"
   - Choose your organization
   - Enter project name: `taxclarity-ng`
   - Set a database password (save this!)
   - Select a region (choose one close to Nigeria, like EU West)
   - Click "Create new project" and wait 2-3 minutes

3. **Run Database Migrations**
   - Once the project is ready, click **"SQL Editor"** in the left sidebar
   - Click **"New Query"**
   - Copy the contents of `supabase/migrations/001_create_tables.sql` and paste it
   - Click **"Run"** (or press Ctrl+Enter)
   - Create another new query
   - Copy the contents of `supabase/migrations/002_seed_tax_rules.sql` and paste it
   - Click **"Run"**

4. **Get Your API Credentials**
   - Click **"Project Settings"** (gear icon at bottom of sidebar)
   - Click **"API"** in the settings menu
   - You'll need:
     - **Project URL** (looks like `https://xxxxx.supabase.co`)
     - **anon/public key** (the one labeled "anon" - this is safe for client-side)

---

### Step 2: Configure the App

1. **Create Environment File**
   - In the `TaxClarityApp` folder, copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
   - Or manually create a file named `.env`

2. **Add Your Supabase Credentials**
   - Open `.env` and add:
   ```
   EXPO_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
   EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
   ```

3. **Update Supabase Config (Alternative)**
   - If environment variables don't work, open `src/config/supabase.ts`
   - Replace the placeholder values directly:
   ```typescript
   const supabaseUrl = 'https://your-project-id.supabase.co';
   const supabaseAnonKey = 'your-anon-key-here';
   ```

---

### Step 3: Install Dependencies

Open a terminal in the `TaxClarityApp` folder and run:

```bash
npm install
```

This will install all required packages including:
- Expo SDK
- React Navigation
- Supabase client
- Zustand (state management)
- React Hook Form + Zod

---

### Step 4: Add App Assets (Required for Expo)

Before running, you need app icons. For quick testing, create placeholder images:

1. Go to the `assets` folder
2. Add the following image files (can be any image for testing):
   - `icon.png` (1024x1024 px)
   - `splash.png` (1284x2778 px)
   - `adaptive-icon.png` (1024x1024 px)
   - `favicon.png` (48x48 px)

**Quick Option:** Download free placeholder icons from https://placeholder.com or use the Expo sample assets.

---

### Step 5: Run the App

Start the Expo development server:

```bash
npx expo start
```

You'll see a QR code in the terminal. To run the app:

**On Physical Device (Recommended):**
1. Install **Expo Go** from App Store (iOS) or Play Store (Android)
2. Scan the QR code with your phone camera (iOS) or Expo Go app (Android)
3. The app will load on your device!

**On Emulator:**
- Press `a` for Android emulator (requires Android Studio)
- Press `i` for iOS simulator (requires macOS + Xcode)
- Press `w` for web browser

---

### Step 6: Push to GitHub

1. **Create a GitHub Repository**
   - Go to https://github.com/new
   - Repository name: `taxclarity-ng`
   - Set to Private (recommended) or Public
   - Click "Create repository"
   - **Don't** initialize with README (we already have one)

2. **Initialize Git and Push**
   Run these commands in the `TaxClarityApp` folder:

   ```bash
   # Initialize git repository
   git init

   # Add all files
   git add .

   # Create first commit
   git commit -m "Initial commit: TaxClarity NG app"

   # Add GitHub as remote (replace with your username)
   git remote add origin https://github.com/YOUR_USERNAME/taxclarity-ng.git

   # Push to GitHub
   git branch -M main
   git push -u origin main
   ```

3. **Verify Upload**
   - Go to your GitHub repository
   - All files should be visible
   - The `.gitignore` file ensures sensitive files (like `.env`) are not uploaded

---

## 🧪 Testing the App Flow

1. **Welcome Screen** → Tap "Get Started"
2. **Register** → Create an account with email/password
3. **Questionnaire** → Answer the 3 questions:
   - Work type (Salary earner, Business owner, or Freelancer)
   - Monthly income range
   - Location (state)
4. **Results** → See your personalized tax status
5. **Checklist** → View action items to complete

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| `expo: command not found` | Run `npm install` first, then use `npx expo start` |
| QR code not scanning | Make sure phone and computer are on same WiFi network |
| Supabase connection error | Double-check your URL and anon key in `.env` or `supabase.ts` |
| "Cannot find module" errors | Delete `node_modules` folder and run `npm install` again |
| Metro bundler errors | Press `r` in terminal to reload, or `c` to clear cache |

---

## 📱 Deploy Edge Functions (Optional)

For production, deploy the Edge Functions to Supabase:

1. Install Supabase CLI:
   ```bash
   npm install -g supabase
   ```

2. Login to Supabase:
   ```bash
   supabase login
   ```

3. Link your project:
   ```bash
   supabase link --project-ref your-project-id
   ```

4. Deploy functions:
   ```bash
   supabase functions deploy check-tax-applicability
   supabase functions deploy send-reminders
   ```

---

## 📄 License

MIT

---

## 👨‍💻 Built With

- [Expo](https://expo.dev) - React Native framework
- [Supabase](https://supabase.com) - Backend as a Service
- [React Navigation](https://reactnavigation.org) - Navigation library
- [Zustand](https://zustand-demo.pmnd.rs) - State management
