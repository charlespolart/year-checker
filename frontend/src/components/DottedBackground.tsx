import React from 'react';
import { View, StyleSheet, Platform } from 'react-native';
import { COLORS } from '../lib/theme';

export default function DottedBackground({ children }: { children: React.ReactNode }) {
  if (Platform.OS === 'web') {
    return (
      <View style={[styles.container, styles.webDots]}>
        {children}
      </View>
    );
  }

  // Native: use react-native-svg
  const Svg = require('react-native-svg').default;
  const { Defs, Pattern, Circle, Rect } = require('react-native-svg');

  return (
    <View style={styles.container}>
      <Svg style={StyleSheet.absoluteFill} width="100%" height="100%">
        <Defs>
          <Pattern id="dots" x="0" y="0" width="32" height="32" patternUnits="userSpaceOnUse">
            <Circle cx="16" cy="16" r="2" fill={COLORS.bgDot} />
          </Pattern>
        </Defs>
        <Rect x="0" y="0" width="100%" height="100%" fill={COLORS.bg} />
        <Rect x="0" y="0" width="100%" height="100%" fill="url(#dots)" />
      </Svg>
      <View style={styles.content}>{children}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.bg,
  },
  webDots: Platform.OS === 'web' ? {
    backgroundImage: `radial-gradient(circle, ${COLORS.bgDot} 2px, transparent 2px)`,
    backgroundSize: '32px 32px',
  } as any : {},
  content: {
    flex: 1,
  },
});
