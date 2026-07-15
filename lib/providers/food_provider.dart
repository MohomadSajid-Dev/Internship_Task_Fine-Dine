import 'package:flutter/foundation.dart';

import '../data/food_repository.dart';
import '../models/food_item.dart';

class FoodProvider extends ChangeNotifier {
  FoodProvider(this._repository);

  final FoodRepository _repository;

  static const categories = [
    'All',
    'Specials',
    'Hoppers',
    'Seafood',
    'Short Eats',
    'Desserts',
    'Drinks',
    'Vegetarian',
  ];

  List<FoodItem> _allItems = [];
  List<FoodItem> _filteredItems = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = true;

  List<FoodItem> get items => _filteredItems;
  List<FoodItem> get allItems => _allItems;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadFoodItems() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 3000));
    _allItems = await _repository.loadFoodItems();
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _allItems = await _repository.loadFoodItems(forceRefresh: true);
    _applyFilters();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  FoodItem? getById(String id) {
    try {
      return _allItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FoodItem> getSuggested(String excludeId, {int limit = 4}) {
    final current = getById(excludeId);
    if (current == null) {
      return _allItems.take(limit).toList();
    }
    return _allItems
        .where((item) =>
            item.id != excludeId &&
            (item.category == current.category ||
                item.restaurantName == current.restaurantName))
        .take(limit)
        .toList();
  }

  void _applyFilters() {
    _filteredItems = _allItems.where((item) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.shortDescription.toLowerCase().contains(query) ||
          item.restaurantName.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == 'All' ||
          (_selectedCategory == 'Vegetarian'
              ? item.isVegetarian
              : _selectedCategory == 'Specials'
                  ? item.category == 'Specials'
                  : item.category == _selectedCategory);

      return matchesSearch && matchesCategory;
    }).toList();
  }
}
