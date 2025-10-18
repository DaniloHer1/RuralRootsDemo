import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/farmer.dart';
import '../models/order.dart';
import '../core/errors/failures.dart';
import '../core/constants/app_constants.dart';

/// Servicio para interactuar con la base de datos (API REST)
class DatabaseService {
  final String baseUrl;
  late final http.Client _client;

  DatabaseService({required this.baseUrl}) {
    _client = http.Client();
  }

  /// Realiza una petición HTTP con manejo mejorado de errores
  Future<http.Response> _makeRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(
        Duration(milliseconds: AppConstants.apiTimeout),
        onTimeout: () {
          throw TimeoutException('La petición tardó demasiado');
        },
      );
    } on SocketException {
      throw NetworkFailure();
    } on TimeoutException {
      throw NetworkFailure();
    } on http.ClientException {
      throw NetworkFailure();
    } on FormatException {
      throw const DatabaseFailure('Formato de respuesta inválido');
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  // ============================================
  // PRODUCTOS
  // ============================================

  /// Obtiene la lista de productos, opcionalmente filtrados por categoría
  Future<List<Product>> getProducts({String? category}) async {
    try {
      final uri = category != null
          ? Uri.parse('$baseUrl/products?category=$category')
          : Uri.parse('$baseUrl/products');

      final response = await _makeRequest(() => _client.get(uri));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((p) => Product.fromJson(p)).toList();
      } else if (response.statusCode == 404) {
        // No se encontraron productos
        return [];
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al obtener productos: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Crea un nuevo producto
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _makeRequest(
        () => _client.post(
          Uri.parse('$baseUrl/products'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(product.toJson()),
        ),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 400) {
        throw const DatabaseFailure('Datos de producto inválidos');
      } else if (response.statusCode == 401) {
        throw const DatabaseFailure('No tienes permiso para crear productos');
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al crear producto: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Actualiza un producto existente
  Future<Product> updateProduct(String productId, Product product) async {
    try {
      final response = await _makeRequest(
        () => _client.put(
          Uri.parse('$baseUrl/products/$productId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(product.toJson()),
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 404) {
        throw const DatabaseFailure('Producto no encontrado');
      } else if (response.statusCode == 401) {
        throw const DatabaseFailure(
          'No tienes permiso para actualizar este producto',
        );
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al actualizar producto: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Elimina un producto
  Future<void> deleteProduct(String productId) async {
    try {
      final response = await _makeRequest(
        () => _client.delete(
          Uri.parse('$baseUrl/products/$productId'),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw const DatabaseFailure('Producto no encontrado');
      } else if (response.statusCode == 401) {
        throw const DatabaseFailure(
          'No tienes permiso para eliminar este producto',
        );
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al eliminar producto: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  // ============================================
  // AGRICULTORES
  // ============================================

  /// Obtiene la lista de agricultores
  Future<List<Farmer>> getFarmers() async {
    try {
      final response = await _makeRequest(
        () => _client.get(Uri.parse('$baseUrl/farmers')),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((f) => Farmer.fromJson(f)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al obtener agricultores: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Obtiene un agricultor por ID
  Future<Farmer> getFarmerById(String farmerId) async {
    try {
      final response = await _makeRequest(
        () => _client.get(Uri.parse('$baseUrl/farmers/$farmerId')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Farmer.fromJson(data);
      } else if (response.statusCode == 404) {
        throw const DatabaseFailure('Agricultor no encontrado');
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al obtener agricultor: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  // ============================================
  // ÓRDENES
  // ============================================

  /// Obtiene las órdenes de un usuario
  Future<List<Order>> getOrders({required String userId}) async {
    try {
      final response = await _makeRequest(
        () => _client.get(
          Uri.parse('$baseUrl/orders?userId=$userId'),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((o) => Order.fromJson(o)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al obtener órdenes: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Crea una nueva orden
  Future<Order> createOrder(Order order) async {
    try {
      final response = await _makeRequest(
        () => _client.post(
          Uri.parse('$baseUrl/orders'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(order.toJson()),
        ),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Order.fromJson(data);
      } else if (response.statusCode == 400) {
        throw const DatabaseFailure('Datos de orden inválidos');
      } else if (response.statusCode == 401) {
        throw const DatabaseFailure('No tienes permiso para crear órdenes');
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al crear orden: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Actualiza el estado de una orden
  Future<Order> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      final response = await _makeRequest(
        () => _client.patch(
          Uri.parse('$baseUrl/orders/$orderId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'status': status.name}),
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Order.fromJson(data);
      } else if (response.statusCode == 404) {
        throw const DatabaseFailure('Orden no encontrada');
      } else if (response.statusCode == 401) {
        throw const DatabaseFailure(
          'No tienes permiso para actualizar esta orden',
        );
      } else if (response.statusCode >= 500) {
        throw const DatabaseFailure(
          'Error en el servidor. Intenta más tarde',
        );
      } else {
        throw DatabaseFailure(
          'Error al actualizar estado: ${response.statusCode}',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _client.close();
  }
}