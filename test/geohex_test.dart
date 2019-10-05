import 'package:geohex/src/loc.dart';
import 'package:geohex/src/xy.dart';
import 'package:geohex/src/zone.dart';
import 'package:test/test.dart';

import 'package:geohex/src/utils.dart' as utils;


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


  group('utils test', (){
    test('hKey const should be valid', (){
        expect(utils.hKey, equals('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'));
    });

    test('hBase const should be valid', (){
        expect(utils.hBase, equals(20037508.34));
    });

    test('h_deg should be pi * (30 / 180)', (){
        //pi * (30 / 180) = 0.5235987755982988
        expect(utils.h_deg, equals(0.5235987755982988));
    });

    test('h_deg should be tan ( pi * (30 / 180) )', (){
      //tan ( pi * (30 / 180) ) = 0.5773502691896257
        expect(utils.h_k, equals(0.5773502691896257));
    });

    test('inc15 pattern should be [15]', (){
        expect(utils.inc15.pattern, equals('[15]'));
    });

    test('exc125 pattern should be [^125]', (){
        expect(utils.exc125.pattern, equals('[^125]'));
    });

    test('clamp precision to 8 digits', (){
        final c1 = utils.clampPrecisionn(0.12345678);
        final c2 = utils.clampPrecisionn(0.123456789);
        final c3 = utils.clampPrecisionn(0.1234567);

        expect(c1, equals(0.12345678));
        expect(c2, equals(0.12345679));
        expect(c3, equals(0.1234567));
    });

    test('loc2xy test', (){
        //Capetown
        final lat = -33.91522085; 
        final lon = 18.3758784;

        final xy = utils.loc2xy(lon, lat);

        expect(xy, equals(const XY(2045593.4260823661, -4017423.9299499094)));
    });

    test('xy2loc test', (){
        //Capetown
        final x = 2045593.4260823661;
        final y = -4017423.9299499094;

        final loc = utils.xy2loc(x, y);

        expect(loc, equals(const Loc(-33.91522085, 18.3758784)));
    });

    test('calcHexSize test', (){
        final s0 = utils.calcHexSize(0);
        final s1 = utils.calcHexSize(1);
        final s2 = utils.calcHexSize(2);
        final s3 = utils.calcHexSize(3);
        final s4 = utils.calcHexSize(4);
        final s5 = utils.calcHexSize(5);
        final s6 = utils.calcHexSize(6);
        final s7 = utils.calcHexSize(7);
        final s8 = utils.calcHexSize(8);
        final s9 = utils.calcHexSize(9);
        final s10 = utils.calcHexSize(10);
        final s11 = utils.calcHexSize(11);
        final s12 = utils.calcHexSize(12);
        final s13 = utils.calcHexSize(13);

        expect(s0, equals(742129.9385185185));
        expect(s1, equals(247376.6461728395));
        expect(s2, equals(82458.88205761317));
        expect(s3, equals(27486.29401920439));
        expect(s4, equals(9162.098006401464));
        expect(s5, equals(3054.0326688004875));
        expect(s6, equals(1018.0108896001626));
        expect(s7, equals(339.3369632000542));
        expect(s8, equals(113.11232106668473));
        expect(s9, equals(37.70410702222824));
        expect(s10, equals(12.56803567407608));
        expect(s11, equals(4.189345224692027));
        expect(s12, equals(1.3964484082306756));
        expect(s13, equals(0.4654828027435586));
    });

    test('adjustXY test', () {
        // passthrough variant
        final axy0 = utils.adjustXY(10, 5, 1);

        //first if x y reverse
        final axy1 = utils.adjustXY(45, 18, 1);

        //computation with diffs x > y
        final axy2 = utils.adjustXY(745, 118, 1);

        //computation with diffs x < y
        final axy3 = utils.adjustXY(145, 618, 1);

        expect(axy0, equals(const XY(10,5)));
        expect(axy1, equals(const XY(18,45)));
        expect(axy2, equals(const XY(718,145)));
        expect(axy3, equals(const XY(172, 591)));
    });

  });
}
