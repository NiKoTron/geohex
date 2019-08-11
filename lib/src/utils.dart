import 'dart:math' as math;

import 'xy.dart';

import 'loc.dart';

const int precision = 8;

const String hKey = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
const double hBase = 20037508.34;
double get h_deg => math.pi * (30.0 / 180.0);
double get h_k => math.tan(h_deg);

RegExp get inc15 => RegExp('[15]');
RegExp get exc125 => RegExp('[^125]');

double clamp(double d, int prec) {
  final fac = math.pow(10, prec);
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
  return Loc(clamp(lat, precision), clamp(lon, precision));
}

double calcHexSize(int level) => (hBase / math.pow(3.0, level + 3));

bool regMatch(String cs, RegExp pat) => pat.hasMatch(cs);

XY adjustXY(double x, double y, int level) {
  final max_hsteps = math.pow(3, level + 2).toDouble();
  final hsteps = ((x - y)).abs();

  if (hsteps == max_hsteps && x > y) {
    final tmp = x;
    x = y;
    y = tmp;
  } else if (hsteps > max_hsteps) {
    final diff = hsteps - max_hsteps;
    final diff_x = (diff / 2).floorToDouble();
    final diff_y = diff - diff_x;
    double edge_x;
    double edge_y;

    if (x > y) {
      edge_x = x - diff_x;
      edge_y = y + diff_y;
      final h_xy = edge_x;
      edge_x = edge_y;
      edge_y = h_xy;
      x = edge_x + diff_x;
      y = edge_y - diff_y;
    } else if (y > x) {
      edge_x = x + diff_x;
      edge_y = y - diff_y;
      final h_xy = edge_x;
      edge_x = edge_y;
      edge_y = h_xy;
      x = clamp(edge_x - diff_x, 12);
      y = edge_y + diff_y;
    }
  }

  return XY(x, y);
}
