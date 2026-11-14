import 'package:flutter/widgets.dart';

import 'screens/booking_summary_screen.dart';
import 'screens/passenger_details_screen.dart';
import 'screens/search_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'screens/trips_screen.dart';

class AppRoutes {
  static const search = '/';
  static const trips = '/trips';
  static const seats = '/seats';
  static const passenger = '/passenger';
  static const summary = '/summary';

  static Map<String, WidgetBuilder> get routes => {
        search: (_) => const SearchScreen(),
        trips: (_) => const TripsScreen(),
        seats: (_) => const SeatSelectionScreen(),
        passenger: (_) => const PassengerDetailsScreen(),
        summary: (_) => const BookingSummaryScreen(),
      };
}
