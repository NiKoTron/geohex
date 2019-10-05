import 'utils.dart';
import 'zone.dart';

class GeoHex {
  static const String version = '3.2.0';

  static String encode(double lat, double lon, int level) =>
      Zone.byLocation(clampPrecisionn(lat), clampPrecisionn(lon), level).code;

  static Zone decode(String code) => Zone.byCode(code);
}
