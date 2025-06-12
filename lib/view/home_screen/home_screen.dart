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
  late AnimationController _backgroundAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;
  ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _appBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _iconAnimationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundAnimationController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Setup enhanced animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appBarAnimationController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appBarAnimationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _appBarAnimationController,
      curve: Curves.easeOutBack,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: AppTheme.primaryYellow,
      end: AppTheme.primaryYellow.withOpacity(0.8),
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations with delays for cascade effect
    _appBarAnimationController.forward();
    
    Future.delayed(Duration(milliseconds: 300), () {
      _iconAnimationController.repeat();
    });
    
    Future.delayed(Duration(milliseconds: 500), () {
      _backgroundAnimationController.repeat(reverse: true);
    });
    
    Future.delayed(Duration(milliseconds: 800), () {
      _pulseAnimationController.repeat(reverse: true);
    });

    // Listen to scroll changes
    _scrollController.addListener(() {
      if (_scrollController.offset > 30 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 30 && _isScrolled) {
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
    _backgroundAnimationController.dispose();
    _pulseAnimationController.dispose();
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
      expandedHeight: 120.h, // Reduced from 180.h
      floating: true,
      pinned: true,
      snap: false,
      backgroundColor: _isScrolled 
          ? AppTheme.primaryYellow.withOpacity(0.95)
          : Colors.transparent,
      elevation: _isScrolled ? 12 : 0,
      shadowColor: AppTheme.darkBlue.withOpacity(0.3),
      flexibleSpace: AnimatedBuilder(
        animation: Listenable.merge([
          _appBarAnimationController,
          _backgroundAnimationController,
          _colorAnimation,
        ]),
        builder: (context, child) {
          return FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h), // Reduced bottom padding
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
            background: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _colorAnimation.value ?? AppTheme.primaryYellow,
                    AppTheme.primaryYellow.withOpacity(0.9),
                    AppTheme.primaryYellow.withOpacity(0.6),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryYellow.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Enhanced animated background elements
                  Positioned.fill(
                    child: _buildRichAnimatedBackground(),
                  ),
                  // Floating particles effect
                  Positioned.fill(
                    child: _buildFloatingParticles(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        // Static notification button
        Container(
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.darkBlue,
                  size: 24.sp,
                ),
                // Static notification badge
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14.w,
                      minHeight: 14.w,
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
        // Static profile button
        Container(
          margin: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
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
        AnimatedBuilder(
          animation: _iconAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(sin(_iconAnimationController.value * 2 * pi) * 2, 0),
              child: Text(
                'YellowJet',
                style: TextStyle(
                  fontSize: 22.sp, // Slightly smaller
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlue,
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _pulseAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.1,
              child: Text(
                'Fly with confidence',
                style: TextStyle(
                  fontSize: 10.sp, // Slightly smaller
                  color: AppTheme.darkBlue.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRichAnimatedBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_iconAnimationController, _backgroundAnimationController]),
      builder: (context, child) {
        return CustomPaint(
          painter: RichAnimatedBackgroundPainter(
            animationValue: _iconAnimationController.value,
            secondaryAnimationValue: _backgroundAnimationController.value,
            color: Colors.white.withOpacity(0.15),
            accentColor: Colors.white.withOpacity(0.25),
          ),
          child: Container(),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return CustomPaint(
          painter: FloatingParticlesPainter(
            animationValue: _backgroundAnimationController.value,
            particleColor: Colors.white.withOpacity(0.3),
          ),
          child: Container(),
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: Duration(milliseconds: 800),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: ScaleAnimation(
            scale: 0.8,
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
      ),
    );
  }

  Widget _buildQuickSearchCard() {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: Duration(milliseconds: 800),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: ScaleAnimation(
            scale: 0.8,
            child: QuickSearchCard(),
          ),
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

// Enhanced custom painter for richer animated background elements
class RichAnimatedBackgroundPainter extends CustomPainter {
  final double animationValue;
  final double secondaryAnimationValue;
  final Color color;
  final Color accentColor;

  RichAnimatedBackgroundPainter({
    required this.animationValue,
    required this.secondaryAnimationValue,
    required this.color,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    // Draw multiple layers of animated circles with different speeds
    for (int i = 0; i < 5; i++) {
      final radius = (15 + i * 12) * (1 + animationValue * 0.4);
      final offset = Offset(
        size.width * (0.7 + i * 0.08) + (cos(animationValue * 2 * pi + i) * 20),
        size.height * (0.15 + i * 0.15) + (sin(secondaryAnimationValue * 2 * pi + i) * 15),
      );
      
      // Use different paints for variety
      canvas.drawCircle(offset, radius, i % 2 == 0 ? paint : accentPaint);
    }

    // Draw animated sine waves
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.7);
    
    for (double x = 0; x <= size.width; x += 5) {
      final y1 = size.height * 0.7 + 
          (15 * sin((x / size.width * 4 * pi) + (animationValue * 4 * pi)));
      final y2 = size.height * 0.8 + 
          (20 * cos((x / size.width * 3 * pi) + (secondaryAnimationValue * 3 * pi)));
      
      wavePath.lineTo(x, y1);
    }
    
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();
    
    canvas.drawPath(wavePath, paint..color = color.withOpacity(0.1));

    // Draw rotating geometric shapes
    final center = Offset(size.width * 0.85, size.height * 0.3);
    final rotationAngle = animationValue * 2 * pi;
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    
    // Draw diamond shape
    final diamondPath = Path();
    diamondPath.moveTo(0, -20);
    diamondPath.lineTo(15, 0);
    diamondPath.lineTo(0, 20);
    diamondPath.lineTo(-15, 0);
    diamondPath.close();
    
    canvas.drawPath(diamondPath, accentPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// New painter for floating particles effect
class FloatingParticlesPainter extends CustomPainter {
  final double animationValue;
  final Color particleColor;

  FloatingParticlesPainter({
    required this.animationValue,
    required this.particleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor
      ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 8; i++) {
      final x = (size.width * (0.1 + (i * 0.12))) + 
               (sin(animationValue * 2 * pi + i * 0.5) * 30);
      final y = (size.height * (0.2 + (i * 0.1))) + 
               (cos(animationValue * 1.5 * pi + i * 0.7) * 20);
      
      final radius = (2 + (i % 3)) * (1 + sin(animationValue * 3 * pi + i) * 0.5);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}