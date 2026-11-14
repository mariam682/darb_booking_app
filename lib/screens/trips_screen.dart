import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/booking_args.dart';
import '../models/trip.dart';
import '../services/trip_repository.dart';
import '../utils/formatters.dart';
import '../widgets/language_toggle_button.dart';
import '../widgets/trip_card.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  SearchArgs? _args;
  late Future<List<Trip>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_args == null) {
      _args = ModalRoute.of(context)!.settings.arguments as SearchArgs;
      _future = TripRepository.search(
        originKey: _args!.originKey,
        destinationKey: _args!.destinationKey,
        date: _args!.date,
      );
    }
  }

  Future<void> _book(Trip trip) async {
    // Seat screen returns the chosen seats with Navigator.pop(...)
    final seats = await Navigator.pushNamed<List<int>>(
      context,
      AppRoutes.seats,
      arguments: TripSelection(trip: trip, date: _args!.date),
    );
    if (!mounted || seats == null || seats.isEmpty) return;
    // ...and they are passed on as arguments to the passenger details screen.
    Navigator.pushNamed(
      context,
      AppRoutes.passenger,
      arguments: BookingArgs(trip: trip, date: _args!.date, seats: seats),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeName = context.locale.toString();
    final args = _args!;
    return Scaffold(
      appBar: AppBar(
        title: Text('available_trips'.tr()),
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.all(16),
              child: Text(
                '${args.originKey.tr()} - ${args.destinationKey.tr()}\n${formatDate(args.date, localeName)}',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Trip>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text('${snap.error}'));
                  }
                  final trips = snap.data ?? const <Trip>[];
                  if (trips.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('no_trips_found'.tr(),
                            textAlign: TextAlign.center),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: trips.length,
                    itemBuilder: (_, i) =>
                        TripCard(trip: trips[i], onBook: () => _book(trips[i])),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
