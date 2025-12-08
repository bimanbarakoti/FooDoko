// lib/features/home/views/home_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/widgets/glass/frosted_container.dart';
import '../../home/providers/home_providers.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popular = ref.watch(popularProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Ingredient River', style: GoogleFonts.poppins(color: AppColors.electricGreen)), backgroundColor: AppColors.deepMidnight, elevation: 0, actions: [IconButton(onPressed: ()=> context.push('/cart'), icon: const Icon(Icons.shopping_basket))]),
      backgroundColor: AppColors.deepMidnight,
      body: popular.when(data: (list) {
        return ListView.builder(itemCount: list.length, itemBuilder: (c,i){
          final r = list[i];
          return GestureDetector(
              onTap: () => context.push('/restaurant/${r.id}'),
              child: Container(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), height: 180, clipBehavior: Clip.hardEdge, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)), child: Stack(children: [
                Positioned.fill(child: Image.network(r.imageUrl, fit: BoxFit.cover)),
                Positioned(bottom: 12, left: 12, child: FrostedContainer(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)), const SizedBox(height:4), Text(r.shortDesc, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12))]), padding: const EdgeInsets.all(12)))
              ]))
          );
        });
      }, loading: ()=> const Center(child: CircularProgressIndicator()), error: (e,st)=> Center(child: Text('Error: $e'))),
    );
  }
}
