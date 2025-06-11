import 'package:flight_booking/controller/flight_controller.dart';
import 'package:flight_booking/model/flight_model.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flight_booking/view/bookingConfirmation/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animations/animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

class FlightDetailsScreen extends StatefulWidget {
  @override
  _FlightDetailsScreenState createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen>
    with TickerProviderStateMixin {
  final FlightController controller = Get.find();
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);

    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final flight = controller.selectedFlight.value;
        if (flight == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/loading_plane.json',
                  width: 200.w,
                  height: 200.h,
                  errorBuilder: (context, error, stackTrace) => 
                    CircularProgressIndicator(),
                ),
                SizedBox(height: 20.h),
                Text('Loading flight details...'),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            _buildAnimatedSliverAppBar(flight),
            SliverToBoxAdapter(
              child: AnimationLimiter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        _buildFlightSummary(flight),
                        SizedBox(height: 24.h),
                        _buildAnimatedFlightTimeline(flight),
                        SizedBox(height: 24.h),
                        _buildAnimatedAmenities(flight),
                        SizedBox(height: 24.h),
                        _buildAnimatedPriceBreakdown(flight),
                        SizedBox(height: 24.h),
                        _buildAnimatedBookButton(flight),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAnimatedSliverAppBar(Flight flight) {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      backgroundColor: AppTheme.primaryYellow,
      flexibleSpace: FlexibleSpaceBar(
        title: SlideTransition(
          position: _slideAnimation,
          child: Text(
            flight.airline,
            style: TextStyle(
              color: AppTheme.darkBlue,
              fontWeight: FontWeight.bold,
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
                AppTheme.primaryYellow.withOpacity(0.8),
                Colors.orange.withOpacity(0.6),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated background particles
              ...List.generate(20, (index) => Positioned(
                left: (index * 50.0) % 400,
                top: (index * 30.0) % 200,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) => Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 4.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )),
              // Main airline logo with pulse animation
              Center(
                child: Hero(
                  tag: 'flight_${flight.id}',
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: flight.airlineLogo,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.flight,
                              size: 60.sp,
                              color: AppTheme.darkBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightSummary(Flight flight) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, action) => Container(), // Detail page
      closedElevation: 0,
      closedBuilder: (context, action) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryYellow.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLocationInfo(
                  flight.departureCode,
                  flight.departure,
                  flight.departureTime,
                  true,
                ),
                _buildFlightPath(flight),
                _buildLocationInfo(
                  flight.arrivalCode,
                  flight.arrival,
                  flight.arrivalTime,
                  false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String code, String city, String time, bool isDeparture) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(isDeparture ? -50 * (1 - value) : 50 * (1 - value), 0),
        child: Opacity(
          opacity: value,
          child: Column(
            children: [
              Text(
                code,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                city,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                time,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightPath(Flight flight) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100.w * value,
                height: 2.h,
                color: AppTheme.primaryYellow,
              ),
              Transform.translate(
                offset: Offset(50.w * value - 25.w, 0),
                child: Icon(
                  Icons.flight,
                  color: AppTheme.primaryYellow,
                  size: 30.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            flight.duration,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          if (!flight.isDirect)
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${flight.stops} stop${flight.stops > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFlightTimeline(Flight flight) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryYellow.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flight Timeline',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(3, (index) {
            bool isStart = index == 0;
            bool isEnd = index == 2;
            bool isStop = index == 1 && !flight.isDirect;
            
            if (isStop && flight.isDirect) return SizedBox.shrink();
            
            String time = isStart ? flight.departureTime : 
                         isEnd ? flight.arrivalTime : '${flight.departureTime} + 2h';
            String location = isStart ? '${flight.departure} (${flight.departureCode})' :
                             isEnd ? '${flight.arrival} (${flight.arrivalCode})' : 'Layover Airport';
            
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 600 + (index * 200)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Transform.translate(
                offset: Offset(-30 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: _buildTimelineItem(
                    time: time,
                    location: location,
                    isStart: isStart,
                    isEnd: isEnd,
                    isStop: isStop,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String location,
    bool isStart = false,
    bool isEnd = false,
    bool isStop = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: isStart || isEnd ? AppTheme.primaryYellow : Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isStart || isEnd ? AppTheme.primaryYellow : Colors.orange)
                        .withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            if (!isEnd)
              Container(
                width: 2.w,
                height: 30.h,
                color: Colors.grey[300],
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                location,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              if (isStop)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Layover: 2h 30m',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedAmenities(Flight flight) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryYellow.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities & Services',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 8.h,
              ),
              itemCount: flight.amenities.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: MouseRegion(
                        onEnter: (_) {},
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppTheme.primaryYellow.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 400),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) => Transform.scale(
                                  scale: value,
                                  child: Icon(
                                    _getAmenityIcon(flight.amenities[index]),
                                    color: AppTheme.primaryYellow,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  flight.amenities[index],
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPriceBreakdown(Flight flight) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryYellow.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(4, (index) {
            List<Map<String, dynamic>> priceItems = [
              {'label': 'Base Fare', 'amount': flight.price, 'isTotal': false},
              {'label': 'Taxes & Fees', 'amount': flight.price * 0.15, 'isTotal': false},
              {'label': 'Service Charge', 'amount': 25.0, 'isTotal': false},
              {'label': 'Total', 'amount': flight.price + (flight.price * 0.15) + 25.0, 'isTotal': true},
            ];
            
            if (index == 3) {
              return Column(
                children: [
                  Divider(thickness: 1, color: Colors.grey[300]),
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) => Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: _buildPriceRow(
                          priceItems[index]['label'],
                          priceItems[index]['amount'],
                          isTotal: priceItems[index]['isTotal'],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Transform.translate(
                offset: Offset(20 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: _buildPriceRow(
                    priceItems[index]['label'],
                    priceItems[index]['amount'],
                    isTotal: priceItems[index]['isTotal'],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnimatedBookButton(Flight flight) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () {
              // Add haptic feedback
              Get.to(
                () => BookingConfirmationScreen(),
                transition: Transition.rightToLeftWithFade,
                duration: Duration(milliseconds: 500),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              foregroundColor: AppTheme.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 8,
              shadowColor: AppTheme.primaryYellow.withOpacity(0.5),
            ),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.05,
                child: Text(
                  'Book Now - \$${(flight.price + (flight.price * 0.15) + 25.0).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'meals':
        return Icons.restaurant;
      case 'entertainment':
        return Icons.tv;
      case 'power outlets':
        return Icons.power;
      case 'premium seats':
        return Icons.airline_seat_recline_extra;
      case 'blanket':
        return Icons.checkroom;
      default:
        return Icons.check_circle;
    }
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryYellow : null,
            ),
          ),
        ],
      ),
    );
  }
}