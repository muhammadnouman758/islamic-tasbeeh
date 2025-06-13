import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/cus_widget/custext.dart';
import 'package:tasbih/model/asma.dart';
import 'package:tasbih/pages/tasbih.dart';
import 'package:tasbih/provider/counter_provider.dart';

class AsmaUlHusnaPage extends StatefulWidget {
  const AsmaUlHusnaPage({super.key});

  @override
  State<AsmaUlHusnaPage> createState() => _AsmaUlHusnaPageState();
}

class _AsmaUlHusnaPageState extends State<AsmaUlHusnaPage>
    with TickerProviderStateMixin {
  // Ultra-Premium Color Palette
  static const Color _primaryGradientStart = Color(0xFF667eea);
  static const Color _primaryGradientEnd = Color(0xFF764ba2);
  static const Color _secondaryGradientStart = Color(0xFF4facfe);
  static const Color _secondaryGradientEnd = Color(0xFF00f2fe);
  static const Color _tertiaryGradientStart = Color(0xFFffecd2);
  static const Color _tertiaryGradientEnd = Color(0xFFfcb69f);
  static const Color _quaternaryGradientStart = Color(0xFFa8edea);
  static const Color _quaternaryGradientEnd = Color(0xFFfed6e3);
  static const Color _backgroundLight = Color(0xFFF8FAFC);
  static const Color _surfaceWhite = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF2D3748);
  static const Color _textSecondary = Color(0xFF4A5568);
  static const Color _accentGold = Color(0xFFD4AF37);
  static const Color _accentEmerald = Color(0xFF10B981);
  static const Color _shadowColor = Color(0x1A000000);
  static const Color _glowColor = Color(0x33667eea);

  // Animation Controllers
  late AnimationController _masterAnimationController;
  late AnimationController _staggeredListController;
  late AnimationController _headerController;
  late AnimationController _loadingController;
  late AnimationController _floatingElementsController;
  late AnimationController _parallaxController;

  // Header Animations
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _headerScaleAnimation;

  // Loading Animations
  late Animation<double> _loadingRotationAnimation;
  late Animation<double> _loadingPulseAnimation;
  late Animation<Color?> _loadingColorAnimation;

  // Floating Background Elements
  late Animation<double> _floatingElement1Animation;
  late Animation<double> _floatingElement2Animation;
  late Animation<double> _floatingElement3Animation;

  // Parallax Scrolling
  late Animation<double> _parallaxAnimation;
  ScrollController _scrollController = ScrollController();

  late CounterProvider _counterDataProvider;

  // Advanced List Animations
  List<AnimationController> _itemControllers = [];
  List<Animation<Offset>> _itemSlideAnimations = [];
  List<Animation<double>> _itemFadeAnimations = [];
  List<Animation<double>> _itemScaleAnimations = [];
  List<Animation<double>> _itemRotationAnimations = [];
  List<Animation<double>> _itemGlowAnimations = [];
  List<Animation<double>> _itemZigZagAnimations = [];

  // Interaction States
  List<bool> _itemHoverStates = [];
  int? _tappedItemIndex;

  @override
  void initState() {
    super.initState();
    _initializeAdvancedAnimations();
    _initializeScrollListener();
  }

  void _initializeAdvancedAnimations() {
    _counterDataProvider = Provider.of<CounterProvider>(context, listen: false);

    // Master Controller for coordinated animations
    _masterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Individual Controllers
    _staggeredListController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatingElementsController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _initializeHeaderAnimations();
    _initializeLoadingAnimations();
    _initializeFloatingAnimations();
    _initializeParallaxAnimations();

    // Start initial animations
    _headerController.forward();
    _floatingElementsController.repeat();
  }

  void _initializeHeaderAnimations() {
    _headerSlideAnimation = Tween<double>(
      begin: -150.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    _headerScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));
  }

  void _initializeLoadingAnimations() {
    _loadingRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));

    _loadingPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _loadingColorAnimation = ColorTween(
      begin: _primaryGradientStart,
      end: _secondaryGradientEnd,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeOut,
    ));
  }

  void _initializeFloatingAnimations() {
    _floatingElement1Animation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _floatingElementsController,
      curve: Curves.linear,
    ));

    _floatingElement2Animation = Tween<double>(
      begin: 0.0,
      end: -2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _floatingElementsController,
      curve: Curves.linear,
    ));

    _floatingElement3Animation = Tween<double>(
      begin: 0.0,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _floatingElementsController,
      curve: Curves.linear,
    ));
  }

  void _initializeParallaxAnimations() {
    _parallaxAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _parallaxController,
      curve: Curves.easeOut,
    ));
  }

  void _initializeScrollListener() {
    _scrollController.addListener(() {
      final scrollPercent = (_scrollController.offset /
          (_scrollController.position.maxScrollExtent ?? 1.0))
          .clamp(0.0, 1.0);
      _parallaxController.animateTo(scrollPercent);
      _staggeredListController.forward();
    });
  }

  void _initializeAdvancedListAnimations(int itemCount) {
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    _itemControllers.clear();
    _itemSlideAnimations.clear();
    _itemFadeAnimations.clear();
    _itemScaleAnimations.clear();
    _itemRotationAnimations.clear();
    _itemGlowAnimations.clear();
    _itemZigZagAnimations.clear();
    _itemHoverStates.clear();

    for (int i = 0; i < itemCount; i++) {
      final itemController = AnimationController(
        duration: Duration(milliseconds: 800 + (i * 100)),
        vsync: this,
      );
      _itemControllers.add(itemController);
      _itemHoverStates.add(false);

      // Zigzag Animation (snake-like crawling)
      final zigZagAnimation = Tween<double>(
        begin: -50.0,
        end: 50.0,
      ).animate(CurvedAnimation(
        parent: _staggeredListController,
        curve: Interval(
          (i * 0.3).clamp(0.0, 0.8),
          ((i * 0.3) + 0.4).clamp(0.2, 1.0),
          curve: Curves.slowMiddle,
        ),
      ));

      // Slide Animation with zigzag direction
      final slideDirection = Offset(
        math.sin(i * math.pi / 4) * 60.0,
        0.3,
      );

      final slideAnimation = Tween<Offset>(
        begin: slideDirection,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _staggeredListController,
        curve: Interval(
          (i * 0.08).clamp(0.0, 0.8),
          ((i * 0.08) + 0.4).clamp(0.2, 1.0),
          curve: Curves.easeOutSine,
        ),
      ));

      // Fade Animation
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _staggeredListController,
        curve: Interval(
          (i * 0.06).clamp(0.0, 0.8),
          ((i * 0.06) + 0.5).clamp(0.2, 1.0),
          curve: Curves.easeOut,
        ),
      ));

      // Scale Animation (larger fixed size)
      final scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 0.8,
      ).animate(CurvedAnimation(
        parent: _staggeredListController,
        curve: Interval(
          (i * 0.07).clamp(0.0, 0.8),
          ((i * 0.07) + 0.6).clamp(0.2, 1.0),
          curve: Curves.easeInOut,
        ),
      ));

      // Rotation Animation (continuous slight rotation)
      final rotationAnimation = Tween<double>(
        begin: (i % 2 == 0) ? -0.1 : 0.1,
        end: (i % 2 == 0) ? 0.1 : -0.1,
      ).animate(CurvedAnimation(
        parent: _staggeredListController,
        curve: Interval(
          (i * 0.05).clamp(0.0, 0.8),
          ((i * 0.05) + 0.7).clamp(0.2, 1.0),
          curve: Curves.easeInOutSine,
        ),
      ));

      // Glow Animation for hover effects
      final glowAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: itemController,
        curve: Curves.easeOut,
      ));

      _itemSlideAnimations.add(slideAnimation);
      _itemFadeAnimations.add(fadeAnimation);
      _itemScaleAnimations.add(scaleAnimation);
      _itemRotationAnimations.add(rotationAnimation);
      _itemGlowAnimations.add(glowAnimation);
      _itemZigZagAnimations.add(zigZagAnimation);
    }
  }

  Future<List<AsmaModel>> _loadAsmaDataWithAdvancedEffects() async {
    try {
      _loadingController.repeat();

      final jsonDataString = await rootBundle.loadString('assets/img/tasbih.json');
      final decodedJsonData = jsonDecode(jsonDataString);
      final asmaDataList = decodedJsonData['Asma'];

      AsmaModel.asmaList = asmaDataList
          .map<AsmaModel>((item) => AsmaModel.fromMap(item as Map<String, dynamic>))
          .toList();

      _initializeAdvancedListAnimations(AsmaModel.asmaList.length);

      await Future.delayed(const Duration(milliseconds: 800));

      _loadingController.stop();
      _loadingController.reset();

      _staggeredListController.forward();

      debugPrint('Advanced loading completed: ${AsmaModel.asmaList.length} items');
      return AsmaModel.asmaList;
    } catch (error) {
      _loadingController.stop();
      debugPrint('Advanced loading error: $error');
      rethrow;
    }
  }

  void _handleItemHover(int index, bool isHovering) {
    setState(() {
      _itemHoverStates[index] = isHovering;
    });

    if (isHovering) {
      _itemControllers[index].forward();
      HapticFeedback.selectionClick();
    } else {
      _itemControllers[index].reverse();
    }
  }

  void _navigateToTasbihWithAdvancedTransition(AsmaModel selectedAsmaItem, int itemIndex) {
    setState(() {
      _tappedItemIndex = itemIndex;
    });

    HapticFeedback.mediumImpact();

    try {
      _counterDataProvider.addNewTasbih(true, selectedAsmaItem);

      _itemControllers[itemIndex].forward().then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => TasbihCounter(
              title: selectedAsmaItem.name ?? 'Unknown',
              count: selectedAsmaItem.count ?? 1,
              index: itemIndex,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                )),
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.95,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
              (route) => route.isFirst,
        );
      });
    } catch (e) {
      debugPrint('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to navigate: $e')),
      );
    }
  }

  @override
  void dispose() {
    _masterAnimationController.dispose();
    _staggeredListController.dispose();
    _headerController.dispose();
    _loadingController.dispose();
    _floatingElementsController.dispose();
    _parallaxController.dispose();
    _scrollController.dispose();

    for (var controller in _itemControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundLight,
      extendBodyBehindAppBar: true,
      appBar: _buildUltraPremiumAppBar(),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _buildMainContent(),
          _buildFloatingElements(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 2.0,
          colors: [
            Color(0xFFF8FAFC),
            Color(0xFFEDF2F7),
            Color(0xFFF7FAFC),
            _backgroundLight,
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: _parallaxAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -50 * _parallaxAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _backgroundLight.withOpacity(0.9),
                    _backgroundLight.withOpacity(0.7),
                    _backgroundLight,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingElementsController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100.h + (50 * math.sin(_floatingElement1Animation.value)),
              right: 50.w + (30 * math.cos(_floatingElement1Animation.value)),
              child: Transform.rotate(
                angle: _floatingElement1Animation.value * 0.5,
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _accentGold.withOpacity(0.1),
                        _accentGold.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: _accentGold.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.star_outline_rounded,
                    color: _accentGold.withOpacity(0.3),
                    size: 24.sp,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300.h + (40 * math.sin(_floatingElement2Animation.value)),
              left: 30.w + (25 * math.cos(_floatingElement2Animation.value)),
              child: Transform.rotate(
                angle: _floatingElement2Animation.value * 0.3,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _accentEmerald.withOpacity(0.1),
                        _accentEmerald.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.auto_awesome_outlined,
                    color: _accentEmerald.withOpacity(0.3),
                    size: 18.sp,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200.h + (35 * math.sin(_floatingElement3Animation.value)),
              right: 80.w + (20 * math.cos(_floatingElement3Animation.value)),
              child: Transform.rotate(
                angle: _floatingElement3Animation.value * 0.7,
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _primaryGradientStart.withOpacity(0.1),
                        _primaryGradientStart.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Icon(
                    Icons.ac_unit_rounded,
                    color: _primaryGradientStart.withOpacity(0.3),
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildUltraPremiumAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: AnimatedBuilder(
        animation: _headerController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_headerSlideAnimation.value, 0),
            child: Transform.scale(
              scale: _headerScaleAnimation.value,
              child: FadeTransition(
                opacity: _headerFadeAnimation,
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_surfaceWhite, Color(0xFFF7FAFC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: _glowColor,
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: _textPrimary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      title: CusText(
        text: 'Asma Ul Husna',
        textColor: _surfaceWhite,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
      centerTitle: true,
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: FutureBuilder<List<AsmaModel>>(
          future: _loadAsmaDataWithAdvancedEffects(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.hasError) {
              return _buildAdvancedErrorState(dataSnapshot.error.toString());
            }

            if (dataSnapshot.hasData && dataSnapshot.data!.isNotEmpty) {
              return _buildAdvancedAsmaListView(dataSnapshot.data!);
            }

            return _buildAdvancedLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildAdvancedLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _loadingController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingRotationAnimation.value * math.pi,
                child: Transform.scale(
                  scale: _loadingPulseAnimation.value,
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _loadingColorAnimation.value ?? _primaryGradientStart,
                          _secondaryGradientEnd,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40.r),
                      boxShadow: [
                        BoxShadow(
                          color: (_loadingColorAnimation.value ?? _primaryGradientStart).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: _glowColor,
                          blurRadius: 30,
                          offset: const Offset(0, 0),
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: _surfaceWhite,
                      size: 36.sp,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 32.h),
          AnimatedBuilder(
            animation: _loadingPulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_loadingPulseAnimation.value - 0.8) * 0.5,
                child: CusText(
                  text: 'Loading Divine Names...',
                  textColor: _textSecondary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          Container(
            width: 200.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: _textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: AnimatedBuilder(
              animation: _loadingRotationAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (_loadingRotationAnimation.value % 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_primaryGradientStart, _secondaryGradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.1),
                  Colors.red.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 48.sp,
            ),
          ),
          SizedBox(height: 20.h),
          CusText(
            text: 'Unable to load divine names',
            textColor: _textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          CusText(
            text: errorMessage,
            textColor: _textSecondary,
            fontSize: 14.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedAsmaListView(List<AsmaModel> asmaDataList) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          _staggeredListController.forward();
        }
        return true;
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 80.h,
        ),
        itemCount: asmaDataList.length,
        itemBuilder: (context, index) {
          final asmaItem = asmaDataList[index];

          return AnimatedBuilder(
            animation: _itemControllers.isNotEmpty && index < _itemControllers.length
                ? _itemControllers[index]
                : _staggeredListController,
            builder: (context, child) {
              if (index >= _itemSlideAnimations.length) {
                return const SizedBox.shrink();
              }

              return Transform.translate(
                offset: Offset(
                  _itemZigZagAnimations[index].value * (index % 2 == 0 ? 1 : -1),
                  0,
                ),
                child: SlideTransition(
                  position: _itemSlideAnimations[index],
                  child: FadeTransition(
                    opacity: _itemFadeAnimations[index],
                    child: Transform.scale(
                      scale: _itemScaleAnimations[index].value,
                      child: Transform.rotate(
                        angle: _itemRotationAnimations[index].value,
                        child: _buildUltraPremiumAsmaCard(asmaItem, index),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUltraPremiumAsmaCard(AsmaModel asmaItem, int index) {
    final isHovered = index < _itemHoverStates.length ? _itemHoverStates[index] : false;
    final isTapped = _tappedItemIndex == index;
    final glowIntensity = index < _itemGlowAnimations.length
        ? _itemGlowAnimations[index].value
        : 0.0;

    final cardGradients = [
      [_primaryGradientStart, _primaryGradientEnd],
      [_secondaryGradientStart, _secondaryGradientEnd],
      [_tertiaryGradientStart, _tertiaryGradientEnd],
      [_quaternaryGradientStart, _quaternaryGradientEnd],
    ];

    final gradientIndex = index % cardGradients.length;
    final cardGradient = cardGradients[gradientIndex];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.r,
        vertical: 4.h,
      ),
      child: MouseRegion(
        onEnter: (_) => _handleItemHover(index, true),
        onExit: (_) => _handleItemHover(index, false),
        child: GestureDetector(
          onTap: () => _navigateToTasbihWithAdvancedTransition(asmaItem, index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()
              ..scale(isHovered ? 0.85 : 0.8)
              ..translate(0.0, isHovered ? -4.0 : 0.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cardGradient[0].withOpacity(isTapped ? 0.9 : 0.8),
                  cardGradient[1].withOpacity(isTapped ? 0.9 : 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withOpacity(0.25 + (glowIntensity * 0.2)),
                  blurRadius: 20 + (glowIntensity * 15),
                  offset: Offset(0, 8 + (glowIntensity * 4)),
                  spreadRadius: isHovered ? 2 : 0,
                ),
                BoxShadow(
                  color: _glowColor.withOpacity(glowIntensity * 0.3),
                  blurRadius: 30 + (glowIntensity * 20),
                  offset: const Offset(0, 0),
                  spreadRadius: -5,
                ),
                if (isHovered)
                  BoxShadow(
                    color: _surfaceWhite.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                    spreadRadius: -10,
                  ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: _surfaceWhite.withOpacity(0.2 + (glowIntensity * 0.1)),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardHeader(asmaItem, index, isHovered),
                  SizedBox(height: 12.h),
                  _buildCardContent(asmaItem, isHovered),
                  SizedBox(height: 16.h),
                  _buildCardFooter(asmaItem, isHovered),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(AsmaModel asmaItem, int index, bool isHovered) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(isHovered ? 12.w : 10.w),
          decoration: BoxDecoration(
            color: _surfaceWhite.withOpacity(isHovered ? 0.25 : 0.2),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _surfaceWhite.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: _surfaceWhite,
              fontSize: isHovered ? 22.sp : 20.sp,
              fontWeight: FontWeight.w800,
            ),
            child: Text('${index + 1}'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: _surfaceWhite,
                  fontSize: isHovered ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                child: Text(
                  asmaItem.name ?? 'Unknown',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: _surfaceWhite.withOpacity(0.8),
                  fontSize: isHovered ? 14.sp : 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                child: Text(
                  'Divine Name ${index + 1}',
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()..rotateZ(isHovered ? 0.1 : 0.0),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: _surfaceWhite.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: _surfaceWhite,
              size: isHovered ? 18.sp : 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(AsmaModel asmaItem, bool isHovered) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _surfaceWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _surfaceWhite.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: _surfaceWhite,
              fontSize: isHovered ? 30.sp : 28.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              height: 1.4,
            ),
            child: Text(
              asmaItem.name ?? '',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(height: 8.h),
          if (asmaItem.desc_en != null && asmaItem.desc_en!.isNotEmpty)
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: _surfaceWhite.withOpacity(0.9),
                fontSize: isHovered ? 16.sp : 14.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
              ),
              child: Text(
                '"${asmaItem.desc_en}"',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardFooter(AsmaModel asmaItem, bool isHovered) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: _surfaceWhite.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _surfaceWhite.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.repeat_rounded,
                  color: _surfaceWhite.withOpacity(0.8),
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: _surfaceWhite,
                    fontSize: isHovered ? 16.sp : 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text('Count: ${asmaItem.count ?? 1}'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(isHovered ? 12.w : 10.w),
          decoration: BoxDecoration(
            color: _accentGold.withOpacity(isHovered ? 0.9 : 0.8),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: _accentGold.withOpacity(0.3),
                blurRadius: isHovered ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            color: _surfaceWhite,
            size: isHovered ? 20.sp : 18.sp,
          ),
        ),
      ],
    );
  }
}