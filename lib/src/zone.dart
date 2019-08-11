import 'dart:math' as math;

import 'loc.dart';
import 'utils.dart';
import 'xy.dart';

class Zone {
  final double lat;
  final double lon;
  final int x;
  final int y;
  final String code;
  int get level => this.code.length - 2;

  Zone(this.lat, this.lon, this.x, this.y, this.code);

  factory Zone.byLocation(double lat, double lon, int level) {
    if (lat < -90 || lat > 90) {
      throw ArgumentError('latitude must be between -90 and 90');
    }
    if (lon < -180 || lon > 180) {
      throw ArgumentError('longitude must be between -180 and 180');
    }
    if (level < 0 || level > 15) {
      throw ArgumentError('level must be between 0 and 15');
    }

    XY xy = XY.byLocation(lat, lon, level);
    return Zone.byXY(xy.x, xy.y, level);
  }

  factory Zone.byCode(String code) {
    XY xy = XY.byCode(code);
    int level = code.length - 2;
    Zone zone = Zone.byXY(xy.x, xy.y, level);
    return zone;
  }

  factory Zone.byXY(double x, double y, int level) {
    double h_size = calcHexSize(level);
    int h_x = x.round();
    int h_y = y.round();
    double unit_x = 6 * h_size;
    double unit_y = 6 * h_size * h_k;
    double h_lat = (h_k * h_x * unit_x + h_y * unit_y) / 2;
    double h_lon = (h_lat - h_y * unit_y) / h_k;
    Loc z_loc = xy2loc(h_lon, h_lat);
    double z_loc_x = z_loc.lon;
    double z_loc_y = z_loc.lat;
    double max_hsteps = math.pow(3, level + 2).toDouble();
    double hsteps = ((h_x - h_y)).abs().toDouble();

    if (hsteps == max_hsteps) {
      if (h_x > h_y) {
        int tmp = h_x;
        h_x = h_y;
        h_y = tmp;
      }
      z_loc_x = -180;
    }

    StringBuffer h_code = StringBuffer();
    List<int> code3_x = List<int>();
    List<int> code3_y = List<int>();

    int mod_x = h_x;
    int mod_y = h_y;

    for (int i = 0; i <= level + 2; i++) {
      int h_pow = math.pow(3, level + 2 - i).round();
      double h_pow_half = (h_pow / 2).ceilToDouble();
      if (mod_x >= h_pow_half) {
        code3_x.add(2);
        mod_x -= h_pow;
      } else if (mod_x <= -h_pow_half) {
        code3_x.add(0);
        mod_x += h_pow;
      } else {
        code3_x.add(1);
      }

      if (mod_y >= h_pow_half) {
        code3_y.add(2);
        mod_y -= h_pow;
      } else if (mod_y <= -h_pow_half) {
        code3_y.add(0);
        mod_y += h_pow;
      } else {
        code3_y.add(1);
      }

      if (i == 2 && (z_loc_x == -180 || z_loc_x >= 0)) {
        if (code3_x[0] == 2 &&
            code3_y[0] == 1 &&
            code3_x[1] == code3_y[1] &&
            code3_x[2] == code3_y[2]) {
          code3_x[0] = 1;
          code3_y[0] = 2;
        } else if (code3_x[0] == 1 &&
            code3_y[0] == 0 &&
            code3_x[1] == code3_y[1] &&
            code3_x[2] == code3_y[2]) {
          code3_x[0] = 0;
          code3_y[0] = 1;
        }
      }
    }

    for (int i = 0; i < code3_x.length; i++) {
      var c3 = '${code3_x[i]}${code3_y[i]}';
      var c9 = '${int.parse(c3, radix: 3)}';
      h_code.write(c9);
    }

    String h_2 = h_code.toString().substring(3);
    int h_1 = int.parse(h_code.toString().substring(0, 3));
    int h_a1 = (h_1 / 30).floor();
    int h_a2 = h_1 % 30;
    StringBuffer h_code_r = StringBuffer();
    h_code_r..write(h_key[h_a1])..write(h_key[h_a2])..write(h_2.toString());
    return Zone(z_loc_y, z_loc_x, h_x, h_y, h_code_r.toString());
  }

  double get hexSize => calcHexSize(this.level);

  List<Loc> get hexCoords {
    double h_lat = this.lat;
    double h_lon = this.lon;
    XY h_xy = loc2xy(h_lon, h_lat);
    double h_x = h_xy.x;
    double h_y = h_xy.y;

    double h_deg = math.tan(math.pi * (60.0 / 180.0));
    double h_size = this.hexSize;
    double h_top = xy2loc(h_x, h_y + h_deg * h_size).lat;
    double h_btm = xy2loc(h_x, h_y - h_deg * h_size).lat;

    double h_l = xy2loc(h_x - 2 * h_size, h_y).lon;
    double h_r = xy2loc(h_x + 2 * h_size, h_y).lon;
    double h_cl = xy2loc(h_x - 1 * h_size, h_y).lon;
    double h_cr = xy2loc(h_x + 1 * h_size, h_y).lon;
    return [
      Loc(h_lat, h_l),
      Loc(h_top, h_cl),
      Loc(h_top, h_cr),
      Loc(h_lat, h_r),
      Loc(h_btm, h_cr),
      Loc(h_btm, h_cl)
    ];
  }

  @override
  bool operator ==(other) => other is Zone && this.code == other.code;

  @override
  int get hashCode => this.code.hashCode;
}
