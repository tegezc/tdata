import 'package:tdata/src/types/t_coordinate.dart';
import 'package:test/test.dart';

void main() {
  group('TCoordinate - Boundary Validation', () {
    test('Berhasil membuat koordinat yang valid', () {
      final jkt = TCoordinate(latitude: -6.200000, longitude: 106.816666); // Jakarta
      expect(jkt.latitude, -6.2);
      expect(jkt.longitude, 106.816666);
    });

    test('Melempar error jika Latitude di luar -90 dan 90', () {
      expect(() => TCoordinate(latitude: -91.0, longitude: 100.0), throwsFormatException);
      expect(() => TCoordinate(latitude: 90.1, longitude: 100.0), throwsFormatException);
    });

    test('Melempar error jika Longitude di luar -180 dan 180', () {
      expect(() => TCoordinate(latitude: 10.0, longitude: -181.0), throwsFormatException);
      expect(() => TCoordinate(latitude: 10.0, longitude: 180.1), throwsFormatException);
    });
  });

  group('TCoordinate - Distance Calculation (Haversine)', () {
    test('Menghitung jarak Jakarta ke Bandung dengan akurasi yang dapat diterima', () {
      // Monas, Jakarta
      final jakarta = TCoordinate(latitude: -6.1751, longitude: 106.8272);
      // Gedung Sate, Bandung
      final bandung = TCoordinate(latitude: -6.9025, longitude: 107.6188);

      final distance = jakarta.distanceTo(bandung);

      // Jarak udara Jakarta - Bandung adalah sekitar 119 - 120 km
      expect(distance > 115.0, isTrue);
      expect(distance < 125.0, isTrue);
    });

    test('Jarak ke titik yang sama adalah 0 km', () {
      final point = TCoordinate(latitude: -6.1751, longitude: 106.8272);
      expect(point.distanceTo(point), 0.0);
    });
  });

  group('TCoordinate - Utilities', () {
    test('Membangun URL Google Maps yang benar', () {
      final point = TCoordinate(latitude: -6.2, longitude: 106.8);
      expect(point.googleMapsUrl, "https://maps.google.com/?q=-6.2,106.8");
    });
  });
}