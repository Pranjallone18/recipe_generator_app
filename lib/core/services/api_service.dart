import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  // IMPORTANT: Replace with your actual Gemini API Key from https://aistudio.google.com/
  static const String _apiKey = 'AIzaSyBnwkM5IM98kzJIru0nK_b3BBzaUFQs7ME';
  
  // Direct HTTP Endpoint for Gemini Pro (Stable)
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<Recipe> generateRecipe(List<String> ingredients) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey');

    final prompt = '''
You are a master chef. Generate a creative and delicious recipe using these and only these main ingredients: ${ingredients.join(", ")}. 
Assume basic pantry staples (salt, pepper, oil, water) are available.

Return strictly a JSON object with this schema:
{
  "title": "Dish Name",
  "description": "Short appetizing description",
  "ingredients": ["1 cup item", "2 tbsp item"],
  "instructions": ["Step 1", "Step 2"],
  "cookingTimeMinutes": 30,
  "difficulty": "Easy",
  "macros": {"calories": 500, "protein": 30, "carbs": 50}
}
''';

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        // Navigate the Gemini response structure
        // candidates[0].content.parts[0].text
        final text = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        
        // Clean up markdown if present
        var cleanText = text.toString();
        if (cleanText.contains('```json')) {
          cleanText = cleanText.replaceAll('```json', '').replaceAll('```', '');
        } else if (cleanText.contains('```')) {
          cleanText = cleanText.replaceAll('```', '');
        }

        final recipeJson = jsonDecode(cleanText);
        return Recipe.fromJson(recipeJson);
      } else {
        // Log the full error to help debug
        final error = jsonDecode(response.body);
        throw Exception('Gemini API Error: ${error['error']['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to Gemini: $e');
    }
  }
}
