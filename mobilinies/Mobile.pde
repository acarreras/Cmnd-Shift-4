class Mobile {
  int index = 0;
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  PVector position0 = new PVector(0,0);
  PVector position = new PVector(0,0);
  float trans = random(50, 256);
  color c;

  Mobile(int i, color _c, float px, float py){
    index = i;
    position0.x = px;
    position0.x = py;
    position.x = px;
    position.x = py;
    this.c = _c;
  }

  void update(){
    float noise1 = 1-2*noise( a4+a2*sin(PI*this.position.x/width), a4+a2*sin(PI*this.position.y/height) );
    float noise2 = 1-2*noise( a2+a3*cos(PI*this.position.x/width), a4+a3*cos(PI*this.position.y/height) );
    velocity = new PVector(noise1,noise2);
    
    velocity.mult(a5);
    //100*fbm(this.position);
    velocity.rotate(atan(10)*noise(a4+a3*cos(PI*this.position.x/width)));
    position0 = position.copy();
    position.add(velocity);
  }

  void display() {
    if(bw){
      stroke(255,trans);
    }
    else {
      stroke(c, trans);
    }
    //  if(bw)stroke(0,this.trans); else stroke(this.hu,this.sat,this.bri,this.trans);
    
    line(position0.x, position0.y, position.x, position.y);
    
    if (position.x>width || position.x<0||position.y>height||position.y<0) {
      position0 = new PVector(random(0, width), random(0, height));
      position = position0.copy();
    }
  }
  
} // final de la classe