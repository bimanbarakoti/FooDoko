// lib/features/food_roulette/data/food_roulette_repository.dart
import 'dart:async';
import 'dart:math';

class RouletteDish {
  final String id;
  final String name;
  final double price;
  RouletteDish({required this.id, required this.name, required this.price});
}

class FoodRouletteRepository {
  final List<RouletteDish> _dishes = List.generate(20, (i) => RouletteDish(id: 'd$i', name: 'Dish ${i+1}', price: (5 + i % 8).toDouble()));

  Future<RouletteDish> spin(double budget) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final candidates = _dishes.where((d) => d.price <= budget).toList();
    final rnd = Random();
    if (candidates.isEmpty) return _dishes[rnd.nextInt(_dishes.length)];
    return candidates[rnd.nextInt(candidates.length)];
  }
}
