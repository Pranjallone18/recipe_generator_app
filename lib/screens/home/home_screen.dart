import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/colors.dart';
import '../../core/providers/recipe_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/soothing_button.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsController = useTextEditingController();
    final recipeState = ref.watch(recipeControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello there!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primarySage,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'What’s in your pantry today?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: ingredientsController,
                hintText: 'Enter ingredients (e.g. Avocado, Salmon...)',
                prefixIcon: LucideIcons.search,
              ),
              const SizedBox(height: 32),
              const Text(
                'Quick Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('All Recipes', true),
                    _buildCategoryChip('Vegan', false),
                    _buildCategoryChip('Breakfast', false),
                    _buildCategoryChip('Seafood', false),
                    _buildCategoryChip('Keto', false),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=1000'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (recipeState.isLoading)
                      const CircularProgressIndicator(
                          color: AppColors.primarySage)
                    else
                      SoothingButton(
                        text: 'Find Recipes',
                        icon: LucideIcons.chefHat,
                        onPressed: () {
                          if (ingredientsController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter some ingredients')),
                            );
                            return;
                          }

                          final ingredients = ingredientsController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();

                          if (ingredients.isEmpty) return;

                          ref
                              .read(recipeControllerProvider.notifier)
                              .generateRecipe(
                            ingredients,
                            onSuccess: () {
                              context.push('/results');
                            },
                            onError: (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $error')),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (v) {},
        backgroundColor: Colors.white,
        selectedColor: AppColors.primarySage.withOpacity(0.2),
        checkmarkColor: AppColors.primarySage,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primarySage : AppColors.softCharcoal,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primarySage
                : Colors.black.withOpacity(0.05),
          ),
        ),
      ),
    );
  }
}
