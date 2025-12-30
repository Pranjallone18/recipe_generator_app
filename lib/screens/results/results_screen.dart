import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/colors.dart';
import '../../core/providers/recipe_provider.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Recipe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.softCharcoal),
          onPressed: () => context.pop(),
        ),
      ),
      body: recipeState.when(
        data: (recipe) {
          if (recipe == null) {
            return const Center(child: Text('No recipe generated yet.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.softCharcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildInfoChip(LucideIcons.clock,
                        '${recipe.cookingTimeMinutes} min'),
                    const SizedBox(width: 12),
                    _buildInfoChip(LucideIcons.chefHat, recipe.difficulty),
                    const SizedBox(width: 12),
                    _buildInfoChip(LucideIcons.flame,
                        '${recipe.macros['calories']?.toInt() ?? 0} kcal'),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Ingredients'),
                const SizedBox(height: 16),
                ...recipe.ingredients.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: AppColors.primarySage),
                          const SizedBox(width: 12),
                          Expanded(child: Text(e, style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    )),
                const SizedBox(height: 32),
                _buildSectionTitle('Instructions'),
                const SizedBox(height: 16),
                ...recipe.instructions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primarySage.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$index',
                            style: const TextStyle(
                              color: AppColors.primarySage,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            step,
                            style: const TextStyle(
                                fontSize: 16, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primarySage),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Oh no! Failed to generate recipe.\n${err.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.softCharcoal),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.softCharcoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.softCharcoal,
      ),
    );
  }
}
