import 'checkers_game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CheckersGame());
}

class CheckersGame extends StatefulWidget {
  @override
  _CheckersGameState createState() => _CheckersGameState();
}

class _CheckersGameState extends State<CheckersGame> {
  CheckersBoardModel model = CheckersBoardModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkers Game'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;
          return GestureDetector(
            onTap: () {
              // Handle tap for moving pieces
            },
            child: Container(
              decoration: BoxDecoration(
                color: (row + col) % 2 == 0 ? Colors.white : Colors.black,
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: model.board[row][col].type != PieceType.empty
                    ? Icon(
                        model.board[row][col].type == PieceType.man
                            ? Icons.circle
                            : Icons.star,
                        size: 24.0,
                        color: model.board[row][col].player == Player.player1
                            ? Colors.red
                            : Colors.blue,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          );
        },
      ),
    );
  }
}
