import 'package:flutter/material.dart';
import 'game_of_life_widget.dart';
import 'sandbox_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // To center the buttons vertically
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameOfLifePage()),
                );
              },
              child: const Text('Start Conway\'s Game of Life'),
            ),
            const SizedBox(height: 20), // Provides spacing between the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SandboxPage()), // Ensure this matches the constructor of your SandboxPage widget
                );
              },
              child: const Text('Start Sandbox Simulation'),
            ),
          ],
        ),
      ),
    );
  }
}
