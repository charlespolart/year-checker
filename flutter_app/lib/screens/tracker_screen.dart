import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/page_model.dart';
import '../providers/cells_provider.dart';
import '../providers/language_provider.dart';
import '../providers/legends_provider.dart';
import '../providers/pages_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cell_editor_dialog.dart';
import '../widgets/legend_editor_dialog.dart';
import '../widgets/tracker_grid.dart';

class TrackerScreen extends StatefulWidget {
  final String pageId;
  final VoidCallback onBack;
  final VoidCallback onOpenSettings;

  const TrackerScreen({
    super.key,
    required this.pageId,
    required this.onBack,
    required this.onOpenSettings,
  });

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  bool _editingTitle = false;
  late TextEditingController _titleController;

  PageModel get _page {
    final pages = context.read<PagesProvider>().pages;
    return pages.firstWhere((p) => p.id == widget.pageId);
  }

  @override
  void initState() {
    super.initState();
    final pages = context.read<PagesProvider>().pages;
    final page = pages.firstWhere((p) => p.id == widget.pageId);
    _titleController = TextEditingController(text: page.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTitle() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isNotEmpty && newTitle != _page.title) {
      context.read<PagesProvider>().updatePage(_page.id, {'title': newTitle});
    }
    setState(() => _editingTitle = false);
  }

  Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final cellsProv = context.watch<CellsProvider>();
    final legends = context.watch<LegendsProvider>().legends;

    // Stats calculation
    final filledDays = cellsProv.cells.length;
    final streak = _calculateStreak(cellsProv);
    final daysInYear = _isLeapYear(_page.year) ? 366 : 365;
    final yearPercent =
        daysInYear > 0 ? (filledDays / daysInYear * 100).round() : 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '<',
                        style: AppFonts.pixel(
                          fontSize: 20,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _editingTitle
                        ? TextField(
                            controller: _titleController,
                            autofocus: true,
                            style: AppFonts.pixel(
                              fontSize: 16,
                              color: AppColors.title,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (_) => _saveTitle(),
                            onTapOutside: (_) => _saveTitle(),
                          )
                        : GestureDetector(
                            onTap: () =>
                                setState(() => _editingTitle = true),
                            child: Text(
                              _page.title,
                              style: AppFonts.pixel(
                                fontSize: 16,
                                color: AppColors.title,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ),
                  Text(
                    '${_page.year}',
                    style: AppFonts.pixel(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Book shell
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.shell,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.shellBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.screen,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.screenBorder,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Sidebar: legends + stats + edit button
                          _buildSidebar(
                            lang: lang,
                            legends: legends,
                            filledDays: filledDays,
                            streak: streak,
                            yearPercent: yearPercent,
                          ),

                          // Vertical divider
                          Container(
                            width: 1,
                            color: AppColors.screenBorder,
                          ),

                          // Grid
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate dot size to fit 13 columns (1 label + 12 months)
                                // and 32 rows (1 header + 31 days) in the available space.
                                final availableWidth = constraints.maxWidth;
                                final availableHeight = constraints.maxHeight;
                                final dotFromWidth = availableWidth / 14.5;
                                final dotFromHeight = availableHeight / 34.5;
                                final dotSize =
                                    dotFromWidth < dotFromHeight
                                        ? dotFromWidth
                                        : dotFromHeight;

                                return Center(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: TrackerGrid(
                                        dotSize: dotSize.clamp(4.0, 18.0),
                                        getCellColor: (month, day) =>
                                            cellsProv.getCellColor(
                                                month, day),
                                        onCellPress: (month, day) {
                                          CellEditorDialog.show(
                                            context,
                                            month: month,
                                            day: day,
                                            year: _page.year,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar({
    required LanguageProvider lang,
    required List legends,
    required int filledDays,
    required int streak,
    required int yearPercent,
  }) {
    return SizedBox(
      width: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Column(
          children: [
            // Legends label
            Text(
              lang.t('tracker.legend'),
              style: AppFonts.pixel(
                fontSize: 8,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),

            // Legend dots
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: legends.map<Widget>((legend) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _parseHex(legend.color),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              legend.label,
                              style: AppFonts.dot(
                                fontSize: 8,
                                color: AppColors.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Stats
            Text(
              lang.t('tracker.stats'),
              style: AppFonts.pixel(
                fontSize: 8,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            _buildStat('$filledDays', lang.t('tracker.statDays')),
            _buildStat('$streak', lang.t('tracker.statStreak')),
            _buildStat('$yearPercent%', lang.t('tracker.statYear')),

            const SizedBox(height: 8),

            // Edit legends button
            GestureDetector(
              onTap: () {
                LegendEditorDialog.show(context, pageId: _page.id);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  border: Border.all(color: AppColors.inputBorder),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  lang.t('tracker.editLegends'),
                  style: AppFonts.pixel(
                    fontSize: 8,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Column(
        children: [
          Text(
            value,
            style: AppFonts.pixel(fontSize: 11, color: AppColors.title),
          ),
          Text(
            label,
            style: AppFonts.dot(fontSize: 7, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  int _calculateStreak(CellsProvider cellsProv) {
    // Calculate current streak ending today (or the most recent filled day)
    final now = DateTime.now();
    int streak = 0;
    DateTime check = DateTime(now.year, now.month, now.day);

    // Only calculate streak for the page's year
    if (check.year != _page.year) {
      check = DateTime(_page.year, 12, 31);
    }

    while (check.year == _page.year) {
      final cell = cellsProv.getCell(check.month, check.day);
      if (cell != null) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        // If today has no cell, try starting from yesterday
        if (streak == 0) {
          check = check.subtract(const Duration(days: 1));
          final prevCell = cellsProv.getCell(check.month, check.day);
          if (prevCell != null) {
            streak++;
            check = check.subtract(const Duration(days: 1));
            continue;
          }
        }
        break;
      }
    }

    return streak;
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
