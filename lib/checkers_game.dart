enum PieceType { empty, man, king }

enum Player { none, player1, player2 }

class CheckersPiece {
  final PieceType type;
  final Player player;

  CheckersPiece({this.type = PieceType.empty, this.player = Player.none});
}

class CheckersBoardModel {
  List<List<CheckersPiece>> board =
      List.generate(8, (i) => List.generate(8, (j) => CheckersPiece()));

  // Initialize the board with pieces for each player
  CheckersBoardModel() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if ((i + j) % 2 != 0) {
          // Checkers are placed on squares of one color
          if (i < 3) {
            board[i][j] =
                CheckersPiece(type: PieceType.man, player: Player.player1);
          } else if (i > 4) {
            board[i][j] =
                CheckersPiece(type: PieceType.man, player: Player.player2);
          }
        }
      }
    }
  }
}
