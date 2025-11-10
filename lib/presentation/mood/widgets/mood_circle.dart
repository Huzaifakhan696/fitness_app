import 'package:flutter/material.dart';
import 'dart:math' as math;

class MoodCircle extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final ValueChanged<double> onChanged;
  final double size;

  const MoodCircle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 300,
  });

  @override
  State<MoodCircle> createState() => _MoodCircleState();
}

class _MoodCircleState extends State<MoodCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        final center = Offset(
          renderBox.size.width / 2,
          renderBox.size.height / 2,
        );
        final position = renderBox.globalToLocal(details.globalPosition);
        final angle = math.atan2(
          position.dy - center.dy,
          position.dx - center.dx,
        );

        // Convert angle to 0-1 range
        double normalizedAngle = (angle + math.pi) / (2 * math.pi);
        // Adjust so top is 0
        normalizedAngle = (normalizedAngle + 0.75) % 1.0;

        widget.onChanged(normalizedAngle);
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: MoodCirclePainter(value: widget.value),
      ),
    );
  }
}

class MoodCirclePainter extends CustomPainter {
  final double value;

  MoodCirclePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 40.0;

    // Draw gradient circle segments
    final segments = 4;
    final colors = [
      const Color(0xFF6EB9AD), // #6EB9AD
      const Color(0xFFC9BBEF), // #C9BBEF
      const Color(0xFFF28DB3), // #F28DB3
      const Color(0xFFF99955), // #F99955
    ];

    final sweepAngle = (2 * math.pi) / segments;
    final blendAngle = 0.2; // Angle for blending at boundaries (in radians)

    // Draw each colored segment with blending at boundaries
    for (int i = 0; i < segments; i++) {
      final startAngle = -math.pi / 2 + (i * sweepAngle);
      final nextColorIndex = (i + 1) % segments;

      // Draw main segment (slightly reduced to make room for blending)
      final mainStartAngle = startAngle + blendAngle / 2;
      final mainSweepAngle = sweepAngle - blendAngle;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        mainStartAngle,
        mainSweepAngle,
        false,
        paint,
      );

      // Draw blended transition at the end of this segment (blending to next color)
      final blendSteps = 10;
      for (int j = 0; j < blendSteps; j++) {
        final blendFactor = j / blendSteps;
        final blendedColor = Color.lerp(
          colors[i],
          colors[nextColorIndex],
          blendFactor,
        )!;
        final blendStartAngle =
            startAngle +
            sweepAngle -
            blendAngle / 2 +
            (j * blendAngle / blendSteps);
        final blendSweepAngle = blendAngle / blendSteps;

        final blendPaint = Paint()
          ..color = blendedColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          blendStartAngle,
          blendSweepAngle,
          false,
          blendPaint,
        );
      }
    }

    // Draw light greyish divider lines at short intervals throughout the complete circle
    final linePaint = Paint()
      ..color = Colors
          .grey
          .shade400 // Light greyish
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5; // Less thick

    // Number of divider lines
    final numberOfLines = 12; // 12 lines
    final lineAngleStep = (2 * math.pi) / numberOfLines;
    final tiltAngle = 0.08; // Lighter tilt angle in radians (~4.6 degrees)

    for (int i = 0; i < numberOfLines; i++) {
      final baseAngle = -math.pi / 2 + (i * lineAngleStep);
      // Apply slight tilt to the line
      final startAngle = baseAngle - tiltAngle;
      final endAngle = baseAngle + tiltAngle;

      final startX =
          center.dx + (radius - strokeWidth / 2) * math.cos(startAngle);
      final startY =
          center.dy + (radius - strokeWidth / 2) * math.sin(startAngle);
      final endX = center.dx + (radius + strokeWidth / 2) * math.cos(endAngle);
      final endY = center.dy + (radius + strokeWidth / 2) * math.sin(endAngle);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);
    }

    // Face removed - image will be displayed in center via Stack in parent widget

    // Draw draggable indicator (complete white circle)
    final indicatorAngle = -math.pi / 2 + (value * 2 * math.pi);
    final indicatorX = center.dx + radius * math.cos(indicatorAngle);
    final indicatorY = center.dy + radius * math.sin(indicatorAngle);

    // White circle
    final indicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(indicatorX, indicatorY), 25, indicatorPaint);
  }

  @override
  bool shouldRepaint(MoodCirclePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
