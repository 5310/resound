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
ArrayList balls;
PVector g = new PVector(0, 0.1);



void ballsSetup() {
  balls = new ArrayList();  
}

void ballsDraw() {
  for ( int i = 0; i < balls.size(); i++ ) {
    Ball ball = balls.get(i);
    ball.tick();
    ball.draw();
  }
}

void ballsMousePressed() {
 for ( int i = 0; i < balls.size(); i++ ) {
    Ball ball = balls.get(i);
    if ( ball.inside( mouseX, mouseY ) ) {
      ball.press();
      mouse_free = false;  //Change global set to held.
    }
  }
}

void ballsMouseReleased() {
 for ( int i = 0; i < balls.size(); i++ ) {
    Ball ball = balls.get(i);
    if ( !ball.free ) {
      ball.release();
    }
  }
}

void ballsAdd() {
  balls.add(new Ball());
}



class Ball {
  
  boolean free;
  boolean alive;

  float radius;

  PVector position, p_position, m_position;
  PVector velocity;
  float max_speed;

  color fillcolor; 

  Ball() {
    
    free = true;  // True is freely dynamic, and False is when it's held. 
    alive = true;

    radius = 10 + (int)random(20);

    position = new PVector( mouseX, mouseY ); p_position = position.get(); m_position = new PVector( 0, 0 );
    velocity = new PVector( mouseX-pmouseX, mouseY-pmouseY );
    max_speed = 7;
    velocity.limit(max_speed);

    fillcolor = #000000;
  }

  void tick( ) {

    if ( alive ) {
    
      // If free... 
      if ( free ) {
        
        // Affect velocity by gravitational acceletation, and change position by velocity.
        velocity.add(g);
        p_position = position.get();
        position.add(velocity);
  
        // Bounce ball when it hits the walls.
        if ( position.x <= 0+radius ) {
          position.x = 0+radius;
          velocity.x *= -1;
        }
        if ( position.x >= width-radius ) {
          position.x = width-radius;
          velocity.x *= -1;
        }
        if ( position.y <= 0+radius ) {
          position.y = 0+radius;
          velocity.y *= -1;
        }
        if ( position.y >= height-radius ) {
          position.y = height-radius;
          velocity.y *= -1;
        }
    
        // Ping when it hits the bottom, but only if it isn't stuck there.
        if ( position.y >= height-radius && abs(velocity.y) >= 1 ) {
          notesAdd( position.x );
          pingsAdd( position.x, position.y+radius, (int)map( velocity.mag(), 0, max_speed, 0, 16 ) );
        }
      
      // If being held...
      } else {
        
        if ( position.y < 0+radius ) {
          alive = false;
          mouse_free = true;
        }
        
        // Move with the mouse.
        setPositionToMouse();
        
      }
    
    } else {
      
      for ( int i = 0; i < balls.size(); i++ ) {
        AudioPlayer ball = balls.get(i);
        if ( !ball.alive ) { 
          balls.remove(i);
        }
      }
      
    }
    
  }

  void draw() {

    pushStyle();
    
    // Render the ball itself.
    noStroke();
    fillcolor = color( map( position.x, 0, width, 0, 1 ), 0.8, map( position.y, 0, height, -3, 1 ));
    fill(fillcolor);
    ellipse( position.x, position.y, radius*2, radius*2);
    
    popStyle();
    
  }
  
  Boolean inside( float _x, float _y ) {
    PVector point = new PVector( _x, _y );
    return position.dist(point) <= radius;
  }
  
  void press() {
    m_position.set( position.x-mouseX, position.y-mouseY );
    free = false;
  }
  void dragged() {
    setPositionToMouse();
  }
  void release() {
    setVelocityToMouse();
    free = true;
  }
  
  void setPositionToMouse() {
    position.set( mouseX+m_position.x, mouseY+m_position.y );
  }
  void setVelocityToMouse() {
    velocity.set( mouseX-pmouseX, mouseY-pmouseY );
    velocity.limit(max_speed);
  }
  
}

//import ddf.maxim.*;
//maxim maxim = new maxim(this);
Maxim maxim = new Maxim(this);

ArrayList notes;

String[] files = {
  "c3.mp3",
  "d3.mp3",
  "e3.mp3",
  "f3.mp3",
  "g3.mp3",
  "a3.mp3",
  "b3.mp3",
  "c4.mp3",
};

void notesSetup() {
  notes = new ArrayList();
}

void notesDraw() {
  // Play newly added note, because Maxim.js does not seem to be able to play immediately after creation of the note.
  if ( notes.size() > 0 ) notes.get(notes.size()-1).play();
  // Remove all older notes if they're not playing.
  for ( int i = 0; i < notes.size()-1; i++ ) {
    AudioPlayer note = notes.get(i);
    if ( !note.isPlaying() ) { 
      notes.remove(i);
    }
  }
}

void notesAdd( float _x ) {
  
  String file = files[ (int)map( _x, 0, width, 0, files.length-1 ) ];
  
  AudioPlayer note = maxim.loadFile(file);
  //note.play();
  notes.add(note);
  
}
ArrayList pings;



void pingsSetup() {
  pings = new ArrayList();
}

void pingsDraw() {
 for ( int i = 0; i < pings.size(); i++ ) {
    Ping ping = pings.get(i);
    ping.tick();
    ping.draw();
    if ( !ping.alive ) pings.remove(i);
  }
}

void pingsAdd( float _x, float _y, int _weight ) {
  pings.add( new Ping( _x, _y, _weight ) );
}



class Ping {
  
  boolean alive;
  
  float radius;
  float rate;
  int weight;
  
  PVector position;
  
  color strokecolor;  
  float max_strokealpha;

  Ping( float _x, float _y, int _weight ) {
    
    alive = true;
    
    radius = 1;
    rate = 1.2;
    weight = _weight;
    
    position = new PVector( _x, _y );
      
    strokecolor = color(0, 0, 0, 0.1);
    max_strokealpha = random(0, 0.8);
    
  }
  
  void tick() {
    
    radius *= rate;
    
    if ( radius >= width ) alive = false;
    
  }
  
  void draw() {
  
    pushStyle();
    
    // Render the ping 
    noFill();
    strokeWeight(weight);
    strokecolor = color( map( position.x, 0, width, 0, 1), 1, 1, map( radius, 0, width, 0.2, -max_strokealpha ) );
    stroke(strokecolor);
    noStroke();
    fill( strokecolor );
    ellipse( position.x, position.y, radius*2, radius*2 );
    
    pushStyle();
    
  }
  
}

