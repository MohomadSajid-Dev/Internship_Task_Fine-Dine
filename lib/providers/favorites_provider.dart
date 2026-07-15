import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(String foodId) => _favoriteIds.contains(foodId);

  void toggleFavorite(String foodId) {
    if (_favoriteIds.contains(foodId)) {
      _favoriteIds.remove(foodId);
    } else {
      _favoriteIds.add(foodId);
    }
    notifyListeners();
  }
}
