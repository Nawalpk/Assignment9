import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/product.dart';

class ProductService {
  final String _endpoint = ApiConstants.productsEndpoint;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
      return decoded
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception(
        'Failed to load products (status ${response.statusCode})');
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> decoded =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(decoded);
    }
    throw Exception(
        'Failed to create product (status ${response.statusCode})');
  }

  Future<void> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception('Cannot update a product without an id');
    }
    final response = await http.put(
      Uri.parse('$_endpoint/${product.id}'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update product (status ${response.statusCode})');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$_endpoint/$id'));
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete product (status ${response.statusCode})');
    }
  }
}
