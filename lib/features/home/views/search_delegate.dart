// lib/features/home/views/search_delegate.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class AppSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> data; // expected: list of RestaurantModel (or objects with .name/.shortDesc/.id)

  AppSearchDelegate(this.data) : super(searchFieldLabel: 'Search restaurants, dishes...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filterResults();
    return _resultList(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = _filterResults(takeSuggestions: true);
    return _resultList(context, results);
  }

  List<dynamic> _filterResults({bool takeSuggestions = false}) {
    final lower = query.toLowerCase();
    final filtered = data.where((d) {
      final name = (d.name ?? '').toString().toLowerCase();
      final desc = (d.shortDesc ?? '').toString().toLowerCase();
      return name.contains(lower) || desc.contains(lower);
    }).toList();

    if (takeSuggestions) {
      return filtered.take(6).toList();
    }
    return filtered;
  }

  Widget _resultList(BuildContext context, List<dynamic> list) {
    if (list.isEmpty) {
      return Center(child: Text('No results', style: GoogleFonts.inter(color: Colors.white70)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.white10),
      itemBuilder: (c, i) {
        final r = list[i];
        return ListTile(
          onTap: () => context.push('/restaurant/${r.id}'),
          leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(r.imageUrl, width: 56, height: 56, fit: BoxFit.cover)),
          title: Text(r.name, style: GoogleFonts.poppins(color: Colors.white)),
          subtitle: Text(r.shortDesc, style: GoogleFonts.inter(color: Colors.white70)),
        );
      },
    );
  }
}
