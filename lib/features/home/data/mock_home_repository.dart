// lib/features/home/data/mock_home_repository.dart
import 'dart:async';
import 'models/category_model.dart';
import 'models/restaurant_model.dart';
import 'models/dish_model.dart';

class MockHomeRepository {
  Future<List<CategoryModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      CategoryModel(id: 'c1', title: 'Pizza', imageUrl: 'https://picsum.photos/200?pizza'),
      CategoryModel(id: 'c2', title: 'Burgers', imageUrl: 'https://picsum.photos/200?burger'),
      CategoryModel(id: 'c3', title: 'Asian', imageUrl: 'https://picsum.photos/200?asian'),
      CategoryModel(id: 'c4', title: 'Desserts', imageUrl: 'https://picsum.photos/200?dessert'),
      CategoryModel(id: 'c5', title: 'Healthy', imageUrl: 'https://picsum.photos/200?salad'),
    ];
  }

  Future<List<RestaurantModel>> fetchPopular(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final restaurants = [
      RestaurantModel(
        id: 'r1',
        name: 'Pizza Palace',
        rating: 4.8,
        imageUrl: 'https://picsum.photos/400/200?pizza',
        shortDesc: 'Authentic Italian pizzas & pasta',
      ),
      RestaurantModel(
        id: 'r2',
        name: 'Burger Junction',
        rating: 4.6,
        imageUrl: 'https://picsum.photos/400/200?burger',
        shortDesc: 'Gourmet burgers & crispy fries',
      ),
      RestaurantModel(
        id: 'r3',
        name: 'Sakura Sushi',
        rating: 4.9,
        imageUrl: 'https://picsum.photos/400/200?sushi',
        shortDesc: 'Fresh sushi & Japanese cuisine',
      ),
      RestaurantModel(
        id: 'r4',
        name: 'Taco Fiesta',
        rating: 4.5,
        imageUrl: 'https://picsum.photos/400/200?taco',
        shortDesc: 'Authentic Mexican street food',
      ),
      RestaurantModel(
        id: 'r5',
        name: 'Green Garden',
        rating: 4.7,
        imageUrl: 'https://picsum.photos/400/200?salad',
        shortDesc: 'Fresh salads & healthy bowls',
      ),
      RestaurantModel(
        id: 'r6',
        name: 'Spice Route',
        rating: 4.4,
        imageUrl: 'https://picsum.photos/400/200?curry',
        shortDesc: 'Aromatic Indian curries & naan',
      ),
    ];
    return restaurants;
  }

  Future<List<DishModel>> fetchDishesForRestaurant(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final dishMap = {
      'r1': [ // Pizza Palace
        DishModel(id: 'r1-d1', name: 'Margherita Pizza', imageUrl: 'https://picsum.photos/300/200?margherita', description: 'Classic tomato, mozzarella & basil', price: 12.99),
        DishModel(id: 'r1-d2', name: 'Pepperoni Supreme', imageUrl: 'https://picsum.photos/300/200?pepperoni', description: 'Loaded with pepperoni & cheese', price: 15.99),
        DishModel(id: 'r1-d3', name: 'Chicken Alfredo Pasta', imageUrl: 'https://picsum.photos/300/200?pasta', description: 'Creamy alfredo with grilled chicken', price: 13.99),
      ],
      'r2': [ // Burger Junction
        DishModel(id: 'r2-d1', name: 'Classic Cheeseburger', imageUrl: 'https://picsum.photos/300/200?cheeseburger', description: 'Beef patty, cheese, lettuce, tomato', price: 9.99),
        DishModel(id: 'r2-d2', name: 'BBQ Bacon Burger', imageUrl: 'https://picsum.photos/300/200?bbqburger', description: 'BBQ sauce, bacon, onion rings', price: 12.99),
        DishModel(id: 'r2-d3', name: 'Crispy Chicken Sandwich', imageUrl: 'https://picsum.photos/300/200?chickensandwich', description: 'Fried chicken, mayo, pickles', price: 10.99),
      ],
      'r3': [ // Sakura Sushi
        DishModel(id: 'r3-d1', name: 'Salmon Nigiri Set', imageUrl: 'https://picsum.photos/300/200?salmon', description: 'Fresh salmon over seasoned rice', price: 16.99),
        DishModel(id: 'r3-d2', name: 'California Roll', imageUrl: 'https://picsum.photos/300/200?californiaroll', description: 'Crab, avocado, cucumber roll', price: 8.99),
        DishModel(id: 'r3-d3', name: 'Chicken Teriyaki Bowl', imageUrl: 'https://picsum.photos/300/200?teriyaki', description: 'Grilled chicken with teriyaki sauce', price: 11.99),
      ],
    };
    
    return dishMap[restaurantId] ?? [
      DishModel(id: '$restaurantId-d1', name: 'House Special', imageUrl: 'https://picsum.photos/300/200?food1', description: 'Chef\'s recommended dish', price: 14.99),
      DishModel(id: '$restaurantId-d2', name: 'Popular Choice', imageUrl: 'https://picsum.photos/300/200?food2', description: 'Customer favorite item', price: 12.99),
    ];
  }
}
