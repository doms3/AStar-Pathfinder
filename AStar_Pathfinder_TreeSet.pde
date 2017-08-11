import java.util.*;

// Parameters
float squareSize = 12;
float obstacleFreq = 0.4;

// Other definitions
int rows, cols;
Node[][] grid;
Node start;
Node  goal;
TreeSet<Node>     openSet;
Set<Node>       closedSet;

public void setup() {
  size( 650, 650 );

  // Color of obstacles
  fill( 51 );

  // Line thickness
  strokeWeight( 3 );

  // Extra row and column for left and bottom edges
  cols = floor( width  / squareSize ) + 1;
  rows = floor( height / squareSize ) + 1;

  grid = new Node[rows][cols];

  // Sets are initialized with a size that cannot possibly be surpassed (all nodes)
  openSet   = new TreeSet<Node>();
  closedSet = new HashSet<Node>(rows * cols);

  // Change starting and goal nodes here
  goal = new Node( rows - 1, cols - 1 );
  start = new Node( 0, 0 );

  // Create all nodes
  for ( int i = 0; i < rows; i++ ) {
    for ( int j = 0; j < cols; j++ ) {
      grid[i][j] = new Node(i, j);
    }
  }

  // Replace starting and goal nodes with appropriate objects
  grid[goal.row][goal.col] = goal;
  grid[start.row][start.col] = start;

  // Randomly sets percentage of nodes to obstacles 
  setObstacles();

  // Each node is connected to its neighbors that are not walls
  for ( int i = 0; i < rows; i++ ) {
    for ( int j = 0; j < cols; j++ ) {
      grid[i][j].getChilds();
    }
  }

  // There is no cost ( g == cost ) to move from start to start
  start.g = 0;

  // Initialize total cost value for starting node
  start.fupdate();

  // Add starting node to openSet
  openSet.add( start );
}

void draw() {
  background( 200 );

  // Show the obstacles as small circles
  for ( int i = 0; i < rows; i++ ) {
    for ( int j = 0; j < cols; j++ ) {
      if ( grid[i][j].isObstacle ) {
        grid[i][j].show();
      }
    }
  }

  Node current;

  // When openSet is empty there is no solution
  if ( openSet.isEmpty() ) {
    println( "No solution found..." );
    noLoop();
    current = start;
  } else {
  
  // Get best node in openSet (TreeSet automatically sorts)
  
  current = openSet.first();

  }
  // If end is reached, algorithm is complete 
  if ( current == goal ) {
    println( "DONE" );
    drawPath( goal );
    noLoop();
  }

  // Otherwise add current to closed set so we don't check it again
  openSet.remove( current );
  closedSet.add ( current );
  
  // Check each neighbor to current...
  for ( Node neighbor : current.children ) {
    // ...that isn't already in the closedSet
    if ( !closedSet.contains( neighbor ) ) {
      openSet.remove( neighbor );
      // If it is easier to get to this node via the current parent (lower g score) compared to all other possible parents it current parent is the optimal parent      
      float gscore = current.g + dist( current.col, current.row, neighbor.col, neighbor.row );
      if ( gscore < neighbor.g ) {
        neighbor.previous = current;
        neighbor.g = gscore;
        neighbor.fupdate();
      }
      openSet.add( neighbor );
    }
  }

  // Draws a path through all the optimal parents from current, back to the beginning
  drawPath( current );
}

void drawPath( Node first ) {
  Node current = first;

  while ( current.previous != null ) {
    Node next = current.previous;

    stroke( 0 );
    line( current.x, current.y, next.x, next.y );

    current = next;
  }
}  

void setObstacles() {
  // Randomly sets percentage of nodes to obstacles 
  int numNodes = rows * cols;
  int count = 0;
  while ( count < numNodes * obstacleFreq ) {
    int row = floor( random( rows ) );
    int col = floor( random( cols ) );
    if ( !grid[row][col].isObstacle && grid[row][col] != start && grid[row][col] != goal ) {
      grid[row][col].isObstacle = true;
      count++;
    }
  }
}