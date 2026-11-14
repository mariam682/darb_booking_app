class Trip {
  final String id;
  final String originKey;
  final String destinationKey;
  final String busClass; // 'economy' | 'business' (also a localization key)
  final String departure; // HH:mm
  final String arrival; // HH:mm
  final String templateDate; // yyyy-MM-dd of the sample day in trips.json
  final int durationMinutes;
  final int priceEgp;
  final int totalSeats;
  final List<int> availableSeats;

  const Trip({
    required this.id,
    required this.originKey,
    required this.destinationKey,
    required this.busClass,
    required this.departure,
    required this.arrival,
    required this.templateDate,
    required this.durationMinutes,
    required this.priceEgp,
    required this.totalSeats,
    required this.availableSeats,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    final dep = json['departure_time'] as String; // 2026-11-05T06:00:00+02:00
    final arr = json['arrival_time'] as String;
    final seats = List<int>.from(json['available_seats'] as List)..sort();
    return Trip(
      id: json['trip_id'] as String,
      originKey: json['origin_key'] as String,
      destinationKey: json['destination_key'] as String,
      busClass: json['bus_class'] as String,
      departure: dep.substring(11, 16),
      arrival: arr.substring(11, 16),
      templateDate: dep.substring(0, 10),
      durationMinutes: json['duration_minutes'] as int,
      priceEgp: json['price_egp'] as int,
      totalSeats: json['total_seats'] as int,
      availableSeats: seats,
    );
  }

  bool get isBusiness => busClass == 'business';
  int get remainingSeats => availableSeats.length;
  bool get isSoldOut => availableSeats.isEmpty;
}
