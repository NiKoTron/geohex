// ignore_for_file: non_constant_identifier_names

import 'dart:math' as math;

import 'utils.dart';

/// Represents X\Y position of cell on decoded map
class XY {
  final double? x, y;

  const XY(this.x, this.y);

  /// Calculates and creates an XY
  /// by passing lattitude longitude and wnated zoom level
  factory XY.byLocation(double lat, double lon, int level) {
    final h_size = calcHexSize(level);
    final z_xy = loc2xy(lon, lat);

    final h_pos_x = (z_xy.x! + z_xy.y! / h_k) / (6 * h_size);
    final h_pos_y = (z_xy.y! - h_k * z_xy.x!) / (6 * h_size * h_k);
    final h_x_0 = (h_pos_x).floor();
    final h_y_0 = (h_pos_y).floor();
    final h_x_q = h_pos_x - h_x_0;
    final h_y_q = h_pos_y - h_y_0;

    var h_x = (h_pos_x).round();
    var h_y = (h_pos_y).round();

    if (h_y_q > -h_x_q + 1) {
      if ((h_y_q < 2 * h_x_q) && (h_y_q > 0.5 * h_x_q)) {
        h_x = h_x_0 + 1;
        h_y = h_y_0 + 1;
      }
    } else if (h_y_q < -h_x_q + 1) {
      if ((h_y_q > (2 * h_x_q) - 1) && (h_y_q < (0.5 * h_x_q) + 0.5)) {
        h_x = h_x_0;
        h_y = h_y_0;
      }
    }

    return adjustXY(h_x, h_y, level);
  }

  /// Calculates and creates XY instance from geohex code
  factory XY.byCode(String code) {
    final level = code.length - 2;
    var h_x = 0;
    var h_y = 0;

    var h_dec9 =
        '${hKey.indexOf(code[0]) * 30 + hKey.indexOf(code[1])}${(code.substring(2))}';
    if (inc15.hasMatch(h_dec9[0]) &&
        exc125.hasMatch(h_dec9[1]) &&
        exc125.hasMatch(h_dec9[2])) {
      if (h_dec9[0] == '5') {
        h_dec9 = '7${h_dec9.substring(1, h_dec9.length)}';
      } else if (h_dec9[0] == '1') {
        h_dec9 = '3${h_dec9.substring(1, h_dec9.length)}';
      }
    }

    var d9xlen = h_dec9.length;
    for (var i = 0; i < level + 3 - d9xlen; i++) {
      h_dec9 = '0$h_dec9';
      d9xlen++;
    }

    final h_dec3 = StringBuffer();
    for (var i = 0; i < d9xlen; i++) {
      final dec9i = int.parse(h_dec9[i]);
      final h_dec0 = dec9i.toRadixString(3);
      if (h_dec0.length == 1) {
        h_dec3.write('0');
      }
      h_dec3.write(h_dec0);
    }

    final h_decx = <String>[];
    final h_decy = <String>[];

    for (var i = 0; i < h_dec3.length / 2; i++) {
      h_decx.add(h_dec3.toString()[i * 2]);
      h_decy.add(h_dec3.toString()[i * 2 + 1]);
    }

    for (var i = 0; i <= level + 2; i++) {
      final h_pow = math.pow(3, level + 2 - i);
      if (h_decx[i] == '0') {
        h_x -= h_pow as int;
      } else if (h_decx[i] == '2') {
        h_x += h_pow as int;
      }
      if (h_decy[i] == '0') {
        h_y -= h_pow as int;
      } else if (h_decy[i] == '2') {
        h_y += h_pow as int;
      }
    }

    return adjustXY(h_x, h_y, level);
  }

  @override
  bool operator ==(other) => other is XY && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
