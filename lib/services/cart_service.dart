import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  final String farmerId;
  final String farmerName;
  int quantity;

  CartItem({
    required this.product,
    required this.farmerId,
    required this.farmerName,
    this.quantity = 1,
  });

  double get total => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      farmerId: farmerId,
      farmerName: farmerName,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.total);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  void addItem({
    required Product product,
    required String farmerId,
    required String farmerName,
    int quantity = 1,
  }) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.farmerId == farmerId,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          product: product,
          farmerId: farmerId,
          farmerName: farmerName,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId, String farmerId) {
    _items.removeWhere(
      (item) => item.product.id == productId && item.farmerId == farmerId,
    );
    notifyListeners();
  }

  void updateQuantity(String productId, String farmerId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId, farmerId);
      return;
    }

    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.farmerId == farmerId,
    );

    if (index >= 0) {
      _items[index].quantity = quantity;
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

  double getTotalByFarmer(String farmerId) {
    return _items
        .where((item) => item.farmerId == farmerId)
        .fold(0, (sum, item) => sum + item.total);
  }
}