import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../utils/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _selectedPayment = 'Kartu Kredit';

  Color _hexToColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return AppTheme.grey;
    }
  }

  // Format sesuai KBBI: Rp4.500.000 (tanpa spasi)
  String _formatRupiah(double price) {
    final parts = price.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (ctx, cart, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 80, color: AppTheme.greyLight),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjangmu masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan furnitur untuk memulai',
                    style: TextStyle(fontSize: 14, color: AppTheme.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...cart.items.map((item) => _buildCartItem(context, item)),
                    const SizedBox(height: 24),
                    _buildPaymentMethod(context, cart),
                  ],
                ),
              ),
              _buildBottomBar(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.product.images[0],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: AppTheme.greyLight, width: 70, height: 70),
              errorWidget: (_, __, ___) =>
                  Container(color: AppTheme.greyLight, width: 70, height: 70),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Gaya: ${item.selectedStyle}',
                      style:
                          const TextStyle(fontSize: 11, color: AppTheme.grey),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _hexToColor(item.selectedColor),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppTheme.greyLight, width: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // FIX 5: Format KBBI tanpa spasi
                      _formatRupiah(item.product.price),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    Row(
                      children: [
                        _buildQtyBtn(
                          icon: Icons.remove,
                          onTap: () => context
                              .read<CartProvider>()
                              .updateQuantity(item.id, item.quantity - 1),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _buildQtyBtn(
                          icon: Icons.add,
                          onTap: () => context
                              .read<CartProvider>()
                              .updateQuantity(item.id, item.quantity + 1),
                          filled: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // FIX: Sweet alert konfirmasi hapus item
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                title: 'Hapus Produk',
                desc:
                    'Apakah kamu yakin ingin menghapus ${item.product.name} dari keranjang?',
                btnCancelText: 'Batal',
                btnCancelOnPress: () {},
                btnOkText: 'Hapus',
                btnOkOnPress: () =>
                    context.read<CartProvider>().removeItem(item.id),
                btnOkColor: Colors.red,
              ).show();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.close, color: AppTheme.grey, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(
      {required IconData icon,
      required VoidCallback onTap,
      bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? AppTheme.black : AppTheme.greyBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon,
            size: 16, color: filled ? AppTheme.white : AppTheme.black),
      ),
    );
  }

  // FIX 2: Payment method dengan state & GestureDetector agar Tunai bisa di-tap
  Widget _buildPaymentMethod(BuildContext context, CartProvider cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Metode Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          icon: Icons.credit_card,
          label: 'Kartu Kredit',
          isSelected: _selectedPayment == 'Kartu Kredit',
          onTap: () => setState(() => _selectedPayment = 'Kartu Kredit'),
        ),
        const SizedBox(height: 8),
        _buildPaymentOption(
          icon: Icons.money,
          label: 'Tunai',
          isSelected: _selectedPayment == 'Tunai',
          onTap: () => setState(() => _selectedPayment = 'Tunai'),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.05)
              : AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.greyLight,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? AppTheme.primary : AppTheme.grey,
                size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppTheme.primary : AppTheme.black,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.greyLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartProvider cart) {
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
              child: const Text('Tambah Produk',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CheckoutScreen(selectedPayment: _selectedPayment),
                ),
              ),
              child: const Text('Checkout',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}