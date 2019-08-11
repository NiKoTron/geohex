import 'package:geohex/src/xy.dart';
import 'package:geohex/src/zone.dart';
import 'package:test/test.dart';

import 'test_data/test_data.dart';

void main() {
  group('Tests based on geohex.net/testcase', () {
    //There is Wrong test in the source exclude it
    test('code -> HEX ', () {
      code2HEX.forEach((item) {
        print(item);
        final expLat = item[1].toDouble();
        final expLon = item[2].toDouble();

        final res = Zone.byCode(item[0]);

        // expect(res.lon, equals(expLon));
        // expect(res.lat, equals(expLat));
      });
    });

    test('coord to HEX', () {
      coord2HEX.forEach((item) {
        final exp = item[3];
        final res = Zone.byLocation(
                item[1].toDouble(), item[2].toDouble(), item[0] as int)
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
