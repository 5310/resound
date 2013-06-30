boolean mouse_free = true;

void setup() {
  
  size(800, 450);
  colorMode(HSB, 1.0); 
  background(color( 0, 0, 0.16, 1 ));
  //frameRate(30);
  smooth();
  
  ballsSetup();
  pingsSetup();
  notesSetup(); 
  
}

void draw() {

  //background( 0, 0, 1, 1 );
  noStroke();
  fill(color( 0, 0, 0.16, 0.55 ));
  rect(0, 0, width, height);
  
  ballsDraw();
  pingsDraw();
  notesDraw();
  
}

void mousePressed() {
  
  ballsMousePressed();
  
}

void mouseReleased() {
  
  ballsMouseReleased();
  
  // Add a ball when mouse is released on screen.
  if ( mouse_free ) { 
    ballsAdd();
  }
  
  // Change set to mouse_free again.
  mouse_free = true;
  
}
