import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/colors.dart';
import '../../data/data_service.dart';
import '../../data/models/recipe.dart';
import '../../widgets/common/ingredient_tile.dart';

class DetailScreen extends StatefulWidget {
  final String recipeId;

  const DetailScreen({super.key, required this.recipeId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Recipe recipe;
  final Set<int> _selectedIngredients = {};

  @override
  void initState() {
    super.initState();
    recipe = DataService.mockRecipes.firstWhere((r) => r.id == widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.8),
          child: IconButton(
            icon: const Icon(LucideIcons.chevronLeft, color: AppColors.softCharcoal),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Hero(
          tag: 'recipe-image-${recipe.id}',
          child: Image.network(
            recipe.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primarySage.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.star, size: 16, color: AppColors.primarySage),
                      const SizedBox(width: 4),
                      const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric(LucideIcons.clock, '${recipe.prepTime} min', 'Preparation'),
                _buildMetric(LucideIcons.flame, '${recipe.calories} kcal', 'Calories'),
                _buildMetric(LucideIcons.chefHat, 'Easy', 'Difficulty'),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recipe.ingredients.asMap().entries.map((entry) {
              return IngredientTile(
                ingredient: entry.value,
                isSelected: _selectedIngredients.contains(entry.key),
                onTap: () {
                  setState(() {
                    if (_selectedIngredients.contains(entry.key)) {
                      _selectedIngredients.remove(entry.key);
                    } else {
                      _selectedIngredients.add(entry.key);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 40),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...recipe.instructions.asMap().entries.map((entry) {
              return _buildInstructionStep(entry.key + 1, entry.value);
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primarySage, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: AppColors.softCharcoal.withOpacity(0.5), fontSize: 12)),
      ],
    );
  }

  Widget _buildInstructionStep(int step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentTerracotta.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: AppColors.accentTerracotta,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.softCharcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
