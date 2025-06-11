import 'package:flight_booking/controller/flight_controller.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class BookingConfirmationScreen extends StatefulWidget {
  @override
  _BookingConfirmationScreenState createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  final FlightController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _checkmarkController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    Future.delayed(Duration(milliseconds: 500), () {
      _checkmarkController.forward();
    });
    
    Future.delayed(Duration(milliseconds: 800), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryYellow,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value * MediaQuery.of(context).size.height),
              child: Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Success animation
                          Container(
                            width: 150.w,
                            height: 150.h,
                            child: Lottie.asset(
                              'assets/animations/success.json',
                              controller: _checkmarkController,
                              repeat: false,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          
                          Text(
                            'Booking Confirmed!',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkBlue,
                            ),
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          Text(
                            'Your flight has been successfully booked.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppTheme.darkBlue.withOpacity(0.7),
                            ),
                          ),
                          
                          SizedBox(height: 32.h),
                          
                          _buildBookingDetails(),
                        ],
                      ),
                    ),
                    
                    _buildActionButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    final flight = controller.selectedFlight.value;
    if (flight == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Booking Reference',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'YJ${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryYellow,
              letterSpacing: 2,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    flight.departureCode,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  Text(
                    flight.departureTime,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.flight_takeoff,
                color: AppTheme.primaryYellow,
                size: 24.sp,
              ),
              Column(
                children: [
                  Text(
                    flight.arrivalCode,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  Text(
                    flight.arrivalTime,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            flight.airline,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () {
              // Download ticket functionality
              Get.snackbar(
                'Download Started',
                'Your e-ticket is being downloaded',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Download E-Ticket',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        Container(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            onPressed: () {
              Get.offAllNamed('/home');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.darkBlue,
              side: BorderSide(color: AppTheme.darkBlue, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'Back to Home',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}