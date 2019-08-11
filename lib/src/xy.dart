import 'dart:math' as math;

import 'utils.dart';

class XY {
  final double x, y;

  const XY(this.x, this.y);

  factory XY.byLocation(double lat, double lon, int level) {
    double h_size = calcHexSize(level);
    XY z_xy = loc2xy(lon, lat);
    double lon_grid = z_xy.x;
    double lat_grid = z_xy.y;
    double unit_x = 6 * h_size;
    double unit_y = 6 * h_size * h_k;
    double h_pos_x = (lon_grid + lat_grid / h_k) / unit_x;
    double h_pos_y = (lat_grid - h_k * lon_grid) / unit_y;
    int h_x_0 = (h_pos_x).floor();
    int h_y_0 = (h_pos_y).floor();
    double h_x_q = h_pos_x - h_x_0;
    double h_y_q = h_pos_y - h_y_0;
    int h_x = (h_pos_x).round();
    int h_y = (h_pos_y).round();

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

    XY inner_xy = adjustXY(h_x.toDouble(), h_y.toDouble(), level);
    return inner_xy;
  }

  factory XY.byCode(String code) {
    int level = code.length - 2;
    double h_x = 0;
    double h_y = 0;

    String h_dec9 =
        '${h_key.indexOf(code[0]) * 30 + h_key.indexOf(code[1])}${(code.substring(2))}';
    if (regMatch(h_dec9[0], inc15) &&
        regMatch(h_dec9[1], exc125) &&
        regMatch(h_dec9[2], exc125)) {
      if (h_dec9[0] == '5') {
        h_dec9 = "7" + h_dec9.substring(1, h_dec9.length);
      } else if (h_dec9[0] == '1') {
        h_dec9 = "3" + h_dec9.substring(1, h_dec9.length);
      }
    }

    int d9xlen = h_dec9.length;
    for (int i = 0; i < level + 3 - d9xlen; i++) {
      h_dec9 = "0" + h_dec9;
      d9xlen++;
    }

    StringBuffer h_dec3 = StringBuffer();
    for (int i = 0; i < d9xlen; i++) {
      int dec9i = int.parse(h_dec9[i]);
      String h_dec0 = dec9i.toRadixString(3);
      if (h_dec0.length == 1) {
        h_dec3.write('0');
      }
      h_dec3.write(h_dec0);
    }

    final h_decx = List<String>();
    final h_decy = List<String>();

    for (int i = 0; i < h_dec3.length / 2; i++) {
      h_decx.add(h_dec3.toString()[i * 2]);
      h_decy.add(h_dec3.toString()[i * 2 + 1]);
    }

    for (int i = 0; i <= level + 2; i++) {
      double h_pow = math.pow(3, level + 2 - i).toDouble();
      if (h_decx[i] == '0') {
        h_x -= h_pow;
      } else if (h_decx[i] == '2') {
        h_x += h_pow;
      }
      if (h_decy[i] == '0') {
        h_y -= h_pow;
      } else if (h_decy[i] == '2') {
        h_y += h_pow;
      }
    }

    XY inner_xy = adjustXY(h_x, h_y, level);
    return inner_xy;
  }

  @override
  bool operator ==(other) =>
      other is XY && this.x == other.x && this.y == other.y;

  @override
  int get hashCode => this.x.hashCode ^ this.y.hashCode;
}
