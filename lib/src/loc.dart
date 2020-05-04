class Loc {
  final double lat, lon;

  const Loc(this.lat, this.lon);

  @override
  bool operator ==(other) =>
      other is Loc && lat == other.lat && lon == other.lon;

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;
}
