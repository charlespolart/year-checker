import React, { useEffect, useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, ActivityIndicator } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';
import { useLanguage } from '../contexts/LanguageContext';
import { API_URL } from '../lib/api';

interface Props {
  token: string;
  onDone: () => void;
}

export default function VerifyEmailScreen({ token, onDone }: Props) {
  const { t } = useLanguage();
  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading');

  useEffect(() => {
    (async () => {
      try {
        const res = await fetch(`${API_URL}/auth/verify-email`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ token }),
        });
        setStatus(res.ok ? 'success' : 'error');
      } catch {
        setStatus('error');
      }
    })();
  }, [token]);

  return (
    <View style={styles.container}>
      <View style={styles.card}>
        <Text style={styles.titleChinese}>点点</Text>
        <Text style={styles.titleEnglish}>Dian Dian</Text>
        <Text style={styles.stars}>☆ ☆ ☆</Text>

        {status === 'loading' && <ActivityIndicator size="large" color={COLORS.accent} style={{ marginVertical: 20 }} />}

        {status === 'success' && (
          <>
            <Text style={styles.success}>✓ {t('auth.emailVerifiedSuccess')}</Text>
            <TouchableOpacity onPress={onDone}>
              <Text style={styles.link}>{t('auth.backToLogin')}</Text>
            </TouchableOpacity>
          </>
        )}

        {status === 'error' && (
          <>
            <Text style={styles.error}>{t('auth.verifyEmailError')}</Text>
            <TouchableOpacity onPress={onDone}>
              <Text style={styles.link}>{t('auth.backToLogin')}</Text>
            </TouchableOpacity>
          </>
        )}
      </View>
    </View>
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
  stars: { fontSize: 14, color: COLORS.star, letterSpacing: 6, textAlign: 'center', marginBottom: 20 },
  success: { fontFamily: FONTS.dot, color: '#708060', fontSize: 15, textAlign: 'center', marginBottom: 16 },
  error: { fontFamily: FONTS.dot, color: '#c0392b', fontSize: 13, textAlign: 'center', marginBottom: 16 },
  link: { fontFamily: FONTS.dot, color: COLORS.accent, textAlign: 'center', fontSize: 12 },
});
