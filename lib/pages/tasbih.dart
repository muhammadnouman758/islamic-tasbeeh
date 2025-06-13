import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/cus_widget/cus_dialog.dart';
import 'package:tasbih/provider/counter_provider.dart';
import 'package:vibration/vibration.dart';

class TasbihCounter extends StatefulWidget {
  final int? count;
  final String? title;
  final int? index;
  const TasbihCounter({super.key, this.count, this.title, this.index});

  @override
  State<TasbihCounter> createState() => _TasbihCounterState();
}

class _TasbihCounterState extends State<TasbihCounter>
    with TickerProviderStateMixin {

  // Enhanced Color Scheme
  final Color primaryColor = const Color(0xFF1B4D3E); // Deep emerald
  final Color accentColor = const Color(0xFF4A90A4); // Soft blue
  final Color surfaceColor = Colors.white;
  final Color onSurfaceColor = const Color(0xFF2C3E50);
  final Color backgroundColor = const Color(0xFFF8F9FA);
  final Color goldAccent = const Color(0xFFD4AF37);

  late CounterProvider provider;
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CounterProvider>(context, listen: false);
    provider.loadStat();
    provider.loadLang();

    // Initialize animations
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkDarkMode();
  }

  void _checkDarkMode() {
    final brightness = MediaQuery.of(context).platformBrightness;
    if (_isDarkMode != (brightness == Brightness.dark)) {
      setState(() {
        _isDarkMode = brightness == Brightness.dark;
      });
    }
  }

  final AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    provider.stop();
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  // Enhanced tap handler with animations
  Future<void> _handleTap() async {
    // Trigger animations
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    final obj = await SharedPreferences.getInstance();
    if (obj.getBool('sound') == true) {
      player.setVolume(provider.volume);
      player.play(AssetSource('img/audio-2.mp3'));
    }
    if (obj.getBool('vibration') == true) {
      Vibration.vibrate(duration: 100, amplitude: 128);
    }

    provider.saveData(provider.keyPre);
    if (!provider.isRunning) {
      provider.startTimer();
      provider.isActive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: _isDarkMode
                  ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A1A1A),
                  const Color(0xFF2D2D2D),
                ],
              )
                  : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Consumer<CounterProvider>(
              builder: (context, value, child) => Column(
                children: [
                  _buildTopMarquee(textScaleFactor),
                  _buildTimerControls(textScaleFactor),
                  Expanded(
                    child: _buildMainCounterDisplay(textScaleFactor),
                  ),
                  _buildProgressIndicator(),
                  _buildBottomControls(textScaleFactor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Top Marquee Section
  Widget _buildTopMarquee(double textScaleFactor) {
    return Container(
      height: 80.h,
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF2D2D2D) : surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Consumer<CounterProvider>(
        builder: (context, value, child) {
          return provider.tasbihText.length > 30
              ? Marquee(
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            blankSpace: 40.0,
            velocity: value.velocity,
            pauseAfterRound: const Duration(seconds: 2),
            startPadding: 10.0,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
            style: GoogleFonts.inter(
              fontSize: (20 * textScaleFactor).clamp(16, 24),
              color: _isDarkMode ? Colors.white : primaryColor,
              fontWeight: FontWeight.w600,
            ),
            text: provider.tasbihText,
          )
              : Text(
            provider.tasbihText,
            style: GoogleFonts.inter(
              fontSize: (20 * textScaleFactor).clamp(16, 24),
              color: _isDarkMode ? Colors.white : primaryColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }

  // Timer Controls Section
  Widget _buildTimerControls(double textScaleFactor) {
    return Container(
      height: 70.h,
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF2D2D2D) : surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimerButton(
            icon: provider.isActive ? Icons.play_arrow_rounded : Icons.pause,
            onPressed: () {
              if (provider.isRunning || provider.isActive) {
                if (provider.isRunning) {
                  provider.pause();
                } else if (provider.isActive) {
                  provider.reversePause();
                }
              } else {
                provider.startTimer();
              }
            },
            tooltip: provider.isActive ? 'Play' : 'Pause',
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${provider.minStr}:${provider.secStr}',
                style: GoogleFonts.inter(
                  fontSize: (22 * textScaleFactor).clamp(18, 28),
                  fontWeight: FontWeight.w700,
                  color: _isDarkMode ? Colors.white : primaryColor,
                ),
              ),
              Text(
                'Timer',
                style: GoogleFonts.inter(
                  fontSize: (12 * textScaleFactor).clamp(10, 16),
                  color: (_isDarkMode ? Colors.white : primaryColor).withOpacity(0.7),
                ),
              ),
            ],
          ),
          _buildTimerButton(
            icon: Icons.refresh,
            onPressed: () {
              HapticFeedback.mediumImpact();
              provider.timeReset();
            },
            tooltip: 'Reset Timer',
          ),
        ],
      ),
    );
  }

  Widget _buildTimerButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: _isDarkMode ? accentColor : primaryColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  // Main Counter Display (Floating Design)
  Widget _buildMainCounterDisplay(double textScaleFactor) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple Effect
          AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) {
              return Container(
                width: (300 + _rippleAnimation.value * 50).w,
                height: (300 + _rippleAnimation.value * 50).h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (_isDarkMode ? accentColor : primaryColor)
                        .withOpacity(0.3 - _rippleAnimation.value * 0.3),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          // Main Counter Container
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 280.w,
                  height: 280.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isDarkMode
                          ? [
                        const Color(0xFF3D3D3D),
                        const Color(0xFF2D2D2D),
                      ]
                          : [
                        surfaceColor,
                        surfaceColor.withOpacity(0.9),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isDarkMode ? Colors.black : Colors.grey).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: (_isDarkMode ? Colors.white : Colors.white).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 220.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: _isDarkMode ? accentColor : primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (_isDarkMode ? accentColor : primaryColor).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${provider.laps * provider.limit + provider.count}',
                          style: GoogleFonts.inter(
                            fontSize: (76 * textScaleFactor).clamp(60, 90),
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Progress Indicator - Fixed to show proper progress
  Widget _buildProgressIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Consumer<CounterProvider>(
        builder: (context, value, child) {
          // Calculate current cycle progress (0.0 to 1.0)
          double progressValue = value.limit > 0 ? (int.tryParse(value.myCount)! % value.limit) / value.limit : 0.0;

          // If we've completed at least one full cycle and myCount is divisible by limit
          if (int.tryParse(value.myCount)! > 0 && int.tryParse(value.myCount)! % value.limit == 0) {
            progressValue = 1.0;
          }

          // Current cycle count
          int currentCycleCount = int.tryParse(value.myCount)! % value.limit;
          if (currentCycleCount == 0 && int.tryParse(value.myCount)! > 0) {
            currentCycleCount = value.limit;
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Cycle',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: (_isDarkMode ? Colors.white : primaryColor).withOpacity(0.8),
                        ),
                      ),
                      Text(
                        'Total Laps: ${value.laps}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: (_isDarkMode ? Colors.white : primaryColor).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$currentCycleCount / ${value.limit}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _isDarkMode ? accentColor : primaryColor,
                        ),
                      ),
                      Text(
                        'Total: ${value.myCount}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: (_isDarkMode ? Colors.white : primaryColor).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: (_isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _isDarkMode ? accentColor : primaryColor,
                    ),
                    minHeight: 8.h,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              // Progress percentage
              Text(
                '${(progressValue * 100).toInt()}% Complete',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: (_isDarkMode ? Colors.white : primaryColor).withOpacity(0.7),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Bottom Controls Section
  Widget _buildBottomControls(double textScaleFactor) {
    return Container(
      height: 80.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF2D2D2D) : surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.add_circle_outline,
            label: 'Add',
            onPressed: () {
              // Add functionality here
              HapticFeedback.selectionClick();
            },
          ),
          _buildControlButton(
            icon: Icons.visibility_outlined,
            label: 'Preview',
            onPressed: () {
              HapticFeedback.selectionClick();
              CusDialog(
                title: provider.tasbihText,
                context: context,
                textColor: _isDarkMode ? Colors.white : primaryColor,
                backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : backgroundColor,
              ).showDialogX();
            },
          ),
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            onPressed: () {
              HapticFeedback.mediumImpact();
              provider.resetAllData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _isDarkMode ? accentColor : primaryColor,
                size: 28,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _isDarkMode ? Colors.white : primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}