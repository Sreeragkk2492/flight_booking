import 'package:flight_booking/model/flight_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightController extends GetxController with GetTickerProviderStateMixin {
  var flights = <Flight>[].obs;
  var flightDeals = <FlightDeal>[].obs;
  var airports = <Airport>[].obs;
  var isLoading = false.obs;
  var selectedDeparture = ''.obs;
  var selectedArrival = ''.obs;
  var selectedDepartureAirport = Rxn<Airport>();
  var selectedArrivalAirport = Rxn<Airport>();
  var departureDate = DateTime.now().obs;
  var returnDate = DateTime.now().add(Duration(days: 7)).obs;
  var isRoundTrip = true.obs;
  var passengers = 1.obs;
  var selectedFlight = Rxn<Flight>();

  late AnimationController searchAnimationController;
  late AnimationController priceGraphController;
  late AnimationController loadingController;
  late Animation<double> searchScaleAnimation;
  late Animation<double> priceLineAnimation;
  late Animation<double> rotationAnimation;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    loadFlightDeals();
    loadAirports();
  }

  void _initializeAnimations() {
    searchAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    priceGraphController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    loadingController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    searchScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: searchAnimationController,
      curve: Curves.elasticOut,
    ));

    priceLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: priceGraphController,
      curve: Curves.easeInOutCubic,
    ));

    rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: loadingController,
      curve: Curves.linear,
    ));
  }

  void searchFlights() async {
    if (selectedDepartureAirport.value == null || selectedArrivalAirport.value == null) {
      Get.snackbar(
        'Missing Information',
        'Please select both departure and arrival airports',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    searchAnimationController.forward();
    
    // Simulate API call
    await Future.delayed(Duration(seconds: 3));
    
    flights.value = _generateSampleFlights();
    
    isLoading.value = false;
    priceGraphController.forward();
  }

  List<Flight> _generateSampleFlights() {
    return [
      Flight(
        id: '1',
        airline: 'Emirates',
        airlineLogo: 'https://logos-world.net/wp-content/uploads/2023/01/Emirates-Logo.png',
        departure: selectedDepartureAirport.value!.city,
        arrival: selectedArrivalAirport.value!.city,
        departureTime: '08:00',
        arrivalTime: '12:30',
        duration: '4h 30m',
        price: 299.99,
        departureCode: selectedDepartureAirport.value!.code,
        arrivalCode: selectedArrivalAirport.value!.code,
        isDirect: true,
        stops: 0,
        aircraft: 'Boeing 777-300ER',
        rating: 4.8,
        amenities: ['WiFi', 'Meals', 'Entertainment', 'Power Outlets'],
      ),
      Flight(
        id: '2',
        airline: 'Qatar Airways',
        airlineLogo: 'https://logos-world.net/wp-content/uploads/2023/01/Qatar-Airways-Logo.png',
        departure: selectedDepartureAirport.value!.city,
        arrival: selectedArrivalAirport.value!.city,
        departureTime: '14:15',
        arrivalTime: '18:45',
        duration: '4h 30m',
        price: 349.99,
        departureCode: selectedDepartureAirport.value!.code,
        arrivalCode: selectedArrivalAirport.value!.code,
        isDirect: true,
        stops: 0,
        aircraft: 'Airbus A350-900',
        rating: 4.9,
        amenities: ['WiFi', 'Meals', 'Entertainment', 'Premium Seats'],
      ),
      Flight(
        id: '3',
        airline: 'Turkish Airlines',
        airlineLogo: 'https://logos-world.net/wp-content/uploads/2023/01/Turkish-Airlines-Logo.png',
        departure: selectedDepartureAirport.value!.city,
        arrival: selectedArrivalAirport.value!.city,
        departureTime: '22:00',
        arrivalTime: '06:30+1',
        duration: '8h 30m',
        price: 199.99,
        departureCode: selectedDepartureAirport.value!.code,
        arrivalCode: selectedArrivalAirport.value!.code,
        isDirect: false,
        stops: 1,
        aircraft: 'Boeing 737-800',
        rating: 4.5,
        amenities: ['Meals', 'Entertainment', 'Blanket'],
      ),
    ];
  }

  void loadFlightDeals() {
    flightDeals.value = [
      FlightDeal(
        id: '1',
        destination: 'Paris',
        imageUrl: 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=500',
        originalPrice: 899.99,
        dealPrice: 599.99,
        validity: '7 days left',
        country: 'France',
        description: 'City of Lights awaits you',
      ),
      FlightDeal(
        id: '2',
        destination: 'Tokyo',
        imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=500',
        originalPrice: 1299.99,
        dealPrice: 999.99,
        validity: '3 days left',
        country: 'Japan',
        description: 'Experience the blend of tradition and modernity',
      ),
      FlightDeal(
        id: '3',
        destination: 'Dubai',
        imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=500',
        originalPrice: 699.99,
        dealPrice: 449.99,
        validity: '5 days left',
        country: 'UAE',
        description: 'Luxury shopping and stunning architecture',
      ),
    ];
  }

  void loadAirports() {
    airports.value = [
      Airport(code: 'DXB', name: 'Dubai International Airport', city: 'Dubai', country: 'UAE'),
      Airport(code: 'LHR', name: 'Heathrow Airport', city: 'London', country: 'UK'),
      Airport(code: 'JFK', name: 'John F. Kennedy International Airport', city: 'New York', country: 'USA'),
      Airport(code: 'CDG', name: 'Charles de Gaulle Airport', city: 'Paris', country: 'France'),
      Airport(code: 'NRT', name: 'Narita International Airport', city: 'Tokyo', country: 'Japan'),
      Airport(code: 'SIN', name: 'Singapore Changi Airport', city: 'Singapore', country: 'Singapore'),
      Airport(code: 'DOH', name: 'Hamad International Airport', city: 'Doha', country: 'Qatar'),
      Airport(code: 'IST', name: 'Istanbul Airport', city: 'Istanbul', country: 'Turkey'),
    ];
  }

  void selectDepartureAirport(Airport airport) {
    selectedDepartureAirport.value = airport;
    selectedDeparture.value = '${airport.city} (${airport.code})';
  }

  void selectArrivalAirport(Airport airport) {
    selectedArrivalAirport.value = airport;
    selectedArrival.value = '${airport.city} (${airport.code})';
  }

  void selectFlight(Flight flight) {
    selectedFlight.value = flight;
  }

  @override
  void onClose() {
    searchAnimationController.dispose();
    priceGraphController.dispose();
    loadingController.dispose();
    super.onClose();
  }
}