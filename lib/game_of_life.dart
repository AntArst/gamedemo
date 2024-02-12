import 'dart:math';

class GameOfLifeModel {
  final int rows;
  final int cols;
  List<List<bool>> grid;

  GameOfLifeModel({required this.rows, required this.cols})
      : grid = List.generate(
            rows, (i) => List.generate(cols, (j) => Random().nextBool()));

  void toggleCellState(int row, int col) {
    grid[row][col] = !grid[row][col];
  }

  void parseAndApplyRLE(
      String rle, List<List<bool>> grid, int startRow, int startCol) {
    final rows = grid.length;
    final cols = grid[0].length;
    int row = startRow;
    int col = startCol;
    int count = 0; // To accumulate the count of cells before a character

    for (int i = 0; i < rle.length; i++) {
      final char = rle[i];

      if (char == 'b' || char == 'o') {
        count = count == 0 ? 1 : count; // Default to 1 if no number is provided

        for (int j = 0; j < count; j++) {
          if (col >= cols) {
            row += 1;
            col = startCol;
          }
          if (row < rows && col < cols) {
            grid[row][col] = char == 'o';
            col += 1;
          }
        }
        count = 0; // Reset count after processing a run
      } else if (char == '\$') {
        row += count == 0 ? 1 : count; // Move down lines
        col = startCol; // Reset column to the start for a new line
        count = 0; // Reset count
      } else if (char == '!') {
        break; // End of pattern
      } else if (char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
          char.codeUnitAt(0) <= '9'.codeUnitAt(0)) {
        count = count * 10 +
            (char.codeUnitAt(0) -
                '0'.codeUnitAt(0)); // Accumulate multi-digit numbers
      }
    }
  }

  void resetToKnownSeed() {
    // Reset grid to spreader pattern
    grid = List.generate(rows, (_) => List.filled(cols, false));
    String testPattern =
        "18bo8b\$17b3o7b\$12b3o4b2o6b\$11bo2b3o2bob2o4b\$10bo3bobo2bobo5b\$10bo4bobobobob2o2b\$12bo4bobo3b2o2b\$4o5bobo4bo3bob3o2b\$o3b2obob3ob2o9b2ob\$o5b2o5bo13b\$bo2b2obo2bo2bob2o10b\$7bobobobobobo5b4o\$bo2b2obo2bo2bo2b2obob2o3bo\$o5b2o3bobobo3b2o5bo\$o3b2obob2o2bo2bo2bob2o2bob\$4o5bobobobobobo7b\$10b2obo2bo2bob2o2bob\$13bo5b2o5bo\$b2o9b2ob3obob2o3bo\$2b3obo3bo4bobo5b4o\$2b2o3bobo4bo12b\$2b2obobobobo4bo10b\$5bobo2bobo3bo10b\$4b2obo2b3o2bo11b\$6b2o4b3o12b\$7b3o17b\$8bo!";
    parseAndApplyRLE(testPattern, grid, 0, 0);
  }

  void updateGrid() {
    var newGrid = List.generate(rows, (_) => List.filled(cols, false));
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        int liveNeighbors = countLiveNeighbors(row, col);
        if (grid[row][col] && (liveNeighbors == 2 || liveNeighbors == 3)) {
          newGrid[row][col] = true;
        } else if (!grid[row][col] && liveNeighbors == 3) {
          newGrid[row][col] = true;
        }
      }
    }
    grid = newGrid;
  }

  int countLiveNeighbors(int row, int col) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        int newRow = row + i;
        int newCol = col + j;
        if (newRow >= 0 &&
            newRow < rows &&
            newCol >= 0 &&
            newCol < cols &&
            grid[newRow][newCol]) {
          count++;
        }
      }
    }
    return count;
  }
}
