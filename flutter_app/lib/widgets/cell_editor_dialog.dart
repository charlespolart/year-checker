import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/legend_model.dart';
import '../providers/cells_provider.dart';
import '../providers/language_provider.dart';
import '../providers/legends_provider.dart';
import '../theme/app_theme.dart';

/// Dialog displayed when tapping a cell in the tracker grid.
///
/// Shows the date, legend selection, optional comment, and confirm/delete.
class CellEditorDialog extends StatefulWidget {
  final int month;
  final int day;
  final int year;

  const CellEditorDialog({
    super.key,
    required this.month,
    required this.day,
    required this.year,
  });

  static Future<void> show(
    BuildContext context, {
    required int month,
    required int day,
    required int year,
  }) {
    return showDialog(
      context: context,
      builder: (_) => CellEditorDialog(month: month, day: day, year: year),
    );
  }

  @override
  State<CellEditorDialog> createState() => _CellEditorDialogState();
}

class _CellEditorDialogState extends State<CellEditorDialog> {
  late int _month;
  late int _day;
  final _commentController = TextEditingController();
  String? _selectedColor;

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _month = widget.month;
    _day = widget.day;
    _loadCellData();
  }

  void _loadCellData() {
    final cells = context.read<CellsProvider>();
    final cell = cells.getCell(_month, _day);
    if (cell != null) {
      _selectedColor = cell.color;
      _commentController.text = cell.comment ?? '';
    } else {
      _selectedColor = null;
      _commentController.text = '';
    }
  }

  void _navigateDay(int delta) {
    setState(() {
      _day += delta;
      if (_day < 1) {
        _month -= 1;
        if (_month < 1) {
          _month = 12;
        }
        _day = 31;
      } else if (_day > 31) {
        _month += 1;
        if (_month > 12) {
          _month = 1;
        }
        _day = 1;
      }
      _loadCellData();
    });
  }

  Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final legends = context.watch<LegendsProvider>().legends;

    return Dialog(
      backgroundColor: AppColors.shell,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.shellBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _navigateDay(-1),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '<',
                      style: AppFonts.pixel(
                        fontSize: 16,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$_day ${_monthNames[_month - 1]} ${widget.year}',
                  style: AppFonts.pixel(fontSize: 14, color: AppColors.title),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _navigateDay(1),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '>',
                      style: AppFonts.pixel(
                        fontSize: 16,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Legend selection
            if (legends.isEmpty)
              Text(
                lang.t('tracker.noLegends'),
                style: AppFonts.dot(fontSize: 13, color: AppColors.textMuted),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: legends.map((legend) {
                      return _buildLegendRow(legend);
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Comment field
            TextField(
              controller: _commentController,
              maxLength: 200,
              maxLines: 2,
              style: AppFonts.dot(fontSize: 13, color: AppColors.inputText),
              decoration: InputDecoration(
                hintText: 'Comment...',
                hintStyle: AppFonts.dot(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                counterStyle: AppFonts.dot(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Delete button
                GestureDetector(
                  onTap: () async {
                    final cells = context.read<CellsProvider>();
                    await cells.deleteCell(_month, _day);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.btnReset,
                      border: Border.all(color: AppColors.btnResetBorder),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lang.t('common.delete'),
                      style: AppFonts.pixel(
                        fontSize: 12,
                        color: AppColors.btnResetText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Confirm button
                GestureDetector(
                  onTap: () async {
                    if (_selectedColor == null) return;
                    final cells = context.read<CellsProvider>();
                    final comment = _commentController.text.trim();
                    await cells.setCell(
                      _month,
                      _day,
                      _selectedColor!,
                      comment: comment.isNotEmpty ? comment : null,
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.btnAdd,
                      border: Border.all(color: AppColors.btnAddBorder),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'OK',
                      style: AppFonts.pixel(
                        fontSize: 12,
                        color: AppColors.btnAddText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow(LegendModel legend) {
    final selected = _selectedColor == legend.color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = legend.color;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.screen : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.screenBorder,
            width: selected ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
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
          ],
        ),
      ),
    );
  }
}
