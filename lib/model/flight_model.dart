class Flight {
  final String id;
  final String airline;
  final String airlineLogo;
  final String departure;
  final String arrival;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;
  final String departureCode;
  final String arrivalCode;
  final bool isDirect;
  final int stops;
  final String aircraft;
  final double rating;
  final List<String> amenities;

  Flight({
    required this.id,
    required this.airline,
    required this.airlineLogo,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.departureCode,
    required this.arrivalCode,
    this.isDirect = true,
    this.stops = 0,
    required this.aircraft,
    required this.rating,
    required this.amenities,
  });
}

class FlightDeal {
  final String id;
  final String destination;
  final String imageUrl;
  final double originalPrice;
  final double dealPrice;
  final String validity;
  final String country;
  final String description;

  FlightDeal({
    required this.id,
    required this.destination,
    required this.imageUrl,
    required this.originalPrice,
    required this.dealPrice,
    required this.validity,
    required this.country,
    required this.description,
  });
}

class Airport {
  final String code;
  final String name;
  final String city;
  final String country;

  Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
  });
}