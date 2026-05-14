// File: lib/product_model.dart

class Product {
  final int? id;
  final String name;
  final String price; // Di JSON tadi price bentuknya String "150000.00"
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  // Fungsi untuk mengubah JSON dari API (Postman tadi) menjadi Object Flutter
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      description: json['description'] ?? '',
    );
  }

  // Fungsi untuk mengubah Object Flutter menjadi JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }
}