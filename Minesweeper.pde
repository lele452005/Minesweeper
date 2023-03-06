import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS=20;
public final static int NUM_MINES = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r=0; r<NUM_ROWS; r++){
      for (int c =0; c<NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    setMines();
}
public void setMines()
{  for (int x=0; x<NUM_MINES; x++){
     int r = (int)(Math.random()*NUM_ROWS);
     int c = (int)(Math.random()*NUM_COLS);
     if (!mines.contains(buttons[r][c])){
       mines.add(buttons[r][c]);
       System.out.println(r + ", " +c);
     }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int countMine = 0;
    for (int r=0; r<NUM_ROWS; r++){
     for (int c=0; c<NUM_COLS; c++){
      if (mines.contains(buttons[r][c]) && buttons[r][c].isFlagged()){
        countMine++;
      }
     }
    }
    if (countMine == NUM_MINES){
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for (int r=0; r<NUM_ROWS; r++){
     for (int c=0; c<NUM_COLS; c++){
       buttons[r][c].clicked = true;
     }
    }
    buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("YOU ");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("  LO");
    buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel(" SE!");
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("YOU");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("  WI");
    buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel(" N!");
}
public boolean isValid(int r, int c)
{
    if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int x = row-1; x<=row+1; x++){
      for (int y = col-1; y<=col+1;y++){
        if (isValid(x, y) && mines.contains(buttons[x][y])){
          numMines = numMines +1;
        }
      }
    }
    if (mines.contains(buttons[row][col])){
      numMines = numMines-1;
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT){
          if (flagged == false){
            flagged = true;
          } else if (flagged == true){
            flagged = false;
          }
        } else if (mines.contains(this)){
          displayLosingMessage();
        } else if (countMines(myRow, myCol)>0){
          buttons[myRow][myCol].setLabel(countMines(myRow, myCol));
        } else{
          if (isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked==false){
            buttons[myRow-1][myCol-1].mousePressed();
          }
          if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked==false){
            buttons[myRow-1][myCol].mousePressed();
          }
          if (isValid (myRow-1, myCol+1) && buttons[myRow-1][myCol+1].clicked==false){
            buttons [myRow-1][myCol+1].mousePressed();
          }
          if (isValid (myRow, myCol-1) && buttons[myRow][myCol-1].clicked==false){
            buttons [myRow][myCol-1].mousePressed();
          }
          if (isValid (myRow, myCol+1) && buttons[myRow][myCol+1].clicked==false){
            buttons [myRow][myCol+1].mousePressed();
          }
          if (isValid (myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked==false){
            buttons [myRow+1][myCol+1].mousePressed();
          }
          if (isValid (myRow+1, myCol-1) && buttons[myRow+1][myCol-1].clicked==false){
            buttons [myRow+1][myCol-1].mousePressed();
          }
          if (isValid (myRow+1, myCol) && buttons[myRow+1][myCol].clicked==false){
            buttons [myRow+1][myCol].mousePressed();
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this))
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
