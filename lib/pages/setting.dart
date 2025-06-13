import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/pages/donation.dart';
import 'package:tasbih/provider/counter_provider.dart';

class SettingApp extends StatefulWidget {
  const SettingApp({super.key});

  @override
  State<SettingApp> createState() => _SettingAppState();
}

class _SettingAppState extends State<SettingApp> with TickerProviderStateMixin {
  late CounterProvider provider;
  late AnimationController _animationController;
  late AnimationController _donationPulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CounterProvider>(context, listen: false);
    provider.loadLang();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _donationPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _donationPulseController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _donationPulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _donationPulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _donationPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Gradient
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Settings Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Consumer<CounterProvider>(
                  builder: (context, counter, child) => Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        // Premium Donation Card - Positioned at top for visibility
                        _buildDonationCard(),

                        SizedBox(height: 24.h),

                        // Audio & Haptics Section
                        _buildSectionCard(
                          title: 'Audio & Haptics',
                          icon: Icons.volume_up_rounded,
                          children: [
                            _buildSwitchTile(
                              title: 'Sound Effects',
                              subtitle: 'Enable audio feedback',
                              icon: Icons.music_note_rounded,
                              value: counter.sound,
                              onChanged: counter.setSound,
                            ),
                            _buildSwitchTile(
                              title: 'Vibration',
                              subtitle: 'Enable haptic feedback',
                              icon: Icons.vibration_rounded,
                              value: provider.vibration,
                              onChanged: provider.setVibr,
                            ),
                            _buildSliderTile(
                              title: 'Volume Level',
                              subtitle: 'Adjust sound volume',
                              icon: Icons.volume_up_rounded,
                              value: counter.volume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: counter.setVolum,
                              displayValue: '${(counter.volume * 100).round()}%',
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Interface Section
                        _buildSectionCard(
                          title: 'Interface',
                          icon: Icons.palette_rounded,
                          children: [
                            _buildNavigationTile(
                              title: 'Theme',
                              subtitle: 'Customize app appearance',
                              icon: Icons.palette_outlined,
                              onTap: () {
                                // Navigate to theme settings
                              },
                            ),
                            _buildNavigationTile(
                              title: 'Language',
                              subtitle: 'Choose your preferred language',
                              icon: Icons.language_rounded,
                              onTap: () {
                                // Navigate to language settings
                              },
                            ),
                            _buildSliderTile(
                              title: 'Animation Speed',
                              subtitle: 'Control text animation velocity',
                              icon: Icons.speed_rounded,
                              value: counter.velocity,
                              min: 5.0,
                              max: 50.0,
                              onChanged: counter.setTextVelocity,
                              displayValue: '${counter.velocity.round()}x',
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Social Section
                        _buildSectionCard(
                          title: 'Social',
                          icon: Icons.share_rounded,
                          children: [
                            _buildNavigationTile(
                              title: 'Invite Friends',
                              subtitle: 'Share the app with others',
                              icon: Icons.person_add_rounded,
                              onTap: () {
                                // Handle invite friends
                              },
                            ),
                            _buildNavigationTile(
                              title: 'Rate Us',
                              subtitle: 'Leave a review on the store',
                              icon: Icons.star_rounded,
                              onTap: () {
                                // Handle rate us
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Support Section
                        _buildSectionCard(
                          title: 'Support',
                          icon: Icons.help_rounded,
                          children: [
                            _buildNavigationTile(
                              title: 'Notifications',
                              subtitle: 'Manage your notification preferences',
                              icon: Icons.notifications_rounded,
                              onTap: () {
                                // Handle notifications
                              },
                            ),
                            _buildNavigationTile(
                              title: 'Help & Support',
                              subtitle: 'Get help and contact support',
                              icon: Icons.help_center_rounded,
                              onTap: () {
                                // Handle help
                              },
                            ),
                            _buildNavigationTile(
                              title: 'About',
                              subtitle: 'App version and information',
                              icon: Icons.info_rounded,
                              onTap: () {
                                // Handle about
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard() {
    return AnimatedBuilder(
      animation: _donationPulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withOpacity(_glowAnimation.value * 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              borderRadius: BorderRadius.circular(20.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CryptoDonationPage(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF6B6B),
                        Color(0xFFFF8E8E),
                        Color(0xFFFFB4B4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      // Icon with animation
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Support Our App',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Help us keep the app free and ad-free',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Donate Now',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Decorative elements
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Center(
                          child: Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Icon(
                              Icons.volunteer_activism_rounded,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF667eea),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF667eea),
            activeTrackColor: const Color(0xFF667eea).withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE2E8F0),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required String displayValue,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF667eea),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667eea).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            displayValue,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF667eea),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF667eea),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF667eea),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
              trackHeight: 4.h,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF667eea),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: const Color(0xFF718096),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}