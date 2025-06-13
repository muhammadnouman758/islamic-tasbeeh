import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasbih/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Animation Controllers
  late AnimationController _primaryController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _loadingController;

  // Animations
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoRotation;
  late Animation<Offset> _logoSlide;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _backgroundFade;
  late Animation<double> _particleAnimation;
  late Animation<double> _loadingProgress;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    // Primary animation controller for logo
    _primaryController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Text animations
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Background and effects
    _backgroundFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeInOut,
      ),
    );

    _loadingProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeInOut,
      ),
    );
  }


  void _startAnimationSequence() async {
    // Start background fade
    _primaryController.forward();

    // Start particles after a delay
    await Future.delayed(const Duration(milliseconds: 300));
    _particleController.repeat(reverse: true);

    // Start text animation
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Start loading animation
    await Future.delayed(const Duration(milliseconds: 200));
    _loadingController.forward();

    // Navigate after all animations
    await Future.delayed(const Duration(milliseconds: 2300));
    _navigateToHome();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Add status bar styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _primaryController,
          _particleController,
          _textController,
          _loadingController,
        ]),
        builder: (context, child) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E3A8A).withOpacity(_backgroundFade.value),
                  const Color(0xFF3B82F6).withOpacity(_backgroundFade.value * 0.8),
                  const Color(0xFF60A5FA).withOpacity(_backgroundFade.value * 0.6),
                  Colors.white.withOpacity(_backgroundFade.value * 0.1),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                _buildParticleBackground(),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo section
                      _buildLogoSection(),

                      const SizedBox(height: 40),

                      // App title
                      _buildTitleSection(),

                      const SizedBox(height: 60),

                      // Loading indicator
                      _buildLoadingSection(),
                    ],
                  ),
                ),

                // Decorative elements
                _buildDecorativeElements(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticleBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ParticlePainter(_particleAnimation.value),
      ),
    );
  }

  Widget _buildLogoSection() {
    return SlideTransition(
      position: _logoSlide,
      child: FadeTransition(
        opacity: _logoFade,
        child: ScaleTransition(
          scale: _logoScale,
          child: Transform.rotate(
            angle: _logoRotation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(_glowAnimation.value * 0.3),
                    blurRadius: 30 * _glowAnimation.value,
                    spreadRadius: 10 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(_glowAnimation.value * 0.2),
                    blurRadius: 50 * _glowAnimation.value,
                    spreadRadius: 20 * _glowAnimation.value,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Image.asset(
                    'assets/img/playstore.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textFade,
        child: Column(
          children: [
            // Main title with glow effect
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.white.withOpacity(_textFade.value),
                    const Color(0xFFE0E7FF).withOpacity(_textFade.value),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'Islamic Tasbeeh Counter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle with Arabic text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                'ذكر • Dhikr',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(_textFade.value * 0.9),
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return FadeTransition(
      opacity: _textFade,
      child: Column(
        children: [
          // Loading progress bar
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 200 * _loadingProgress.value,
                height: 4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE0E7FF)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Loading text
          Text(
            'Preparing your spiritual journey...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return Stack(
      children: [
        // Top-left decorative circle
        Positioned(
          top: -50,
          left: -50,
          child: FadeTransition(
            opacity: _backgroundFade,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        // Bottom-right decorative circle
        Positioned(
          bottom: -100,
          right: -100,
          child: FadeTransition(
            opacity: _backgroundFade,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const HomePage(pageTitle: 'Islamic Tasbeeh Counter - Dhikr'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.3),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}

// Custom painter for animated particles
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final dx = (size.width * 0.1) + (i * size.width * 0.05) % size.width;
      final dy = (size.height * 0.2) +
          (animationValue * size.height * 0.6 + i * 30) % size.height;

      final radius = 2.0 + (animationValue * 3.0);

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        paint..color = Colors.white.withOpacity(0.1 * animationValue),
      );
    }

    // Draw larger floating elements
    for (int i = 0; i < 8; i++) {
      final dx = (size.width * 0.2) + (i * size.width * 0.15) % size.width;
      final dy = (size.height * 0.3) +
          (animationValue * size.height * 0.4 + i * 80) % size.height;

      final radius = 8.0 + (animationValue * 4.0);

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        paint..color = Colors.white.withOpacity(0.05 * animationValue),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}