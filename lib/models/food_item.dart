import 'review.dart';

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.price,
    required this.category,
    required this.restaurantName,
    required this.imageUrl,
    required this.rating,
    required this.prepTime,
    required this.availability,
    required this.ingredients,
    required this.spiceLevel,
    required this.isVegetarian,
    required this.reviews,
    this.isChefSelection = false,
  });

  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final double price;
  final String category;
  final String restaurantName;
  final String imageUrl;
  final double rating;
  final String prepTime;
  final String availability;
  final List<String> ingredients;
  final String spiceLevel;
  final bool isVegetarian;
  final List<Review> reviews;
  final bool isChefSelection;

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      restaurantName: json['restaurantName'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      prepTime: json['prepTime'] as String,
      availability: json['availability'] as String? ?? 'All Day',
      ingredients: (json['ingredients'] as List<dynamic>).cast<String>(),
      spiceLevel: json['spiceLevel'] as String,
      isVegetarian: json['isVegetarian'] as bool,
      reviews: (json['reviews'] as List<dynamic>)
          .map((r) => Review.fromJson(r as Map<String, dynamic>))
          .toList(),
      isChefSelection: json['isChefSelection'] as bool? ?? false,
    );
  }
}
