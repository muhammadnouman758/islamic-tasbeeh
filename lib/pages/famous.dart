import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/cus_widget/custext.dart';
import 'package:tasbih/model/asma.dart';
import 'package:tasbih/model/favourit.dart';
import 'package:tasbih/pages/tasbih.dart';
import 'package:tasbih/provider/counter_provider.dart';

class Famous extends StatefulWidget {
  const Famous({super.key});

  @override
  State<Famous> createState() => _FamousState();
}

class _FamousState extends State<Famous> with TickerProviderStateMixin {
  // Enhanced Color Palette
  Color textColor = Colors.blue;
  Color backGroundWhiteColor = Colors.white;
  Color backGroundColor = const Color.fromARGB(255, 249, 249, 249);

  // Additional enhanced colors
  final Color primaryColor = const Color(0xFF2196F3);
  final Color secondaryColor = const Color(0xFF42A5F5);
  final Color accentColor = const Color(0xFFE3F2FD);
  final Color shadowColor = Colors.black.withOpacity(0.08);

  late CounterProvider provider;

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  List<Color> cardGradients = [
    const Color(0xFF2196F3),
    const Color(0xFF4CAF50),
    const Color(0xFF9C27B0),
    const Color(0xFFFF9800),
    const Color(0xFFE91E63),
    const Color(0xFF00BCD4),
  ];

  @override
  void initState() {
    provider = Provider.of(context, listen: false);

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 15),
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
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
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

    super.initState();
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
    final asma = decodeData['Popular'];
    FamousModel.famousList = asma
        .map<FamousModel>((e) => FamousModel.fromMap(e as Map<String, dynamic>))
        .toList();
    return FamousModel.famousList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backGroundColor,
              backGroundColor.withOpacity(0.95),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar
            SliverAppBar(
              expandedHeight: 120.h,
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
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Animated Background Pattern
                    Positioned(
                      top: -40,
                      right: -20,
                      child: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Container(
                              width: 100,
                              height: 100,
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
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    Icons.star_rounded,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Popular',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      centerTitle: false,
                      titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
                    ),
                  ],
                ),
              ),
              leading: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: EdgeInsets.all(16.r),
              sliver: FutureBuilder(
                future: loadData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final item = snapshot.data[index];
                          final colorIndex = index % cardGradients.length;

                          return AnimatedBuilder(
                            animation: _fadeAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 16.h),
                                    child: _buildEnhancedCard(item, colorIndex, index),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: FamousModel.famousList.length,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(40.r),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 60.r,
                                      height: 60.r,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [primaryColor, secondaryColor],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.mosque_rounded,
                                        color: Colors.white,
                                        size: 30.sp,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'Loading Popular Dhikr...',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: textColor,
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
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedCard(dynamic item, int colorIndex, int index) {
    return Consumer<CounterProvider>(
      builder: (context, counterProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardGradients[colorIndex].withOpacity(0.1),
                    cardGradients[colorIndex].withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: cardGradients[colorIndex].withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    provider.addNewTasbih(true, item);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasbihCounter(
                          title: item.name,
                          count: item.count,
                        ),
                      ),
                          (route) => route.isFirst,
                    );
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                cardGradients[colorIndex],
                                cardGradients[colorIndex].withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [
                              BoxShadow(
                                color: cardGradients[colorIndex].withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),

                        SizedBox(width: 16.w),

                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Popular Dhikr ${index + 1}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: textColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              CusText(
                                text: FamousModel.famousList[index].name,
                                fontSize: 18.sp,
                                textColor: textColor,
                                fontWeight: FontWeight.w600,
                                textAlignc: TextAlign.start,
                              ),
                            ],
                          ),
                        ),

                        // Arrow Icon
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: cardGradients[colorIndex].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: cardGradients[colorIndex],
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}