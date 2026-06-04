import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../providers/notification_provider.dart';
import '../utils/app_theme.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String selectedPayment;

  const CheckoutScreen({
    super.key,
    this.selectedPayment = 'Kartu Kredit',
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _promoController = TextEditingController();
  late String _selectedPayment;
  bool _isProcessing = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _selectedPayment = widget.selectedPayment;
  }

  // FIX 5: Format sesuai KBBI — Rp4.500.000 (tanpa spasi)
  String _formatRupiah(double price) {
    final parts = price.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  // FIX 3: Deteksi lokasi GPS
  Future<void> _detectLocation(UserProvider user) async {
    setState(() => _isLocating = true);

    try {
      // Cek layanan GPS aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLocating = false);
        if (mounted) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.scale,
            title: 'GPS Tidak Aktif',
            desc: 'Aktifkan layanan lokasi (GPS) di perangkat kamu.',
            btnOkText: 'Buka Pengaturan',
            btnOkOnPress: () => Geolocator.openLocationSettings(),
            btnCancelText: 'Batal',
            btnCancelOnPress: () {},
          ).show();
        }
        return;
      }

      // Cek & minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLocating = false);
          if (mounted) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.scale,
              title: 'Izin Lokasi Ditolak',
              desc:
                  'Izin akses lokasi diperlukan untuk mendeteksi alamat pengiriman.',
              btnOkOnPress: () {},
              btnOkColor: AppTheme.primary,
            ).show();
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLocating = false);
        if (mounted) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Izin Lokasi Diblokir',
            desc:
                'Aktifkan izin lokasi untuk aplikasi ini melalui pengaturan perangkat.',
            btnOkText: 'Buka Pengaturan',
            btnOkOnPress: () => Geolocator.openAppSettings(),
            btnCancelText: 'Batal',
            btnCancelOnPress: () {},
          ).show();
        }
        return;
      }

      // Dapatkan posisi GPS
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Konversi koordinat → alamat
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
        ].where((s) => s != null && s!.isNotEmpty).toList();

        final address = parts.join(', ');

        // Simpan ke UserProvider
        await user.updateProfile(
          name: user.name,
          email: user.email,
          phone: user.phone,
          address: address,
        );

        setState(() => _isLocating = false);

        if (mounted) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Lokasi Terdeteksi!',
            desc: address,
            btnOkOnPress: () {},
            btnOkColor: AppTheme.primary,
          ).show();
        }
      }
    } catch (e) {
      setState(() => _isLocating = false);
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Gagal Mendeteksi Lokasi',
          desc: 'Pastikan GPS aktif dan koneksi internet tersedia, lalu coba lagi.',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<CartProvider, UserProvider>(
        builder: (ctx, cart, user, _) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMap(user),
                    const SizedBox(height: 20),
                    _buildDeliveryInfo(user),
                    const SizedBox(height: 20),
                    _buildPaymentSummary(cart),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context, cart, user),
          ],
        ),
      ),
    );
  }

  // FIX 3: Peta bisa di-tap untuk deteksi lokasi GPS
  Widget _buildMap(UserProvider user) {
    return GestureDetector(
      onTap: _isLocating ? null : () => _detectLocation(user),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 160,
          color: const Color(0xFFE8EAF0),
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(double.infinity, 160),
                painter: MapPainter(),
              ),
              Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: _isLocating
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                            strokeWidth: 2,
                          ),
                        )
                      : Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isLocating
                              ? Icons.gps_fixed
                              : Icons.my_location,
                          color: AppTheme.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isLocating
                              ? 'Mendeteksi lokasi...'
                              : 'Ketuk untuk deteksi lokasi otomatis',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(UserProvider user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Informasi Pengiriman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                ),
              ),
              GestureDetector(
                onTap: () => _showEditDelivery(user),
                child: const Icon(Icons.edit_outlined,
                    color: AppTheme.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow('Nama:', user.name),
          _infoRow('Nomor HP:', user.phone),
          _infoRow('Alamat:', user.address),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: AppTheme.grey),
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value.isEmpty ? '-' : value,
              style: const TextStyle(
                color: AppTheme.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 14),

          // Kode promo
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.greyBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_outlined,
                    color: AppTheme.grey, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Masukkan kode promo',
                      border: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_promoController.text.isNotEmpty) {
                      final success = context
                          .read<CartProvider>()
                          .applyPromoCode(_promoController.text);
                      // FIX: Sweet alert untuk promo
                      AwesomeDialog(
                        context: context,
                        dialogType: success
                            ? DialogType.success
                            : DialogType.error,
                        animType: AnimType.scale,
                        title: success
                            ? 'Promo Berhasil!'
                            : 'Promo Tidak Valid',
                        desc: success
                            ? 'Kode promo "${_promoController.text.toUpperCase()}" berhasil diterapkan.'
                            : 'Kode promo tidak ditemukan atau sudah kadaluarsa.',
                        btnOkOnPress: () {},
                        btnOkColor:
                            success ? AppTheme.primary : Colors.red,
                      ).show();
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios,
                      color: AppTheme.grey, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _summaryRow('Subtotal', _formatRupiah(cart.subtotal)),
          if (cart.discountAmount > 0)
            _summaryRow(
              'Diskon kupon',
              '- ${_formatRupiah(cart.discountAmount)}',
              isDiscount: true,
            ),
          // FIX 5: Ongkos kirim format KBBI (sebelumnya Rp 5 karena 5.0 tidak diformat)
          _summaryRow('Ongkos Kirim', _formatRupiah(cart.deliveryFee)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppTheme.greyLight),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.black,
                ),
              ),
              Text(
                _formatRupiah(cart.total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 13, color: AppTheme.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDiscount ? AppTheme.green : AppTheme.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, CartProvider cart, UserProvider user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Kembali'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _placeOrder(context, cart, user),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Pesan Sekarang',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(
      BuildContext context, CartProvider cart, UserProvider user) async {
    if (user.name.isEmpty || user.phone.isEmpty || user.address.isEmpty) {
      // FIX: Sweet alert validasi
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: 'Data Tidak Lengkap',
        desc: 'Lengkapi nama, nomor HP, dan alamat pengiriman terlebih dahulu.',
        btnOkOnPress: () {},
        btnOkColor: AppTheme.primary,
      ).show();
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final orderId = await context.read<OrderProvider>().placeOrder(
            items: cart.items,
            subtotal: cart.subtotal,
            discount: cart.discountAmount,
            deliveryFee: cart.deliveryFee,
            total: cart.total,
            deliveryName: user.name,
            deliveryPhone: user.phone,
            deliveryAddress: user.address,
            paymentMethod: _selectedPayment,
          );

      context.read<NotificationProvider>().addOrderNotification(orderId);
      cart.clearCart();
      setState(() => _isProcessing = false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(orderId: orderId),
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Pesanan Gagal',
          desc: 'Terjadi kesalahan saat memproses pesanan. Silakan coba lagi.',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  void _showEditDelivery(UserProvider user) {
    final nameCtrl = TextEditingController(text: user.name);
    final phoneCtrl = TextEditingController(text: user.phone);
    final addrCtrl = TextEditingController(text: user.address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Info Pengiriman',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama')),
            const SizedBox(height: 10),
            TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Nomor HP')),
            const SizedBox(height: 10),
            TextField(
                controller: addrCtrl,
                decoration:
                    const InputDecoration(labelText: 'Alamat')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  user.updateProfile(
                    name: nameCtrl.text,
                    email: user.email,
                    phone: phoneCtrl.text,
                    address: addrCtrl.text,
                  );
                  Navigator.pop(context);
                  // Sweet alert konfirmasi simpan
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.scale,
                    title: 'Tersimpan!',
                    desc: 'Informasi pengiriman berhasil diperbarui.',
                    btnOkOnPress: () {},
                    btnOkColor: AppTheme.primary,
                  ).show();
                },
                child: const Text('Simpan'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0D3DC)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFE8EAF0),
    );

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    canvas.drawLine(Offset(size.width * 0.2, 0),
        Offset(size.width * 0.3, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.45), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.65), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}