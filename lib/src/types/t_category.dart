/// Wrapper untuk Kategori atau Tag (Identifier).
/// Menormalisasi input teks menjadi snake_case agar seragam di Database.
///
/// [CURSOR AI HINT]:
/// - STRICT RULE: Use `TCategory` for Category IDs, tags, or system labels.
/// - It automatically converts "Food & Beverage" into "food_beverage" for safe database querying.
/// - When rendering the category name back to the user in the UI, ALWAYS use `.toDisplay()` to convert it back to Title Case.
/// - For JSON serialization in Freezed, annotate the field with `@TCategoryConverter()`.
extension type const TCategory._(String value) {

  // ==========================================
  // 1. CONSTRUCTORS & SANITIZATION
  // ==========================================

  /// Menerima teks bebas dari user, lalu mengubahnya menjadi format standar (snake_case).
  /// Contoh: "Makan Siang" -> "makan_siang"
  factory TCategory(String input) {
    if (input.trim().isEmpty) {
      throw const FormatException('TCategory: Tidak boleh kosong');
    }

    // 1. Jadikan huruf kecil
    var clean = input.toLowerCase();

    // 2. Ganti SEMUA karakter selain huruf dan angka menjadi spasi.
    // (Emoji "🍎" dan simbol "&" akan berubah menjadi spasi)
    clean = clean.replaceAll(RegExp(r'[^a-z0-9]'), ' ');

    // 3. Hapus spasi di awal/akhir (trim),
    // lalu kompres sisa spasi beruntun di tengah menjadi tepat SATU underscore (_)
    clean = clean.trim().replaceAll(RegExp(r'\s+'), '_');

    if (clean.isEmpty) {
      throw const FormatException('TCategory: Input tidak memiliki huruf/angka valid');
    }

    return TCategory._(clean);
  }

  static TCategory fromJson(dynamic jsonValue) {
    if (jsonValue == null) throw const FormatException('TCategory.fromJson: null');
    // Asumsi data dari DB sudah berformat snake_case, tapi tetap dilewatkan ke factory untuk aman
    return TCategory(jsonValue.toString());
  }

  static TCategory? tryParse(String? input) {
    try {
      return TCategory(input!);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // 2. DISPLAY
  // ==========================================

  /// Mengubah format "makan_siang" kembali menjadi "Makan Siang" (Title Case)
  String toDisplay() {
    final words = value.split('_');

    // Kapitalisasi huruf pertama setiap kata
    final capitalized = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    });

    return capitalized.join(' ');
  }

  // ==========================================
  // 3. SERIALIZATION
  // ==========================================

  /// Output untuk Database: Selalu huruf kecil dan underscore (Aman untuk query/indexing)
  String toJson() => value;
}