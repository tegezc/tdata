import 'package:tdata/src/types/t_text.dart';
import 'package:test/test.dart';

void main() {
  group('TText - Sanitization Logic', () {
    test('Should remove double spaces and newlines if sanitize is active', () {
      const input = "  Beli    Kopi \n\n  Susu  ";
      final result = TText(input, sanitize: true);

      // Result should be single space and trimmed
      expect(result.value, "Beli Kopi Susu");
    });

    test('Should truncate text if exceeds maxLength', () {
      const input = "Nama Transaksi Yang Sangat Panjang Sekali";
      final result = TText(input, maxLength: 10);

      expect(result.value.length, 10);
      expect(result.value, "Nama Trans");
    });

    test('SingleLine mode should convert enter to space', () {
      const input = "Baris 1\nBaris 2";
      final result = TText(input, singleLine: true);

      expect(result.value, "Baris 1 Baris 2");
      expect(result.value.contains('\n'), isFalse);
    });
  });

  group('TText - UI Utilities', () {
    test('toEllipsis should truncate and add ellipsis', () {
      final text = TText("Makan Siang Bersama Teman Kantor");

      expect(text.toEllipsis(10), "Makan Sian...");
      expect(text.toEllipsis(100), "Makan Siang Bersama Teman Kantor");
    });
  });
}
