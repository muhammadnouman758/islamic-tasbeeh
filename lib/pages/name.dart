import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/cus_widget/custext.dart';
import 'package:tasbih/model/names.dart';
import 'package:tasbih/pages/tasbih.dart';
import 'package:tasbih/provider/counter_provider.dart';

class MuhammadPage extends StatefulWidget {
  const MuhammadPage({super.key});

  @override
  State<MuhammadPage> createState() => _MuhammadPageState();
}

class _MuhammadPageState extends State<MuhammadPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late CounterProvider provider;

  // Enhanced Color Palette
  final Color primaryColor = const Color(0xFF1E88E5);
  final Color secondaryColor = const Color(0xFF42A5F5);
  final Color accentColor = const Color(0xFFE3F2FD);
  final Color backgroundGradientStart = const Color(0xFFF8FBFF);
  final Color backgroundGradientEnd = const Color(0xFFE8F4FD);
  final Color cardColor = Colors.white;
  final Color textPrimary = const Color(0xFF1E88E5);
  final Color textSecondary = const Color(0xFF64748B);
  final Color shadowColor = Colors.black.withOpacity(0.08);

  List<Color> cardGradients = [
    const Color(0xFF667eea),
    const Color(0xFF764ba2),
    const Color(0xFF4facfe),
    const Color(0xFF00f2fe),
    const Color(0xFFf093fb),
    const Color(0xFFf5576c),
  ];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CounterProvider>(context, listen: false);

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Start animations
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<dynamic> loadData() async {
    final jsonData = await rootBundle.loadString('assets/img/tasbih.json');
    final decodeData = jsonDecode(jsonData);
    final asma = decodeData['Muhammad'];
    Muhammad.listMuhammad = asma
        .map<Muhammad>((e) => Muhammad.fromMap(e as Map<String, dynamic>))
        .toList();
    return Muhammad.listMuhammad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundGradientStart, backgroundGradientEnd],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar
            SliverAppBar(
              expandedHeight: 140.h,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.r),
                    bottomRight: Radius.circular(35.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Animated Background Pattern
                    Positioned(
                      top: -50,
                      right: -30,
                      child: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    FlexibleSpaceBar(
                      title: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Flexible(
                                  child: Text(
                                    'Muhammad ﷺ Names',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      centerTitle: false,
                      titlePadding: EdgeInsets.only(left: 20.w, bottom: 20.h),
                    ),
                  ],
                ),
              ),
              leading: Container(
                margin: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),

            // Header Info Card
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      margin: EdgeInsets.all(20.r),
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.r),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Beautiful Names',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Names and titles of Prophet Muhammad ﷺ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color: primaryColor,
                                    size: 20.sp,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Names List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: FutureBuilder(
                future: loadData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final delay = math.min(index * 0.1, 0.9);
                              final progress = math.max(0.0, _fadeAnimation.value - delay);
                              final normalizedProgress = delay >= 1.0 ? 1.0 : progress / (1.0 - delay);
                              final clampedProgress = normalizedProgress.clamp(0.0, 1.0);

                              var animValue = clampedProgress.isNaN ? 0.0 : Curves.elasticOut.transform(clampedProgress);
                              animValue = animValue.clamp(0.0, 1.0);

                              if (!animValue.isFinite) {
                                animValue = 0.0;
                              }

                              return Transform.translate(
                                offset: Offset(0, 50 * (1 - animValue)),
                                child: Opacity(
                                  opacity: animValue,
                                  child: _buildEnhancedNameCard(
                                    Muhammad.listMuhammad[index],
                                    index,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: Muhammad.listMuhammad.length,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 300.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20.r),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: SizedBox(
                                  width: 40.w,
                                  height: 40.h,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'Loading beautiful names...',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // Bottom Spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 30.h),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedNameCard(Muhammad muhammad, int index) {
    final gradientColors = [
      cardGradients[index % cardGradients.length].withOpacity(0.1),
      cardColor,
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            provider.addNewTasbih(true, muhammad);
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TasbihCounter(
                      title: muhammad.name,
                      count: muhammad.count,
                    ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: child,
                  );
                },
              ),
                  (route) => route.isFirst,
            );
          },
          borderRadius: BorderRadius.circular(25.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: cardGradients[index % cardGradients.length].withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Decorative Background Elements
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cardGradients[index % cardGradients.length].withOpacity(0.05),
                    ),
                  ),
                ),

                // Main Content
                Padding(
                  padding: EdgeInsets.all(25.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  cardGradients[index % cardGradients.length],
                                  cardGradients[index % cardGradients.length].withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: cardGradients[index % cardGradients.length].withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Arabic Name Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          muhammad.name ?? '',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                            height: 2.0,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Decorative divider
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15.h),
                        child: Image.asset(
                          'assets/img/wazifa.png',
                          color: cardGradients[index % cardGradients.length],
                          height: 20.h,
                          width: 240.w,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Description Section
                      if (muhammad.desc_en != null && muhammad.desc_en!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(18.r),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            muhammad.desc_en!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: textSecondary,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(height: 15.h),

                      // Action Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            color: cardGradients[index % cardGradients.length],
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Tap to start dhikr',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: cardGradients[index % cardGradients.length].withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: cardGradients[index % cardGradients.length],
                              size: 16.sp,
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
}