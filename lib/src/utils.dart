import 'dart:math' as math;

import 'xy.dart';

import 'loc.dart';

const String hKey = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
const double hBase = 20037508.34;
double get h_deg => math.pi * (30.0 / 180.0);
double get h_k => math.tan(h_deg);

RegExp get inc15 => RegExp('[15]');
RegExp get exc125 => RegExp('[^125]');

double clampPrecisionn(double d) {
  final fac = math.pow(10, 8);
  d = (d * fac).round() / fac;
  return d;
}

XY loc2xy(double lon, double lat) {
  final x = lon * hBase / 180.0;
  var y =
      math.log(math.tan((90.0 + lat) * math.pi / 360.0)) / (math.pi / 180.0);
  y *= hBase / 180.0;
  return XY(x, y);
}

Loc xy2loc(double x, double y) {
  final lon = (x / hBase) * 180.0;
  var lat = (y / hBase) * 180.0;
  lat = 180.0 /
      math.pi *
      (2.0 * math.atan(math.exp(lat * math.pi / 180.0)) - math.pi / 2.0);
  return Loc(clampPrecisionn(lat), clampPrecisionn(lon));
}

double calcHexSize(int level) => (hBase / math.pow(3.0, level + 3));

XY adjustXY(int x, int y, int level) {
  var resultX = x.toDouble();
  var resultY = y.toDouble();

  final max_hsteps = math.pow(3, level + 2);
  final hsteps = ((x - y)).abs();

  if (hsteps == max_hsteps && x > y) {
    resultX = y.toDouble();
    resultY = x.toDouble();
  } else if (hsteps > max_hsteps) {
    final diff = hsteps - max_hsteps;
    final diff_x = (diff / 2).floor();
    final diff_y = diff - diff_x;

    if (x > y) {
      resultX = (y + diff_y + diff_x).toDouble();
      resultY = (x - diff_x - diff_y).toDouble();
    } else if (y > x) {
      resultX = (y - diff_y - diff_x).toDouble();
      resultY = (x + diff_x + diff_y).toDouble();
    }
  }
  return XY(resultX, resultY);
}
