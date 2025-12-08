// lib/features/restaurant/data/mock_restaurant_repository.dart
import 'dart:async';
import 'models/menu_section_model.dart';
import 'models/menu_item_model.dart';

class MockRestaurantRepository {
  Future<List<MenuSectionModel>> fetchSections(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      MenuSectionModel(id: 's1', title: 'Quick Snack', itemIds: ['i1','i2']),
      MenuSectionModel(id: 's2', title: '30-Min Comfort', itemIds: ['i3','i4','i5']),
      MenuSectionModel(id: 's3', title: 'Slow Cooked', itemIds: ['i6','i7']),
    ];
  }

  Future<List<MenuItemModel>> fetchItems(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 450));
    return List.generate(7, (i) => MenuItemModel(
      id: 'i${i+1}',
      name: 'Menu Item ${i+1}',
      description: 'Tasty component ${i+1}',
      price: 6.5 + i,
      imageUrl: 'https://picsum.photos/300/200?menu=$i',
    ));
  }
}
