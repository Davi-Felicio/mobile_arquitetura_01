import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorites_notifier.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/product_state.dart';

class ProductPage extends StatelessWidget {
  final ProductViewModel viewModel;

  const ProductPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          return Consumer<FavoritesNotifier>(
            builder: (context, favorites, _) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    leading: Image.network(product.image, width: 50),
                    title: Text(product.title),
                    subtitle: Text("\$${product.price}"),
                    trailing: Checkbox(
                      value: favorites.isFavorite(product.id),
                      onChanged: (_) => favorites.toggle(product.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.loadProducts,
        child: const Icon(Icons.download),
      ),
    );
  }
}
