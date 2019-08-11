import 'package:geohex/geohex.dart';

void main() {
  final geoHexCode = GeoHex.encode(-33.91522085, 18.3758784, 4); //Capetown
  print('http://geohex.net/$geoHexCode');
}
