import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/cus_widget/custext.dart';
import 'package:tasbih/pages/tasbih.dart';
import 'package:tasbih/provider/counter_provider.dart';

import '../box/counter_box.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Modern color scheme
  final Color primaryColor = const Color(0xFF6366F1);
  final Color secondaryColor = const Color(0xFF8B5CF6);
  final Color backgroundColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;
  final Color textPrimary = const Color(0xFF1E293B);
  final Color textSecondary = const Color(0xFF64748B);
  final Color accentColor = const Color(0xFF06B6D4);

  late CounterProvider provider;
  String searchQuery = '';
  bool isSearching = false;

  Future<dynamic> loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Data loaded successfully";
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CounterProvider>(context, listen: false);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var box = BoxTasbih.getData().values.toList();
    var box2 = BoxTasbih.getData();

    // Filter based on search
    var filteredBox = box.where((item) {
      return item.tasbihText.toString().toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // Modern App Bar
                SliverAppBar(
                  expandedHeight: 200.h,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
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
                      ),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/img/poster.png'),
                                  fit: BoxFit.cover,
                                  opacity: 0.1,
                                ),
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15.r),
                                      ),
                                      child: Icon(
                                        Icons.history_rounded,
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
                                            'Tasbih History',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${box.length} records saved',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(20.w),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search your tasbih records...',
                          hintStyle: TextStyle(color: textSecondary, fontSize: 14.sp),
                          prefixIcon: Icon(Icons.search_rounded, color: textSecondary),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: textSecondary),
                            onPressed: () => setState(() => searchQuery = ''),
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: cardColor,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 15.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          searchQuery.isEmpty ? 'Recent Records' : 'Search Results',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        if (filteredBox.isNotEmpty)
                          Text(
                            '${filteredBox.length} found',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.all(20.w),
                  sliver: FutureBuilder(
                    future: loadData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (filteredBox.isEmpty) {
                          return SliverToBoxAdapter(
                            child: _buildEmptyState(),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final item = filteredBox[index];
                              final originalIndex = box.indexOf(item);

                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300 + (index * 100)),
                                curve: Curves.easeOutCubic,
                                child: _buildHistoryCard(item, originalIndex, box2),
                              );
                            },
                            childCount: filteredBox.length,
                          ),
                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: _buildLoadingState(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(dynamic item, int index, dynamic box2) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            provider.selectHistory(index);
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, _) => TasbihCounter(),
                transitionsBuilder: (context, animation, _, child) {
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
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with tasbih text and delete button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor.withOpacity(0.1), secondaryColor.withOpacity(0.1)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          item.tasbihText.toString(),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      decoration: BoxDecoration(
                        color: box2.keyAt(index) == provider.keyPre
                            ? Colors.red.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (provider.keyPre != box2.keyAt(index)) {
                            _showDeleteDialog(index);
                          }
                        },
                        icon: Icon(
                          box2.keyAt(index) == provider.keyPre
                              ? Icons.delete_forever_outlined
                              : Icons.delete_outline_rounded,
                          color: box2.keyAt(index) == provider.keyPre
                              ? Colors.red
                              : textSecondary,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Stats Grid
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildStatItem(
                            icon: Icons.flag_outlined,
                            label: 'Limits',
                            value: '${item.limit}',
                            color: accentColor,
                          ),
                          SizedBox(width: 20.w),
                          _buildStatItem(
                            icon: Icons.repeat_rounded,
                            label: 'Laps',
                            value: '${item.laps}',
                            color: primaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          _buildStatItem(
                            icon: Icons.numbers_rounded,
                            label: 'Counts',
                            value: '${item.count}',
                            color: secondaryColor,
                          ),
                          SizedBox(width: 20.w),
                          _buildStatItem(
                            icon: Icons.access_time_rounded,
                            label: 'Time',
                            value: '${item.minute}:${item.second.toString().padLeft(2, '0')}',
                            color: Colors.orange,
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

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48.sp,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            searchQuery.isEmpty ? 'No History Yet' : 'No Results Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            searchQuery.isEmpty
                ? 'Start using Tasbih to see your records here'
                : 'Try different search terms',
            style: TextStyle(
              fontSize: 14.sp,
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
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
            'Loading History...',
            style: TextStyle(
              fontSize: 16.sp,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Delete Record',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this tasbih record?',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.deleteHistory(index);
                setState(() {});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}