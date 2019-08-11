class Loc {
  final double lat, lon;

  const Loc(this.lat, this.lon);

  @override
  bool operator ==(other) =>
      other is Loc && this.lat == other.lat && this.lon == other.lon;

  @override
  int get hashCode => this.lat.hashCode ^ this.lon.hashCode;
}
