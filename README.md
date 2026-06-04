# 🛋️ Hoomly - Furniture Shopping App

Aplikasi Flutter untuk jual beli furniture dengan desain modern.

## Fitur Lengkap
- ✅ Home Screen (Banner, Kategori, Featured, Popular)
- ✅ Search & Filter berdasarkan kategori
- ✅ Product Detail (pilih warna, quantity, wishlist)
- ✅ Cart Screen (tambah/hapus item, quantity)
- ✅ Checkout Screen (delivery info, promo code, payment summary)
- ✅ Order Success Screen
- ✅ Notification Screen (promo & transaksi)
- ✅ Wishlist Screen
- ✅ Account/Profile Screen
- ✅ Order History
- ✅ State management dengan Provider

## Cara Menjalankan

### 1. Pastikan Flutter sudah terinstall
```bash
flutter --version
# Flutter 3.x.x
```

### 2. Install dependencies
```bash
cd hoomly
flutter pub get
```

### 3. Jalankan aplikasi
```bash
# Emulator/device Android
flutter run

# Emulator iOS (Mac only)
flutter run -d ios

# Browser (web)
flutter run -d chrome
```

## Promo Code (untuk testing)
- `HOOMLY10` → diskon 10%
- `SAVE5` → diskon $5.5

## Struktur Project
```
lib/
├── main.dart                    # Entry point
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   ├── order.dart
│   └── notification.dart
├── providers/
│   ├── product_provider.dart    # State produk & wishlist
│   ├── cart_provider.dart       # State keranjang
│   ├── order_provider.dart      # State order/transaksi
│   ├── user_provider.dart       # State profil user
│   └── notification_provider.dart
├── screens/
│   ├── main_scaffold.dart       # Bottom navigation
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── order_success_screen.dart
│   ├── order_history_screen.dart
│   ├── notification_screen.dart
│   ├── wishlist_screen.dart
│   └── account_screen.dart
├── services/
│   └── mock_data_service.dart   # Data produk & notifikasi
└── utils/
    └── app_theme.dart           # Tema & warna aplikasi
```

## Catatan
- Data produk menggunakan mock data (tidak perlu Firebase)
- Gambar produk dari Unsplash (perlu koneksi internet)
- State tersimpan selama sesi aplikasi berjalan
- Gunakan `shared_preferences` untuk data user yang persisten
