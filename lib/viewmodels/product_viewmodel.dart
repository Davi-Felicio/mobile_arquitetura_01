import 'package:flutter/foundation.dart';
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
      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
