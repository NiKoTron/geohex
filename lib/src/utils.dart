import 'dart:math' as math;

import 'xy.dart';

import 'loc.dart';

const String h_key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const double h_base = 20037508.34;
double get h_deg => math.pi * (30.0 / 180.0);
double get h_k => math.tan(h_deg);

RegExp get inc15 => RegExp('[15]');
RegExp get exc125 => RegExp('[^125]');

XY loc2xy(double lon, double lat) {
  double x = lon * h_base / 180.0;
  double y =
      math.log(math.tan((90.0 + lat) * math.pi / 360.0)) / (math.pi / 180.0);
  y *= h_base / 180.0;
  return XY(x, y);
}

Loc xy2loc(double x, double y) {
  double lon = (x / h_base) * 180.0;
  double lat = (y / h_base) * 180.0;
  lat = 180.0 /
      math.pi *
      (2.0 * math.atan(math.exp(lat * math.pi / 180.0)) - math.pi / 2.0);
  return Loc(lat, lon);
}

double calcHexSize(int level) => (h_base / math.pow(3.0, level + 3));

bool regMatch(String cs, RegExp pat) => pat.hasMatch(cs);

XY adjustXY(double x, double y, int level) {
  double max_hsteps = math.pow(3, level + 2).toDouble();
  double hsteps = ((x - y)).abs();

  if (hsteps == max_hsteps && x > y) {
    double tmp = x;
    x = y;
    y = tmp;
  } else if (hsteps > max_hsteps) {
    double diff = hsteps - max_hsteps;
    double diff_x = (diff / 2).floorToDouble();
    double diff_y = diff - diff_x;
    double edge_x;
    double edge_y;

    if (x > y) {
      edge_x = x - diff_x;
      edge_y = y + diff_y;
      double h_xy = edge_x;
      edge_x = edge_y;
      edge_y = h_xy;
      x = edge_x + diff_x;
      y = edge_y - diff_y;
    } else if (y > x) {
      edge_x = x + diff_x;
      edge_y = y - diff_y;
      double h_xy = edge_x;
      edge_x = edge_y;
      edge_y = h_xy;
      x = edge_x - diff_x;
      y = edge_y + diff_y;
    }
  }

  return XY(x, y);
}
