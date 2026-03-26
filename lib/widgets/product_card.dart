import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.image, width: 50),
      title: Text(product.title),
      subtitle: Text("\$${product.price}"),
      trailing: Checkbox(
        value: isFavorite,
        onChanged: (_) => onFavoriteToggle(),
      ),
      onTap: onTap,
    );
  }
}
