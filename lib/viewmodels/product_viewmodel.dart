import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'product_state.dart';

class ProductViewModel {
  final ProductService service;

  final ValueNotifier<ProductState> state =
      ValueNotifier(const ProductState());

  ProductViewModel(this.service);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final products = await service.getProducts();
      state.value = state.value.copyWith(isLoading: false, products: products);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    final created = await service.addProduct(product);
    state.value = state.value.copyWith(
      products: [...state.value.products, created],
    );
  }

  Future<void> updateProduct(Product product) async {
    await service.updateProduct(product);
    final updated = state.value.products
        .map((p) => p.id == product.id ? product : p)
        .toList();
    state.value = state.value.copyWith(products: updated);
  }

  Future<void> deleteProduct(int id) async {
    await service.deleteProduct(id);
    final updated =
        state.value.products.where((p) => p.id != id).toList();
    state.value = state.value.copyWith(products: updated);
  }
}
