import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage>
    with SingleTickerProviderStateMixin {
  // Start with center alignment.
  Alignment _alignment = Alignment.center;
  final Random _random = Random();
  late Timer _timer;

  // Animation controller and tween for the border width.
  late AnimationController _controller;
  late Animation<double> _borderWidthAnimation;

  // Bubble gradient.
  late Gradient _bubbleGradient;

  /// Generates a random dark gradient ensuring white text is visible.
  Gradient _generateRandomGradient() {
    double hue = _random.nextDouble() * 360;
    final HSLColor color1 = HSLColor.fromAHSL(1.0, hue, 0.6, 0.3);
    final HSLColor color2 = HSLColor.fromAHSL(1.0, hue, 0.6, 0.2);
    return RadialGradient(
      center: const Alignment(-0.5, -0.6),
      radius: 0.8,
      colors: [color1.toColor(), color2.toColor()],
      stops: const [0.3, 1.0],
    );
  }

  @override
  void initState() {
    super.initState();

    // Always start at center with an initial gradient.
    _alignment = Alignment.center;
    _bubbleGradient = _generateRandomGradient();

    // Setup border animation.
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _borderWidthAnimation =
        Tween<double>(begin: 2.0, end: 5.0).animate(_controller);

    // Timer to update bubble position and gradient every 3 seconds.
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _alignment = Alignment(
          _random.nextDouble() * 2 - 1,
          _random.nextDouble() * 2 - 1,
        );
        _bubbleGradient = _generateRandomGradient();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark background highlights the bubble.
      backgroundColor: Colors.black,
      body: AnimatedAlign(
        alignment: _alignment,
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
        child: AnimatedBuilder(
          animation: _borderWidthAnimation,
          builder: (context, child) {
            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _bubbleGradient,
                border: Border.all(
                  color: Colors.white,
                  width: _borderWidthAnimation.value,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.6),
                    offset: const Offset(5, 5),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Coming Soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
