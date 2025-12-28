import 'models/recipe.dart';

class DataService {
  static List<Recipe> get mockRecipes => [
    Recipe(
      id: '1',
      title: 'Creamy Avocado Pasta',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=1000',
      prepTime: 15,
      ingredients: [
        '12 oz pasta',
        '2 ripe avocados',
        '1/2 cup fresh basil leaves',
        '2 cloves garlic',
        '2 tbsp lemon juice',
        'Salt and pepper to taste',
        'Freshly grated Parmesan'
      ],
      instructions: [
        'Cook pasta in a large pot of boiling salted water according to package directions.',
        'While pasta is cooking, make the sauce: place avocados, basil, garlic, and lemon juice in a food processor.',
        'Pulse until smooth and creamy.',
        'Drain pasta, reserving 1/2 cup of the cooking water.',
        'Toss pasta with the avocado sauce, adding reserved water if needed.',
        'Season with salt and pepper. Serve with Parmesan.'
      ],
      calories: 450,
      tags: ['Quick', 'Vegan', 'Healthy'],
    ),
    Recipe(
      id: '2',
      title: 'Honey Glazed Salmon',
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&q=80&w=1000',
      prepTime: 25,
      ingredients: [
        '2 salmon fillets',
        '2 tbsp honey',
        '1 tbsp soy sauce',
        '1 tbsp lemon juice',
        '1 tsp minced ginger',
        'Asparagus for side'
      ],
      instructions: [
        'Preheat oven to 400°F (200°C).',
        'In a small bowl, whisk together honey, soy sauce, lemon juice, and ginger.',
        'Place salmon on a baking sheet lined with parchment paper.',
        'Brush the glaze over the salmon.',
        'Bake for 12-15 minutes or until flakey.',
        'Serve with roasted asparagus.'
      ],
      calories: 520,
      tags: ['Seafood', 'Keto', 'Elegant'],
    ),
    Recipe(
      id: '3',
      title: 'Berry Smoothie Bowl',
      imageUrl: 'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?auto=format&fit=crop&q=80&w=1000',
      prepTime: 10,
      ingredients: [
        '1 cup frozen mixed berries',
        '1 frozen banana',
        '1/2 cup almond milk',
        'Toppings: Granola, chia seeds, fresh berries'
      ],
      instructions: [
        'Place berries, banana, and milk in a high-speed blender.',
        'Blend until thick and smooth.',
        'Pour into a bowl.',
        'Top with granola, seeds, and fresh fruit.'
      ],
      calories: 320,
      tags: ['Breakfast', 'Vegan', 'Refreshing'],
    ),
    Recipe(
      id: '4',
      title: 'Mediterranean Quinoa Salad',
      imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&q=80&w=1000',
      prepTime: 20,
      ingredients: [
        '1 cup cooked quinoa',
        '1/2 cucumber, diced',
        '1/2 cup cherry tomatoes',
        '1/4 cup feta cheese',
        'Olives, red onion, parsley',
        'Lemon vinaigrette'
      ],
      instructions: [
        'In a large bowl, combine quinoa, cucumber, tomatoes, olives, red onion, and parsley.',
        'Toss with lemon vinaigrette.',
        'Gently fold in feta cheese.',
        'Chill before serving for best flavor.'
      ],
      calories: 380,
      tags: ['Vegetarian', 'Meal Prep', 'Fresh'],
    ),
  ];
}
