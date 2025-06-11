import 'package:flight_booking/view/bookingConfirmation/booking_confirmation_screen.dart';
import 'package:flight_booking/view/flightDetailScreen/flight_detail_screen.dart';
import 'package:flight_booking/view/flight_search_screen.dart';
import 'package:flight_booking/view/home_screen/home_screen.dart';
import 'package:flight_booking/view/splash_screen/splash_screen.dart';
import 'package:get/get.dart';


class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String flightSearch = '/flight-search';
  static const String flightDetails = '/flight-details';
  static const String bookingConfirmation = '/booking-confirmation';

  static final routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: flightSearch,
      page: () => FlightSearchScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: flightDetails,
      page: () => FlightDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: bookingConfirmation,
      page: () => BookingConfirmationScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}