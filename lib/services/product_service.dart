import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // Tüm ürünleri getir
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ürünler yüklenemedi: ${response.statusCode}');
    }
  }

  // Kategorileri getir
  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/products/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return ['Tümü', ...jsonList.map((e) => e.toString())];
    } else {
      throw Exception('Kategoriler yüklenemedi');
    }
  }

  // Kategoriye göre ürün getir
  Future<List<Product>> getProductsByCategory(String category) async {
    if (category == 'Tümü') return getProducts();

    final response = await http.get(
      Uri.parse('$_baseUrl/products/category/$category'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ürünler yüklenemedi');
    }
  }
}
