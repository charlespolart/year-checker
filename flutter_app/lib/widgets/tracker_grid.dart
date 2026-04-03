import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The year grid widget: 12 months x 31 days of colored dots.
///
/// Fills all available space, using the constraining axis (width or height)
/// to determine the cell size.
class TrackerGrid extends StatelessWidget {
  final int year;
  final String? Function(int month, int day) getCellColor;
  final void Function(int month, int day) onCellPress;

  const TrackerGrid({
    super.key,
    required this.year,
    required this.getCellColor,
    required this.onCellPress,
  });

  static const List<String> _monthLabels = [
    'J', 'F', 'M', 'A', 'M', 'J',
    'J', 'A', 'S', 'O', 'N', 'D',
  ];

  static const int _cols = 13; // 1 label + 12 months
  static const int _rows = 32; // 1 header + 31 days

  static int getDaysInMonth(int month, int year) {
    if (month == 2) {
      final isLeap =
          (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeap ? 29 : 28;
    }
    if ([4, 6, 9, 11].contains(month)) return 30;
    return 31;
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Each cell = dotSize + gap. We pick the axis that constrains us.
        final hasW = constraints.maxWidth.isFinite;
        final hasH = constraints.maxHeight.isFinite;
        final cellW = hasW ? constraints.maxWidth / _cols : double.infinity;
        final cellH = hasH ? constraints.maxHeight / _rows : double.infinity;
        final cellSize = cellW < cellH ? cellW : cellH;
        final dotSize = cellSize * 0.78;
        final labelSize = (dotSize * 0.65).clamp(6.0, 12.0);

        // Total grid size
        final gridW = cellSize * _cols;
        final gridH = cellSize * _rows;

        return SizedBox(
          width: gridW,
          height: gridH,
          child: Column(
            children: [
              // Month headers row
              SizedBox(
                height: cellSize,
                child: Row(
                  children: [
                    SizedBox(width: cellSize),
                    ...List.generate(12, (m) {
                      return SizedBox(
                        width: cellSize,
                        child: Center(
                          child: Text(
                            _monthLabels[m],
                            style: AppFonts.pixel(
                              fontSize: labelSize,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Day rows (1..31)
              ...List.generate(31, (dayIdx) {
                final day = dayIdx + 1;
                return SizedBox(
                  height: cellSize,
                  child: Row(
                    children: [
                      // Day label
                      SizedBox(
                        width: cellSize,
                        child: Center(
                          child: Text(
                            '$day',
                            style: AppFonts.pixel(
                              fontSize: labelSize,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      // Month cells
                      ...List.generate(12, (mIdx) {
                        final month = mIdx + 1;
                        final maxDays = getDaysInMonth(month, year);
                        final valid = day <= maxDays;
                        final color = valid ? getCellColor(month, day) : null;

                        return SizedBox(
                          width: cellSize,
                          height: cellSize,
                          child: Center(
                            child: GestureDetector(
                              onTap: valid ? () => onCellPress(month, day) : null,
                              child: valid
                                  ? Container(
                                      width: dotSize,
                                      height: dotSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color != null
                                            ? _parseColor(color)
                                            : AppColors.dotEmpty,
                                        border: color == null
                                            ? Border.all(
                                                color: AppColors.dotBorder,
                                                width: 0.5,
                                              )
                                            : null,
                                      ),
                                    )
                                  : SizedBox(width: dotSize, height: dotSize),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
