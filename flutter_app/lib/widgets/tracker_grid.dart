import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The year grid widget: 12 months x 31 days of colored dots.
///
/// [dotSize] controls the diameter of each dot.
/// [getCellColor] returns a hex color for the given (month, day) or `null`.
/// [onCellPress] is called when a dot is tapped.
class TrackerGrid extends StatelessWidget {
  final double dotSize;
  final String? Function(int month, int day) getCellColor;
  final void Function(int month, int day) onCellPress;

  const TrackerGrid({
    super.key,
    required this.dotSize,
    required this.getCellColor,
    required this.onCellPress,
  });

  static const List<String> _monthLabels = [
    'J', 'F', 'M', 'A', 'M', 'J',
    'J', 'A', 'S', 'O', 'N', 'D',
  ];

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
    final gap = (dotSize * 0.25).clamp(1.0, 4.0);
    final labelSize = (dotSize * 0.7).clamp(6.0, 11.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month headers row
        Row(
          children: [
            // Spacer for day label column
            SizedBox(width: dotSize + gap),
            ...List.generate(12, (m) {
              return SizedBox(
                width: dotSize + gap,
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
        SizedBox(height: gap),
        // Day rows (1..31)
        ...List.generate(31, (dayIdx) {
          final day = dayIdx + 1;
          return Padding(
            padding: EdgeInsets.only(bottom: gap),
            child: Row(
              children: [
                // Day label
                SizedBox(
                  width: dotSize + gap,
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
                // Month cells for this day
                ...List.generate(12, (mIdx) {
                  final month = mIdx + 1;
                  final color = getCellColor(month, day);
                  final valid = day <= 31; // always render the slot

                  return Padding(
                    padding: EdgeInsets.only(right: gap),
                    child: GestureDetector(
                      onTap: valid ? () => onCellPress(month, day) : null,
                      child: Container(
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
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
