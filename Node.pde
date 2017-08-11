class Node {

  // f & g are set to arbitrarily large numbers
  float f = Float.POSITIVE_INFINITY;
  float g = Float.POSITIVE_INFINITY;
  float h;

  int row;
  int col;

  float x;
  float y;

  // Best parent
  Node previous = null;

  boolean isObstacle = false;

  // Expecting 8 children so for safety, a size of 16 is given
  Set<Node> children = new HashSet<Node>(16);

  Node( int row, int col ) {
    this.row = row;
    this.col = col;

    this.x = col * squareSize;
    this.y = row * squareSize;

    // goal is null when the goal node is created in setup; since the goal node is at the end, h is zero anyhow
    if ( goal != null ) {
      h = dist( this.x, this.y, goal.x, goal.y );
    } else {
      h = 0;
    }
  }

  // Obstacles are draw as ellipses with varying size based on square density
  void show() {
    noStroke();
    ellipse( x, y, squareSize / 2, squareSize / 2 );
  }

  void getChilds() {
    // This loop encompasses all nodes in a 3x3 space around the current node
    for ( int i = -1; i <= 1; i++ ) {
      for ( int j = -1; j <= 1; j++ ) {
        // If the indexes are within bounds and the candidate child is not an obstacle it is added as a child
        // It is ensured that the current node is not added as a child 
        if ( !( i == 0 && j == 0 ) && row + i < rows && row + i >= 0 && col + j < cols && col + j >= 0 ) { 
          if ( !grid[row + i][col + j].isObstacle ) {
            children.add( grid[row + i][col + j] );
          }
        }
      }
    }
  }

  void fupdate() {
    f = g + h;
  }

}