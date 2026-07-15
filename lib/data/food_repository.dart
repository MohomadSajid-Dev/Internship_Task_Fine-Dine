import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/food_item.dart';

class FoodRepository {
  List<FoodItem>? _cachedItems;

  Future<List<FoodItem>> loadFoodItems({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedItems != null) return _cachedItems!;

    final jsonString =
        await rootBundle.loadString('assets/data/food_items.json');
    final jsonList = json.decode(jsonString) as List<dynamic>;
    _cachedItems = jsonList
        .map((item) => FoodItem.fromJson(item as Map<String, dynamic>))
        .toList();
    return _cachedItems!;
  }
}
