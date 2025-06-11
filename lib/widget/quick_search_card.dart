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
              Expanded(
                child: _buildLocationField(
                  'From',
                  controller.selectedDeparture.value.isEmpty 
                    ? 'Select departure' 
                    : controller.selectedDeparture.value,
                  Icons.flight_takeoff,
                  () => _showAirportPicker(true),
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: _swapLocations,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: AppTheme.primaryYellow,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildLocationField(
                  'To',
                  controller.selectedArrival.value.isEmpty 
                    ? 'Select destination' 
                    : controller.selectedArrival.value,
                  Icons.flight_land,
                  () => _showAirportPicker(false),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          Container(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => FlightSearchScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                foregroundColor: AppTheme.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              child: Text(
                'Search Flights',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField(String label, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryYellow,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: value.contains('Select') ? Colors.grey[500] : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
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
            Text(
              isDeparture ? 'Select Departure Airport' : 'Select Arrival Airport',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.airports.length,
                itemBuilder: (context, index) {
                  final airport = controller.airports[index];
                  return ListTile(
                    leading: Icon(
                      Icons.flight,
                      color: AppTheme.primaryYellow,
                    ),
                    title: Text(
                      '${airport.city} (${airport.code})',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(airport.name),
                    onTap: () {
                      if (isDeparture) {
                        controller.selectDepartureAirport(airport);
                      } else {
                        controller.selectArrivalAirport(airport);
                      }
                      Get.back();
                    },
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _swapLocations() {
    final tempDeparture = controller.selectedDepartureAirport.value;
    final tempArrival = controller.selectedArrivalAirport.value;
    
    if (tempDeparture != null && tempArrival != null) {
      controller.selectDepartureAirport(tempArrival);
      controller.selectArrivalAirport(tempDeparture);
    }
  }
}