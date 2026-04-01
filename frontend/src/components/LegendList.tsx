import React from 'react';
import { View, Text, StyleSheet, useWindowDimensions } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';
import type { Legend } from '../hooks/useLegends';

interface Props {
  legends: Legend[];
}

export default function LegendList({ legends }: Props) {
  const { width } = useWindowDimensions();
  const isMobile = width < 768;

  if (legends.length === 0) return null;

  return (
    <View style={styles.container}>
      {legends.map(legend => (
        <View key={legend.id} style={[styles.legendItem, isMobile && styles.legendItemHalf]}>
          <View style={[styles.legendDot, { backgroundColor: legend.color }]} />
          <Text style={styles.legendLabel} numberOfLines={1}>{legend.label}</Text>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    gap: 3,
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingVertical: 4,
    paddingHorizontal: 6,
    borderRadius: 6,
    width: '100%',
  },
  legendItemHalf: {
    width: '48%',
  },
  legendDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
    borderWidth: 2,
    borderColor: 'rgba(0,0,0,0.08)',
  },
  legendLabel: {
    flex: 1,
    fontFamily: FONTS.dot,
    fontSize: 11,
    color: COLORS.textLabel,
  },
});
