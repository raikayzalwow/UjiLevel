import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<Product> get featuredProducts =>
      _products.where((p) => p.rating >= 4.5).take(6).toList();

  List<Product> get popularProducts =>
      _products.where((p) => p.reviewCount > 80).take(6).toList();

  List<Product> get wishlistedProducts =>
      _products.where((p) => p.isWishlisted).toList();

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _products = MockDataService.getProducts();
    _filteredProducts = List.from(_products);

    _isLoading = false;
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void toggleWishlist(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].isWishlisted = !_products[index].isWishlisted;
      notifyListeners();
    }
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
