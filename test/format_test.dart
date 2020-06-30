import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:track_time/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.hours(-10), '0h');
    });
    test('decimal', () {
      expect(Format.hours(1.2), '1.2h');
    });
  });

  group('date - en locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en-GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2019-04-04', () {
      expect(Format.date(DateTime(2019, 4, 4)), '4 Apr 2019');
    });
  });

  group('date - ru locale', () {
    setUp(() async {
      Intl.defaultLocale = 'ru-RU';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2019-04-04', () {
      expect(Format.date(DateTime(2019, 4, 4)), '4 апр. 2019 г.');
    });
  });

  group('day of week', () {
    setUp(() async {
      Intl.defaultLocale = 'en-GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('Thursday', () {
      expect(Format.dayOfWeek(DateTime(2019, 4, 4)), 'Thu');
    });
  });

  group('currency - us locale', () {
    setUp(() {
      Intl.defaultLocale = 'en-US';
    });
    test('positive', () {
      expect(Format.currency(1000000), '\$1,000,000');
    });
    test('zero', () {
      expect(Format.currency(0), '');
    });
    test('negative', () {
      expect(Format.currency(-4), '-\$4');
    });
  });
}
