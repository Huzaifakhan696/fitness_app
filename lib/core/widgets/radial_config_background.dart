import 'dart:ui';
import 'package:flutter/material.dart';

class RadialCircleConfig {
  final List<Color> colors;
  final List<double>? stops;
  final Offset position;
  final double diameter;
  final double blurSigma;
  final Alignment center;
  final double radius;

  const RadialCircleConfig({
    required this.colors,
    required this.position,
    this.stops,
    this.diameter = 600,
    this.blurSigma = 40,
    this.center = Alignment.center,
    this.radius = 0.5,
  });
}

class CustomRadialBackground extends StatelessWidget {
  final RadialCircleConfig circle1;
  final RadialCircleConfig? circle2;
  final Widget child;

  const CustomRadialBackground({
    super.key,
    required this.circle1,
    this.circle2,
    required this.child,
  });

  Widget _buildBlurredCircle(RadialCircleConfig config) {
    return Positioned(
      left: config.position.dx,
      top: config.position.dy,
      child: SizedBox(
        width: config.diameter,
        height: config.diameter,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: config.blurSigma,
            sigmaY: config.blurSigma,
          ),
          child: Opacity(
            opacity: 1.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: config.center,
                  radius: config.radius,
                  colors: config.colors,
                  stops: config.stops,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          _buildBlurredCircle(circle1),
          if (circle2 != null) _buildBlurredCircle(circle2!),
          child,
        ],
      ),
    );
  }
}
