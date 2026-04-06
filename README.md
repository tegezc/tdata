# tdata
data type 
# 🛡️ TData (Type-Safe Data Core)

[![Coverage Status](https://img.shields.io/badge/Coverage-100%25-brightgreen.svg)]()
[![Dart SDK Version](https://img.shields.io/badge/Dart-%3E%3D3.0.0-blue.svg)]()
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-orange.svg)]()

**TData** adalah koleksi *Primitive Wrappers* tingkat *Enterprise* untuk Dart & Flutter. Dirancang khusus untuk menjinakkan anomali data, memastikan keamanan tipe (Type-Safety), dan mempermudah serialisasi JSON pada aplikasi skala besar (terutama aplikasi Finansial & *Expense Management*).

## 🤔 Mengapa TData?

Di dalam pengembangan aplikasi, tipe data primitif bawaan bahasa (seperti `String`, `double`, atau `DateTime`) **sangat berbahaya** jika langsung berhadapan dengan input pengguna atau *response backend*:
- `double` bisa berisi nilai `NaN` atau `Infinity` yang membuat aplikasi *crash*.
- `String` nomor telepon bisa memiliki berbagai format berantakan (`0812`, `+62 812`, `(0812)`).
- `DateTime` sering terjebak dalam masalah Zona Waktu (Lokal vs UTC).

**TData bertindak sebagai "Brankas Baja".** Data yang masuk ke TData akan otomatis divalidasi, dibersihkan (*sanitized*), dan diseragamkan sebelum menyentuh *Database* atau *Layer* Bisnis Anda.

---

## ✨ Ekosistem Tipe Data

TData mencakup seluruh kebutuhan fundamental aplikasi Anda:

### 🔢 Finansial & Angka (Numeric)
* **`TDouble` & `TInteger`**: Kebal terhadap `NaN`, `Infinity`, dan *parsing error* dari JSON.
* **`TCurrency`**: Sistem Multi-Mata Uang pintar dengan akurasi tinggi dan format UI otomatis (Tersedia Registry untuk 180+ negara).
* **`TPercentage`**: Menghilangkan kebingungan antara `11%` dan `0.11`. Dilengkapi fitur `.calculate()` untuk pajak, diskon, dan *split bill*.

### ⏳ Waktu & Laporan (Time)
* **`TDateTime`**: Pengunci Zona Waktu. Selalu menyimpan data dalam UTC untuk Database, tapi sangat mudah diformat ke Kalender Lokal untuk UI.
* **`TDateRange`**: Otak dari fitur filter laporan. Pintar membalik tanggal jika user salah *input* (Start > End) dan dilengkapi banyak *preset* seperti `thisMonth()`.

### 📝 Teks & Sanitasi (String)
* **`TText`**: Pembersih narasi. Otomatis menghapus spasi ganda, memotong kepanjangan karakter (`maxLength`), dan mencegah UI *layout break*.
* **`TEmail`**: Validasi regex tangguh dengan fitur `.toMasked()` untuk privasi UI (e.g. `sup***@gmail.com`).
* **`TPassword`**: Pengevaluasi kekuatan kata sandi (*Strength Indicator*) tanpa pernah mencetak nilai aslinya ke log *console*.
* **`TUrl`**: Auto-koreksi protokol `https://`, validasi ekstensi domain, dan pembersih UI (*display-friendly*).

### 🏷️ Identitas & Geospasial
* **`TPhoneNumber`**: Normalisasi ekstrem. Menelan format nomor apapun dan memuntahkan format standar internasional **E.164** yang siap pakai untuk *WhatsApp/SMS API*.
* **`TCategory`**: Standardisasi label (Tag). Mengubah input kotor `" Makan   Siang "` menjadi `"makan_siang"` untuk Database, dan bisa dikembalikan ke `"Makan Siang"` untuk UI.
* **`TCoordinate`**: Validasi *Latitude/Longitude* Bumi dengan fitur penghitung jarak geografis bawaan (Rumus *Haversine*).

---

## 🚀 Cara Penggunaan (Quick Start)

### 1. Keajaiban Sanitasi Telepon & Email
Jangan biarkan UI mengatur sanitasi. Biarkan TData yang bekerja:
```dart
final phone = TPhoneNumber("+62 812-3456-7890");
print(phone.toJson()); // Output: "+6281234567890" (Database Ready)
print(phone.toDisplay()); // Output: "+62 812-3456-7890" (UI Ready)

final email = TEmail("  User@GMAIL.com ");
print(email.value); // Output: "user@gmail.com"
```

### 2. Logika Finansial Bebas Pusing
Menghitung tagihan restoran beserta PPN tidak pernah semudah ini:
```dart
final hargaMakanan = TCurrency(150000); // Rp 150.000
final ppn = TPercentage(11);            // Pajak 11%

final totalPajak = ppn.calculate(hargaMakanan);
final totalBayar = hargaMakanan + totalPajak;

print(totalBayar.toDisplay(locale: 'id_ID')); // Output: "Rp166.500"
```
### 3. Ekstraksi Jarak Geografis
```dart
final jkt = TCoordinate(latitude: -6.2000, longitude: 106.8166);
final bdg = TCoordinate(latitude: -6.9025, longitude: 107.6188);

final jarak = jkt.distanceTo(bdg);
print('Jarak: ${jarak.toStringAsFixed(1)} km'); // Output: Jarak: 119.5 km
```
## 🏗️ Integrasi dengan Freezed & JSON Serializable
TData didesain 100% kompatibel dengan code generator modern. Setiap tipe memiliki Converter bawaan.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t_data/t_data.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required TCategory categoryId,
    required TText title,
    @TCurrencyConverter() required TCurrency amount,
    @TDateTimeConverter() required TDateTime date,
    @TPhoneNumberConverter() TPhoneNumber? contactPerson,
    @TCoordinateConverter() TCoordinate? location,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => 
      _$TransactionModelFromJson(json);
}
```
## 🛠️ Testing
Package ini diuji dengan sangat ketat (100% Code Coverage) untuk memastikan tidak ada kebocoran logika.

```bash
 flutter test -r expanded
```