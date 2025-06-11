import 'package:flight_booking/controller/flight_controller.dart';
import 'package:flight_booking/model/flight_model.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flight_booking/view/flightDetailScreen/flight_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';


class AnimatedFlightCard extends StatelessWidget {
  final Flight flight;
  final int index;

  const AnimatedFlightCard({
    Key? key,
    required this.flight,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: Duration(milliseconds: 800),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            child: Hero(
              tag: 'flight_${flight.id}',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.find<FlightController>().selectFlight(flight);
                    Get.to(() => FlightDetailsScreen());
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
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
                      border: Border.all(
                        color: AppTheme.primaryYellow.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildFlightHeader(),
                        SizedBox(height: 16.h),
                        _buildFlightRoute(),
                        SizedBox(height: 16.h),
                        _buildFlightDetails(),
                        SizedBox(height: 16.h),
                        _buildPriceAndBook(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlightHeader() {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          child: CachedNetworkImage(
            imageUrl: flight.airlineLogo,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.flight, color: Colors.grey[600]),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.flight, color: AppTheme.primaryYellow),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flight.airline,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                flight.aircraft,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: flight.isDirect ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            flight.isDirect ? 'Direct' : '${flight.stops} Stop${flight.stops > 1 ? 's' : ''}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlightRoute() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                flight.departureCode,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
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
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryYellow,
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Icon(
                      Icons.flight_takeoff,
                      color: AppTheme.primaryYellow,
                      size: 20.sp,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryYellow,
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                flight.duration,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                flight.arrivalCode,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
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
        ),
      ],
    );
  }

  Widget _buildFlightDetails() {
    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              flight.rating.toString(),
              style: TextStyle(fontSize: 12.sp),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Wrap(
            spacing: 8.w,
            children: flight.amenities.take(3).map((amenity) => Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                amenity,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppTheme.darkBlue,
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndBook() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'from',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '\$${flight.price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryYellow,
              ),
            ),
          ],
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            Get.find<FlightController>().selectFlight(flight);
            Get.to(() => FlightDetailsScreen());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryYellow,
            foregroundColor: AppTheme.darkBlue,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
          child: Text(
            'Select',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}