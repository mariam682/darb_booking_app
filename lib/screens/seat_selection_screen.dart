import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/booking_args.dart';
import '../models/trip.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';
import '../widgets/language_toggle_button.dart';
import '../widgets/seat_tile.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  static const int _maxSeats = 4;
  final Set<int> _selected = <int>{};
  bool _showError = false;

  TripSelection get _sel =>
      ModalRoute.of(context)!.settings.arguments as TripSelection;

  /// Economy: 2+2 with a 5-seat back row. Business: 2+1. `null` = aisle.
  List<List<int?>> _buildRows(Trip trip) {
    final perRow = trip.isBusiness ? 3 : 4;
    final hasBackRow = !trip.isBusiness && trip.totalSeats % 4 == 1;
    final regular = hasBackRow ? trip.totalSeats - 5 : trip.totalSeats;
    final rows = <List<int?>>[];
    var n = 1;
    while (n <= regular) {
      final row = <int?>[];
      for (var i = 0; i < perRow; i++) {
        if (i == 2) row.add(null);
        if (n <= regular) row.add(n++);
      }
      rows.add(row);
    }
    if (hasBackRow) {
      rows.add([for (var i = 0; i < 5; i++) n++]);
    }
    return rows;
  }

  void _toggle(Trip trip, int seat) {
    if (!trip.availableSeats.contains(seat)) return; // booked seats: ignore
    setState(() {
      if (_selected.contains(seat)) {
        _selected.remove(seat);
        _showError = false;
      } else if (_selected.length >= _maxSeats) {
        _showError = true;
      } else {
        _selected.add(seat);
        _showError = false;
      }
    });
  }

  void _next() {
    if (!Validators.isValidSeatCount(_selected.length)) {
      setState(() => _showError = true);
      return;
    }
    // return the chosen seats to the trips screen
    Navigator.pop(context, _selected.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // rebuild when the language changes
    final trip = _sel.trip;
    final rows = _buildRows(trip);
    final sorted = _selected.toList()..sort();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('seat_selection'.tr()),
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final size = math.min(
                      46.0, math.max(28.0, (c.maxWidth - 32 - 48 - 40) / 5.5));
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('select_seat'.tr(),
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _legend('seat_available', SeatState.available),
                            _legend('seat_unavailable', SeatState.unavailable),
                            _legend('seat_selected', SeatState.selected),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: scheme.primary, width: 2),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.airline_seat_recline_extra,
                                      color: scheme.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text('driver'.tr(),
                                          overflow: TextOverflow.ellipsis)),
                                  Flexible(
                                    child: Text('front_of_bus'.tr(),
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              for (final row in rows)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (final s in row)
                                      if (s == null)
                                        SizedBox(width: size)
                                      else
                                        SeatTile(
                                          number: s,
                                          size: size,
                                          state: !trip.availableSeats.contains(s)
                                              ? SeatState.unavailable
                                              : _selected.contains(s)
                                                  ? SeatState.selected
                                                  : SeatState.available,
                                          onTap: () => _toggle(trip, s),
                                        ),
                                  ],
                                ),
                              const Divider(height: 24),
                              Text('rear_of_bus'.tr(),
                                  style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Material(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('error_select_seat'.tr(),
                            style: TextStyle(color: scheme.error)),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('seats_selected'.tr(),
                                  style: Theme.of(context).textTheme.bodySmall),
                              Text(sorted.isEmpty ? '—' : sorted.join(', '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('total_amount'.tr(),
                                style: Theme.of(context).textTheme.bodySmall),
                            Text(formatPrice(trip.priceEgp * _selected.length),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _next,
                        child: Text('next'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend(String key, SeatState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SeatTile(number: 0, size: 24, state: state, onTap: () {}),
        Text(key.tr()),
      ],
    );
  }
}
