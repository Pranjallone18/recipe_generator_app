import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final recipeControllerProvider =
    StateNotifierProvider<RecipeController, AsyncValue<Recipe?>>((ref) {
  return RecipeController(ref.read(apiServiceProvider));
});

class RecipeController extends StateNotifier<AsyncValue<Recipe?>> {
  final ApiService _apiService;

  RecipeController(this._apiService) : super(const AsyncValue.data(null));

  Future<void> generateRecipe(
    List<String> ingredients, {
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    state = const AsyncValue.loading();
    try {
      final recipe = await _apiService.generateRecipe(ingredients);
      state = AsyncValue.data(recipe);
      onSuccess();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      onError(e.toString());
    }
  }
}
