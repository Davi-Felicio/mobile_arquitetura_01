import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService _service;
  List<Product>? _cache;

  ProductRepository(this._service);

  Future<List<Product>> getProducts() async {
    try {
      final products = await _service.fetchProducts();
      _cache = products;
      return products;
    } catch (e) {
      if (_cache != null) return _cache!;
      throw Exception("Não foi possível carregar os produtos");
    }
  }

  Future<Product> addProduct(Product product) async {
    return await _service.addProduct(product);
  }

  Future<Product> updateProduct(Product product) async {
    return await _service.updateProduct(product);
  }

  Future<void> deleteProduct(int id) async {
    await _service.deleteProduct(id);
  }
}
