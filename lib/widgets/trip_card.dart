import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../utils/formatters.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onBook;
  const TripCard({super.key, required this.trip, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context).name == 'rtl';
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _time(context, 'departure_time', trip.departure,
                      CrossAxisAlignment.start),
                ),
                Column(
                  children: [
                    Text(formatDuration(trip.durationMinutes),
                        style: Theme.of(context).textTheme.bodySmall),
                    Icon(rtl ? Icons.arrow_back : Icons.arrow_forward,
                        color: scheme.primary),
                  ],
                ),
                Expanded(
                  child: _time(context, 'arrival_time', trip.arrival,
                      CrossAxisAlignment.end),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(
                      trip.isBusiness
                          ? Icons.workspace_premium
                          : Icons.event_seat,
                      size: 18),
                  label: Text(trip.busClass.tr()),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  avatar:
                      const Icon(Icons.airline_seat_recline_normal, size: 18),
                  label: trip.isSoldOut
                      ? Text('sold_out'.tr())
                      : Text(
                          '${'remaining_seats'.tr()}: ${trip.remainingSeats}'),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatPrice(trip.priceEgp),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: trip.isSoldOut ? null : onBook,
                  child:
                      Text(trip.isSoldOut ? 'sold_out'.tr() : 'book_now'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _time(BuildContext context, String labelKey, String time,
      CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall),
        Text(time,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
