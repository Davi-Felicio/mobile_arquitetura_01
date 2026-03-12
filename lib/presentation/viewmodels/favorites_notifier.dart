import 'package:flutter/foundation.dart';

class FavoritesNotifier extends ChangeNotifier {
  final Set<int> _favorites = {};

  bool isFavorite(int productId) => _favorites.contains(productId);

  void toggle(int productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }
}
