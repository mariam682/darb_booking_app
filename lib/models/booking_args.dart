import 'trip.dart';

class SearchArgs {
  final String originKey;
  final String destinationKey;
  final DateTime date;
  const SearchArgs({
    required this.originKey,
    required this.destinationKey,
    required this.date,
  });
}

class TripSelection {
  final Trip trip;
  final DateTime date;
  const TripSelection({required this.trip, required this.date});
}

class BookingArgs {
  final Trip trip;
  final DateTime date;
  final List<int> seats;
  final String? passengerName;
  final String? phone;
  final String? email;

  const BookingArgs({
    required this.trip,
    required this.date,
    required this.seats,
    this.passengerName,
    this.phone,
    this.email,
  });

  int get total => trip.priceEgp * seats.length;

  BookingArgs withPassenger({
    required String name,
    required String phone,
    required String email,
  }) =>
      BookingArgs(
        trip: trip,
        date: date,
        seats: seats,
        passengerName: name,
        phone: phone,
        email: email,
      );
}
