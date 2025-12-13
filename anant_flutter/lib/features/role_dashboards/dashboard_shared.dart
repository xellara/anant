import 'dart:math';
import 'package:flutter/material.dart';

// Dark banner painter.
class HomeBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFF1E293B);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final Offset center = const Offset(0, 0);
    final List<Color> circleColors = [
      const Color(0xFF335762), // Darker variant
      const Color(0xFF3C6673), // Base color
      const Color(0xFF457584), // Lighter variant
      const Color(0xFF4E8596), // Even lighter variant
    ];

    double radius = size.width * 1.2;
    for (int i = 0; i < circleColors.length; i++) {
      paint.color = circleColors[i].withValues(alpha: 0.6);
      final rect = Rect.fromCircle(center: center, radius: radius);
      const double startAngle = -0.5;
      const double sweepAngle = 2.5;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      radius *= 0.709;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Twinkling Stars Widget.
class TwinklingStarsWidget extends StatefulWidget {
  const TwinklingStarsWidget({super.key});

  @override
  State<TwinklingStarsWidget> createState() => _TwinklingStarsWidgetState();
}

class _TwinklingStarsWidgetState extends State<TwinklingStarsWidget>
    with TickerProviderStateMixin {
  static const int starCount = 10;
  final Random _random = Random();

  // Store star positions & sizes.
  final List<Offset> _starPositions = [];
  final List<double> _starSizes = [];
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(starCount, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200 + _random.nextInt(1200)),
      )..repeat(reverse: true);
      return controller;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_starPositions.isEmpty) {
          _generateStars(constraints.maxWidth, constraints.maxHeight);
        }

        return Stack(
          children: List.generate(starCount, (i) {
            return Positioned(
              left: _starPositions[i].dx,
              top: _starPositions[i].dy,
              child: AnimatedBuilder(
                animation: _controllers[i],
                builder: (context, child) {
                  final opacity = _controllers[i].value;
                  return Opacity(
                    opacity: opacity,
                    child: SizedBox(
                      width: _starSizes[i],
                      height: _starSizes[i],
                      child: CustomStarWidget(
                        size: _starSizes[i],
                        color: Colors.white.withValues(alpha: opacity),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  void _generateStars(double maxWidth, double maxHeight) {
    for (int i = 0; i < starCount; i++) {
      final dx = _random.nextDouble() * maxWidth;
      final dy = _random.nextDouble() * maxHeight;
      _starPositions.add(Offset(dx, dy));
      _starSizes.add(_random.nextDouble() * 12 + 3);
    }
  }
}

// Helper widget to paint a star.
class CustomStarWidget extends StatelessWidget {
  final double size;
  final Color color;

  const CustomStarWidget({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(color),
      size: Size(size, size),
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const double angle = pi / 5;

    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      double x = centerX + radius * cos(i * 2 * angle);
      double y = centerY + radius * sin(i * 2 * angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      x = centerX + (radius / 2) * cos((i * 2 + 1) * angle);
      y = centerY + (radius / 2) * sin((i * 2 + 1) * angle);
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => false;
}
