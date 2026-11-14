import 'package:easy_localization/easy_localization.dart';

String formatDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  final parts = <String>[
    if (h > 0) '$h ${'hours_short'.tr()}',
    if (m > 0) '$m ${'minutes_short'.tr()}',
  ];
  return parts.join(' ');
}

String formatPrice(int egp) => '$egp ${'currency'.tr()}';

String formatDate(DateTime d, String localeName) =>
    DateFormat.yMMMEd(localeName).format(d);
