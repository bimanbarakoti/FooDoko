// lib/features/home/providers/home_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_home_repository.dart';
import '../data/models/category_model.dart';
import '../data/models/restaurant_model.dart';

final homeRepoProvider = Provider<MockHomeRepository>((ref) => MockHomeRepository());

final categoriesProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) async {
  final repo = ref.watch(homeRepoProvider);
  return repo.fetchCategories();
});

final popularProvider = FutureProvider.autoDispose<List<RestaurantModel>>((ref) async {
  final repo = ref.watch(homeRepoProvider);
  // mock lat/lng
  return repo.fetchPopular(0.0, 0.0);
});
