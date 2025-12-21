import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/widgets/glass/frosted_container.dart';
import '../../home/data/models/category_model.dart';

class CategoryListView extends ConsumerWidget {
  final List<CategoryModel> categories;
  const CategoryListView({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final c = categories[index];

          return GestureDetector(
            onTap: () {},
            child: FrostedContainer(
              blur: 12,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (c.imageUrl != null && c.imageUrl!.isNotEmpty)
                    Image.network(c.imageUrl!, width: 36, height: 36)
                  else
                    const Icon(Icons.fastfood, color: Colors.white),

                  const SizedBox(height: 6),

                  Text(
                    c.title,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: categories.length,
      ),
    );
  }
}
