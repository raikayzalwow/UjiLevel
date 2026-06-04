class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final List<String> colors;
  final List<String> styles;
  bool isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.colors,
    required this.styles,
    this.isWishlisted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'images': images,
      'colors': colors,
      'styles': styles,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      images: List<String>.from(map['images'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      styles: List<String>.from(map['styles'] ?? []),
    );
  }
}
