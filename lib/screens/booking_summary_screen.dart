import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/booking_args.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/language_toggle_button.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  static const Duration _morph = Duration(milliseconds: 700);
  static const Duration _fade = Duration(milliseconds: 300);

  bool _confirmed = false;
  String? _ticket;

  void _confirm() {
    setState(() {
      _confirmed = true;
      _ticket = 'DRB-${DateTime.now().millisecondsSinceEpoch % 900000 + 100000}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeName = context.locale.toString();
    final args = ModalRoute.of(context)!.settings.arguments as BookingArgs;
    final trip = args.trip;
    final scheme = Theme.of(context).colorScheme;
    final fullWidth = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      appBar: AppBar(
        title: Text('booking_summary'.tr()),
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _row('origin', trip.originKey.tr()),
                        _row('destination', trip.destinationKey.tr()),
                        _row('date', formatDate(args.date, localeName)),
                        _row('departure_time', trip.departure),
                        _row('arrival_time', trip.arrival),
                        _row('bus_class', trip.busClass.tr()),
                        _row('seats_selected', args.seats.join(', ')),
                        const Divider(height: 24),
                        _row('name', args.passengerName ?? ''),
                        _row('phone', args.phone ?? ''),
                        _row('email', args.email ?? ''),
                        const Divider(height: 24),
                        _row('total_amount', formatPrice(args.total), bold: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _confirmed ? null : _confirm,
                    child: AnimatedContainer(
                      duration: _morph,
                      curve: Curves.easeInOut,
                      width: _confirmed ? 64 : fullWidth,
                      height: 64,
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: _confirmed ? AppTheme.success : scheme.primary,
                        borderRadius: BorderRadius.circular(_confirmed ? 32 : 14),
                      ),
                      child: AnimatedSwitcher(
                        duration: _fade,
                        child: _confirmed
                            ? const Icon(Icons.check,
                                key: ValueKey('ok'), color: Colors.white, size: 36)
                            : Text('confirm_booking'.tr(),
                                key: const ValueKey('confirm'),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  alignment: Alignment.topCenter,
                  child: _confirmed
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Text('success'.tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: AppTheme.success,
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('${'ticket_number'.tr()}: $_ticket',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () => Navigator.popUntil(
                                    context, (route) => route.isFirst),
                                child: Text('search_trip'.tr()),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String labelKey, String value, {bool bold = false}) {
    final style = bold
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(labelKey.tr(), style: style)),
          Expanded(flex: 3, child: Text(value, style: style)),
        ],
      ),
    );
  }
}
