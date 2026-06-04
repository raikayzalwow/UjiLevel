import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../utils/app_theme.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _categories = [
    'Semua',
    'Sofa',
    'Kursi',
    'Meja',
    'Lemari',
    'Tempat Tidur',
    'Lampu',
    'Karpet',
    'Dekorasi'
  ];

  String _formatRupiah(double price) {
    final parts = price.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: false,
          decoration: const InputDecoration(
            hintText: 'Cari furnitur...',
            border: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            context.read<ProductProvider>().search(value);
            setState(() {});
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () {
            context.read<ProductProvider>().search('');
            context.read<ProductProvider>().filterByCategory('Semua');
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppTheme.grey),
              onPressed: () {
                _searchController.clear();
                context.read<ProductProvider>().search('');
                setState(() {});
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<ProductProvider>(
      builder: (ctx, pp, _) => Container(
        color: AppTheme.white,
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: _categories.length,
          itemBuilder: (ctx, i) {
            final cat = _categories[i];
            final selectedCat = pp.selectedCategory;
            final isSelected = selectedCat == cat ||
                (cat == 'Semua' &&
                    (selectedCat == 'All' ||
                        selectedCat == 'Semua' ||
                        selectedCat.isEmpty));
            return GestureDetector(
              onTap: () =>
                  context.read<ProductProvider>().filterByCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.greyBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppTheme.white : AppTheme.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (ctx, pp, _) {
        if (pp.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (pp.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: AppTheme.greyLight),
                SizedBox(height: 16),
                Text(
                  'Produk tidak ditemukan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Coba kata kunci atau kategori lain',
                  style: TextStyle(fontSize: 13, color: AppTheme.grey),
                ),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: pp.products.length,
          itemBuilder: (ctx, i) => _buildProductCard(pp.products[i]),
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: product.images[0],
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppTheme.greyLight, height: 130),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppTheme.greyLight, height: 130),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => context
                        .read<ProductProvider>()
                        .toggleWishlist(product.id),
                    child: Consumer<ProductProvider>(
                      builder: (ctx, pp, _) {
                        final p = pp.getProductById(product.id);
                        return Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppTheme.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            p?.isWishlisted == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: p?.isWishlisted == true
                                ? AppTheme.red
                                : AppTheme.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    style: const TextStyle(fontSize: 11, color: AppTheme.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          _formatRupiah(product.price),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppTheme.star, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                                fontSize: 11, color: AppTheme.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
