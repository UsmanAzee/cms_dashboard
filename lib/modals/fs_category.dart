import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Timestamp

class Product {
  late final String label;
  late final Timestamp created;
  late final Timestamp updated;
  late final List<String> images;

  Product(this.label, this.created, this.updated, this.images);

  // Factory constructor to create a Product instance from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['label'] as String,
      json['created'] as Timestamp,
      json['updated'] as Timestamp,
      List<String>.from(json['images']),
    );
  }

  // Method to convert a Product instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'created': created,
      'updated': updated,
      'images': images,
    };
  }
}

class Category {
  late final String label;
  late final Timestamp created;
  late final Timestamp updated;
  late final List<Product> products;

  Category(this.label, this.created, this.updated, this.products);

  // Factory constructor to create a Category instance from a JSON map
  factory Category.fromJson(Map<String, dynamic> json) {
    final List<Product> productsList = List<Product>.from(json['products'].map((productJson) => Product.fromJson(productJson as Map<String, dynamic>)));
    return Category(
      json['label'] as String,
      json['created'] as Timestamp,
      json['updated'] as Timestamp,
      productsList,
    );
  }

  // Method to convert a Category instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'created': created,
      'updated': updated,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
