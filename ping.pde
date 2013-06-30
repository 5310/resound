ArrayList<Ping> pings;



void pingsSetup() {
  pings = new ArrayList<Ping>();
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
