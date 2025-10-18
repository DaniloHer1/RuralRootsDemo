import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending('Pendiente'),
  confirmed('Confirmado'),
  delivered('Entregado'),
  cancelled('Cancelado');

  final String displayName;
  const OrderStatus(this.displayName);
}

class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final String unit;
  final double price;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.price,
  });

  double get total => quantity * price;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unit': unit,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [productId, productName, quantity, unit, price];
}

class Order extends Equatable {
  final String id;
  final String farmerId;
  final String farmerName;
  final String buyerId;
  final String buyerName;
  final List<OrderItem> items;
  final OrderStatus status;
  final String paymentMethod;
  final DateTime createdAt;
  final String? notes;
  final int? rating;

  const Order({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.buyerId,
    required this.buyerName,
    required this.items,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.notes,
    this.rating,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      farmerId: json['farmerId'] as String,
      farmerName: json['farmerName'] as String,
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: json['paymentMethod'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
      rating: json['rating'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'items': items.map((i) => i.toJson()).toList(),
      'status': status.name,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'rating': rating,
    };
  }

  Order copyWith({
    String? id,
    String? farmerId,
    String? farmerName,
    String? buyerId,
    String? buyerName,
    List<OrderItem>? items,
    OrderStatus? status,
    String? paymentMethod,
    DateTime? createdAt,
    String? notes,
    int? rating,
  }) {
    return Order(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      items: items ?? this.items,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
        id,
        farmerId,
        farmerName,
        buyerId,
        buyerName,
        items,
        status,
        paymentMethod,
        createdAt,
        notes,
        rating,
      ];
}