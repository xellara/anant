import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// -------------------------
// Animation Widgets
// -------------------------

class EntranceFader extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  const EntranceFader({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 800),
    this.offset = const Offset(0.0, 30.0),
  });

  @override
  State<EntranceFader> createState() => _EntranceFaderState();
}

class _EntranceFaderState extends State<EntranceFader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _translate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _translate = Tween<Offset>(begin: widget.offset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(
          offset: _translate.value,
          child: widget.child,
        ),
      ),
    );
  }
}

class BreathingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const BreathingWidget({super.key, required this.child, this.duration = const Duration(seconds: 4)});

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: widget.child,
      ),
    );
  }
}

// -------------------------
// New Attractive Animations
// -------------------------

class ParticleEffectWidget extends StatefulWidget {
  final int numberOfParticles;
  final Color color;
  final Size size;

  const ParticleEffectWidget({
    super.key,
    this.numberOfParticles = 15,
    this.color = Colors.white,
    required this.size,
  });

  @override
  State<ParticleEffectWidget> createState() => _ParticleEffectWidgetState();
}

class _Particle {
  late double x;
  late double y;
  late double size;
  late double speedX;
  late double speedY;
  late double opacity;

  _Particle(Size screenSize) {
    reset(screenSize, randomY: true);
  }

  void reset(Size screenSize, {bool randomY = false}) {
    x = (DateTime.now().microsecondsSinceEpoch % 1000) / 1000 * screenSize.width;
    y = randomY 
      ? (DateTime.now().microsecondsSinceEpoch % 1000) / 1000 * screenSize.height
      : screenSize.height + 10;
    size = (DateTime.now().microsecondsSinceEpoch % 5 + 2).toDouble();
    speedX = (DateTime.now().microsecondsSinceEpoch % 10 - 5) / 20;
    speedY = -(DateTime.now().microsecondsSinceEpoch % 10 + 5) / 20;
    opacity = (DateTime.now().microsecondsSinceEpoch % 50 + 20) / 100;
  }
}

class _ParticleEffectWidgetState extends State<ParticleEffectWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _controller.addListener(_updateParticles);
    
    // Initialize particles
    for (int i = 0; i < widget.numberOfParticles; i++) {
        _particles.add(_Particle(widget.size));
    }
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.y += particle.speedY;
      particle.x += particle.speedX;

      if (particle.y < -10) {
        particle.y = widget.size.height + 10;
        particle.x = _random.nextDouble() * widget.size.width;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: _ParticlePainter(_particles, widget.color),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;

  _ParticlePainter(this.particles, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var particle in particles) {
      paint.color = color.withOpacity(particle.opacity);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  const ShimmerEffect({super.key, required this.child});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(_controller.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double percent;
  const _SlidingGradientTransform(this.percent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (percent * 3 - 1), 0, 0);
  }
}

class FloatingSchoolIconsWidget extends StatefulWidget {
  final Size size;
  final int numberOfIcons;

  const FloatingSchoolIconsWidget({
    super.key,
    required this.size,
    this.numberOfIcons = 12,
  });

  @override
  State<FloatingSchoolIconsWidget> createState() => _FloatingSchoolIconsWidgetState();
}

class _FloatingIcon {
  late double x;
  late double y;
  late double size;
  late double speed;
  late String icon;
  late double opacity;
  late double rotation;
  late double rotationSpeed;

  final List<String> icons = ['🎓', '📚', '✏️', '🏆', '💡', '🚀', '✨', '🎨', '⚽', '🔬'];

  _FloatingIcon(Size screenSize) {
    reset(screenSize, randomY: true);
  }

  void reset(Size screenSize, {bool randomY = false}) {
    final random = Random();
    x = random.nextDouble() * screenSize.width;
    y = randomY 
      ? random.nextDouble() * screenSize.height 
      : screenSize.height + 50;
    size = random.nextDouble() * 20 + 15; // Size between 15 and 35
    speed = random.nextDouble() * 1.5 + 0.5;
    icon = icons[random.nextInt(icons.length)];
    opacity = random.nextDouble() * 0.3 + 0.1; // Low opacity for background
    rotation = random.nextDouble() * 2 * pi;
    rotationSpeed = (random.nextDouble() - 0.5) * 0.05;
  }
}

class _FloatingSchoolIconsWidgetState extends State<FloatingSchoolIconsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FloatingIcon> _icons = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _controller.addListener(_updateIcons);
    
    for (int i = 0; i < widget.numberOfIcons; i++) {
        _icons.add(_FloatingIcon(widget.size));
    }
  }

  void _updateIcons() {
    for (var icon in _icons) {
      icon.y -= icon.speed; // Move up
      icon.rotation += icon.rotationSpeed;

      if (icon.y < -50) {
        icon.reset(widget.size);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _icons.map((icon) {
        return Positioned(
          left: icon.x,
          top: icon.y,
          child: Transform.rotate(
            angle: icon.rotation,
            child: Opacity(
              opacity: icon.opacity,
              child: Text(
                icon.icon,
                style: TextStyle(
                  fontSize: icon.size,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MagicalKnowledgeWorldWidget extends StatefulWidget {
  final Size size;

  const MagicalKnowledgeWorldWidget({super.key, required this.size});

  @override
  State<MagicalKnowledgeWorldWidget> createState() => _MagicalKnowledgeWorldWidgetState();
}

class _MagicalKnowledgeWorldWidgetState extends State<MagicalKnowledgeWorldWidget> with TickerProviderStateMixin {
  late AnimationController _mainController;
  final List<_KnowledgeBubble> _bubbles = [];

  // Dream Planets
  final List<_DreamPlanet> _planets = [];
  
  // Shooting Star
  late AnimationController _starController;
  late Animation<double> _starAnimation;
  Offset _starStart = Offset.zero;
  Offset _starEnd = Offset.zero;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _mainController.addListener(_updateWorld);

    // Initialize Popping Bubbles & Planets in didChangeDependencies to access Theme
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_planets.isEmpty) {
       final theme = Theme.of(context);
       // Initialize Popping Bubbles
       for (int i = 0; i < 12; i++) {
          _bubbles.add(_KnowledgeBubble(widget.size));
       }

       // Initialize Dream Planets with Theme Colors
       _planets.add(_DreamPlanet(widget.size, theme.primaryColor.withOpacity(0.3), 60)); 
       _planets.add(_DreamPlanet(widget.size, theme.colorScheme.secondary.withOpacity(0.3), 80));
       _planets.add(_DreamPlanet(widget.size, theme.primaryColor.withOpacity(0.2), 50));
       _planets.add(_DreamPlanet(widget.size, theme.colorScheme.secondary.withOpacity(0.2), 70));
    }

    // Shooting Star Setup
    _starController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _starAnimation = CurvedAnimation(parent: _starController, curve: Curves.easeOut);
    _starController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _resetStar();
        Future.delayed(Duration(seconds: Random().nextInt(5) + 3), () {
            if(mounted) _starController.forward(from: 0);
        });
      }
    });
    _resetStar();
    _starController.forward();
  }

  void _resetStar() {
    final random = Random();
    // Start from top-left area
    _starStart = Offset(random.nextDouble() * widget.size.width * 0.5, -50);
    // End in bottom-right area
    _starEnd = Offset(
      random.nextDouble() * widget.size.width * 0.5 + widget.size.width * 0.5, 
      widget.size.height + 50
    );
  }

  void _updateWorld() {
    // Update Bubbles (Tick their individual lifecycles)
    for (var bubble in _bubbles) {
      bubble.update();
      if (bubble.isDead) {
        bubble.reset(widget.size);
      }
    }
    // Update Planets (Slow Drift)
    for (var planet in _planets) {
      planet.update(widget.size);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _mainController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Dream Planets (Background)
        ..._planets.map((planet) => Positioned(
          left: planet.x,
          top: planet.y,
          child: Container(
            width: planet.size,
            height: planet.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: planet.color.withOpacity(0.3),
              boxShadow: [
                 BoxShadow(color: planet.color.withOpacity(0.2), blurRadius: 30, spreadRadius: 10),
              ],
            ),
          ),
        )),

        // 2. Shooting Star
        AnimatedBuilder(
          animation: _starAnimation,
          builder: (context, child) {
            final val = _starAnimation.value;
            final currentPos = Offset.lerp(_starStart, _starEnd, val)!;
            return Positioned(
              left: currentPos.dx,
              top: currentPos.dy,
              child: Opacity(
                opacity: (1.0 - val).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: pi / 4,
                  child: Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // 3. Popping Knowledge Bubbles (Foreground)
        ..._bubbles.map((bubble) {
          double scale = 1.0;
          double opacity = 0.0;
          
          // Custom fade-in/pop/fade-out logic based on 'life' (0.0 to 1.0)
          if (bubble.life < 0.2) {
             // Fade In & Scale Up
             opacity = bubble.life / 0.2;
             scale = 0.5 + (0.5 * (bubble.life / 0.2));
          } else if (bubble.life > 0.8) {
             // Fade Out
             opacity = (1.0 - bubble.life) / 0.2;
             scale = 1.0 + (0.2 * ((bubble.life - 0.8) / 0.2)); // Slight over-scale
          } else {
             opacity = 1.0;
             scale = 1.0;
          }

          return Positioned(
            left: bubble.x,
            top: bubble.y,
            child: Opacity(
              opacity: opacity * 0.8, // Max opacity
              child: Transform.scale(
                scale: scale,
                child: Text(
                  bubble.text,
                  style: TextStyle(
                    fontSize: bubble.size,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _KnowledgeBubble {
  late double x;
  late double y;
  late String text;
  late double size;
  double life = 0.0; // 0.0 to 1.0
  double lifeSpeed = 0.01;
  
  final List<String> symbols = [
    'A', 'B', 'C', 'a', 'b', 'c', 
    '1', '2', '3', '10', 
    '+', '-', '×', '÷', '=', 
    '?', '!', '★', '♫', '☀', '☁'
  ];

  _KnowledgeBubble(Size screenSize) {
    reset(screenSize, randomLife: true);
  }

  void reset(Size screenSize, {bool randomLife = false}) {
    final rand = Random();
    x = rand.nextDouble() * (screenSize.width - 40);
    y = rand.nextDouble() * (screenSize.height - 40);
    text = symbols[rand.nextInt(symbols.length)];
    size = rand.nextDouble() * 20 + 20; // 20 to 40
    lifeSpeed = rand.nextDouble() * 0.005 + 0.003; // Random speed
    life = randomLife ? rand.nextDouble() : 0.0;
  }

  void update() {
    life += lifeSpeed;
  }

  bool get isDead => life >= 1.0;
}

class _DreamPlanet {
  double x = 0;
  double y = 0;
  double size = 0;
  double speedX = 0;
  double speedY = 0;
  Color color;

  _DreamPlanet(Size screenSize, this.color, double baseSize) {
    final rand = Random();
    size = baseSize + rand.nextDouble() * 30;
    x = rand.nextDouble() * screenSize.width;
    y = rand.nextDouble() * screenSize.height;
    speedX = (rand.nextDouble() - 0.5) * 0.2;
    speedY = (rand.nextDouble() - 0.5) * 0.2;
  }

  void update(Size screenSize) {
    x += speedX;
    y += speedY;

    // Bounce off edges (softly)
    if (x < -50 || x > screenSize.width + 50) speedX *= -1;
    if (y < -50 || y > screenSize.height + 50) speedY *= -1;
  }
}

class SplashScreenQuotesWidget extends StatelessWidget {
  const SplashScreenQuotesWidget({super.key});

  static const List<String> quotes = [
    "Believe you can and you're halfway there. - Theodore Roosevelt",
    "It always seems impossible until it's done. - Nelson Mandela",
    "Keep your face always toward the sunshine—and shadows will fall behind you. - Walt Whitman",
    "The beautiful thing about learning is that no one can take it away from you. - B.B. King",
    "Education is the most powerful weapon which you can use to change the world. - Nelson Mandela",
    "Start where you are. Use what you have. Do what you can. - Arthur Ashe",
    "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
    "You are capable of more than you know.",
    "Dream big and dare to fail. - Norman Vaughan",
    "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
  ];

  @override
  Widget build(BuildContext context) {
    // Shuffle the quotes so it's new every time (though AnimatedTextKit usually plays sequentially, 
    // we can randomize the list on build)
    final List<String> randomQuotes = List.from(quotes)..shuffle();

    return SizedBox(
      height: 60, // Restrain height
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontStyle: FontStyle.italic,
          shadows: [
            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
        child: AnimatedTextKit(
          repeatForever: true,
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
          animatedTexts: randomQuotes.map((quote) => TypewriterAnimatedText(
            quote,
            textAlign: TextAlign.center,
            speed: const Duration(milliseconds: 300),
            cursor: '_',
          )).toList(),
          isRepeatingAnimation: true,
        ),
      ),
    );
  }
}


