import 'package:intl/date_symbol_data_local.dart';

/// Setup yang dijalankan sekali sebelum semua test
Future<void> setupTestEnvironment() async {
  // Inisialisasi semua locale data (termasuk 'id_ID')
  await initializeDateFormatting();
}