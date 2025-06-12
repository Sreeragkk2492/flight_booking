import 'package:flight_booking/controller/flight_controller.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flight_booking/view/flight_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuickSearchCard extends StatelessWidget {
  final FlightController controller = Get.find();

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            children: [
              // Wrap departure field with Obx for reactive updates
              Expanded(
                child: Obx(() => _buildLocationField(
                  'From',
                  controller.selectedDeparture.value.isEmpty 
                    ? 'Select departure' 
                    : controller.selectedDeparture.value,
                  Icons.flight_takeoff,
                  () => _showAirportPicker(true),
                )),
              ),
              SizedBox(width: 16.w),
              
              // Enhanced swap button with animation
              Obx(() => GestureDetector(
                onTap: controller.canSwap ? () => controller.swapAirports() : null,
                child: AnimatedBuilder(
                  animation: controller.swapAnimationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: controller.swapRotationAnimation.value * 3.14159, // 180 degrees
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: controller.canSwap 
                            ? AppTheme.primaryYellow.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.swap_horiz,
                          color: controller.canSwap 
                            ? AppTheme.primaryYellow 
                            : Colors.grey,
                          size: 20.sp,
                        ),
                      ),
                    );
                  },
                ),
              )),
              
              SizedBox(width: 16.w),
              
              // Wrap arrival field with Obx for reactive updates
              Expanded(
                child: Obx(() => _buildLocationField(
                  'To',
                  controller.selectedArrival.value.isEmpty 
                    ? 'Select destination' 
                    : controller.selectedArrival.value,
                  Icons.flight_land,
                  () => _showAirportPicker(false),
                )),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          // Enhanced search button with validation
          Obx(() => Container(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: controller.canSwap ? () {
                Get.to(() => FlightSearchScreen());
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.canSwap 
                  ? AppTheme.primaryYellow 
                  : Colors.grey[300],
                foregroundColor: controller.canSwap 
                  ? AppTheme.darkBlue 
                  : Colors.grey[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: controller.canSwap ? 2 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isLoading.value) ...[
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.darkBlue,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    controller.isLoading.value ? 'Searching...' : 'Search Flights',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLocationField(String label, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: value.contains('Select') 
              ? Colors.grey[300]! 
              : AppTheme.primaryYellow.withOpacity(0.5),
            width: value.contains('Select') ? 1 : 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    color: value.contains('Select') 
                      ? Colors.grey[400] 
                      : AppTheme.primaryYellow,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: value.contains('Select') 
                        ? Colors.grey[500] 
                        : (Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAirportPicker(bool isDeparture) {
    Get.bottomSheet(
      Container(
        height: 400.h,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              isDeparture ? 'Select Departure Airport' : 'Select Arrival Airport',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.airports.length,
                itemBuilder: (context, index) {
                  final airport = controller.airports[index];
                  final isSelected = isDeparture 
                    ? controller.selectedDepartureAirport.value?.code == airport.code
                    : controller.selectedArrivalAirport.value?.code == airport.code;
                  
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? AppTheme.primaryYellow.withOpacity(0.1)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: isSelected 
                        ? Border.all(color: AppTheme.primaryYellow, width: 1)
                        : null,
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? AppTheme.primaryYellow 
                            : AppTheme.primaryYellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.flight,
                          color: isSelected ? Colors.white : AppTheme.primaryYellow,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        '${airport.city} (${airport.code})',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                            ? AppTheme.primaryYellow 
                            : (Get.isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      subtitle: Text(
                        airport.name,
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      trailing: isSelected 
                        ? Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryYellow,
                          )
                        : null,
                      onTap: () {
                        if (isDeparture) {
                          controller.selectDepartureAirport(airport);
                        } else {
                          controller.selectArrivalAirport(airport);
                        }
                        Get.back();
                      },
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}