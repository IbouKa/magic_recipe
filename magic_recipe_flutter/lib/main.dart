import 'package:flutter/material.dart';
import 'package:magic_recipe_client/magic_recipe_client.dart';

import 'client.dart';
import 'screens/greetings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const MyApp());
}

/// Builds a theme for the given [brightness].
ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Serverpod Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

// magic_recipe_flutter/lib/main.dart
class MyHomePageState extends State<MyHomePage> {
  /// Holds the last result or null if no result exists yet.
  Recipe? _recipe;
  /// Holds the last error message that we've received from the server or null if no
  /// error exists yet.
  String? _errorMessage;
  final _textEditingController = TextEditingController();
  bool _loading = false;
  

  void _callGenerateRecipe() async {
    try {
      setState(() {
        _errorMessage = null;
        _recipe = null;
        _loading = true;
      });
      final result =
          await client.recipes.generateRecipe(_textEditingController.text);
      setState(() {
        _errorMessage = null;
        _recipe = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
        _recipe = null;
        _loading = false;
      });
    }
  
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Enter your ingredients for the recipe',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _loading ? null : _callGenerateRecipe,
                child: _loading
                    ? const Text('Loading...')
                    : const Text('Generate Recipe'),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ResultDisplay(
                  resultMessage: _recipe != null
                  ? '${_recipe?.author} on ${_recipe?.date}:\n${_recipe?.text}' : null,
                  errorMessage: _errorMessage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}