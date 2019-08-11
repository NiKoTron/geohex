# GeoHex for Dart

Implementation of [GeoHex](http://www.geohex.org/) encoding for Dart language.

## Usage

Encoding example:

```dart
import 'package:geohex/geohex.dart';

main() {
  //Location of Capetown
  String geoHexCode = GeoHex.encode(-33.91522085, 18.3758784, 4); //OM4138
}

```

Decoding example:

```dart
import 'package:geohex/geohex.dart';

main() {
  //Geocode of Capetown
  String geoHexCode = GeoHex.decode('OM4138'); // instance of Zone with lat -33.91522085 lon 18.3758784 and level 4
}

```

## Note
This realisation has some difference with the original lib. It's location clamping. Original [lib](http://www.geohex.org/) uses `double` representation of lat'n'lon, so theoretically, it should take more precision etc. but in fact, it leads to errors. 

Refer to this - [decimal degrees](https://en.wikipedia.org/wiki/Decimal_degrees), eight points after dot the should be enough for everything.
