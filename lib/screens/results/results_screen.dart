import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/colors.dart';
import '../../data/data_service.dart';
import '../../widgets/common/recipe_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = DataService.mockRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Found for You',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.softCharcoal),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return BeautifulRecipeCard(
            recipe: recipe,
            onTap: () => context.push('/detail/${recipe.id}'),
          );
        },
      ),
    );
  }
}
