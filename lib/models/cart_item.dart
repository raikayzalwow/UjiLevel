import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final String selectedColor;
  final String selectedStyle;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.selectedColor,
    required this.selectedStyle,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': product.id,
      'productName': product.name,
      'price': product.price,
      'image': product.images.isNotEmpty ? product.images[0] : '',
      'selectedColor': selectedColor,
      'selectedStyle': selectedStyle,
      'quantity': quantity,
    };
  }
}
