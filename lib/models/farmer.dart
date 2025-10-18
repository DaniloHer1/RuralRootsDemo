import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'product.dart';

class Farmer extends Equatable {
  final String id;
  final String name;
  final LatLng location;
  final List<Product> products;
  final double rating;
  final int reviewCount;
  final String? imageUrl;

  const Farmer({
    required this.id,
    required this.name,
    required this.location,
    required this.products,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imageUrl,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'] as String,
      name: json['name'] as String,
      location: LatLng(
        json['latitude'] as double,
        json['longitude'] as double,
      ),
      products: (json['products'] as List<dynamic>?)
              ?.map((p) => Product.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'products': products.map((p) => p.toJson()).toList(),
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
    };
  }

  int get availableProductsCount => products.where((p) => p.isAvailable).length;

  @override
  List<Object?> get props => [id, name, location, products, rating, reviewCount, imageUrl];
}