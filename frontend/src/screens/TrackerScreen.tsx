import React, { useState, useCallback } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet, Platform, useWindowDimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

const SafeContainer = Platform.OS === 'web'
  ? ({ children, ...props }: any) => <View style={props.style}>{children}</View>
  : SafeAreaView;
import { usePages } from '../hooks/usePages';
import { useCells } from '../hooks/useCells';
import { useLegends } from '../hooks/useLegends';
import { useLanguage } from '../contexts/LanguageContext';
import TrackerGrid from '../components/TrackerGrid';
import PaletteEditor from '../components/PaletteEditor';
import LegendEditor from '../components/LegendEditor';
import LegendList from '../components/LegendList';
import CellEditor from '../components/CellEditor';
import Stats from '../components/Stats';
import { useTapSound } from '../hooks/useTapSound';
import { apiFetch } from '../lib/api';
import { useConfirm } from '../hooks/useConfirm';
import { COLORS, FONTS, DEFAULT_PALETTE } from '../lib/theme';

interface Props {
  pageId: string;
  onBack: () => void;
  onOpenSettings: () => void;
}

export default function TrackerScreen({ pageId, onBack, onOpenSettings }: Props) {
  const { t } = useLanguage();
  const { pages, updatePage } = usePages();
  const confirm = useConfirm();
  const { playTap, playErase } = useTapSound();
  const [paletteEditorOpen, setPaletteEditorOpen] = useState(false);
  const [legendEditorOpen, setLegendEditorOpen] = useState(false);
  const [cellEditorTarget, setCellEditorTarget] = useState<{ month: number; day: number } | null>(null);
  const [editingTitle, setEditingTitle] = useState(false);
  const [gridDotSize, setGridDotSize] = useState(16);
  const { width, height } = useWindowDimensions();
  const isLandscape = width > height;
  const isTabletLandscape = isLandscape && height >= 600;
  const isPhoneLandscape = isLandscape && height < 600;
  const spacingH = 3;
  const spacingV = 2;


  const currentPageId = pageId;

  const { cells, getCellColor, getCell, setCell, deleteCell } = useCells(currentPageId);
  const { legends, createLegend, deleteLegend, reorderLegends } = useLegends(currentPageId);

  const currentPage = pages.find(p => p.id === currentPageId);
  const currentPalette = currentPage?.palette || DEFAULT_PALETTE;

  const handleCellPress = useCallback((month: number, day: number) => {
    setCellEditorTarget({ month, day });
  }, []);


  const handleTitleSubmit = useCallback((text: string) => {
    if (currentPageId && text.trim()) {
      updatePage(currentPageId, { title: text.trim() });
    }
    setEditingTitle(false);
  }, [currentPageId, updatePage]);


  return (
    <SafeContainer style={styles.safeArea} edges={['top', 'bottom']}>
      {/* Back + title bar — hidden on tablet landscape */}
      {!isTabletLandscape && <View style={styles.backBar}>
        <TouchableOpacity style={styles.backBtn} onPress={onBack}>
          <Text style={styles.backBtnText}>←</Text>
        </TouchableOpacity>
        {editingTitle ? (
          <TextInput
            style={styles.backBarTitleInput}
            defaultValue={currentPage?.title}
            autoFocus
            onBlur={(e) => handleTitleSubmit((e.nativeEvent as any).text ?? currentPage?.title ?? '')}
            onSubmitEditing={(e) => handleTitleSubmit(e.nativeEvent.text)}
            selectTextOnFocus
            maxLength={50}
          />
        ) : (
          <TouchableOpacity style={{ flex: 1 }} onPress={() => setEditingTitle(true)}>
            <Text style={styles.backBarTitle} numberOfLines={1}>{currentPage?.title || ''}</Text>
          </TouchableOpacity>
        )}
        <View style={styles.backBtn} />
      </View>}

      {/* Content — scrollable only on phone landscape */}
      <ScrollView
        style={{ flex: 1 }}
        scrollEnabled={isPhoneLandscape}
        contentContainerStyle={!isPhoneLandscape ? { flex: 1 } : undefined}
      >
        <View style={[isTabletLandscape ? styles.wideLayout : { flex: 1 }]}>
        {isTabletLandscape && (
          <View style={styles.leftColumn}>
            <TouchableOpacity onPress={() => setEditingTitle(true)}>
              <Text style={styles.wideTitle}>{currentPage?.title || 'Dian Dian'}</Text>
            </TouchableOpacity>
            <Text style={styles.wideSubtitle}>~ {currentPage?.year ?? new Date().getFullYear()} ~</Text>
            <Text style={styles.wideStars}>☆ ☆ ☆ ☆ ☆</Text>
            <TouchableOpacity style={styles.wideBackBtn} onPress={onBack}>
              <Text style={styles.wideBackText}>← {t('settings.back')}</Text>
            </TouchableOpacity>
          </View>
        )}
        <View style={[styles.shell, { flex: 1 }]}>
          <View style={[styles.screen, { flex: 1 }]}>
            <View style={[styles.screenRow, { flex: 1 }]}>
              <View style={styles.sidebar}>
                <Text style={styles.sidebarTitle}>{t('tracker.legend')}</Text>
                <LegendList legends={legends} />
                <TouchableOpacity style={styles.legendEditBtn} onPress={() => setLegendEditorOpen(true)}>
                  <Text style={styles.legendEditBtnText}>{t('tracker.editLegends')}</Text>
                </TouchableOpacity>
                <View style={styles.statsSection}>
                  <Text style={styles.sidebarTitle}>{t('tracker.stats')}</Text>
                  <Stats cells={cells} />
                </View>
              </View>
              <View
                style={[styles.gridContainer, { flex: 1 }]}
                onLayout={((e: any) => {
                  const { width: gw, height: gh } = e.nativeEvent.layout;
                  if (gw < 50 || gh < 50) return;
                  const labelW = 16;
                  const headerH = 16;
                  const dw = (gw - labelW - 11 * spacingH) / 12;
                  const dh = (gh - headerH - 30 * spacingV) / 31;
                  const d = Math.max(6, isPhoneLandscape ? Math.min(dw, 32) : Math.min(dw, dh, 32));
                  if (Math.abs(d - gridDotSize) > 0.3) setGridDotSize(d);
                })}
              >
                {currentPageId ? (
                  <TrackerGrid
                    getCellColor={getCellColor}
                    selectedColor={null}
                    onCellPress={handleCellPress}
                    dotSize={gridDotSize}
                  />
                ) : null}
              </View>
            </View>
          </View>
        </View>
        </View>
      </ScrollView>

      {paletteEditorOpen && currentPageId && (
        <PaletteEditor
          palette={currentPalette}
          cells={cells}
          legends={legends}
          onSave={async (palette, colorMap) => {
            const isDefault = JSON.stringify(palette) === JSON.stringify(DEFAULT_PALETTE);
            updatePage(currentPageId, { palette: isDefault ? null : palette });

            // Recolor cells and legends if colors changed
            if (Object.keys(colorMap).length > 0) {
              await apiFetch(`/cells/${currentPageId}/recolor`, {
                method: 'PATCH',
                body: JSON.stringify({ colorMap }),
              });
              await apiFetch(`/legends/${currentPageId}/recolor`, {
                method: 'PATCH',
                body: JSON.stringify({ colorMap }),
              });
            }

          }}
          onClose={() => { setPaletteEditorOpen(false); setLegendEditorOpen(true); }}
        />
      )}

      {legendEditorOpen && currentPageId && (
        <LegendEditor
          legends={legends}
          cells={cells}
          palette={currentPalette}
          brushColor={null}
          onCreateLegend={createLegend}
          onDeleteLegend={async (id, color) => {
            await deleteLegend(id);
            const matching = cells.filter(c => c.color.toUpperCase() === color.toUpperCase());
            await Promise.all(matching.map(c => deleteCell(c.month, c.day)));
          }}
          onReorderLegends={reorderLegends}
          onOpenPaletteConfig={() => { setLegendEditorOpen(false); setPaletteEditorOpen(true); }}
          onClose={() => setLegendEditorOpen(false)}
        />
      )}

      {/* Cell Editor Popup */}
      {cellEditorTarget && currentPageId && (
        <CellEditor
          month={cellEditorTarget.month}
          day={cellEditorTarget.day}
          year={currentPage?.year ?? new Date().getFullYear()}
          cell={getCell(cellEditorTarget.month, cellEditorTarget.day)}
          legends={legends}
          onSave={(color, comment) => {
            playTap();
            setCell(cellEditorTarget.month, cellEditorTarget.day, color, comment);
            setCellEditorTarget(null);
          }}
          onDelete={() => {
            playErase();
            deleteCell(cellEditorTarget.month, cellEditorTarget.day);
            setCellEditorTarget(null);
          }}
          onNavigate={(dir) => {
            let { month, day } = cellEditorTarget;
            const yr = currentPage?.year ?? new Date().getFullYear();
            const daysInMonth = (m: number) => new Date(yr, m + 1, 0).getDate();
            day += dir;
            if (day < 1) { month--; if (month < 0) month = 11; day = daysInMonth(month); }
            else if (day > daysInMonth(month)) { month++; if (month > 11) month = 0; day = 1; }
            setCellEditorTarget({ month, day });
          }}
          onClose={() => setCellEditorTarget(null)}
        />
      )}
    </SafeContainer>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },
  backBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 8,
    paddingVertical: 2,
  },
  backBtn: {
    width: 28,
    paddingVertical: 2,
  },
  backBtnText: {
    fontSize: 18,
    color: COLORS.accent,
  },
  backBarTitle: {
    fontFamily: FONTS.pixel,
    fontSize: 12,
    color: COLORS.title,
    textAlign: 'center',
    letterSpacing: 2,
  },
  backBarTitleInput: {
    flex: 1,
    fontFamily: FONTS.pixel,
    fontSize: 12,
    color: COLORS.title,
    textAlign: 'center',
    letterSpacing: 2,
    borderBottomWidth: 2,
    borderBottomColor: COLORS.tabActiveBorder,
    borderStyle: 'dashed',
    paddingVertical: 2,
  },
  shell: {
    flex: 1,
    backgroundColor: '#faf5ea',
    borderRadius: 12,
    padding: 3,
    borderWidth: 1,
    borderColor: COLORS.shellBorder,
    boxShadow: '2px 3px 10px rgba(0,0,0,0.08)',
    marginHorizontal: 4,
    marginBottom: 4,
  },
  screen: {
    backgroundColor: COLORS.screen,
    borderWidth: 2,
    borderColor: COLORS.screenBorder,
    borderStyle: 'dashed',
    borderRadius: 12,
    padding: 4,
    overflow: 'hidden',
  },
  sectionTitle: {
    fontFamily: FONTS.pixel,
    fontSize: 8,
    letterSpacing: 2,
    textTransform: 'uppercase',
    textAlign: 'center',
    marginBottom: 2,
    paddingBottom: 2,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.sectionBorder,
    borderStyle: 'dashed',
    color: COLORS.textWarm,
  },
  screenRow: {
    flexDirection: 'row',
    gap: 6,
  },
  sidebar: {
    width: 80,
    gap: 4,
  },
  sidebarTitle: {
    fontFamily: FONTS.pixel,
    fontSize: 8,
    letterSpacing: 2,
    textTransform: 'uppercase',
    textAlign: 'center',
    paddingBottom: 3,
    borderBottomWidth: 2,
    borderBottomColor: COLORS.sectionBorder,
    borderStyle: 'dashed',
    color: COLORS.textWarm,
    opacity: 0.7,
  },
  statsSection: {
    marginTop: 'auto' as any,
    gap: 4,
  },
  gridContainer: {
    alignItems: 'flex-end',
  },
  wideLayout: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'stretch',
    paddingHorizontal: 8,
    gap: 16,
  },
  leftColumn: {
    width: 220,
    alignItems: 'center',
    justifyContent: 'center',
  },
  wideTitle: {
    fontFamily: FONTS.pixel,
    fontSize: 28,
    color: COLORS.title,
    textAlign: 'center',
    letterSpacing: 2,
  },
  wideTitleInput: {
    fontFamily: FONTS.pixel,
    fontSize: 28,
    color: COLORS.title,
    textAlign: 'center',
    letterSpacing: 2,
    borderBottomWidth: 3,
    borderBottomColor: COLORS.tabActiveBorder,
    borderStyle: 'dashed',
    paddingVertical: 4,
    width: '100%',
  },
  wideSubtitle: {
    fontFamily: FONTS.dot,
    fontSize: 14,
    color: COLORS.subtitle,
    textAlign: 'center',
    letterSpacing: 4,
    marginBottom: 2,
  },
  wideStars: {
    fontSize: 14,
    color: COLORS.star,
    letterSpacing: 6,
    textAlign: 'center',
    marginBottom: 12,
  },
  wideBackBtn: {
    paddingVertical: 6,
    paddingHorizontal: 12,
  },
  wideBackText: {
    fontFamily: FONTS.pixel,
    fontSize: 11,
    color: COLORS.accent,
    letterSpacing: 1,
  },
  legendEditBtn: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderWidth: 1,
    borderColor: COLORS.tabBorder,
    borderRadius: 6,
    borderStyle: 'dashed',
  },
  legendEditBtnText: {
    fontFamily: FONTS.pixel,
    fontSize: 7,
    letterSpacing: 1,
    color: COLORS.textMuted,
    textTransform: 'uppercase',
  },
});
