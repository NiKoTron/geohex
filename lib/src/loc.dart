/// Represents location include lattitude and longitude
class Loc {
  /// Lattitude
  final double lat;

  /// Longitude
  final double lon;

  const Loc(this.lat, this.lon);

  @override
  bool operator ==(other) =>
      other is Loc && lat == other.lat && lon == other.lon;

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;
}
