import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Pressable } from 'react-native';
import { COLORS, FONTS } from '../lib/theme';

interface Props {
  visible: boolean;
  title?: string;
  message: string;
  confirmText?: string;
  cancelText?: string;
  destructive?: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}

export default function ConfirmDialog({ visible, title, message, confirmText = 'OK', cancelText, destructive, onConfirm, onCancel }: Props) {
  if (!visible) return null;

  return (
    <View style={styles.overlay}>
      <Pressable style={styles.backdrop} onPress={onCancel} />
      <View style={styles.dialog}>
        {title && <Text style={styles.title}>{title}</Text>}
        <Text style={styles.message}>{message}</Text>
        <View style={styles.buttons}>
          {cancelText && (
            <TouchableOpacity style={styles.cancelBtn} onPress={onCancel}>
              <Text style={styles.cancelText}>{cancelText}</Text>
            </TouchableOpacity>
          )}
          <TouchableOpacity style={[styles.confirmBtn, destructive && styles.destructiveBtn]} onPress={onConfirm}>
            <Text style={[styles.confirmText, destructive && styles.destructiveText]}>{confirmText}</Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  overlay: {
    ...StyleSheet.absoluteFillObject,
    zIndex: 200,
    justifyContent: 'center',
    alignItems: 'center',
  },
  backdrop: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  dialog: {
    width: '85%',
    maxWidth: 320,
    backgroundColor: '#faf5ea',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: COLORS.shellBorder,
    padding: 20,
    gap: 14,
  },
  title: {
    fontFamily: FONTS.pixel,
    fontSize: 12,
    letterSpacing: 2,
    color: COLORS.accent,
    textTransform: 'uppercase',
    textAlign: 'center',
  },
  message: {
    fontFamily: FONTS.dot,
    fontSize: 14,
    color: COLORS.textLabel,
    textAlign: 'center',
    lineHeight: 20,
  },
  buttons: {
    flexDirection: 'row',
    gap: 10,
    marginTop: 4,
  },
  cancelBtn: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: COLORS.tabBorder,
    alignItems: 'center',
  },
  cancelText: {
    fontFamily: FONTS.pixel,
    fontSize: 10,
    letterSpacing: 1,
    color: COLORS.textMuted,
    textTransform: 'uppercase',
  },
  confirmBtn: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: COLORS.btnAddBorder,
    backgroundColor: COLORS.btnAdd,
    alignItems: 'center',
  },
  confirmText: {
    fontFamily: FONTS.pixel,
    fontSize: 10,
    letterSpacing: 1,
    color: COLORS.btnAddText,
    textTransform: 'uppercase',
  },
  destructiveBtn: {
    borderColor: '#c0392b',
    backgroundColor: '#f8e0dc',
  },
  destructiveText: {
    color: '#c0392b',
  },
});
