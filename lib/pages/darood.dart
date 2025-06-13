import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/cus_widget/custext.dart';
import 'package:tasbih/model/darod.dart';
import 'package:tasbih/pages/tasbih.dart';
import 'package:tasbih/provider/counter_provider.dart';

class Darood extends StatefulWidget {
  const Darood({super.key});

  @override
  State<Darood> createState() => _DaroodState();
}

class _DaroodState extends State<Darood> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late CounterProvider provider;
  bool _isLoading = true;
  String _searchQuery = '';
  List<DarrodModel> _filteredList = [];

  // Modern Color Scheme
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFFFFD700);
  static const Color backgroundColor = Color(0xFFF8FFF8);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF1B5E20);
  static const Color textSecondary = Color(0xFF4E7C31);
  static const Color gradientStart = Color(0xFF2E7D32);
  static const Color gradientEnd = Color(0xFF66BB6A);

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CounterProvider>(context, listen: false);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final jsonData = await rootBundle.loadString('assets/img/tasbih.json');
      final decodeData = jsonDecode(jsonData);
      final darod = decodeData['Darood'];

      DarrodModel.daroodList = darod
          .map<DarrodModel>((e) => DarrodModel.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _filteredList = DarrodModel.daroodList;
        _isLoading = false;
      });

      _fadeController.forward();
      _slideController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterList(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredList = DarrodModel.daroodList;
      } else {
        _filteredList = DarrodModel.daroodList
            .where((item) =>
        item.name!.toLowerCase().contains(query.toLowerCase()) ||
            item.title_en!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _navigateToTasbih(DarrodModel daroodModel) {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    provider.addNewTasbih(true, daroodModel);
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TasbihCounter(
          title: daroodModel.name,
          count: daroodModel.count,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.elasticOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          _buildSearchSection(),
          _buildDaroodList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStart, gradientEnd],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Islamic pattern overlay
              Positioned(
                top: 40,
                right: 20,
                child: Icon(
                  Icons.mosque,
                  size: 80,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              // Title
              Positioned(
                bottom: 60,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'دُرُودِ شَرِيف',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Darood Sharif Collection',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              onChanged: _filterList,
              decoration: InputDecoration(
                hintText: 'Search Darood...',
                hintStyle: TextStyle(
                  color: textSecondary.withOpacity(0.6),
                  fontSize: 16.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                  size: 24,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _filterList('');
                    FocusScope.of(context).unfocus();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: textSecondary,
                  ),
                )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
              ),
              style: TextStyle(
                fontSize: 16.sp,
                color: textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaroodList() {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 400.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Loading Darood Collection...',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_filteredList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: textSecondary.withOpacity(0.5),
                ),
                SizedBox(height: 20.h),
                Text(
                  'No Darood found',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Try searching with different keywords',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildDaroodCard(_filteredList[index], index),
              ),
            );
          },
          childCount: _filteredList.length,
        ),
      ),
    );
  }

  Widget _buildDaroodCard(DarrodModel daroodModel, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToTasbih(daroodModel),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardColor,
                  cardColor.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: const Offset(-5, -5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background decoration
                Positioned(
                  top: -10,
                  right: -10,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.2),
                          primaryColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.star,
                      color: accentColor.withOpacity(0.6),
                      size: 30,
                    ),
                  ),
                ),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // English title
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        daroodModel.title_en.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Arabic text
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        daroodModel.name.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          height: 1.8,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Action row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.repeat,
                                size: 16,
                                color: textPrimary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Count: ${daroodModel.count}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}