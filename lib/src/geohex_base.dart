import 'zone.dart';

class GeoHex {
  static const String VERSION = "3.2.2";

  static String encode(double lat, double lon, int level) =>
      Zone.byLocation(lat, lon, level).code;

  static Zone decode(String code) => Zone.byCode(code);
}
