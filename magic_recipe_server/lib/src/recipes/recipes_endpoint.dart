import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:serverpod/serverpod.dart';

class RecipesEndpoint extends Endpoint {
  Future<String> generateRecipes(Session session, String ingredients) async {
    final geminiApiKey = session.passwords['geminiApiKey'];
    if (geminiApiKey == null) {
      throw Exception('Gemini API key is not set in the server configuration.');
    }

    final agent = Agent.forProvider(
      GoogleProvider(
        apiKey: geminiApiKey),
        chatModelName: 'gemini-2.5-flash-lite',
    );

    final prompt = '''
      You are a helpful assistant that generates recipes based on the provided ingredients.
      Please provide a list of recipes that can be made with the following ingredients: $ingredients.
      Each recipe should include a title, a list of ingredients, and step-by-step instructions.
    ''';

    final response = await agent.send(prompt);
    final responseText = response.output;
    if (responseText == null || responseText.isEmpty) {
      throw Exception('No response received from the AI model.');
    }
    return responseText;

}