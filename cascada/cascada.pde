import controlP5.*;

int numDrops = 20000;
Drop[] particles;
float ALPHA;

ControlP5 cp5;
RadioButton fitxers;
String path; // path absolut a l'sketch
File[] files;
int quinaFile = 0;
String filename = "";

float migW;
float migH;
PImage terra;
boolean bdrawTerra = true;
int terraW;
int terraH;
float migterraW;
float migterraH;
float tX = 0;
float tY = 0;

void setup() {
  size(1200, 768);
  
  println("...image filenames ...");
  path = sketchPath();
  println("path: " + path);
  String s1 = path.substring(0,path.lastIndexOf("/")+1);
  println("path s1: " + s1);
  path = s1 + "imatges/";
  println("path2: " + path);
  files = listFiles(path);
  for (int i=0; i<files.length; i++) {
    File f = files[i];    
    println("file " + i + ": " + f.getName());
  }
  
  println("...loading file ...");
  if(files.length > 0){
    filename = path + files[quinaFile].getName();
    terra = loadImage(filename);
    terraW = terra.width;
    terraH = terra.height;
    migterraW = 0.5*terra.width;
    migterraH = 0.5*terra.height;
  }
  else{
    exit();
  }
  
  println("...creating drops ...");
  setParticles();
  
  println("...creating controls ...");
  cp5 = new ControlP5(this);
  cp5.addFrameRate().setInterval(1).setPosition(width-20, 10);
  
  fitxers = cp5.addRadioButton("llistatFitxers")
    .setPosition(20, 20)
    .setSize(20, 16)
  ;
  for(int i=0; i<files.length; i++){
    File f = files[i];    
    fitxers.addItem(f.getName(), i);
  }
  fitxers.activate(quinaFile);
  
  cp5.addToggle("bdrawTerra")
     .setPosition(200,60)
     .setSize(40,16)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
         
  cp5.addToggle("bsaveFrames")
     .setPosition(200,120)
     .setSize(40,16)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
  
  cp5.setAutoDraw(false);
  
  println("...variables de la app ...");
  migW = width*0.5;
  migH = height*0.5;
  
  if(bdrawTerra){
    pushMatrix();
    //tint(255,50);
    translate(tX,tY);
    image(terra, 0,0);
    //noTint();
    popMatrix();
  }
  else{
    background(120);
  }
  println("########################################");
  println("START###################################");
  println("########################################");
}

void draw() {
  //float ALPHA = map(mouseY, 10, height, 255, 50);
  tint(255, 20);
  image(terra,0,0);
  loadPixels();
  for (Drop p : particles) {
    p.move();
  }
  updatePixels();
}

void keyPressed(){
  if (key== 's' || key== 'S'){
    save("./../pantallazos_baixa/drops" + frameCount + "_" + day() + ".jpg");
  }
  else if (key== ' '){
    setParticles();
  }
}

void llistatFitxers(int a) {
  quinaFile = a;
  filename = path + files[quinaFile].getName();
  terra = loadImage(filename);
}

void setParticles() {
  particles = new Drop[numDrops];

  for (int i = 0; i < particles.length; i++) { 
    float posX = random(0, width);
    float posY = random(0, height);
    float pX = posX+tX;
    float pY = posY+tY;
    color cp = terra.get((int)pX,(int)pY);
    particles[i]= new Drop(posX, posY, cp);
  }
}

void mouseDragged(){
  // TODO
  /*
  for(int f=0; f<10; f++){
    float posX = mouseX + random(-5,5);
    float posY = mouseY + random(-5,5);
    float pX = posX+tX;
    float pY = posY+tY;
    color cp = terra.get((int)pX,(int)pY);
    particles[f]= new Drop(posX, posY, cp);
  }
  */
}