import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:tasbih/model/wazifa.dart';
import 'package:tasbih/pages/tasbih.dart';
import 'package:tasbih/provider/counter_provider.dart';
import '../cus_widget/custext.dart';

class Wazifa extends StatefulWidget {
  const Wazifa({super.key});

  @override
  State<Wazifa> createState() => _WazifaState();
}

class _WazifaState extends State<Wazifa> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  late CounterProvider provider;
  bool _isLoading = true;
  String _searchQuery = '';
  List<WazifaModel> _filteredList = [];
  Set<int> _favoriteIndices = <int>{};

  // Modern Color Scheme - Purple/Violet Theme for Wazifa
  static const Color primaryColor = Color(0xFF6A1B9A);
  static const Color secondaryColor = Color(0xFF9C27B0);
  static const Color accentColor = Color(0xFFE1BEE7);
  static const Color backgroundColor = Color(0xFFFAF7FF);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF4A148C);
  static const Color textSecondary = Color(0xFF7B1FA2);
  static const Color gradientStart = Color(0xFF6A1B9A);
  static const Color gradientEnd = Color(0xFFAB47BC);
  static const Color benefitColor = Color(0xFF8E24AA);

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CounterProvider>(context, listen: false);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final jsonData = await rootBundle.loadString('assets/img/tasbih.json');
      final decodeData = jsonDecode(jsonData);
      final wazifa = decodeData['Wazifa'];

      WazifaModel.wazifa = wazifa
          .map<WazifaModel>((e) => WazifaModel.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _filteredList = WazifaModel.wazifa;
        _isLoading = false;
      });

      _fadeController.forward();
      _slideController.forward();
      _rotationController.repeat();
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
        _filteredList = WazifaModel.wazifa;
      } else {
        _filteredList = WazifaModel.wazifa
            .where((item) =>
        item.name!.toLowerCase().contains(query.toLowerCase()) ||
            item.desc_en!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoriteIndices.contains(index)) {
        _favoriteIndices.remove(index);
      } else {
        _favoriteIndices.add(index);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _navigateToTasbih(WazifaModel wazifaModel, int index) {
    HapticFeedback.mediumImpact();

    provider.addNewTasbih(true, wazifaModel);
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TasbihCounter(
          title: wazifaModel.name,
          count: wazifaModel.count,
          index: index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
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
          _buildWazifaList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.h,
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
              // Animated background pattern
              ...List.generate(5, (index) => Positioned(
                top: (index * 40.0) - 20,
                right: (index * 60.0) - 30,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) => Transform.rotate(
                    angle: _rotationAnimation.value + (index * 0.5),
                    child: Container(
                      width: 40 + (index * 10.0),
                      height: 40 + (index * 10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
              // Decorative crescent
              Positioned(
                top: 30,
                right: 30,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) => Transform.rotate(
                    angle: _rotationAnimation.value * 0.2,
                    child: Icon(
                      Icons.brightness_2,
                      size: 60,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),
              ),
              // Title section
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وَظِيفَه',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 15.0,
                            color: Colors.black38,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sacred Recitations & Benefits',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
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
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
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
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 25,
                  offset: const Offset(-8, -8),
                ),
              ],
            ),
            child: TextField(
              onChanged: _filterList,
              decoration: InputDecoration(
                hintText: 'Search Wazifa...',
                hintStyle: TextStyle(
                  color: textSecondary.withOpacity(0.6),
                  fontSize: 16.sp,
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.search,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _filterList('');
                    FocusScope.of(context).unfocus();
                  },
                  icon: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: primaryColor,
                      size: 18,
                    ),
                  ),
                )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
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

  Widget _buildWazifaList() {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 400.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 4,
                      ),
                      Icon(
                        Icons.brightness_2,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Loading Wazifa Collection...',
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

    if (_filteredList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 350.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.3),
                        secondaryColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.search_off,
                    size: 50,
                    color: primaryColor.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'No Wazifa Found',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Try different search terms',
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
                child: _buildWazifaCard(_filteredList[index], index),
              ),
            );
          },
          childCount: _filteredList.length,
        ),
      ),
    );
  }

  Widget _buildWazifaCard(WazifaModel wazifaModel, int index) {
    final bool isFavorite = _favoriteIndices.contains(index);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToTasbih(wazifaModel, index),
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardColor,
                  backgroundColor,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 30,
                  offset: const Offset(-12, -12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with favorite button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.brightness_2,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Wazifa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleFavorite(index),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? accentColor.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? primaryColor : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Arabic text container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.1),
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    wazifaModel.name!,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                      height: 2.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Description
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: secondaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    wazifaModel.desc_en!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Benefits section
                if (wazifaModel.benefits_en != null && wazifaModel.benefits_en!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [benefitColor.withOpacity(0.2), accentColor.withOpacity(0.3)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: benefitColor,
                              size: 16,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Benefits',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: benefitColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...wazifaModel.benefits_en!.take(3).map((benefit) => Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: benefitColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: benefitColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                benefit,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),

                SizedBox(height: 20.h),

                // Action button
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _navigateToTasbih(wazifaModel, index),
                      borderRadius: BorderRadius.circular(25),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Start Recitation',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
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
}