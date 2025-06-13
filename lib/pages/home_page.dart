import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasbih/ad_manager/ad_manager.dart';
import 'package:tasbih/pages/features.dart';
import 'package:tasbih/pages/history.dart';
import 'package:tasbih/pages/setting.dart';
import 'package:tasbih/pages/tasbih.dart';

class HomePage extends StatefulWidget {
  final String pageTitle;
  const HomePage({super.key, required this.pageTitle});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  int _currentPageIndex = 0;
  late AnimationController _fabAnimationController;
  late AnimationController _pageTransitionController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _pageSlideAnimation;

  // Modern gradient colors
  static const Color _primaryBlue = Color(0xFF4A90E2);
  static const Color _secondaryBlue = Color(0xFF357ABD);
  static const Color _accentTeal = Color(0xFF50E3C2);
  static const Color _backgroundLight = Color(0xFFF8FAFC);
  static const Color _surfaceWhite = Color(0xFFFFFFFF);
  static const Color _textDark = Color(0xFF2D3748);
  static const Color _textLight = Color(0xFF718096);

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.analytics_rounded,
      activeIcon: Icons.analytics_rounded,
      label: 'Analytics',
      gradient: const LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    NavigationItem(
      icon: Icons.radio_button_unchecked,
      activeIcon: Icons.radio_button_checked,
      label: 'Counter',
      gradient: const LinearGradient(
        colors: [_primaryBlue, _secondaryBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    NavigationItem(
      icon: Icons.tune_rounded,
      activeIcon: Icons.tune_rounded,
      label: 'Settings',
      gradient: const LinearGradient(
        colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    NavigationItem(
      icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded,
      label: 'Features',
      gradient: const LinearGradient(
        colors: [Color(0xFFee9ca7), Color(0xFFffdde1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  final List<Widget> _pageWidgets = [
    const History(),
    const TasbihCounter(count: 1, title: 'Welcome to Tasbih', index: 1),
    const SettingApp(),
    const FeaturesOfApp(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _pageSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageTransitionController,
      curve: Curves.easeInOutCubic,
    ));

    _fabAnimationController.forward();
    _pageTransitionController.forward();
  }


  void _handleNavigationTap(int selectedIndex) {
    if (_currentPageIndex != selectedIndex) {
      _provideTactileFeedback();
      _pageTransitionController.reset();
      setState(() {
        _currentPageIndex = selectedIndex;
      });
      _pageTransitionController.forward();
    }
  }

  void _provideTactileFeedback() {
    HapticFeedback.lightImpact();
  }

  void _navigateToMainCounter() {
    _provideTactileFeedback();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const TasbihCounter(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundLight,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_backgroundLight, Color(0xFFEDF2F7)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SlideTransition(
          position: _pageSlideAnimation,
          child: _pageWidgets[_currentPageIndex],
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavigation(),
      floatingActionButton: _buildAnimatedFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildModernBottomNavigation() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_surfaceWhite, Color(0xFFF7FAFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 10,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.r),
        child: Container(
          height: 80.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == _currentPageIndex;

              return _buildNavigationItem(item, index, isSelected);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(NavigationItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleNavigationTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isSelected ? item.gradient : null,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: item.gradient.colors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? _surfaceWhite : _textLight,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? _surfaceWhite : _textLight,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFloatingActionButton() {
    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_primaryBlue, _accentTeal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(35.r),
          boxShadow: [
            BoxShadow(
              color: _primaryBlue.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(35.r),
            onTap: _navigateToMainCounter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.r),
              ),
              child: Icon(
                Icons.add_rounded,
                color: _surfaceWhite,
                size: 32.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final LinearGradient gradient;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.gradient,
  });
}

// Enhanced Custom Bottom Navigation Bar with Modern Design
class EnhancedCustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onNavigationItemSelected;
  final int currentSelectedIndex;

  const EnhancedCustomBottomNavigationBar({
    super.key,
    required this.onNavigationItemSelected,
    required this.currentSelectedIndex,
  });

  @override
  State<EnhancedCustomBottomNavigationBar> createState() =>
      _EnhancedCustomBottomNavigationBarState();
}

class _EnhancedCustomBottomNavigationBarState
    extends State<EnhancedCustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _itemAnimationControllers;
  late List<Animation<double>> _itemScaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeItemAnimations();
  }

  void _initializeItemAnimations() {
    _itemAnimationControllers = List.generate(
      4,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _itemScaleAnimations = _itemAnimationControllers
        .map((controller) => Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)))
        .toList();
  }

  void _handleItemPress(int index) {
    _itemAnimationControllers[index].forward().then((_) {
      _itemAnimationControllers[index].reverse();
    });
    widget.onNavigationItemSelected(index);
  }

  @override
  void dispose() {
    for (var controller in _itemAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ModernBottomNavPainter(),
      child: Container(
        height: 80.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.analytics_rounded, 'History'),
            _buildNavItem(1, Icons.radio_button_checked, 'Counter', isAsset: true),
            SizedBox(width: 80.w), // Space for FAB
            _buildNavItem(2, Icons.tune_rounded, 'Settings'),
            _buildNavItem(3, Icons.grid_view_rounded, 'Features'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData iconData, String label, {bool isAsset = false}) {
    final isSelected = widget.currentSelectedIndex == index;

    return ScaleTransition(
      scale: _itemScaleAnimations[index],
      child: GestureDetector(
        onTap: () => _handleItemPress(index),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4A90E2).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: isSelected
                      ? Border.all(color: const Color(0xFF4A90E2), width: 1)
                      : null,
                ),
                child: isAsset
                    ? Image.asset(
                  'assets/img/tasbih-icon.png',
                  height: 24.h,
                  width: 24.w,
                  color: isSelected
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFF718096),
                )
                    : Icon(
                  iconData,
                  color: isSelected
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFF718096),
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFF718096),
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modern Bottom Navigation Painter with Glassmorphism Effect
class ModernBottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8FAFC),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();

    // Create modern curved path with smooth transitions
    path.moveTo(0, 20);
    path.quadraticBezierTo(0, 0, 20, 0);

    // Left curve before FAB cutout
    path.lineTo(size.width * 0.35, 0);
    path.quadraticBezierTo(
      size.width * 0.38, 0,
      size.width * 0.40, 15,
    );

    // FAB cutout with smooth curves
    path.quadraticBezierTo(
      size.width * 0.42, 25,
      size.width * 0.46, 30,
    );
    path.arcToPoint(
      Offset(size.width * 0.54, 30),
      radius: const Radius.elliptical(40, 30),
      clockwise: false,
    );
    path.quadraticBezierTo(
      size.width * 0.58, 25,
      size.width * 0.60, 15,
    );

    // Right curve after FAB cutout
    path.quadraticBezierTo(
      size.width * 0.62, 0,
      size.width * 0.65, 0,
    );

    path.lineTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}