import 'dart:math' as math;

import 'package:geohex/geohex.dart';

void main() {
  final geoHexCode = GeoHex.encode(-33.91522085, 18.3758784, 4); //Capetown
  print('http://geohex.net/$geoHexCode');

  final a = GeoHex.decode('XM488507762');
  final b = GeoHex.decode('XM488531402');

  final len = math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));

  print('${len * a.hexSize} 鯨尺');
  print('${(len * a.hexSize) / (25 / 66)}m');
  print('${(len * a.hexSize) / (10 / 33)}m');
}
