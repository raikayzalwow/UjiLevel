import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final String status;
  final DateTime createdAt;
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;
  final String paymentMethod;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryAddress,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deliveryName': deliveryName,
      'deliveryPhone': deliveryPhone,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
    };
  }
}
