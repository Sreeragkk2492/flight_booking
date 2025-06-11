import 'package:flight_booking/controller/flight_controller.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';


class FlightDealsCarousel extends StatelessWidget {
  final FlightController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.flightDeals.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 600),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  width: 280.w,
                  margin: EdgeInsets.only(right: 16.w),
                  child: _buildDealCard(controller.flightDeals[index]),
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildDealCard(deal) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: deal.imageUrl,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryYellow,
                  ),
                ),
              ),
            ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            
            // Content
            Positioned(
              bottom: 16.h,
              left: 16.w,
              right: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.destination,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                         Text(
                    deal.country,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  //       decoration: BoxDecoration(
                  //         color: AppTheme.primaryYellow,
                  //         borderRadius: BorderRadius.circular(20.r),
                  //       ),
                  //       child: Text(
                  //         'From \$${deal.price}',RqQ
                  
                  //         style: TextStyle(
                  //           color: AppTheme.darkBlue,
                  //           fontSize: 14.sp,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //     if (deal.discount > 0)
                  //       Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  //         decoration: BoxDecoration(
                  //           color: Colors.red,
                  //           borderRadius: BorderRadius.circular(12.r),
                  //         ),
                  //         child: Text(
                  //           '${deal.discount}% OFF',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 12.sp,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}