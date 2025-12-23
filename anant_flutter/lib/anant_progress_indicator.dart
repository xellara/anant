import 'dart:ui';
import 'package:flutter/material.dart';

class InfinityPainter extends CustomPainter {
  InfinityPainter({
    required this.progress,
    required this.infinitiesLength,
  });

  final double progress;
  final int infinitiesLength;
  late double width;
  late double height;

  // Beautiful ocean to sunset gradient
  final colors = const [
    Color(0xFF0EA5E9), // Ocean blue
    Color(0xFF2563EB), // Royal blue
    Color(0xFF7C3AED), // Deep purple
    Color(0xFF14B8A6), // Teal
    Color(0xFF059669), // Emerald
    Color(0xFFD97706), // Golden orange
  ];


  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;

    for (int i = 0; i < infinitiesLength; i++) {
      _drawInfinitySymbols(
        canvas,
        color: colors[i % colors.length],
        index: i,
        strokeWidth: 1,
      );
    }
  }

  void _drawInfinitySymbols(
    Canvas canvas, {
    Color color = Colors.blueAccent,
    double strokeWidth = 1,
    int index = 0,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final path = _getInfinityPath(strokeWidth, index);
    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath = pathMetric.extractPath(
      (pathMetric.length * progress) / 2,
      (pathMetric.length * progress),
    );

    canvas.drawPath(extractPath, paint);
  }

  Path _getInfinityPath(double strokeWidth, int index) {
    final sw = strokeWidth * 1.5;

    final originX = width / 2 + (sw * index);
    final originY = height / 2;

    return Path()
      ..moveTo(originX, originY)
      ..cubicTo(
        0 - (sw * index) * 1.2, //x1
        0 - (sw * index) * 2, //y1
        0 - (sw * index) * 1.2, //x2
        height + (sw * index) * 2, //y2
        originX, //x3
        originY, //y3
      )
      ..cubicTo(
        width + width / 3 - (sw * index * 1.2), //x1
        0 - height / 3 + (sw * index * 2), //y1
        width + width / 3 - (sw * index * 1.2), //x2
        height + height / 3 - (sw * index * 2), //y2
        originX, //x3
        originY, //y3
      )
      ..cubicTo(
        0 - (sw * index) * 1.2, //x1
        0 - (sw * index) * 2, //y1
        0 - (sw * index) * 1.2, //x2
        height + (sw * index) * 2, //y2
        originX, //x3
        originY, //y3
      )
      ..cubicTo(
        width + width / 3 - (sw * index * 1.2), //x1
        0 - height / 3 + (sw * index * 2), //y1
        width + width / 3 - (sw * index * 1.2), //x2
        height + height / 3 - (sw * index * 2), //y2
        originX, //x3
        originY, //y3
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class AnantProgressIndicator extends StatefulWidget {
  final bool showBackground;
  
  const AnantProgressIndicator({
    super.key,
    this.showBackground = false, // Default: transparent for in-app use
  });

  @override
  State<AnantProgressIndicator> createState() => _AnantProgressIndicatorState();
}

class _AnantProgressIndicatorState extends State<AnantProgressIndicator>
    with SingleTickerProviderStateMixin {
  int infinitiesLength = 9;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.showBackground 
          ? Colors.white // Opaque white background for splash
          : Colors.transparent, // Transparent for in-app loading
      body: Container(
        decoration: widget.showBackground ? BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.teal.shade50,
            ],
          ),
        ) : null,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(60, 60),
                painter: InfinityPainter(
                  progress: _controller.value,
                  infinitiesLength: infinitiesLength,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}