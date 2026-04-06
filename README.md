# tdata
data type 
# 🛡️ TData (Type-Safe Data Core)

[![Coverage Status](https://img.shields.io/badge/Coverage-100%25-brightgreen.svg)]()
[![Dart SDK Version](https://img.shields.io/badge/Dart-%3E%3D3.0.0-blue.svg)]()
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-orange.svg)]()

**TData** is a collection of *Enterprise-Level Primitive Wrappers* for Dart & Flutter. Specifically designed to tame data anomalies, ensure type-safety, and simplify JSON serialization in large-scale applications (especially Financial & *Expense Management* apps).

## 🤔 Why TData?

In application development, built-in primitive data types (like `String`, `double`, or `DateTime`) **are very dangerous** when directly facing user input or backend responses:
- `double` can contain `NaN` or `Infinity` values that crash the app.
- `String` phone numbers can have messy formats (`0812`, `+62 812`, `(0812)`).
- `DateTime` often gets stuck in Time Zone issues (Local vs UTC).

**TData acts as a "Steel Vault".** Data entering TData will be automatically validated, sanitized, and standardized before touching your *Database* or *Business Layer*.

---

## ✨ Data Type Ecosystem

TData covers all fundamental needs of your application:

### 🔢 Financial & Numbers (Numeric)
* **`TDouble` & `TInteger`**: Immune to `NaN`, `Infinity`, and JSON parsing errors.
* **`TCurrency`**: Smart Multi-Currency system with high accuracy and automatic UI formatting (Registry available for 180+ countries).
* **`TPercentage`**: Eliminates confusion between `11%` and `0.11`. Equipped with `.calculate()` feature for taxes, discounts, and bill splitting.

### ⏳ Time & Reports (Time)
* **`TDateTime`**: Time Zone Locker. Always stores data in UTC for Database, but very easy to format to Local Calendar for UI.
* **`TDateRange`**: Brain of report filter features. Smartly reverses dates if user inputs wrong (Start > End) and equipped with many presets like `thisMonth()`.

### 📝 Text & Sanitization (String)
* **`TText`**: Narrative Cleaner. Automatically removes double spaces, truncates excessive characters (`maxLength`), and prevents UI layout breaks.
* **`TEmail`**: Robust regex validation with `.toMasked()` feature for UI privacy (e.g. `sup***@gmail.com`).
* **`TPassword`**: Password strength evaluator (*Strength Indicator*) without ever printing original values to console logs.
* **`TUrl`**: Auto-correction of `https://` protocol, domain extension validation, and UI cleaner (*display-friendly*).

### 🏷️ Identity & Geospatial
* **`TPhoneNumber`**: Extreme Normalization. Swallows any phone number format and spits out standard international **E.164** format ready for *WhatsApp/SMS API*.
* **`TCategory`**: Label Standardization (Tag). Converts dirty input `" Makan   Siang "` to `"makan_siang"` for Database, and can be returned to `"Makan Siang"` for UI.
* **`TCoordinate`**: Earth Latitude/Longitude validation with built-in geographic distance calculator (Haversine Formula).

---

## 🚀 Usage Guide (Quick Start)

### 1. Phone & Email Sanitization Magic
Don't let UI handle sanitization. Let TData do the work:
```dart
final phone = TPhoneNumber("+62 812-3456-7890");
print(phone.toJson()); // Output: "+6281234567890" (Database Ready)
print(phone.toDisplay()); // Output: "+62 812-3456-7890" (UI Ready)

final email = TEmail("  User@GMAIL.com ");
print(email.value); // Output: "user@gmail.com"
```

### 2. Headache-Free Financial Logic
Calculating restaurant bills with VAT has never been this easy:
```dart
final hargaMakanan = TCurrency(150000); // Rp 150.000
final ppn = TPercentage(11);            // Tax 11%

final totalPajak = ppn.calculate(hargaMakanan);
final totalBayar = hargaMakanan + totalPajak;

print(totalBayar.toDisplay(locale: 'id_ID')); // Output: "Rp166.500"
```
### 3. Geographic Distance Extraction
```dart
final jkt = TCoordinate(latitude: -6.2000, longitude: 106.8166);
final bdg = TCoordinate(latitude: -6.9025, longitude: 107.6188);

final jarak = jkt.distanceTo(bdg);
print('Distance: ${jarak.toStringAsFixed(1)} km'); // Output: Distance: 119.5 km
```
## 🏗️ Integration with Freezed & JSON Serializable
TData is designed 100% compatible with modern code generators. Each type has built-in Converters.

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
This package is tested very strictly (100% Code Coverage) to ensure no logic leaks.

```bash
 flutter test -r expanded
```