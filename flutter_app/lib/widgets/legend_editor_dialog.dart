import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/legends_provider.dart';
import '../theme/app_theme.dart';
import 'confirm_dialog.dart';

/// Dialog for managing legends: list, add, delete, reorder.
class LegendEditorDialog extends StatefulWidget {
  final String pageId;

  const LegendEditorDialog({super.key, required this.pageId});

  static Future<void> show(BuildContext context, {required String pageId}) {
    return showDialog(
      context: context,
      builder: (_) => LegendEditorDialog(pageId: pageId),
    );
  }

  @override
  State<LegendEditorDialog> createState() => _LegendEditorDialogState();
}

class _LegendEditorDialogState extends State<LegendEditorDialog> {
  final _labelController = TextEditingController();
  String _selectedColor = AppTheme.defaultPalette[0][0];

  Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final legendsProv = context.watch<LegendsProvider>();
    final legends = legendsProv.legends;

    return Dialog(
      backgroundColor: AppColors.shell,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.shellBorder),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lang.t('tracker.legend'),
              style: AppFonts.pixel(fontSize: 16, color: AppColors.title),
            ),
            const SizedBox(height: 16),

            // Existing legends (reorderable)
            if (legends.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  lang.t('tracker.noLegends'),
                  style:
                      AppFonts.dot(fontSize: 13, color: AppColors.textMuted),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: ReorderableListView(
                  shrinkWrap: true,
                  buildDefaultDragHandles: true,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    final ids =
                        legends.map((l) => l.id).toList();
                    final movedId = ids.removeAt(oldIndex);
                    ids.insert(newIndex, movedId);
                    legendsProv.reorderLegends(ids);
                  },
                  children: [
                    for (int i = 0; i < legends.length; i++)
                      _buildLegendTile(
                        key: ValueKey(legends[i].id),
                        legend: legends[i],
                        index: i,
                        lang: lang,
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.sectionBorder, height: 1),
            const SizedBox(height: 16),

            // Color palette picker
            _buildPalettePicker(),

            const SizedBox(height: 12),

            // Add new legend
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _labelController,
                    style: AppFonts.dot(
                      fontSize: 13,
                      color: AppColors.inputText,
                    ),
                    decoration: InputDecoration(
                      hintText: lang.t('tracker.legendPlaceholder'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final label = _labelController.text.trim();
                    if (label.isEmpty) return;
                    await legendsProv.createLegend(_selectedColor, label);
                    _labelController.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.btnAdd,
                      border: Border.all(color: AppColors.btnAddBorder),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lang.t('common.add'),
                      style: AppFonts.pixel(
                        fontSize: 11,
                        color: AppColors.btnAddText,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Close button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                lang.t('settings.back'),
                style: AppFonts.pixel(
                  fontSize: 12,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendTile({
    required Key key,
    required dynamic legend,
    required int index,
    required LanguageProvider lang,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.drag_handle, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _parseHex(legend.color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              legend.label,
              style: AppFonts.dot(fontSize: 13, color: AppColors.text),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: lang.t('common.delete'),
                message: lang.t('tracker.deleteLegendConfirm'),
                confirmLabel: lang.t('common.delete'),
                cancelLabel: lang.t('common.cancel'),
                destructive: true,
              );
              if (confirmed == true) {
                final prov = context.read<LegendsProvider>();
                await prov.deleteLegend(legend.id);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 16,
                color: AppColors.btnResetText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalettePicker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: AppTheme.defaultPalette.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((hex) {
              final isSelected = _selectedColor == hex;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = hex),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _parseHex(hex),
                    border: isSelected
                        ? Border.all(color: AppColors.accent, width: 2.5)
                        : Border.all(
                            color: AppColors.dotBorder,
                            width: 0.5,
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
