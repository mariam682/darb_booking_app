import 'package:darb_booking_app/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('name', () {
    test('accepts Latin and Arabic', () {
      expect(Validators.isValidName('Mariam Ali'), isTrue);
      expect(Validators.isValidName('مريم علي'), isTrue);
    });
    test('rejects short, digits, symbols', () {
      expect(Validators.isValidName('Al'), isFalse);
      expect(Validators.isValidName('Ali1'), isFalse);
      expect(Validators.isValidName('Ali!'), isFalse);
    });
  });

  group('phone', () {
    test('valid', () {
      expect(Validators.isValidPhone('01012345678'), isTrue);
      expect(Validators.isValidPhone('01198765432'), isTrue);
    });
    test('invalid', () {
      expect(Validators.isValidPhone('01312345678'), isFalse);
      expect(Validators.isValidPhone('0101234567'), isFalse);
    });
  });

  test('email', () {
    expect(Validators.isValidEmail('user@domain.com'), isTrue);
    expect(Validators.isValidEmail('user@domain'), isFalse);
  });

  test('same city / past date / seat count', () {
    expect(Validators.isSameCity('cairo', 'cairo'), isTrue);
    expect(Validators.isSameCity('cairo', 'luxor'), isFalse);
    final now = DateTime(2026, 11, 14, 15);
    expect(Validators.isPastDate(DateTime(2026, 11, 13), now: now), isTrue);
    expect(Validators.isPastDate(DateTime(2026, 11, 14), now: now), isFalse);
    expect(Validators.isValidSeatCount(0), isFalse);
    expect(Validators.isValidSeatCount(4), isTrue);
    expect(Validators.isValidSeatCount(5), isFalse);
  });
}
