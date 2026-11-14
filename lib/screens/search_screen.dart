import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/booking_args.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';
import '../widgets/language_toggle_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _cities = [
    'cairo',
    'alexandria',
    'luxor',
    'aswan',
    'hurghada',
    'sharm_el_sheikh',
  ];

  final _formKey = GlobalKey<FormState>();
  final _destKey = GlobalKey<FormFieldState<String>>();
  String? _origin;
  String? _destination;
  DateTime? _date;

  Future<void> _pickDate(FormFieldState<DateTime> field) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? today,
      firstDate: today, // past dates are not selectable
      lastDate: today.add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _date = picked);
      field.didChange(picked);
    }
  }

  void _search() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushNamed(
      context,
      AppRoutes.trips,
      arguments: SearchArgs(
        originKey: _origin!,
        destinationKey: _destination!,
        date: _date!,
      ),
    );
  }

  List<DropdownMenuItem<String>> _items() => _cities
      .map((k) => DropdownMenuItem<String>(value: k, child: Text(k.tr())))
      .toList();

  @override
  Widget build(BuildContext context) {
    final localeName = context.locale.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.seed, Color(0xFF14B8A6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_bus,
                            color: Colors.white, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'search_trip'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration:
                                  AppTheme.input('origin'.tr(), Icons.trip_origin),
                              items: _items(),
                              validator: (v) =>
                                  v == null ? 'required_field'.tr() : null,
                              onChanged: (v) {
                                setState(() => _origin = v);
                                // flag "same city" immediately
                                if (_destination != null) {
                                  _destKey.currentState?.validate();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              key: _destKey,
                              isExpanded: true,
                              decoration: AppTheme.input(
                                  'destination'.tr(), Icons.location_on),
                              items: _items(),
                              validator: (v) => Validators.sameCity(_origin, v),
                              onChanged: (v) => setState(() => _destination = v),
                            ),
                            const SizedBox(height: 16),
                            FormField<DateTime>(
                              validator: (_) => Validators.date(_date),
                              builder: (field) => InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _pickDate(field),
                                child: InputDecorator(
                                  isEmpty: _date == null,
                                  decoration: AppTheme.input(
                                          'date'.tr(), Icons.calendar_month)
                                      .copyWith(errorText: field.errorText),
                                  child: Text(_date == null
                                      ? ''
                                      : formatDate(_date!, localeName)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _search,
                                icon: const Icon(Icons.search),
                                label: Text('search_trip'.tr()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
