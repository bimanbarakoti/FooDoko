// lib/features/food_roulette/views/food_roulette_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../food_roulette/providers/roulette_providers.dart';
import '../../../app/config/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodRouletteScreen extends ConsumerStatefulWidget {
  const FoodRouletteScreen({super.key});
  @override
  ConsumerState<FoodRouletteScreen> createState() => _FoodRouletteScreenState();
}

class _FoodRouletteScreenState extends ConsumerState<FoodRouletteScreen> {
  double budget = 10.0;
  AsyncValue? result;

  Future<void> _spin() async {
    setState((){ result = null; });
    final r = await ref.read(spinProvider(budget).future);
    if (!mounted) return;
    showDialog(context: context, builder: (_) => AlertDialog(title: Text('Try this', style: GoogleFonts.poppins()), content: Text('${r.name}\n\$${r.price}'), actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('OK'))]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Roulette', style: GoogleFonts.poppins()), backgroundColor: AppColors.deepMidnight),
      backgroundColor: AppColors.deepMidnight,
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Set your budget', style: GoogleFonts.poppins(color: Colors.white)),
        Slider(value: budget, min: 3, max: 50, divisions: 47, label: '\$${budget.round()}', onChanged: (v)=> setState(()=> budget = v)),
        ElevatedButton(onPressed: _spin, child: const Text('Spin!'))
      ])),
    );
  }
}
