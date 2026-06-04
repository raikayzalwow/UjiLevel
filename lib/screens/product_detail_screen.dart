import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  int _selectedImageIndex = 0;
  int _quantity = 1;
  bool _isExpanded = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  String _formatRupiah(double price) {
    final parts = price.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  void _onColorTap(int index) {
    setState(() {
      _selectedColorIndex = index;
      _selectedImageIndex = index < widget.product.images.length ? index : 0;
    });
    if (_selectedImageIndex < widget.product.images.length) {
      _pageController.animateToPage(
        _selectedImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final screenH = MediaQuery.of(context).size.height;
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: screenH * 0.52,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImages(product),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: topPad + 72,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.35),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: topPad + 8,
                        left: 16,
                        child: _iconButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        top: topPad + 8,
                        right: 16,
                        child: Consumer<ProductProvider>(
                          builder: (_, pp, __) {
                            final p = pp.getProductById(product.id);
                            final fav = p?.isWishlisted == true;
                            return _iconButton(
                              icon:
                                  fav ? Icons.favorite : Icons.favorite_border,
                              iconColor: fav ? Colors.red : Colors.black87,
                              onTap: () => context
                                  .read<ProductProvider>()
                                  .toggleWishlist(product.id),
                            );
                          },
                        ),
                      ),
                      if (product.images.length > 1)
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(product.images.length, (i) {
                              final active = i == _selectedImageIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: active ? 22 : 7,
                                height: 7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: active
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: _buildDetail(product),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: botPad + 90)),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(product, botPad),
          ),
        ],
      ),
    );
  }

  Widget _buildImages(Product product) {
    if (product.images.isEmpty) {
      return Container(
        color: Colors.grey[100],
        child:
            const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: product.images.length,
      onPageChanged: (i) => setState(() => _selectedImageIndex = i),
      itemBuilder: (_, i) => Image.network(
        product.images[i],
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : Container(
                color: Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[100],
          child: const Icon(Icons.image_not_supported,
              size: 64, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildDetail(Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFC107), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${product.reviewCount} ulasan',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey[600],
                    height: 1.65,
                  ),
                  children: [
                    TextSpan(
                      text: _isExpanded
                          ? product.description
                          : (product.description.length > 120
                              ? '${product.description.substring(0, 120)}...'
                              : product.description),
                    ),
                    if (product.description.length > 120)
                      TextSpan(
                        text: _isExpanded ? ' Lebih Sedikit' : ' Selengkapnya',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (product.images.length > 1) ...[
            SizedBox(
              height: 68,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: product.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final active = i == _selectedImageIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedImageIndex = i);
                      _pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: active ? AppTheme.primary : Colors.grey[200]!,
                          width: active ? 2.5 : 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.images[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey[100]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (product.colors.isNotEmpty) ...[
            const Text(
              'Pilih Warna',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: product.colors.asMap().entries.map((e) {
                final active = e.key == _selectedColorIndex;
                final color = _hexToColor(e.value);
                return GestureDetector(
                  onTap: () => _onColorTap(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: active ? 36 : 32,
                    height: active ? 36 : 32,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active ? AppTheme.primary : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: active
                              ? AppTheme.primary.withValues(alpha: 0.35)
                              : Colors.black.withValues(alpha: 0.1),
                          blurRadius: active ? 8 : 4,
                        ),
                      ],
                    ),
                    child: active
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black54
                                : Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jumlah',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _qtyButton(
                      icon: Icons.remove,
                      onTap: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                    ),
                    SizedBox(
                      width: 44,
                      child: Center(
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    _qtyButton(
                      icon: Icons.add,
                      onTap: () => setState(() => _quantity++),
                      filled: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Divider(color: Colors.grey[100], thickness: 1),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    VoidCallback? onTap,
    bool filled = false,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: filled
              ? AppTheme.primary
              : (enabled ? Colors.white : Colors.grey[100]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: filled
              ? [
                  BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8)
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled
              ? Colors.white
              : (enabled ? Colors.black87 : Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildBottomBar(Product product, double botPad) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, botPad + 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          final color = product.colors.isNotEmpty
              ? product.colors[_selectedColorIndex]
              : 'Default';
          context.read<CartProvider>().addToCart(
                product,
                color,
                'Default',
                _quantity,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Berhasil ditambahkan ke keranjang!'),
                ],
              ),
              backgroundColor: AppTheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Lihat',
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
            ),
          );
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              const Text(
                'Tambah ke Keranjang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 1,
                height: 22,
                color: Colors.white.withValues(alpha: 0.4),
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),
              Text(
                _formatRupiah(product.price * _quantity),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
