// lib/features/home/data/mock_home_repository.dart
import 'dart:async';
import 'models/category_model.dart';
import 'models/restaurant_model.dart';
import 'models/dish_model.dart';

class MockHomeRepository {
  Future<List<CategoryModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      CategoryModel(id: 'c1', title: 'Ginger', imageUrl: 'https://picsum.photos/200?1'),
      CategoryModel(id: 'c2', title: 'Chili', imageUrl: 'https://picsum.photos/200?2'),
      CategoryModel(id: 'c3', title: 'Vanilla', imageUrl: 'https://picsum.photos/200?3'),
    ];
  }

  Future<List<RestaurantModel>> fetchPopular(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(6, (i) => RestaurantModel(
      id: 'r$i',
      name: 'Chef Place $i',
      rating: 4.0 + (i % 5) * 0.1,
      imageUrl: 'https://picsum.photos/400/200?random=$i',
      shortDesc: 'Tasty food and cozy vibe',
    ));
  }

  Future<List<DishModel>> fetchDishesForRestaurant(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(8, (i) => DishModel(
      id: '$restaurantId-d$i',
      name: 'Dish ${i+1}',
      imageUrl: 'https://picsum.photos/300/200?dish=$i',
      description: 'Delicious item #${i+1}',
      price: 5.0 + i * 2,
    ));
  }
}
