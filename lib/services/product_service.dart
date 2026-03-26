import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  List<Product>? _cache;

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse("https://fakestoreapi.com/products"),
      );
      final List data = jsonDecode(response.body);
      final products = data.map((json) => Product.fromJson(json)).toList();
      _cache = products;
      return products;
    } catch (e) {
      if (_cache != null) return _cache!;
      throw Exception("Não foi possível carregar os produtos");
    }
  }
}
