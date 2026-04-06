import 'package:tdata/tdata.dart';
import 'package:test/test.dart';

void main() {
  group('TCategory - Normalization to snake_case', () {
    test('Mengubah Title Case dengan spasi menjadi snake_case', () {
      final category = TCategory("Makan Siang");
      expect(category.value, "makan_siang");
    });

    test('Mengabaikan spasi berlebih dan huruf kapital acak', () {
      final category = TCategory("   BiAya   seKOLAH  ");
      expect(category.value, "biaya_sekolah");
    });

    test('Menghapus emoji dan karakter spesial secara otomatis', () {
      // User mungkin iseng memasukkan emoji atau simbol
      final category = TCategory("Groceries 🍎 & Stuff!");
      // Output harus bersih dari '&', '!', dan emoji, tapi menyisakan huruf/angka
      expect(category.value, "groceries_stuff");
    });
  });

  group('TCategory - Validation', () {
    test('Melempar error jika kosong atau hanya berisi spasi/simbol', () {
      expect(() => TCategory("   "), throwsFormatException);
      expect(() => TCategory(" !@#\$% "), throwsFormatException);
    });
  });

}