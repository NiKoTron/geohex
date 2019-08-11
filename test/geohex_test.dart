import 'package:geohex/src/loc.dart';
import 'package:geohex/src/utils.dart';
import 'package:geohex/src/xy.dart';
import 'package:geohex/src/zone.dart';
import 'package:test/test.dart';

import 'test_data/test_data.dart';

void main() {
  group('Unit tests', () {
    test('Throws when latitude must be between -90 and 90', () {
      expect(
          () => Zone.byLocation(91, 0, 1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'latitude must be between -90 and 90')));

      expect(
          () => Zone.byLocation(-91, 0, 1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'latitude must be between -90 and 90')));
    });

    test('Throws when longitude must be between -180 and 180', () {
      expect(
          () => Zone.byLocation(0, -181, 1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'longitude must be between -180 and 180')));

      expect(
          () => Zone.byLocation(0, 181, 1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'longitude must be between -180 and 180')));
    });

    test('Throws when level must be between 0 and 15', () {
      expect(
          () => Zone.byLocation(0, 0, 16),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'level must be between 0 and 15')));

      expect(
          () => Zone.byLocation(0, 0, -1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'level must be between 0 and 15')));
    });

    test('Zones should be equlas by code', () {
      final fakeZone1 = Zone(0, 0, 0, 0, 'codeX');
      final fakeZone2 = Zone(1, 1, 1, 1, 'codeX');
      expect(fakeZone1, equals(fakeZone2));
    });

    test('Zone hashCode is code hashCode', () {
      final fakeZone1 = Zone(0, 0, 0, 0, 'codeX');
      expect(fakeZone1.hashCode, equals(fakeZone1.code.hashCode));
    });

    test('Loc should be equlas', () {
      final fakeZone1 = Loc(0, 0);
      final fakeZone2 = Loc(0, 0);
      expect(fakeZone1, equals(fakeZone2));
    });

    test('Loc hashCode', () {
      final fakeZone1 = Loc(0, 0);
      expect(fakeZone1.hashCode,
          equals(fakeZone1.lat.hashCode ^ fakeZone1.lon.hashCode));
    });
  });

  group('Tests based on geohex.net/testcase', () {
    //There is clamping till eight positions after the dot.
    //It's enough precision for decimal location ref. - https://en.wikipedia.org/wiki/Decimal_degrees
    test('code -> HEX ', () {
      code2HEX.forEach((item) {
        final expLat = clamp(item[1].toDouble(), 8);
        final expLon = clamp(item[2].toDouble(), 8);

        final res = Zone.byCode(item[0]);

        expect(res.lon, equals(expLon));
        expect(res.lat, equals(expLat));
      });
    });

    test('coord to HEX', () {
      coord2HEX.forEach((item) {
        final exp = item[3];
        final res =
            Zone.byLocation(item[1].toDouble(), item[2].toDouble(), item[0])
                .code;
        expect(res, equalsIgnoringCase(exp));
      });
    });

    test('coord to XY', () {
      code2XY.forEach((item) {
        final exp = XY(item[1].toDouble(), item[2].toDouble());
        final res = XY.byCode(item[0]);
        expect(res, equals(exp));
      });
    });

    test('XY to HEX', () {
      xy2HEX.forEach((item) {
        final exp = item[3];
        final res =
            Zone.byXY(item[1].toDouble(), item[2].toDouble(), item[0]).code;
        expect(res, equalsIgnoringCase(exp));
      });
    });
  });
}
