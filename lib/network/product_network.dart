import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vape_store/models/product_model.dart';

class ProductNetwork {
  final String baseUrl = 'http://localhost:8000/api';

  // Fetch all products
  Future<List<ProductModel>> fetchProducts({
    String? category,
    String? name,
    String? order,
  }) async {
    // Build the URL with optional parameters
    final queryParameters = <String, String>{};
    if (name != null && name.isNotEmpty) queryParameters['name'] = name;
    if (category != null && category.isNotEmpty)
      queryParameters['category'] = category;
    if (order != null && order.isNotEmpty) queryParameters['order'] = order;

    final uri =
        Uri.parse('$baseUrl/product').replace(queryParameters: queryParameters);

    print(uri);

    final response = await http.get(uri);
    // final response = await http.get(Uri.parse(
    //     '$baseUrl/product?name=$name&category=$category&order=$order'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> productsData = jsonData['data'];
      return productsData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductModel>> fetchProductsFavorite() async {
    final response = await http.get(Uri.parse('$baseUrl/product/favorite'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> productsData = jsonData['data'];
      return productsData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductModel>> fetchProductsNewProduct() async {
    final response = await http.get(Uri.parse('$baseUrl/product/new-product'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> productsData = jsonData['data'];
      return productsData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductModel>> fetchProductsFlashSale() async {
    final response = await http.get(Uri.parse('$baseUrl/product/flash-sale'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> productsData = jsonData['data'];
      return productsData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch a single product by ID
  Future<ProductModel> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/product/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData['message']);
      return ProductModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  // Create a new product
  Future<ProductModel?> createProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/product'),
      body: jsonEncode(product.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData['message']);
      return ProductModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to create product');
    }
  }

  // Update a product
  Future updateProduct(ProductModel product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/product/${product.id}'),
        body: jsonEncode(product.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData['message']);
        return true; //ProductModel.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      return false;
    }
  }

  // Delete a product
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/product/$id'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData['message']);
        return true; //jsonData['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      // print(jsonData['message']);
      // print(object);
      return false;
    }
  }
}