import 'dart:math' as math;

/// Wrapper untuk titik Koordinat Geografis (GPS).
/// Menjamin Latitude dan Longitude selalu berada dalam batas valid Bumi.
class TCoordinate {
  final double latitude;
  final double longitude;

  // Private constructor
  const TCoordinate._(this.latitude, this.longitude);

  // ==========================================
  // 1. CONSTRUCTORS & VALIDATION
  // ==========================================

  /// Constructor Utama: Memvalidasi batas geografis Bumi.
  /// Latitude: -90.0 hingga 90.0 (Kutub Selatan ke Utara)
  /// Longitude: -180.0 hingga 180.0 (Garis Tanggal Internasional)
  factory TCoordinate({required double latitude, required double longitude}) {
    if (latitude < -90.0 || latitude > 90.0) {
      throw FormatException('TCoordinate: Latitude harus antara -90 dan 90 -> $latitude');
    }
    if (longitude < -180.0 || longitude > 180.0) {
      throw FormatException('TCoordinate: Longitude harus antara -180 dan 180 -> $longitude');
    }

    return TCoordinate._(latitude, longitude);
  }

  static TCoordinate fromJson(Map<String, dynamic>? json) {
    if (json == null) throw const FormatException('TCoordinate.fromJson: null');

    try {
      final lat = (json['lat'] as num).toDouble();
      final lng = (json['lng'] as num).toDouble();
      return TCoordinate(latitude: lat, longitude: lng);
    } catch (e) {
      throw FormatException('TCoordinate.fromJson: format tidak valid -> $e');
    }
  }

  static TCoordinate? tryParse({required double? latitude, required double? longitude}) {
    if (latitude == null || longitude == null) return null;
    try {
      return TCoordinate(latitude: latitude, longitude: longitude);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // 2. GEOSPATIAL MATH (HAVERSINE FORMULA)
  // ==========================================

  /// Menghitung jarak lurus (Distance) antara koordinat ini ke koordinat lain dalam Kilometer.
  /// Sangat berguna untuk filter "Transaksi di sekitar saya (Radius 5km)".
  double distanceTo(TCoordinate target) {
    const double earthRadiusKm = 6371.0; // Radius bumi dalam kilometer

    // Konversi derajat ke radian
    final dLat = _degreesToRadians(target.latitude - latitude);
    final dLon = _degreesToRadians(target.longitude - longitude);

    final lat1 = _degreesToRadians(latitude);
    final lat2 = _degreesToRadians(target.latitude);

    // Rumus Haversine
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  // ==========================================
  // 3. DISPLAY & UTILITIES
  // ==========================================

  /// Menampilkan untuk UI, misal membuka Google Maps via URL Launcher
  /// "https://maps.google.com/?q=-6.200000,106.816666"
  String get googleMapsUrl => 'https://maps.google.com/?q=$latitude,$longitude';

  /// Output UI yang dibaca manusia
  String toDisplay() {
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }

  // ==========================================
  // 4. SERIALIZATION & EQUALITY
  // ==========================================

  Map<String, double> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TCoordinate &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}