import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String _promoCode = '';
  double _discount = 0;

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  String get promoCode => _promoCode;

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => _items.isEmpty ? 0 : 5.0;
  double get discountAmount => _discount;
  double get total => subtotal - discountAmount + deliveryFee;

  void addToCart(Product product, String color, String style, int quantity) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor == color &&
          item.selectedStyle == style,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: const Uuid().v4(),
        product: product,
        selectedColor: color,
        selectedStyle: style,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int quantity) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  bool applyPromoCode(String code) {
    if (code.toUpperCase() == 'HOOMLY10') {
      _promoCode = code;
      _discount = subtotal * 0.10;
      notifyListeners();
      return true;
    } else if (code.toUpperCase() == 'SAVE5') {
      _promoCode = code;
      _discount = 5.5;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _promoCode = '';
    _discount = 0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _promoCode = '';
    _discount = 0;
    notifyListeners();
  }
}
