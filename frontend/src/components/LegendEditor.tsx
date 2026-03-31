import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet, Alert, Platform, Pressable } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';
import { useLanguage } from '../contexts/LanguageContext';
import ColorPicker from './ColorPicker';
import type { Legend } from '../hooks/useLegends';
import type { Cell } from '../hooks/useCells';

interface Props {
  legends: Legend[];
  cells: Cell[];
  palette: string[][];
  brushColor: string | null;
  onCreateLegend: (color: string, label: string) => Promise<any>;
  onDeleteLegend: (id: string, color: string) => Promise<void>;
  onOpenPaletteConfig: () => void;
  onClose: () => void;
}

export default function LegendEditor({ legends, cells, palette, brushColor, onCreateLegend, onDeleteLegend, onOpenPaletteConfig, onClose }: Props) {
  const { t } = useLanguage();
  const [pickerColor, setPickerColor] = useState<string | null>(null);
  const [newLabel, setNewLabel] = useState('');
  const [adding, setAdding] = useState(false);

  const handleAdd = async () => {
    if (!pickerColor || !newLabel.trim()) return;
    setAdding(true);
    try {
      await onCreateLegend(pickerColor, newLabel.trim());
      setNewLabel('');
    } catch { /* ignore */ }
    setAdding(false);
  };

  const handleDelete = (legend: Legend) => {
    // Check if color is used in grid
    const usedInGrid = cells.some(c => c.color.toUpperCase() === legend.color.toUpperCase());
    const msg = usedInGrid ? t('tracker.deleteLegendConfirm') : t('tracker.deleteLegendConfirmSimple');

    const doDelete = () => onDeleteLegend(legend.id, legend.color);
    if (Platform.OS === 'web') {
      if (confirm(msg)) doDelete();
    } else {
      Alert.alert(t('common.delete'), msg, [
        { text: t('common.cancel'), style: 'cancel' },
        { text: t('common.delete'), style: 'destructive', onPress: doDelete },
      ]);
    }
  };

  return (
    <View style={styles.overlay}>
      <Pressable style={styles.backdrop} onPress={onClose} />
      <View style={styles.modal}>
        <View style={styles.header}>
          <Text style={styles.title}>{t('tracker.editLegends')}</Text>
          <TouchableOpacity onPress={onClose}>
            <Text style={styles.closeBtn}>✕</Text>
          </TouchableOpacity>
        </View>

        <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
          {/* Existing legends */}
          <View style={styles.legendsList}>
            {legends.map(legend => (
              <View key={legend.id} style={styles.legendItem}>
                <View style={[styles.legendDot, { backgroundColor: legend.color }]} />
                <Text style={styles.legendLabel} numberOfLines={1}>{legend.label}</Text>
                <TouchableOpacity onPress={() => handleDelete(legend)} hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
                  <Text style={styles.deleteText}>✕</Text>
                </TouchableOpacity>
              </View>
            ))}
            {legends.length === 0 && (
              <Text style={styles.emptyText}>{t('tracker.noLegends')}</Text>
            )}
          </View>

          {/* Divider */}
          <View style={styles.divider} />

          {/* Color picker for new legend */}
          <Text style={styles.sectionTitle}>{t('tracker.colors')}</Text>
          <ColorPicker
            palette={palette}
            selectedColor={pickerColor}
            onSelect={setPickerColor}
            onOpenPaletteConfig={onOpenPaletteConfig}
          />

          {/* Add new legend */}
          <View style={styles.addSection}>
            <View style={styles.addRow}>
              <TextInput
                style={[styles.input, pickerColor ? { borderLeftWidth: 5, borderLeftColor: pickerColor } : null]}
                placeholder={t('tracker.legendPlaceholder')}
                placeholderTextColor="#b0a890"
                value={newLabel}
                onChangeText={setNewLabel}
                onSubmitEditing={handleAdd}
              />
              <TouchableOpacity style={styles.addBtn} onPress={handleAdd} disabled={adding || !pickerColor}>
                <Text style={styles.addBtnText}>+</Text>
              </TouchableOpacity>
            </View>
          </View>
        </ScrollView>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  overlay: {
    ...StyleSheet.absoluteFillObject,
    zIndex: 100,
    justifyContent: 'center',
    alignItems: 'center',
  },
  backdrop: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  modal: {
    width: '90%',
    maxWidth: 400,
    maxHeight: '85%',
    backgroundColor: '#faf5ea',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: COLORS.shellBorder,
    overflow: 'hidden',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.sectionBorder,
  },
  title: {
    fontFamily: FONTS.pixel,
    fontSize: 12,
    letterSpacing: 2,
    color: COLORS.accent,
    textTransform: 'uppercase',
  },
  closeBtn: {
    fontSize: 16,
    color: COLORS.textMuted,
  },
  content: {
    padding: 16,
  },
  legendsList: {
    gap: 4,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    paddingVertical: 6,
    paddingHorizontal: 8,
    borderRadius: 8,
    backgroundColor: 'rgba(0,0,0,0.02)',
  },
  legendDot: {
    width: 16,
    height: 16,
    borderRadius: 8,
    borderWidth: 2,
    borderColor: 'rgba(0,0,0,0.08)',
  },
  legendLabel: {
    flex: 1,
    fontFamily: FONTS.dot,
    fontSize: 13,
    color: COLORS.textLabel,
  },
  deleteText: {
    fontSize: 12,
    color: '#c0392b',
  },
  emptyText: {
    fontFamily: FONTS.dot,
    fontSize: 12,
    color: COLORS.textMuted,
    fontStyle: 'italic',
    textAlign: 'center',
    paddingVertical: 8,
  },
  divider: {
    height: 1,
    backgroundColor: COLORS.sectionBorder,
    marginVertical: 14,
  },
  sectionTitle: {
    fontFamily: FONTS.pixel,
    fontSize: 9,
    letterSpacing: 2,
    textTransform: 'uppercase',
    textAlign: 'center',
    paddingBottom: 6,
    color: COLORS.textWarm,
    opacity: 0.7,
    marginBottom: 4,
  },
  addSection: {
    marginTop: 12,
  },
  addRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  input: {
    flex: 1,
    minWidth: 0,
    fontFamily: FONTS.dot,
    fontSize: 13,
    borderWidth: 2,
    borderColor: COLORS.inputBorder,
    borderRadius: 8,
    paddingHorizontal: 8,
    paddingVertical: 6,
    backgroundColor: COLORS.inputBg,
    color: COLORS.inputText,
  },
  addBtn: {
    backgroundColor: COLORS.btnAdd,
    borderWidth: 2,
    borderColor: COLORS.btnAddBorder,
    borderRadius: 8,
    width: 32,
    height: 32,
    flexShrink: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  addBtnText: {
    fontSize: 18,
    color: COLORS.btnAddText,
    lineHeight: 20,
  },
});
