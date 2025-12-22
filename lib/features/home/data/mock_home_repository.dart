// lib/features/home/data/mock_home_repository.dart
import 'dart:async';
import 'models/category_model.dart';
import 'models/restaurant_model.dart';
import 'models/dish_model.dart';

class MockHomeRepository {
  Future<List<CategoryModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      CategoryModel(id: 'c1', title: 'Pizza', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=200&h=200&fit=crop'),
      CategoryModel(id: 'c2', title: 'Burgers', imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&h=200&fit=crop'),
      CategoryModel(id: 'c3', title: 'Asian', imageUrl: 'https://images.unsplash.com/photo-1617093727343-374698b1b08d?w=200&h=200&fit=crop'),
      CategoryModel(id: 'c4', title: 'Desserts', imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=200&h=200&fit=crop'),
      CategoryModel(id: 'c5', title: 'Healthy', imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200&h=200&fit=crop'),
    ];
  }

  Future<List<RestaurantModel>> fetchPopular(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final restaurants = [
      RestaurantModel(
        id: 'r1',
        name: 'Pizza Palace',
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=200&fit=crop',
        shortDesc: 'Authentic Italian pizzas & pasta',
      ),
      RestaurantModel(
        id: 'r2',
        name: 'Burger Junction',
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=200&fit=crop',
        shortDesc: 'Gourmet burgers & crispy fries',
      ),
      RestaurantModel(
        id: 'r3',
        name: 'Sakura Sushi',
        rating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=200&fit=crop',
        shortDesc: 'Fresh sushi & Japanese cuisine',
      ),
      RestaurantModel(
        id: 'r4',
        name: 'Taco Fiesta',
        rating: 4.5,
        imageUrl: 'https://images.unsplash.com/photo-1565299585323-38174c4a6471?w=400&h=200&fit=crop',
        shortDesc: 'Authentic Mexican street food',
      ),
      RestaurantModel(
        id: 'r5',
        name: 'Green Garden',
        rating: 4.7,
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=200&fit=crop',
        shortDesc: 'Fresh salads & healthy bowls',
      ),
      RestaurantModel(
        id: 'r6',
        name: 'Spice Route',
        rating: 4.4,
        imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&h=200&fit=crop',
        shortDesc: 'Aromatic Indian curries & naan',
      ),
    ];
    return restaurants;
  }

  Future<List<DishModel>> fetchDishesForRestaurant(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final dishMap = {
      'r1': [ // Pizza Palace
        DishModel(id: 'r1-d1', name: 'Margherita Pizza', imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=300&h=200&fit=crop', description: 'Classic tomato, mozzarella & basil', price: 12.99),
        DishModel(id: 'r1-d2', name: 'Pepperoni Supreme', imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=300&h=200&fit=crop', description: 'Loaded with pepperoni & cheese', price: 15.99),
        DishModel(id: 'r1-d3', name: 'Chicken Alfredo Pasta', imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=300&h=200&fit=crop', description: 'Creamy alfredo with grilled chicken', price: 13.99),
      ],
      'r2': [ // Burger Junction
        DishModel(id: 'r2-d1', name: 'Classic Cheeseburger', imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop', description: 'Beef patty, cheese, lettuce, tomato', price: 9.99),
        DishModel(id: 'r2-d2', name: 'BBQ Bacon Burger', imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433a?w=300&h=200&fit=crop', description: 'BBQ sauce, bacon, onion rings', price: 12.99),
        DishModel(id: 'r2-d3', name: 'Crispy Chicken Sandwich', imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e2013455?w=300&h=200&fit=crop', description: 'Fried chicken, mayo, pickles', price: 10.99),
      ],
      'r3': [ // Sakura Sushi
        DishModel(id: 'r3-d1', name: 'Salmon Nigiri Set', imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300&h=200&fit=crop', description: 'Fresh salmon over seasoned rice', price: 16.99),
        DishModel(id: 'r3-d2', name: 'California Roll', imageUrl: 'https://images.unsplash.com/photo-1617093727343-374698b1b08d?w=300&h=200&fit=crop', description: 'Crab, avocado, cucumber roll', price: 8.99),
        DishModel(id: 'r3-d3', name: 'Chicken Teriyaki Bowl', imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=300&h=200&fit=crop', description: 'Grilled chicken with teriyaki sauce', price: 11.99),
      ],
    };
    
    return dishMap[restaurantId] ?? [
      DishModel(id: '$restaurantId-d1', name: 'House Special', imageUrl: 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=300&h=200&fit=crop', description: 'Chef\'s recommended dish', price: 14.99),
      DishModel(id: '$restaurantId-d2', name: 'Popular Choice', imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=300&h=200&fit=crop', description: 'Customer favorite item', price: 12.99),
    ];
  }
}
