// lib/features/restaurant/providers/restaurant_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_restaurant_repository.dart';
import '../data/models/menu_item_model.dart';
import '../data/models/menu_section_model.dart';

final restaurantRepoProvider = Provider<MockRestaurantRepository>((ref) => MockRestaurantRepository());

final menuSectionsProvider = FutureProvider.family<List<MenuSectionModel>, String>((ref, restaurantId) async {
  final repo = ref.watch(restaurantRepoProvider);
  return repo.fetchSections(restaurantId);
});

final menuItemsProvider = FutureProvider.family<List<MenuItemModel>, String>((ref, restaurantId) async {
  final repo = ref.watch(restaurantRepoProvider);
  return repo.fetchItems(restaurantId);
});
