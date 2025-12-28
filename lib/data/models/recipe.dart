class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final int prepTime;
  final List<String> ingredients;
  final List<String> instructions;
  final int calories;
  final List<String> tags;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.prepTime,
    required this.ingredients,
    required this.instructions,
    required this.calories,
    required this.tags,
  });
}
