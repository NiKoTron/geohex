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

  List<Loc> _hex;

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

    final xy = XY.byLocation(lat, lon, level);
    return Zone.byXY(xy.x, xy.y, level);
  }

  factory Zone.byCode(String code) {
    final xy = XY.byCode(code);
    return Zone.byXY(xy.x, xy.y, code.length - 2);
  }

  factory Zone.byXY(double x, double y, int level) {
    final h_size = calcHexSize(level);
    var h_x = x.round();
    var h_y = y.round();

    final h_lat = (h_k * h_x * (6 * h_size) + h_y * (6 * h_size * h_k)) / 2;
    final h_lon = (h_lat - h_y * (6 * h_size * h_k)) / h_k;

    final z_loc = xy2loc(h_lon, h_lat);
    var z_loc_x = z_loc.lon;
    final z_loc_y = z_loc.lat;
    final max_hsteps = math.pow(3, level + 2).toDouble();
    final hsteps = ((h_x - h_y)).abs().toDouble();

    if (hsteps == max_hsteps) {
      if (h_x > h_y) {
        final tmp = h_x;
        h_x = h_y;
        h_y = tmp;
      }
      z_loc_x = -180;
    }

    final h_code = StringBuffer();
    final code3_x = List<int>();
    final code3_y = List<int>();

    var mod_x = h_x;
    var mod_y = h_y;

    for (var i = 0; i <= level + 2; i++) {
      final h_pow = math.pow(3, level + 2 - i).round();
      final h_pow_half = (h_pow / 2).ceilToDouble();
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

    for (var i = 0; i < code3_x.length; i++) {
      final c3 = '${code3_x[i]}${code3_y[i]}';
      final c9 = '${int.parse(c3, radix: 3)}';
      h_code.write(c9);
    }

    final h_2 = h_code.toString().substring(3);
    final h_1 = int.parse(h_code.toString().substring(0, 3));
    final h_a1 = (h_1 / 30).floor();
    final h_a2 = h_1 % 30;

    return Zone(z_loc_y, z_loc_x, h_x, h_y, '${hKey[h_a1]}${hKey[h_a2]}$h_2');
  }

  double get hexSize => calcHexSize(this.level);

  List<Loc> get hexCoords {
    if (_hex == null) {
      final h_xy = loc2xy(this.lon, this.lat);

      final h_deg = math.tan(math.pi * (60.0 / 180.0));

      final h_top = xy2loc(h_xy.x, h_xy.y + h_deg * this.hexSize).lat;
      final h_btm = xy2loc(h_xy.x, h_xy.y - h_deg * this.hexSize).lat;

      final h_l = xy2loc(h_xy.x - 2 * this.hexSize, h_xy.y).lon;
      final h_r = xy2loc(h_xy.x + 2 * this.hexSize, h_xy.y).lon;

      final h_cl = xy2loc(h_xy.x - 1 * this.hexSize, h_xy.y).lon;
      final h_cr = xy2loc(h_xy.x + 1 * this.hexSize, h_xy.y).lon;

      _hex = [
        Loc(this.lat, h_l),
        Loc(h_top, h_cl),
        Loc(h_top, h_cr),
        Loc(this.lat, h_r),
        Loc(h_btm, h_cr),
        Loc(h_btm, h_cl)
      ];
    }
    return _hex;
  }

  @override
  bool operator ==(other) => other is Zone && this.code == other.code;

  @override
  int get hashCode => this.code.hashCode;
}
