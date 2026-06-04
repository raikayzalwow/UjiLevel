import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<String> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double deliveryFee,
    required double total,
    required String deliveryName,
    required String deliveryPhone,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final orderId = 'HM-${DateTime.now().millisecondsSinceEpoch}';
    final order = Order(
      id: orderId,
      items: List.from(items),
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: total,
      status: 'confirmed',
      createdAt: DateTime.now(),
      deliveryName: deliveryName,
      deliveryPhone: deliveryPhone,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order);
    notifyListeners();
    return orderId;
  }
}
