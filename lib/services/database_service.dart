import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../models/farmer.dart';
import '../models/order.dart';
import '../core/errors/failures.dart';

class DatabaseService {
  final String baseUrl;

  DatabaseService({required this.baseUrl});

  // Productos
  Future<List<Product>> getProducts({String? category}) async {
    try {
      final uri = category != null
          ? Uri.parse('$baseUrl/products?category=$category')
          : Uri.parse('$baseUrl/products');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((p) => Product.fromJson(p)).toList();
      } else {
        throw DatabaseFailure('Error al obtener productos');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw DatabaseFailure('Error al crear producto');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  // Agricultores
  Future<List<Farmer>> getFarmers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/farmers'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((f) => Farmer.fromJson(f)).toList();
      } else {
        throw DatabaseFailure('Error al obtener agricultores');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  // Órdenes
  Future<List<Order>> getOrders({required String userId}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders?userId=$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((o) => Order.fromJson(o)).toList();
      } else {
        throw DatabaseFailure('Error al obtener órdenes');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  Future<Order> createOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(order.toJson()),
      );

      if (response.statusCode == 201) {
        return Order.fromJson(json.decode(response.body));
      } else {
        throw DatabaseFailure('Error al crear orden');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  Future<Order> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status.name}),
      );

      if (response.statusCode == 200) {
        return Order.fromJson(json.decode(response.body));
      } else {
        throw DatabaseFailure('Error al actualizar estado');
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }
}