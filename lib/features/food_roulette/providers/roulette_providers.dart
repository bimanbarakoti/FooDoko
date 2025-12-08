// lib/features/food_roulette/providers/roulette_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/food_roulette_repository.dart';

final rouletteRepoProvider = Provider<FoodRouletteRepository>((ref) => FoodRouletteRepository());

final spinProvider = FutureProvider.family<RouletteDish, double>((ref, budget) async {
  final repo = ref.watch(rouletteRepoProvider);
  return repo.spin(budget);
});
