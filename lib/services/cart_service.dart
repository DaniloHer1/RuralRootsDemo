// lib/services/cart_service.dart
import 'package:flutter/foundation.dart';

class CartItem {
  final String productId;
  final String productName;
  final String farmerName;
  final String farmerId;
  final double price;
  final String unit;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.productName,
    required this.farmerName,
    required this.farmerId,
    required this.price,
    required this.unit,
    this.quantity = 1,
    this.imageUrl,
  });

  double get total => price * quantity;
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  void addItem({
    required String productId,
    required String productName,
    required String farmerName,
    required String farmerId,
    required double price,
    required String unit,
    String? imageUrl,
  }) {
    // Verificar si el producto ya está en el carrito
    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId && item.farmerId == farmerId,
    );

    if (existingIndex >= 0) {
      // Incrementar cantidad
      _items[existingIndex].quantity++;
    } else {
      // Añadir nuevo producto
      _items.add(
        CartItem(
          productId: productId,
          productName: productName,
          farmerName: farmerName,
          farmerId: farmerId,
          price: price,
          unit: unit,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId, String farmerId) {
    _items.removeWhere(
      (item) => item.productId == productId && item.farmerId == farmerId,
    );
    notifyListeners();
  }

  void updateQuantity(String productId, String farmerId, int quantity) {
    final index = _items.indexWhere(
      (item) => item.productId == productId && item.farmerId == farmerId,
    );
    
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Map<String, List<CartItem>> groupByFarmer() {
    final Map<String, List<CartItem>> grouped = {};
    
    for (var item in _items) {
      if (!grouped.containsKey(item.farmerId)) {
        grouped[item.farmerId] = [];
      }
      grouped[item.farmerId]!.add(item);
    }
    
    return grouped;
  }
}