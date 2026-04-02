import React, { useEffect, useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';
import { apiFetch } from '../lib/api';
import type { Page } from '../hooks/usePages';
import type { Cell } from '../hooks/useCells';

interface Props {
  page: Page;
  cardWidth: number;
  onPress: () => void;
  onLongPress: () => void;
}

interface LegendSummary {
  color: string;
  label: string;
}

function getDaysInMonth(month: number, year: number): number {
  return new Date(year, month + 1, 0).getDate();
}

export default function PageCard({ page, cardWidth, onPress, onLongPress }: Props) {
  const [cells, setCells] = useState<Cell[]>([]);
  const [legends, setLegends] = useState<LegendSummary[]>([]);

  useEffect(() => {
    apiFetch(`/cells/${page.id}`).then(r => r.ok ? r.json() : []).then(setCells).catch(() => {});
    apiFetch(`/legends/${page.id}`).then(r => r.ok ? r.json() : []).then(setLegends).catch(() => {});
  }, [page.id]);

  const year = page.year ?? new Date().getFullYear();
  const cellMap = new Map(cells.map(c => [`${c.month}-${c.day}`, c.color]));
  const availW = cardWidth - 24; // card padding (12 * 2)
  const dotSize = Math.floor(Math.max(2, (availW - 11) / 12)); // 11 = gaps between 12 cols

  return (
    <TouchableOpacity
      style={[styles.card, { width: cardWidth }]}
      onPress={onPress}
      onLongPress={onLongPress}
      activeOpacity={0.8}
    >
      {/* Title */}
      <Text style={styles.cardTitle} numberOfLines={1}>{page.title}</Text>

      {/* Legend dots — horizontal, top left (always reserve space) */}
      <View style={styles.legendDots}>
        {legends.length > 0
          ? legends.slice(0, 8).map((l, i) => (
              <View key={i} style={[styles.legendDot, { backgroundColor: l.color }]} />
            ))
          : <View style={[styles.legendDot, { backgroundColor: 'transparent' }]} />
        }
      </View>

      {/* Grid */}
      <View style={styles.miniGrid}>
        {Array.from({ length: 12 }, (_, m) => (
          <View key={m} style={styles.miniCol}>
            {Array.from({ length: getDaysInMonth(m, year) }, (_, d) => {
              const color = cellMap.get(`${m}-${d + 1}`);
              return (
                <View
                  key={d}
                  style={[
                    styles.miniDot,
                    { width: dotSize, height: dotSize, borderRadius: dotSize / 2 },
                    { backgroundColor: color || COLORS.dotEmpty },
                  ]}
                />
              );
            })}
          </View>
        ))}
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: '#faf5ea',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: COLORS.shellBorder,
    padding: 12,
    gap: 10,
  },
  miniGrid: {
    flexDirection: 'row',
    gap: 1,
  },
  miniCol: {
    gap: 1,
  },
  miniDot: {
    borderWidth: 0.5,
    borderColor: 'rgba(0,0,0,0.04)',
  },
  cardTitle: {
    fontFamily: FONTS.pixel,
    fontSize: 10,
    color: COLORS.title,
    letterSpacing: 1,
    textAlign: 'center',
  },
  legendDots: {
    flexDirection: 'row',
    gap: 4,
    flexWrap: 'wrap',
    justifyContent: 'center',
  },
  legendDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    borderWidth: 0.5,
    borderColor: 'rgba(0,0,0,0.06)',
  },
});
