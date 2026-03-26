import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, ActivityIndicator, KeyboardAvoidingView, Platform } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';
import { useLanguage } from '../contexts/LanguageContext';
import { API_URL } from '../lib/api';

interface Props {
  token: string;
  onDone: () => void;
}

export default function ResetPasswordScreen({ token, onDone }: Props) {
  const { t } = useLanguage();
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);

  const handleSubmit = async () => {
    if (!password || !confirm) return;
    if (password !== confirm) { setError(t('auth.passwordMismatch')); return; }
    if (password.length < 8) { setError(t('auth.passwordMin')); return; }
    setError('');
    setLoading(true);
    try {
      const res = await fetch(`${API_URL}/auth/reset-password`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ token, password }),
      });
      if (res.ok) {
        setSuccess(true);
      } else {
        const data = await res.json();
        setError(data.error || 'Error');
      }
    } catch {
      setError('Network error');
    }
    setLoading(false);
  };

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <View style={styles.card}>
        <Text style={styles.titleChinese}>点点</Text>
        <Text style={styles.titleEnglish}>Dian Dian</Text>
        <Text style={styles.subtitle}>~ {t('auth.resetPassword').toLowerCase()} ~</Text>
        <Text style={styles.stars}>☆ ☆ ☆</Text>

        {success ? (
          <>
            <Text style={styles.success}>{t('auth.resetPasswordSuccess')}</Text>
            <TouchableOpacity onPress={onDone}>
              <Text style={styles.link}>{t('auth.backToLogin')}</Text>
            </TouchableOpacity>
          </>
        ) : (
          <>
            {error ? <Text style={styles.error}>{error}</Text> : null}

            <TextInput
              style={styles.input}
              placeholder={t('auth.password')}
              placeholderTextColor={COLORS.subtitle}
              value={password}
              onChangeText={setPassword}
              secureTextEntry
              autoComplete="new-password"
            />
            <TextInput
              style={styles.input}
              placeholder={t('auth.confirmPassword')}
              placeholderTextColor={COLORS.subtitle}
              value={confirm}
              onChangeText={setConfirm}
              secureTextEntry
              autoComplete="new-password"
            />

            <TouchableOpacity style={styles.button} onPress={handleSubmit} disabled={loading}>
              {loading ? <ActivityIndicator color={COLORS.btnAddText} /> : <Text style={styles.buttonText}>{t('auth.resetPasswordBtn')}</Text>}
            </TouchableOpacity>

            <TouchableOpacity onPress={onDone}>
              <Text style={styles.link}>{t('auth.backToLogin')}</Text>
            </TouchableOpacity>
          </>
        )}
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 },
  card: {
    width: '100%', maxWidth: 380, backgroundColor: '#faf5ea',
    borderTopLeftRadius: 4, borderBottomLeftRadius: 4, borderTopRightRadius: 16, borderBottomRightRadius: 16,
    padding: 28, borderWidth: 1, borderColor: COLORS.shellBorder,
    boxShadow: '2px 3px 10px rgba(0,0,0,0.08)',
  },
  titleChinese: { fontSize: 42, color: COLORS.title, textAlign: 'center', letterSpacing: 6 },
  titleEnglish: { fontFamily: FONTS.pixel, fontSize: 14, color: COLORS.subtitle, textAlign: 'center', letterSpacing: 3, marginBottom: 12 },
  subtitle: { fontFamily: FONTS.dot, fontSize: 14, color: COLORS.subtitle, textAlign: 'center', letterSpacing: 4, marginBottom: 4 },
  stars: { fontSize: 14, color: COLORS.star, letterSpacing: 6, textAlign: 'center', marginBottom: 20 },
  error: { fontFamily: FONTS.dot, color: '#c0392b', fontSize: 12, textAlign: 'center', marginBottom: 10 },
  success: { fontFamily: FONTS.dot, color: '#708060', fontSize: 13, textAlign: 'center', marginBottom: 16, lineHeight: 20 },
  input: {
    fontFamily: FONTS.dot, fontSize: 14, borderWidth: 2, borderColor: COLORS.inputBorder,
    borderRadius: 10, padding: 12, backgroundColor: COLORS.inputBg, color: COLORS.inputText, marginBottom: 10,
  },
  button: {
    backgroundColor: COLORS.btnAdd, borderWidth: 2, borderColor: COLORS.btnAddBorder,
    borderRadius: 10, padding: 12, alignItems: 'center', marginTop: 6, marginBottom: 14,
  },
  buttonText: { fontFamily: FONTS.pixel, fontSize: 11, letterSpacing: 1, color: COLORS.btnAddText, textTransform: 'uppercase' },
  link: { fontFamily: FONTS.dot, color: COLORS.accent, textAlign: 'center', fontSize: 12 },
});
