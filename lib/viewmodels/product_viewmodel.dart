import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import 'product_state.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state =
      ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(isLoading: false, products: products);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    final created = await repository.addProduct(product);
    state.value = state.value.copyWith(
      products: [...state.value.products, created],
    );
  }

  Future<void> updateProduct(Product product) async {
    await repository.updateProduct(product);
    final updated = state.value.products
        .map((p) => p.id == product.id ? product : p)
        .toList();
    state.value = state.value.copyWith(products: updated);
  }

  Future<void> deleteProduct(int id) async {
    await repository.deleteProduct(id);
    final updated =
        state.value.products.where((p) => p.id != id).toList();
    state.value = state.value.copyWith(products: updated);
  }
}
