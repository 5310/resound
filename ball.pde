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

