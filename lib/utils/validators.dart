import 'package:easy_localization/easy_localization.dart';

class Validators {
  static final RegExp _name = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]{3,}$');
  static final RegExp _phone = RegExp(r'^(010|011|012|015)[0-9]{8}$');
  static final RegExp _email =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static bool isValidName(String v) => _name.hasMatch(v.trim());
  static bool isValidPhone(String v) => _phone.hasMatch(v.trim());
  static bool isValidEmail(String v) => _email.hasMatch(v.trim());
  static bool isSameCity(String? a, String? b) => a != null && a == b;
  static bool isPastDate(DateTime d, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    return DateTime(d.year, d.month, d.day).isBefore(today);
  }

  static bool isValidSeatCount(int n) => n >= 1 && n <= 4;

  static String? required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'required_field'.tr() : null;

  static String? sameCity(String? origin, String? destination) {
    if (destination == null) return 'required_field'.tr();
    return isSameCity(origin, destination) ? 'error_same_city'.tr() : null;
  }

  static String? date(DateTime? d) {
    if (d == null) return 'required_field'.tr();
    return isPastDate(d) ? 'error_past_date'.tr() : null;
  }

  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'required_field'.tr();
    return isValidName(v) ? null : 'error_invalid_name'.tr();
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'required_field'.tr();
    return isValidPhone(v) ? null : 'error_invalid_phone'.tr();
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'required_field'.tr();
    return isValidEmail(v) ? null : 'error_invalid_email'.tr();
  }
}
