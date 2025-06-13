import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CryptoDonationPage extends StatefulWidget {
  const CryptoDonationPage({super.key});

  @override
  State<CryptoDonationPage> createState() => _CryptoDonationPageState();
}

class _CryptoDonationPageState extends State<CryptoDonationPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int selectedCryptoIndex = 0;

  final List<CryptoOption> cryptoOptions = [
    CryptoOption(
      name: 'Bitcoin',
      symbol: 'BTC',
      address: 'bc1q27h5rct7eg7j6edce9gac5awdau3xe7mlagqea',
      icon: '₿',
      color: const Color(0xFFF7931A),
      gradient: [const Color(0xFFF7931A), const Color(0xFFFFB74D)],
    ),
    CryptoOption(
      name: 'Ethereum',
      symbol: 'ETH',
      address: '0x701afd6991615d90b901cdef1c4e2e5219b31577',
      icon: 'Ξ',
      color: const Color(0xFF627EEA),
      gradient: [const Color(0xFF627EEA), const Color(0xFF9C88FF)],
    ),
    CryptoOption(
      name: 'Binance Coin',
      symbol: 'BNB',
      address: '0x701afd6991615d90b901cdef1c4e2e5219b31577',
      icon: 'B',
      color: const Color(0xFFF3BA2F),
      gradient: [const Color(0xFFF3BA2F), const Color(0xFFFFD54F)],
    ),
    CryptoOption(
      name: 'Tether',
      symbol: 'USDT',
      address: 'TKFAFRE3aohdj5oJfdo7zHehGhFe3uoJGX',
      icon: '₮',
      color: const Color(0xFF26A17B),
      gradient: [const Color(0xFF26A17B), const Color(0xFF4CAF50)],
    ),
    CryptoOption(
      name: 'Solana',
      symbol: 'SOL',
      address: 'DrXB896QGTKc4ZLoRuKM1KdVj5hQKRHGsM86Ut4Fhwew',
      icon: '◎',
      color: const Color(0xFF9945FF),
      gradient: [const Color(0xFF9945FF), const Color(0xFF14F195)],
    ),
    CryptoOption(
      name: 'Toncoin',
      symbol: 'TON',
      address: 'EQD5mxRgCuRNLxKxeOjG6r14iSroLF5FtomPnet-sgP5xNJb',
      icon: '◈',
      color: const Color(0xFF0088CC),
      gradient: [const Color(0xFF0088CC), const Color(0xFF00BFFF)],
      memo: '108942104',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper methods for better UX
  void _copyAddress() {
    final selectedCrypto = cryptoOptions[selectedCryptoIndex];
    Clipboard.setData(ClipboardData(text: selectedCrypto.address));
    _showSnackBar('Address copied!', Icons.check_circle_rounded, Colors.green);
  }

  void _copyMemo() {
    final selectedCrypto = cryptoOptions[selectedCryptoIndex];
    if (selectedCrypto.memo != null) {
      Clipboard.setData(ClipboardData(text: selectedCrypto.memo!));
      _showSnackBar('Memo copied!', Icons.check_circle_rounded, Colors.green);
    }
  }

  void _copyAllDetails() {
    final selectedCrypto = cryptoOptions[selectedCryptoIndex];
    String copyText = 'Address: ${selectedCrypto.address}';
    if (selectedCrypto.memo != null) {
      copyText += '\nMemo: ${selectedCrypto.memo}';
    }
    Clipboard.setData(ClipboardData(text: copyText));
    _showSnackBar('All details copied!', Icons.check_circle_rounded, Colors.green);
  }

  void _openWallet() {
    _showSnackBar('Opening wallet app...', Icons.wallet_rounded, Colors.blue);
    // Here you could implement deep links to popular wallet apps
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Hero App Bar
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: cryptoOptions[selectedCryptoIndex].gradient,
                ),
              ),
              child: FlexibleSpaceBar(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Support Our Mission',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      'Your donation makes a difference',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: cryptoOptions[selectedCryptoIndex].gradient,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 40.sp,
                          ),
                        ),
                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),
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

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cryptocurrency Selection
                      _buildSectionTitle('Choose Cryptocurrency'),
                      SizedBox(height: 16.h),
                      _buildCryptoSelector(),

                      SizedBox(height: 32.h),

                      // QR Code and Address
                      _buildDonationCard(),

                      SizedBox(height: 32.h),

                      // Instructions
                      _buildInstructionsCard(),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildCryptoSelector() {
    return Container(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cryptoOptions.length,
        itemBuilder: (context, index) {
          final crypto = cryptoOptions[index];
          final isSelected = selectedCryptoIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCryptoIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: crypto.gradient)
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? crypto.color.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: isSelected ? 20 : 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    crypto.icon,
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: isSelected ? Colors.white : crypto.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    crypto.symbol,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    crypto.name,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDonationCard() {
    final selectedCrypto = cryptoOptions[selectedCryptoIndex];

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: selectedCrypto.gradient),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: selectedCrypto.color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                selectedCrypto.icon,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Send ${selectedCrypto.symbol}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              // One-tap copy button
              GestureDetector(
                onTap: () => _copyAllDetails(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy_all_rounded, color: Colors.white, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'Copy All',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Copy Address',
                  Icons.content_copy_rounded,
                      () => _copyAddress(),
                ),
              ),
              SizedBox(width: 12.w),
              if (selectedCrypto.memo != null) ...[
                Expanded(
                  child: _buildQuickActionButton(
                    'Copy Memo',
                    Icons.note_rounded,
                        () => _copyMemo(),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: _buildQuickActionButton(
                  'Open Wallet',
                  Icons.wallet_rounded,
                      () => _openWallet(),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Address Section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Wallet Address:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _copyAddress(),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.copy_rounded,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  selectedCrypto.address,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),

                // Memo section for TON
                if (selectedCrypto.memo != null) ...[
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Text(
                        'Memo (Required):',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _copyMemo(),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.copy_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      selectedCrypto.memo!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange[100], size: 16.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Important: Include memo for TON transactions',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.orange[100],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.info_rounded,
                  color: const Color(0xFF667eea),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'How to Donate',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          _buildInstructionStep(
            1,
            'Choose your cryptocurrency',
            'Select from 6 available cryptocurrencies',
          ),
          _buildInstructionStep(
            2,
            'Use quick action buttons',
            'Copy address, memo (for TON), or use "Copy All" for convenience',
          ),
          _buildInstructionStep(
            3,
            'Complete in your wallet',
            'Paste the details and send the transaction',
          ),

          SizedBox(height: 16.h),

          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security_rounded,
                  color: const Color(0xFF059669),
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'All donations are secure and processed on the blockchain. Thank you for your support!',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int step, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cryptoOptions[selectedCryptoIndex].gradient,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
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
    );
  }
}

class CryptoOption {
  final String name;
  final String symbol;
  final String address;
  final String icon;
  final Color color;
  final List<Color> gradient;
  final String? memo;

  CryptoOption({
    required this.name,
    required this.symbol,
    required this.address,
    required this.icon,
    required this.color,
    required this.gradient,
    this.memo,
  });
}