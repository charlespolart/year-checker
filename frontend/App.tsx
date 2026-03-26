import React, { useState, useEffect } from 'react';
import { StatusBar } from 'expo-status-bar';
import { ActivityIndicator, View, StyleSheet, Platform } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useFonts, Silkscreen_400Regular, Silkscreen_700Bold } from '@expo-google-fonts/silkscreen';
import { DotGothic16_400Regular } from '@expo-google-fonts/dotgothic16';
import { AuthProvider, useAuth } from './src/contexts/AuthContext';
import { LanguageProvider } from './src/contexts/LanguageContext';
import LoginScreen from './src/screens/LoginScreen';
import RegisterScreen from './src/screens/RegisterScreen';
import TrackerScreen from './src/screens/TrackerScreen';
import SettingsScreen from './src/screens/SettingsScreen';
import ForgotPasswordScreen from './src/screens/ForgotPasswordScreen';
import ResetPasswordScreen from './src/screens/ResetPasswordScreen';
import VerifyEmailScreen from './src/screens/VerifyEmailScreen';
import { COLORS } from './src/lib/theme';
import DottedBackground from './src/components/DottedBackground';
import CustomCursor from './src/components/CustomCursor';

// Detect deep link params from URL (web only)
function getUrlParams(): { resetToken?: string; verifyToken?: string } {
  if (Platform.OS !== 'web') return {};
  const url = new URL(window.location.href);
  const path = url.pathname;
  if (path === '/reset-password') {
    return { resetToken: url.searchParams.get('token') || undefined };
  }
  if (path === '/verify-email') {
    return { verifyToken: url.searchParams.get('token') || undefined };
  }
  return {};
}

function clearUrlParams() {
  if (Platform.OS === 'web') {
    window.history.replaceState({}, '', '/');
  }
}

function AppContent() {
  const { isLoading, isAuthenticated, setEmailVerified } = useAuth();
  const [authScreen, setAuthScreen] = useState<'login' | 'register' | 'forgot'>('login');
  const [showSettings, setShowSettings] = useState(false);
  const [resetToken, setResetToken] = useState<string | undefined>();
  const [verifyToken, setVerifyToken] = useState<string | undefined>();

  useEffect(() => {
    const params = getUrlParams();
    if (params.resetToken) setResetToken(params.resetToken);
    if (params.verifyToken) setVerifyToken(params.verifyToken);
  }, []);

  if (isLoading) {
    return (
      <View style={styles.loading}>
        <ActivityIndicator size="large" color={COLORS.accent} />
      </View>
    );
  }

  // Reset password screen (shown regardless of auth state)
  if (resetToken) {
    return <ResetPasswordScreen token={resetToken} onDone={() => { setResetToken(undefined); clearUrlParams(); }} />;
  }

  // Verify email screen (shown regardless of auth state)
  if (verifyToken) {
    return <VerifyEmailScreen token={verifyToken} onDone={() => { setVerifyToken(undefined); setEmailVerified(true); clearUrlParams(); }} />;
  }

  if (!isAuthenticated) {
    if (authScreen === 'register') return <RegisterScreen onSwitchToLogin={() => setAuthScreen('login')} />;
    if (authScreen === 'forgot') return <ForgotPasswordScreen onBack={() => setAuthScreen('login')} />;
    return <LoginScreen onSwitchToRegister={() => setAuthScreen('register')} onForgotPassword={() => setAuthScreen('forgot')} />;
  }

  if (showSettings) {
    return <SettingsScreen onBack={() => setShowSettings(false)} />;
  }

  return <TrackerScreen onOpenSettings={() => setShowSettings(true)} />;
}

export default function App() {
  const [fontsLoaded] = useFonts({
    Silkscreen_400Regular,
    Silkscreen_700Bold,
    DotGothic16_400Regular,
  });

  if (!fontsLoaded) {
    return (
      <View style={styles.loading}>
        <ActivityIndicator size="large" color={COLORS.accent} />
      </View>
    );
  }

  return (
    <SafeAreaProvider>
      <DottedBackground>
        <LanguageProvider>
          <AuthProvider>
            <StatusBar style="dark" />
            <CustomCursor />
            <AppContent />
          </AuthProvider>
        </LanguageProvider>
      </DottedBackground>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  loading: {
    flex: 1,
    backgroundColor: COLORS.bg,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
