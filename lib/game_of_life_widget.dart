import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'game_of_life.dart';

void main() => runApp(GameOfLifeApp());

class GameOfLifeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameOfLifePage(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
    );
  }
}

class GameOfLifePage extends StatefulWidget {
  const GameOfLifePage({Key? key}) : super(key: key);
  @override
  _GameOfLifePageState createState() => _GameOfLifePageState();
}

class _GameOfLifePageState extends State<GameOfLifePage> {
  final GameOfLifeModel model = GameOfLifeModel(rows: 50, cols: 50);
  Timer? _timer;

  void _toggleTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
        setState(() {
          model.updateGrid();
        });
      });
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the size of the screen
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    double appBarHeight = AppBar().preferredSize.height;
    double statusBarHeight =
        MediaQuery.of(context).padding.top; // Height of the status bar
    double screenHeight = screenSize.height - appBarHeight - statusBarHeight;

    // Calculate the size of each cell to fit all columns and rows on the screen
    double cellWidth = screenWidth / model.cols;
    double cellHeight = screenHeight / model.rows;
    double cellSize = min(cellWidth,
        cellHeight); // Ensure cells are square and fit in both dimensions

    return Scaffold(
      appBar: AppBar(
        title: Text('Conway\'s Game of Life'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: model.cols,
          childAspectRatio: 1.0, // Ensuring cell is square
          mainAxisSpacing: 0, // Remove spacing between cells
          crossAxisSpacing: 0,
        ),
        itemCount: model.rows * model.cols,
        itemBuilder: (BuildContext context, int index) {
          int row = index ~/ model.cols;
          int col = index % model.cols;
          return InkWell(
            onTap: () {
              setState(() {
                model.toggleCellState(row, col);
              });
            },
            child: Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: model.grid[row][col] ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: cellSize, // Ensure the tag is unique
            onPressed: _toggleTimer,
            child: Icon(_timer == null ? Icons.play_arrow : Icons.pause),
          ),
          const SizedBox(height: 20), // Spacing between buttons
          FloatingActionButton(
            heroTag: cellSize * 2, // Ensure the tag is unique
            onPressed: () {
              setState(() {
                model
                    .resetToKnownSeed(); // Resets the grid to a specific pattern or seed
              });
            },
            child: const Icon(Icons.refresh),
            backgroundColor:
                Colors.red, // To distinguish it from the play/pause button
          ),
        ],
      ),
    );
  }
}
