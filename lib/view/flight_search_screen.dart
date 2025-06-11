import 'package:flight_booking/controller/flight_controller.dart';
import 'package:flight_booking/model/flight_model.dart';
import 'package:flight_booking/theme/theme.dart';
import 'package:flight_booking/view/flightDetailScreen/flight_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class FlightSearchScreen extends StatefulWidget {
  @override
  _FlightSearchScreenState createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen>
    with TickerProviderStateMixin {
  late FlightController controller;
  late AnimationController _searchButtonController;
  late AnimationController _resultsController;
  late AnimationController _filterController;
  late Animation<double> _searchButtonAnimation;
  late Animation<double> _resultsAnimation;
  late Animation<Offset> _filterSlideAnimation;

  String selectedSortOption = 'Price (Low to High)';
  List<String> sortOptions = [
    'Price (Low to High)',
    'Price (High to Low)',
    'Duration (Shortest)',
    'Departure Time',
    'Airline Rating'
  ];

  @override
  void initState() {
    super.initState();
    _initializeController();
    _initializeAnimations();
  }

  void _initializeController() {
    try {
      controller = Get.find<FlightController>();
    } catch (e) {
      controller = Get.put(FlightController());
    }
  }

  void _initializeAnimations() {
    _searchButtonController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _resultsController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _filterController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _searchButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _searchButtonController,
      curve: Curves.easeInOut,
    ));

    _resultsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultsController,
      curve: Curves.easeOutCubic,
    ));

    _filterSlideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _filterController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _searchButtonController.dispose();
    _resultsController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchHeader(),
              _buildSearchForm(),
              _buildFilterSection(),
              _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryYellow,
            AppTheme.primaryYellow.withOpacity(0.8),
          ],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.darkBlue,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Search Flights',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                Text(
                  'Find your perfect flight',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.darkBlue.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.filter_list,
              color: AppTheme.darkBlue,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[800] : Colors.white,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTripTypeToggle(),
          SizedBox(height: 20.h),
          
          Row(
            children: [
              Expanded(child: _buildAirportSelector(true)),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: _swapAirports,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: AppTheme.primaryYellow,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(child: _buildAirportSelector(false)),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          Row(
            children: [
              Expanded(child: _buildDateSelector(true)),
              SizedBox(width: 12.w),
              GetBuilder<FlightController>(
                builder: (ctrl) => ctrl.isRoundTrip.value
                    ? Expanded(child: _buildDateSelector(false))
                    : SizedBox.shrink(),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          _buildPassengerSelector(),
          
          SizedBox(height: 24.h),
          
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildTripTypeToggle() {
    return GetBuilder<FlightController>(
      builder: (ctrl) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.isRoundTrip.value = true;
                  controller.update();
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: controller.isRoundTrip.value
                        ? AppTheme.primaryYellow
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Round Trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: controller.isRoundTrip.value
                          ? AppTheme.darkBlue
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.isRoundTrip.value = false;
                  controller.update();
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: !controller.isRoundTrip.value
                        ? AppTheme.primaryYellow
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'One Way',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: !controller.isRoundTrip.value
                          ? AppTheme.darkBlue
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportSelector(bool isDeparture) {
    return GetBuilder<FlightController>(
      builder: (ctrl) => GestureDetector(
        onTap: () => _showAirportPicker(isDeparture),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDeparture ? 'From' : 'To',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isDeparture 
                    ? (controller.selectedDeparture.value.isEmpty 
                        ? 'Select departure' 
                        : controller.selectedDeparture.value)
                    : (controller.selectedArrival.value.isEmpty 
                        ? 'Select destination' 
                        : controller.selectedArrival.value),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: (isDeparture ? controller.selectedDeparture.value : controller.selectedArrival.value).isEmpty
                      ? Colors.grey[400]
                      : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(bool isDeparture) {
    return GetBuilder<FlightController>(
      builder: (ctrl) => GestureDetector(
        onTap: () => _selectDate(isDeparture),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isDeparture ? 'Departure' : 'Return',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isDeparture
                    ? '${controller.departureDate.value.day}/${controller.departureDate.value.month}/${controller.departureDate.value.year}'
                    : '${controller.returnDate.value.day}/${controller.returnDate.value.month}/${controller.returnDate.value.year}',
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

  Widget _buildPassengerSelector() {
    return GetBuilder<FlightController>(
      builder: (ctrl) => GestureDetector(
        onTap: _showPassengerPicker,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.grey[600], size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Passengers',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${controller.passengers.value} ${controller.passengers.value == 1 ? 'Passenger' : 'Passengers'}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return GetBuilder<FlightController>(
      builder: (ctrl) => AnimatedBuilder(
        animation: _searchButtonAnimation,
        builder: (context, child) => Transform.scale(
          scale: _searchButtonAnimation.value,
          child: Container(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : () {
                _searchButtonController.forward().then((_) {
                  _searchButtonController.reverse();
                  controller.searchFlights();
                  _resultsController.forward();
                  HapticFeedback.mediumImpact();
                });
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
              child: controller.isLoading.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.darkBlue),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Searching...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Search Flights',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return GetBuilder<FlightController>(
      builder: (ctrl) => controller.flights.isNotEmpty
          ? SlideTransition(
              position: _filterSlideAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Row(
                  children: [
                    Text(
                      '${controller.flights.length} flights found',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _showSortOptions,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.primaryYellow),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sort,
                              size: 16.sp,
                              color: AppTheme.primaryYellow,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Sort',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.primaryYellow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildSearchResults() {
    return GetBuilder<FlightController>(
      builder: (ctrl) {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }
        
        if (controller.flights.isEmpty) {
          return _buildEmptyState();
        }
        
        return FadeTransition(
          opacity: _resultsAnimation,
          child: AnimationLimiter(
            child: Column(
              children: [
                for (int index = 0; index < controller.flights.length; index++)
                  AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildFlightCard(controller.flights[index], index),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/loading_plane.json',
            width: 200.w,
            height: 200.h,
            errorBuilder: (context, error, stackTrace) => 
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryYellow),
              ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Searching for the best flights...',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'This may take a few moments',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20.h),
          Text(
            'Ready to find flights?',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Enter your travel details above to search',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(Flight flight, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            controller.selectFlight(flight);
            Get.to(
              () => FlightDetailsScreen(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 500),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'flight_${flight.id}',
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
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
                              color: AppTheme.primaryYellow.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.flight,
                              color: AppTheme.primaryYellow,
                              size: 20.sp,
                            ),
                          ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${flight.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                        Text(
                          'per person',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 16.h),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            flight.departureTime,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            flight.departureCode,
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
                                  height: 1.h,
                                  color: AppTheme.primaryYellow,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryYellow,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.flight,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1.h,
                                  color: AppTheme.primaryYellow,
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
                          if (!flight.isDirect)
                            Container(
                              margin: EdgeInsets.only(top: 4.h),
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
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
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            flight.arrivalTime,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            flight.arrivalCode,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                Row(
                  children: [
                    ...flight.amenities.take(3).map((amenity) => 
                      Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppTheme.primaryYellow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).toList(),
                    if (flight.amenities.length > 3)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '+${flight.amenities.length - 3}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          flight.rating.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _swapAirports() {
    final tempDeparture = controller.selectedDepartureAirport.value;
    final tempDepartureString = controller.selectedDeparture.value;
    
    controller.selectedDepartureAirport.value = controller.selectedArrivalAirport.value;
    controller.selectedDeparture.value = controller.selectedArrival.value;
    
    controller.selectedArrivalAirport.value = tempDeparture;
    controller.selectedArrival.value = tempDepartureString;
    
    HapticFeedback.lightImpact();
  }

  void _showAirportPicker(bool isDeparture) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              isDeparture ? 'Select Departure Airport' : 'Select Destination',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search airports...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              onChanged: (value) {
                // Implement airport search functionality
              },
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: controller.airports.length,
                itemBuilder: (context, index) {
                  final airport = controller.airports[index];
                  return ListTile(
                    leading: Icon(Icons.flight_takeoff, color: AppTheme.primaryYellow),
                    title: Text(airport.name, style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${airport.city}, ${airport.country}'),
                    trailing: Text(airport.code, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryYellow,
                    )),
                    onTap: () {
                      if (isDeparture) {
                        controller.selectedDeparture.value = '${airport.code} - ${airport.city}';
                        controller.selectedDepartureAirport.value = airport;
                      } else {
                        controller.selectedArrival.value = '${airport.code} - ${airport.city}';
                        controller.selectedArrivalAirport.value = airport;
                      }
                      Get.back();
                      HapticFeedback.lightImpact();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _selectDate(bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? controller.departureDate.value : controller.returnDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryYellow,
              onPrimary: AppTheme.darkBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isDeparture) {
        controller.departureDate.value = picked;
        if (controller.returnDate.value.isBefore(picked)) {
          controller.returnDate.value = picked.add(Duration(days: 1));
        }
      } else {
        controller.returnDate.value = picked;
      }
      HapticFeedback.lightImpact();
    }
  }

  void _showPassengerPicker() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Passengers',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Adults', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    IconButton(
                      onPressed: controller.passengers.value > 1
                          ? () {
                              controller.passengers.value--;
                              HapticFeedback.lightImpact();
                            }
                          : null,
                      icon: Icon(Icons.remove_circle_outline),
                      color: AppTheme.primaryYellow,
                    ),
                    Container(
                      width: 40.w,
                      child: Text(
                        '${controller.passengers.value}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.passengers.value < 9
                          ? () {
                              controller.passengers.value++;
                              HapticFeedback.lightImpact();
                            }
                          : null,
                      icon: Icon(Icons.add_circle_outline),
                      color: AppTheme.primaryYellow,
                    ),
                  ],
                ),
              ],
            )),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.darkBlue,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Sort by',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            ...sortOptions.map((option) => 
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(option, style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: selectedSortOption == option
                    ? Icon(Icons.check_circle, color: AppTheme.primaryYellow)
                    : null,
                onTap: () {
                  selectedSortOption = option;
                  Get.back();
                  HapticFeedback.lightImpact();
                },
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }
}