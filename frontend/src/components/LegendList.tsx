import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';
import type { Legend } from '../hooks/useLegends';

interface Props {
  legends: Legend[];
}

export default function LegendList({ legends }: Props) {
  if (legends.length === 0) return null;

  return (
    <View style={styles.container}>
      {legends.map(legend => (
        <View key={legend.id} style={styles.legendItem}>
          <View style={[styles.legendDot, { backgroundColor: legend.color }]} />
          <Text style={styles.legendLabel} numberOfLines={1}>{legend.label}</Text>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    gap: 2,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingVertical: 2,
  },
  legendDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    borderWidth: 1,
    borderColor: 'rgba(0,0,0,0.08)',
    flexShrink: 0,
  },
  legendLabel: {
    flex: 1,
    fontFamily: FONTS.dot,
    fontSize: 10,
    color: COLORS.textLabel,
  },
});
