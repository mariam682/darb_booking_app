import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_routes.dart';
import '../models/booking_args.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';
import '../widgets/language_toggle_button.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  void _submit(BookingArgs args) {
    if (!_formKey.currentState!.validate()) return; // blocked until all rules pass
    Navigator.pushNamed(
      context,
      AppRoutes.summary,
      arguments: args.withPassenger(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeName = context.locale.toString();
    final args = ModalRoute.of(context)!.settings.arguments as BookingArgs;
    final trip = args.trip;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('passenger_details'.tr()),
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
                  Card(
                    color: scheme.primaryContainer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${trip.originKey.tr()} - ${trip.destinationKey.tr()}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('${formatDate(args.date, localeName)} • ${trip.departure}'),
                          const SizedBox(height: 4),
                          Text('${'seats_selected'.tr()}: ${args.seats.join(', ')}'),
                          Text('${'total_amount'.tr()}: ${formatPrice(args.total)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration:
                              AppTheme.input('name'.tr(), Icons.person_outline),
                          validator: Validators.name,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          decoration:
                              AppTheme.input('phone'.tr(), Icons.phone_outlined),
                          validator: Validators.phone,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration:
                              AppTheme.input('email'.tr(), Icons.email_outlined),
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 8),
                        FormField<bool>(
                          initialValue: false,
                          validator: (v) =>
                              v == true ? null : 'required_field'.tr(),
                          builder: (state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                                value: state.value ?? false,
                                onChanged: (v) => state.didChange(v),
                                title: Text('terms_conditions'.tr()),
                              ),
                              if (state.hasError)
                                Text(state.errorText!,
                                    style: TextStyle(
                                        color: scheme.error, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _submit(args),
                            child: Text('next'.tr()),
                          ),
                        ),
                      ],
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
