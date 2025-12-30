class Recipe {
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final int cookingTimeMinutes;
  final String difficulty;
  final Map<String, double> macros;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.cookingTimeMinutes,
    required this.difficulty,
    required this.macros,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] as String? ?? 'Unknown Recipe',
      description: json['description'] as String? ?? 'No description available',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      cookingTimeMinutes: json['cookingTimeMinutes'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'Unknown',
      macros: (json['macros'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'cookingTimeMinutes': cookingTimeMinutes,
      'difficulty': difficulty,
      'macros': macros,
    };
  }
}
