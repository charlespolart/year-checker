import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Pressable } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';
import { useLanguage } from '../contexts/LanguageContext';
import type { Cell } from '../hooks/useCells';
import type { Legend } from '../hooks/useLegends';

const MONTHS_SHORT = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const COMMENT_MAX = 200;

interface Props {
  month: number;
  day: number;
  year: number;
  cell: Cell | null;
  legends: Legend[];
  onSave: (color: string, comment: string | null) => void;
  onDelete: () => void;
  onNavigate: (direction: -1 | 1) => void;
  onClose: () => void;
}

function getDaysInMonth(month: number, year: number): number {
  return new Date(year, month + 1, 0).getDate();
}

export default function CellEditor({ month, day, year, cell, legends, onSave, onDelete, onNavigate, onClose }: Props) {
  const { t } = useLanguage();
  const [selectedColor, setSelectedColor] = useState<string | null>(cell?.color ?? null);
  const [comment, setComment] = useState(cell?.comment ?? '');

  const handleSave = () => {
    if (!selectedColor) return;
    onSave(selectedColor, comment.trim() || null);
  };

  const maxDays = getDaysInMonth(month, year);

  return (
    <View style={styles.overlay}>
      <Pressable style={styles.backdrop} onPress={onClose} />
      <View style={styles.modal}>
        {/* Date header with navigation */}
        <View style={styles.dateHeader}>
          <TouchableOpacity onPress={() => onNavigate(-1)} style={styles.navBtn}>
            <Text style={styles.navText}>‹</Text>
          </TouchableOpacity>
          <Text style={styles.dateText}>{day} {MONTHS_SHORT[month]} {year}</Text>
          <TouchableOpacity onPress={() => onNavigate(1)} style={styles.navBtn}>
            <Text style={styles.navText}>›</Text>
          </TouchableOpacity>
        </View>

        {/* Legend selection */}
        <View style={styles.legendGrid}>
          {legends.map(legend => (
            <TouchableOpacity
              key={legend.id}
              style={[styles.legendItem, selectedColor === legend.color && styles.legendItemSelected]}
              onPress={() => setSelectedColor(legend.color)}
            >
              <View style={[styles.legendDot, { backgroundColor: legend.color }]} />
              <Text style={[styles.legendLabel, selectedColor === legend.color && styles.legendLabelSelected]} numberOfLines={1}>{legend.label}</Text>
            </TouchableOpacity>
          ))}
          {legends.length === 0 && (
            <Text style={styles.emptyText}>{t('tracker.noLegends')}</Text>
          )}
        </View>

        {/* Comment */}
        <TextInput
          style={styles.commentInput}
          placeholder={t('cell.commentPlaceholder')}
          placeholderTextColor={COLORS.subtitle}
          value={comment}
          onChangeText={(v) => setComment(v.slice(0, COMMENT_MAX))}
          multiline
          maxLength={COMMENT_MAX}
        />
        <Text style={styles.charCount}>{comment.length}/{COMMENT_MAX}</Text>

        {/* Actions */}
        <View style={styles.actions}>
          {cell && (
            <TouchableOpacity style={styles.deleteBtn} onPress={onDelete}>
              <Text style={styles.deleteBtnText}>{t('tracker.eraser')}</Text>
            </TouchableOpacity>
          )}
          <TouchableOpacity
            style={[styles.saveBtn, !selectedColor && styles.saveBtnDisabled]}
            onPress={handleSave}
            disabled={!selectedColor}
          >
            <Text style={styles.saveBtnText}>{t('common.confirm')}</Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  overlay: {
    ...StyleSheet.absoluteFillObject,
    zIndex: 150,
    justifyContent: 'center',
    alignItems: 'center',
  },
  backdrop: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  modal: {
    width: '90%',
    maxWidth: 360,
    backgroundColor: '#faf5ea',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: COLORS.shellBorder,
    padding: 16,
    gap: 12,
  },
  dateHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  navBtn: {
    padding: 8,
  },
  navText: {
    fontSize: 24,
    color: COLORS.accent,
    fontWeight: '600',
  },
  dateText: {
    fontFamily: FONTS.pixel,
    fontSize: 14,
    letterSpacing: 2,
    color: COLORS.title,
    textTransform: 'uppercase',
  },
  legendGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 6,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingVertical: 6,
    paddingHorizontal: 10,
    borderRadius: 8,
    borderWidth: 2,
    borderColor: 'transparent',
    width: '48%',
  },
  legendItemSelected: {
    backgroundColor: COLORS.tabActive,
    borderColor: COLORS.tabActiveBorder,
  },
  legendDot: {
    width: 14,
    height: 14,
    borderRadius: 7,
    borderWidth: 2,
    borderColor: 'rgba(0,0,0,0.08)',
  },
  legendLabel: {
    flex: 1,
    fontFamily: FONTS.dot,
    fontSize: 12,
    color: COLORS.textLabel,
  },
  legendLabelSelected: {
    color: COLORS.accent,
  },
  emptyText: {
    fontFamily: FONTS.dot,
    fontSize: 12,
    color: COLORS.textMuted,
    fontStyle: 'italic',
    textAlign: 'center',
    width: '100%',
    paddingVertical: 8,
  },
  commentInput: {
    fontFamily: FONTS.dot,
    fontSize: 13,
    borderWidth: 2,
    borderColor: COLORS.inputBorder,
    borderRadius: 8,
    padding: 10,
    backgroundColor: COLORS.inputBg,
    color: COLORS.inputText,
    minHeight: 50,
    maxHeight: 80,
    textAlignVertical: 'top',
  },
  charCount: {
    fontFamily: FONTS.dot,
    fontSize: 10,
    color: COLORS.textMuted,
    textAlign: 'right',
    marginTop: -8,
  },
  actions: {
    flexDirection: 'row',
    gap: 10,
  },
  deleteBtn: {
    paddingVertical: 10,
    paddingHorizontal: 14,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: COLORS.btnResetBorder,
    backgroundColor: COLORS.btnReset,
  },
  deleteBtnText: {
    fontFamily: FONTS.pixel,
    fontSize: 10,
    letterSpacing: 1,
    color: COLORS.btnResetText,
    textTransform: 'uppercase',
  },
  saveBtn: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: COLORS.btnAddBorder,
    backgroundColor: COLORS.btnAdd,
    alignItems: 'center',
  },
  saveBtnDisabled: {
    opacity: 0.4,
  },
  saveBtnText: {
    fontFamily: FONTS.pixel,
    fontSize: 10,
    letterSpacing: 1,
    color: COLORS.btnAddText,
    textTransform: 'uppercase',
  },
});
