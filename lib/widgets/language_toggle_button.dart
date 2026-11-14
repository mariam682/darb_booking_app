import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: () =>
          context.setLocale(isArabic ? const Locale('en') : const Locale('ar')),
      icon: const Icon(Icons.translate, size: 18),
      label: Text('language_toggle'.tr()),
    );
  }
}
