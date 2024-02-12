class SandboxModel {
  final int rows;
  final int cols;
  List<List<bool>> grid;

  SandboxModel({required this.rows, required this.cols})
      : grid = List.generate(rows, (_) => List.generate(cols, (__) => false));

  // Function to add sand at a specific location
  void addSand(int row, int col) {
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      grid[row][col] = true;
    }
  }

  // Function to update the grid, simulating sand falling
  void update() {
    for (int row = rows - 2; row >= 0; row--) {
      for (int col = 0; col < cols; col++) {
        if (grid[row][col]) {
          bool moved = false;

          // Check directly below
          if (row < rows - 1 && !grid[row + 1][col]) {
            grid[row][col] = false;
            grid[row + 1][col] = true;
            moved = true;
          }

          // If the cell below is occupied, check to the left and right
          if (!moved) {
            // Check left
            if (col > 0 && !grid[row][col - 1] && !grid[row + 1][col - 1]) {
              grid[row][col] = false;
              grid[row + 1][col - 1] = true; // Move sand down and to the left
              moved = true;
            }

            // Check right
            if (!moved &&
                col < cols - 1 &&
                !grid[row][col + 1] &&
                !grid[row + 1][col + 1]) {
              grid[row][col] = false;
              grid[row + 1][col + 1] = true; // Move sand down and to the right
            }
          }
        }
      }
    }
  }
}
