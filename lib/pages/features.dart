import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasbih/cus_widget/custext.dart';
import 'package:tasbih/pages/asma.dart';
import 'package:tasbih/pages/darood.dart';
import 'package:tasbih/pages/dua.dart';
import 'package:tasbih/pages/famous.dart';
import 'package:tasbih/pages/name.dart';
import 'package:tasbih/pages/tasbih_namaz.dart';
import 'package:tasbih/pages/wazifa.dart';

class FeaturesOfApp extends StatefulWidget {
  const FeaturesOfApp({super.key});

  @override
  State<FeaturesOfApp> createState() => _FeaturesOfAppState();
}

class _FeaturesOfAppState extends State<FeaturesOfApp>
    with TickerProviderStateMixin {

  // Enhanced Color Scheme with Islamic theme
  final Color primaryColor = const Color(0xFF1B5E20);
  final Color secondaryColor = const Color(0xFF2E7D32);
  final Color accentColor = const Color(0xFFFFD700);
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF1A1A1A);
  final Color textSecondaryColor = const Color(0xFF6B7280);
  final Color shadowColor = Colors.black.withOpacity(0.08);

  late AnimationController _staggerController;
  late AnimationController _pulseController;
  late AnimationController _backgroundController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;

  // Enhanced Feature Data Structure with better icons and descriptions
  final List<FeatureItem> features = [
    FeatureItem(
      icon: "assets/img/asma_ul_husana.png",
      title: "Asma-ul-Husna",
      subtitle: "99 Beautiful Names",
      description: "Explore the 99 beautiful names of Allah with meanings",
      color: Color(0xFF2E7D32),
      gradient: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
      iconData: Icons.star_rounded,
    ),
    FeatureItem(
      icon: "assets/img/asmu_e_nabii.png",
      title: "Muhammad ﷺ",
      subtitle: "Prophet's Names",
      description: "Names and attributes of Prophet Muhammad (PBUH)",
      color: Color(0xFF1565C0),
      gradient: [Color(0xFF0D47A1), Color(0xFF1976D2)],
      iconData: Icons.person_rounded,
    ),
    FeatureItem(
      icon: "assets/img/darood-icon.png",
      title: "Darood Pak",
      subtitle: "Blessings & Peace",
      description: "Recite Darood and send blessings upon the Prophet",
      color: Color(0xFF6A1B9A),
      gradient: [Color(0xFF4A148C), Color(0xFF8E24AA)],
      iconData: Icons.favorite_rounded,
    ),
    FeatureItem(
      icon: "assets/img/wazifa-icon.png",
      title: "Wazifa",
      subtitle: "Spiritual Practices",
      description: "Daily spiritual practices and powerful supplications",
      color: Color(0xFFD32F2F),
      gradient: [Color(0xFFB71C1C), Color(0xFFE53935)],
      iconData: Icons.psychology_rounded,
    ),
    FeatureItem(
      icon: "assets/img/tasbih-logo.png",
      title: "Tasbih",
      subtitle: "Digital Counter",
      description: "Count your dhikr and remembrance of Allah",
      color: Color(0xFFE65100),
      gradient: [Color(0xFFBF360C), Color(0xFFFF5722)],
      iconData: Icons.sync_rounded,
    ),
    FeatureItem(
      icon: "assets/img/tasbih-logo.png",
      title: "Dua",
      subtitle: "Supplications",
      description: "Collection of authentic Islamic prayers and duas",
      color: Color(0xFF2E7D32),
      gradient: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
      iconData: Icons.menu_book_rounded,
    ),
    FeatureItem(
      icon: "assets/img/wazifa-icon.png",
      title: "Popular",
      subtitle: "Trending Content",
      description: "Most accessed and beneficial Islamic content",
      color: Color(0xFF5D4037),
      gradient: [Color(0xFF3E2723), Color(0xFF795548)],
      iconData: Icons.trending_up_rounded,
    ),
  ];

  final List<Widget> pageList = [
    AsmaUlHusnaPage(),
    MuhammadPage(),
    Darood(),
    Wazifa(),
    TasbihNamaz(),
    Dua(),
    Famous()
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));

    _staggerController.forward();
    _pulseController.repeat(reverse: true);
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _pulseController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Animated background pattern
            _buildAnimatedBackground(),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(),
                _buildStatsSection(),
                _buildFeaturesGrid(),
                _buildFooterSpacing(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: IslamicPatternPainter(_backgroundAnimation.value),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, accentColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [primaryColor, secondaryColor],
                              ).createShader(bounds),
                              child: Text(
                                "Islamic Companion",
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.8,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Your spiritual journey, digitally enhanced",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: textSecondaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.2),
                        accentColor.withOpacity(0.1)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: accentColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.mosque_rounded,
                    color: accentColor,
                    size: 28.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Material(
          elevation: 12,
          shadowColor: primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("7+", "Features", Icons.apps_rounded),
                    _buildDivider(),
                    _buildStatItem("∞", "Dhikr", Icons.all_inclusive_rounded),
                    _buildDivider(),
                    _buildStatItem("24/7", "Access", Icons.access_time_rounded),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Alhamdulillahi Rabbil Alameen",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 2.w,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(1.r),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(icon, color: Colors.white, size: 24.r),
        ),
        SizedBox(height: 12.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.w,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return AnimatedBuilder(
              animation: _staggerController,
              builder: (context, child) {
                // Fixed animation calculation to prevent end > 1.0
                final itemDelay = (index * 0.1).clamp(0.0, 0.7);
                final itemEnd = (0.4 + itemDelay).clamp(0.0, 1.0);

                final animation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: _staggerController,
                  curve: Interval(
                    itemDelay,
                    itemEnd,
                    curve: Curves.elasticOut,
                  ),
                ));

                return Transform.scale(
                  scale: animation.value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - animation.value) * 50),
                    child: _buildFeatureCard(features[index], index),
                  ),
                );
              },
            );
          },
          childCount: features.length,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(FeatureItem feature, int index) {
    return GestureDetector(
      onTap: () => _navigateToPage(index),
      child: Material(
        elevation: 8,
        shadowColor: feature.color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: feature.color.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              children: [
                // Gradient background
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: feature.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),

                // Decorative pattern
                Positioned(
                  top: -20.h,
                  right: -20.w,
                  child: Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon container
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: feature.color.withOpacity(0.3),
                              blurRadius: 12.r,
                              offset: Offset(0, 6.h),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Fallback icon
                            Icon(
                              feature.iconData,
                              color: feature.color,
                              size: 28.r,
                            ),
                            // Asset image (will overlay if available)
                            Image.asset(
                              feature.icon,
                              width: 32.r,
                              height: 32.r,
                              color: feature.color,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  feature.iconData,
                                  color: feature.color,
                                  size: 28.r,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Title and subtitle
                      Text(
                        feature.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        feature.subtitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: textSecondaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const Spacer(),

                      // Action row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    feature.color.withOpacity(0.1),
                                    feature.color.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: feature.color.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Explore",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: feature.color,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: feature.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.r,
                              color: feature.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSpacing() {
    return SliverToBoxAdapter(
      child: SizedBox(height: 60.h),
    );
  }

  void _navigateToPage(int index) {
    HapticFeedback.mediumImpact();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => pageList[index],
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

// Enhanced Feature Item Model
class FeatureItem {
  final String icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final List<Color> gradient;
  final IconData iconData;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.gradient,
    required this.iconData,
  });
}

// Custom painter for Islamic patterns
class IslamicPatternPainter extends CustomPainter {
  final double animationValue;

  IslamicPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1B5E20).withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final maxRadius = size.width * 0.8;

    // Draw animated concentric circles
    for (int i = 1; i <= 8; i++) {
      final radius = (maxRadius / 8) * i;
      final animatedRadius = radius * (0.8 + 0.2 * sin(animationValue * 2 * pi + i));

      canvas.drawCircle(
        Offset(centerX, centerY),
        animatedRadius,
        paint..color = const Color(0xFF1B5E20).withOpacity(0.02 + i * 0.003),
      );
    }

    // Draw geometric pattern
    final patternPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 * pi / 180) + (animationValue * 2 * pi / 12);
      final x = centerX + cos(angle) * maxRadius * 0.6;
      final y = centerY + sin(angle) * maxRadius * 0.6;

      canvas.drawCircle(Offset(x, y), 8, patternPaint);
    }
  }

  @override
  bool shouldRepaint(IslamicPatternPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Helper function for sine calculation
double sin(double value) {
  return math.sin(value);
}

double cos(double value) {
  return math.cos(value);
}

const double pi = 3.14159265359;