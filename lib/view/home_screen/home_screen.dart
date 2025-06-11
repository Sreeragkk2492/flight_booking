// import 'package:flight_booking/controller/flight_controller.dart';
// import 'package:flight_booking/theme/theme.dart';
// import 'package:flight_booking/widget/flight_deal_carousel.dart';
// import 'package:flight_booking/widget/quick_search_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatelessWidget {
//   final FlightController controller = Get.put(FlightController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: AnimationLimiter(
//           child: CustomScrollView(
//             slivers: [
//               _buildSliverAppBar(),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.all(20.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildWelcomeSection(),
//                       SizedBox(height: 24.h),
//                       _buildQuickSearchCard(),
//                       SizedBox(height: 32.h),
//                       _buildSectionTitle('Flight Deals', 'View All'),
//                       SizedBox(height: 16.h),
//                       FlightDealsCarousel(),
//                       SizedBox(height: 32.h),
//                       _buildSectionTitle('Popular Destinations', ''),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 120.h,
//       floating: true,
//       pinned: false,
//       backgroundColor: AppTheme.primaryYellow,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 AppTheme.primaryYellow,
//                 AppTheme.primaryYellow.withOpacity(0.8),
//               ],
//             ),
//           ),
//           child: Center(
//             child: Text(
//               'YellowJet',
//               style: TextStyle(
//                 fontSize: 32.sp,
//                 fontWeight: FontWeight.bold,
//                 color: AppTheme.darkBlue,
//               ),
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {},
//           icon: Icon(
//             Icons.notifications_outlined,
//             color: AppTheme.darkBlue,
//           ),
//         ),
//         IconButton(
//           onPressed: () {},
//           icon: Icon(
//             Icons.account_circle_outlined,
//             color: AppTheme.darkBlue,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return AnimationConfiguration.staggeredList(
//       position: 0,
//       duration: Duration(milliseconds: 600),
//       child: SlideAnimation(
//         verticalOffset: 30.0,
//         child: FadeInAnimation(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Where to next?',
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 'Discover amazing destinations with AI-powered recommendations',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickSearchCard() {
//     return AnimationConfiguration.staggeredList(
//       position: 1,
//       duration: Duration(milliseconds: 600),
//       child: SlideAnimation(
//         verticalOffset: 30.0,
//         child: FadeInAnimation(
//           child: QuickSearchCard(),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, String actionText) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         if (actionText.isNotEmpty)
//           TextButton(
//             onPressed: () {},
//             child: Text(
//               actionText,
//               style: TextStyle(
//                 color: AppTheme.primaryYellow,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'dart:math';

import 'package:flight_booking/controller/flight_controller.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flight_booking/view/flightDetailScreen/flight_detail_screen.dart';
import 'package:flight_booking/widget/flight_deal_carousel.dart';
import 'package:flight_booking/widget/quick_search_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final FlightController controller = Get.put(FlightController());
  late AnimationController _appBarAnimationController;
  late AnimationController _iconAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _appBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _iconAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appBarAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appBarAnimationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _appBarAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _appBarAnimationController.forward();
    _iconAnimationController.repeat(reverse: true);

    // Listen to scroll changes
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _appBarAnimationController.dispose();
    _iconAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimationLimiter(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildEnhancedSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      SizedBox(height: 24.h),
                      _buildQuickSearchCard(),
                      SizedBox(height: 32.h),
                      _buildSectionTitle('Flight Deals', 'View All'),
                      SizedBox(height: 16.h),
                      FlightDealsCarousel(),
                      SizedBox(height: 32.h),
                      _buildSectionTitle('Popular Destinations', ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedSliverAppBar() {
    return SliverAppBar.large(
      expandedHeight: 180.h,
      floating: true,
      pinned: true,
      snap: false,
      backgroundColor: _isScrolled 
          ? AppTheme.primaryYellow.withOpacity(0.95)
          : AppTheme.primaryYellow,
      elevation: _isScrolled ? 8 : 0,
      shadowColor: AppTheme.darkBlue.withOpacity(0.2),
      flexibleSpace: AnimatedBuilder(
        animation: _appBarAnimationController,
        builder: (context, child) {
          return FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsets.only(left: 20.w, bottom: 20.h),
            title: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildAppBarTitle(),
                ),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryYellow,
                    AppTheme.primaryYellow.withOpacity(0.9),
                    AppTheme.primaryYellow.withOpacity(0.7),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Animated background elements
                  Positioned.fill(
                    child: _buildAnimatedBackground(),
                  ),
                  // Welcome overlay
                  // Positioned(
                  //   bottom: 60.h,
                  //   left: 20.w,
                  //   right: 20.w,
                  //   child: FadeTransition(
                  //     opacity: _fadeAnimation,
                  //     child: _buildWelcomeOverlay(),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        AnimatedBuilder(
          animation: _iconAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_iconAnimationController.value * 0.1),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  onPressed: () {
                    // Add haptic feedback
                    HapticFeedback.lightImpact();
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.darkBlue,
                        size: 24.sp,
                      ),
                      // Notification badge
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12.w,
                            minHeight: 12.w,
                          ),
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            icon: Icon(
              Icons.account_circle_outlined,
              color: AppTheme.darkBlue,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YellowJet',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBlue,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Fly with confidence',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTheme.darkBlue.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _iconAnimationController,
      builder: (context, child) {
        return CustomPaint(
          painter: AnimatedBackgroundPainter(
            animationValue: _iconAnimationController.value,
            color: Colors.white.withOpacity(0.1),
          ),
          child: Container(),
        );
      },
    );
  }

  Widget _buildWelcomeOverlay() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.flight_takeoff,
              color: AppTheme.darkBlue,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Ready for takeoff?',
          //         style: TextStyle(
          //           fontSize: 14.sp,
          //           fontWeight: FontWeight.bold,
          //           color: AppTheme.darkBlue,
          //         ),
          //       ),
          //       Text(
          //         'Book your next adventure',
          //         style: TextStyle(
          //           fontSize: 12.sp,
          //           color: AppTheme.darkBlue.withOpacity(0.8),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where to next?',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Discover amazing destinations with AI-powered recommendations',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSearchCard() {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: QuickSearchCard(),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: () {
              Get.to(FlightDetailsScreen());
            },
            child: Text(
              actionText,
              style: TextStyle(
                color: AppTheme.primaryYellow,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

// Custom painter for animated background elements
class AnimatedBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  AnimatedBackgroundPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw animated circles
    for (int i = 0; i < 3; i++) {
      final radius = (20 + i * 15) * (1 + animationValue * 0.3);
      final offset = Offset(
        size.width * (0.8 + i * 0.1),
        size.height * (0.2 + i * 0.2) + (animationValue * 10),
      );
      canvas.drawCircle(offset, radius, paint);
    }

    // Draw animated path
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    
    for (double x = 0; x <= size.width; x += 20) {
      final y = size.height * 0.8 + 
          (20 * sin((x / size.width * 2 * pi) + (animationValue * 2 * pi)));
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}