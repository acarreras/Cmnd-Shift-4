class Particle { 
  PVector pos;
  color c;
  float mida = 2;
  
  public Particle(int x,int y,float z, color _c, float m) {  
    pos = new PVector(x,y,z);
    c = _c; 
    mida = m;
  } 
  void display() { 
    fill(c);
    noStroke();
    pushMatrix();
    //translate(pos.x,pos.y,0);
    //box(mida,mida,pos.z*ampliZ);
    translate(pos.x,pos.y,pos.z*ampliZ);
    rect(0,0,mida,mida);
    popMatrix();
  } 
}