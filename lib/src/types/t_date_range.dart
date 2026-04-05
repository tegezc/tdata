import 't_date_time.dart';

/// Membungkus dua TDateTime (start dan end) untuk keperluan filter dan laporan.
/// Sangat aman: Otomatis memperbaiki jika tanggal terbalik.
class TDateRange {
  final TDateTime start;
  final TDateTime end;

  // Private constructor
  const TDateRange._(this.start, this.end);

  // ==========================================
  // 1. CONSTRUCTORS & VALIDATION
  // ==========================================

  /// Constructor pintar: Jika user/UI secara tidak sengaja memasukkan
  /// tanggal awal yang lebih besar dari tanggal akhir, sistem akan OTOMATIS menukarnya.
  factory TDateRange({required TDateTime start, required TDateTime end}) {
    if (start > end) {
      return TDateRange._(end, start);
    }
    return TDateRange._(start, end);
  }

  static TDateRange fromJson(Map<String, dynamic>? json) {
    if (json == null) throw const FormatException('TDateRange.fromJson: null');

    try {
      final start = TDateTime.fromJson(json['start']);
      final end = TDateTime.fromJson(json['end']);
      return TDateRange(start: start, end: end);
    } catch (e) {
      throw FormatException('TDateRange.fromJson: format tidak valid -> $e');
    }
  }

  // ==========================================
  // 2. SMART PRESETS (Sangat berguna untuk UI Filter)
  // ==========================================

  /// Preset: Hari ini (00:00 sampai besok 00:00)
  factory TDateRange.today() {
    final now = TDateTime.now();
    return TDateRange._(now.startOfDay, now.startOfNextDay);
  }

  /// Preset: 7 Hari terakhir (termasuk hari ini)
  factory TDateRange.last7Days() {
    final now = TDateTime.now();
    final start = now.subtractDays(6).startOfDay;
    return TDateRange._(start, now.startOfNextDay);
  }

  /// Preset: Bulan Ini (Tanggal 1 sampai awal bulan depan)
  factory TDateRange.thisMonth() {
    final localNow = DateTime.now().toLocal();
    final startOfMonth = TDateTime.safe(DateTime(localNow.year, localNow.month, 1));
    final startOfNextMonth = TDateTime.safe(DateTime(localNow.year, localNow.month + 1, 1));

    return TDateRange._(startOfMonth, startOfNextMonth);
  }

  // ==========================================
  // 3. UTILITIES & LOGIC
  // ==========================================

  /// Mengecek apakah sebuah tanggal (target) berada di dalam rentang ini
  bool contains(TDateTime target) {
    // Berlaku inklusif (>= start dan < end)
    // Menggunakan logika '< end' karena end kita biasanya adalah startOfNextDay
    return (target >= start) && (target < end);
  }

  /// Menghitung durasi rentang dalam hari
  int get durationInDays {
    return end.difference(start).inDays;
  }

  // ==========================================
  // 4. DISPLAY FORMATTING
  // ==========================================

  /// Contoh output: "12 Okt 2025 - 15 Okt 2025"
  /// Pintar: Jika bulan/tahun sama, bisa disingkat kelak
  String toDisplay({String locale = 'id_ID'}) {
    // Jika rentangnya cuma 1 hari, tampilkan 1 tanggal saja
    if (durationInDays <= 1) {
      return start.toDisplayDate(locale: locale);
    }

    // Karena 'end' adalah startOfNextDay (Jam 00:00 besoknya),
    // Untuk keperluan display ke user, kita kurangi 1 hari agar masuk akal.
    // Misal range (1 Okt - 2 Okt 00:00) ditampilkan sebagai "1 Okt 2025"
    final displayEnd = end.subtractDays(1);

    return '${start.toDisplayDate(locale: locale)} - ${displayEnd.toDisplayDate(locale: locale)}';
  }

  // ==========================================
  // 5. SERIALIZATION & EQUALITY
  // ==========================================

  Map<String, dynamic> toJson() {
    return {
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TDateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}