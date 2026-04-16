import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const _baseUrl = "https://fakestoreapi.com/products";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    final List data = jsonDecode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    final data = jsonDecode(response.body);
    return Product(
      id: data["id"],
      title: product.title,
      price: product.price,
      image: product.image,
      description: product.description,
    );
  }

  Future<Product> updateProduct(Product product) async {
    await http.put(
      Uri.parse("$_baseUrl/${product.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    return product;
  }

  Future<void> deleteProduct(int id) async {
    await http.delete(Uri.parse("$_baseUrl/$id"));
  }
}
