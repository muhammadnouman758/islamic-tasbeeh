import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/cus_widget/custext.dart';
import 'package:tasbih/model/dua.dart';
import 'package:tasbih/pages/tasbih.dart';
import 'package:tasbih/provider/counter_provider.dart';

class Dua extends StatefulWidget {
  const Dua({super.key});

  @override
  State<Dua> createState() => _DuaState();
}

class _DuaState extends State<Dua> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late CounterProvider provider;

  // Enhanced Color Scheme with gradients
  final Color primaryColor = const Color(0xFF1B4B6B);
  final Color secondaryColor = const Color(0xFF2E8B8B);
  final Color accentColor = const Color(0xFFE8F4FD);
  final Color cardColor = Colors.white;
  final Color shadowColor = Colors.black12;
  final Color textPrimary = const Color(0xFF1B4B6B);
  final Color textSecondary = const Color(0xFF64748B);

  List<Color> gradientColors = [
    const Color(0xFF1B4B6B),
    const Color(0xFF2E8B8B),
    const Color(0xFF4FD1C7),
  ];

  Future<dynamic> loadData() async {
    final jsonData = await rootBundle.loadString('assets/img/tasbih.json');
    final decodeData = jsonDecode(jsonData);
    final darod = decodeData['Dua'];
    DuaModel.duaList = darod
        .map<DuaModel>((e) => DuaModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return DuaModel.duaList;
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CounterProvider>(context, listen: false);

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with gradient
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
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: FlexibleSpaceBar(
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
                              Icons.auto_stories_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Namaz Duas',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
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

          // Header Stats Section
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
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
                child: FutureBuilder(
                  future: loadData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.menu_book_rounded,
                              title: 'Total Duas',
                              value: '${DuaModel.duaList.length}',
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.favorite_rounded,
                              title: 'Categories',
                              value: '5+',
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),

          // Duas List
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
                            return Transform.translate(
                              offset: Offset(
                                0,
                                50 * (1 - _fadeAnimation.value) * (index % 3),
                              ),
                              child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: _buildEnhancedDuaCard(
                                  snapshot.data[index],
                                  index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: DuaModel.duaList.length,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.h,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 3,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Loading beautiful duas...',
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
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDuaCard(DuaModel dua, int index) {
    // Alternating card colors for visual variety
    final cardGradient = index % 2 == 0
        ? [cardColor, cardColor]
        : [cardColor, accentColor.withOpacity(0.3)];

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            provider.addNewTasbih(true, dua);
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TasbihCounter(
                      title: dua.name,
                      count: dua.count,
                    ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
                  (route) => route.isFirst,
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: cardGradient,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Decorative Pattern
                Positioned(
                  top: -20.h,
                  right: -20.w,
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30.h,
                  left: -30.w,
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: secondaryColor.withOpacity(0.05),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dua ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: textSecondary,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  dua.title_en ?? 'Islamic Dua',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: secondaryColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${dua.count}x',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Arabic Text
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.r),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          dua.name ?? '',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                            height: 1.8,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      // Action Row
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            color: secondaryColor,
                            size: 16.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Tap to start tasbih',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: secondaryColor,
                            size: 16.sp,
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