import 'package:flutter/material.dart';

/// Paints a dashed rounded rectangle border around its child.
class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;
  final EdgeInsets padding;

  const DashedBorder({
    super.key,
    required this.child,
    this.color = const Color(0xFFD0C8B0),
    this.strokeWidth = 1.0,
    this.dashLength = 4.0,
    this.gapLength = 3.0,
    this.borderRadius = 0.0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
        borderRadius: borderRadius,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0.0, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.dashLength != dashLength ||
      old.gapLength != gapLength ||
      old.borderRadius != borderRadius;
}

/// Paints a dashed vertical line.
class DashedVerticalDivider extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  const DashedVerticalDivider({
    super.key,
    this.color = const Color(0xFFD0C8B0),
    this.strokeWidth = 1.0,
    this.dashLength = 4.0,
    this.gapLength = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: strokeWidth,
      child: CustomPaint(
        painter: _DashedVerticalPainter(
          color: color,
          strokeWidth: strokeWidth,
          dashLength: dashLength,
          gapLength: gapLength,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DashedVerticalPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedVerticalPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double y = 0;
    while (y < size.height) {
      final end = (y + dashLength).clamp(0.0, size.height);
      canvas.drawLine(Offset(0, y), Offset(0, end), paint);
      y += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(_DashedVerticalPainter old) =>
      old.color != color || old.dashLength != dashLength;
}
