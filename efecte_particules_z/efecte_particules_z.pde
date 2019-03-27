import controlP5.*;
import peasy.*;

ControlP5 cp5;
RadioButton fitxers;
String path; // path absolut a l'sketch
File[] files;
int quinaFile = 9;
String filename = "";

PeasyCam cam;

float migW;
float migH;
PImage terra;
boolean bdrawTerra = true;
int terraW;
int terraH;
float migterraW;
float migterraH;
ArrayList<Particle> particles = new ArrayList<Particle>();
int saltPart = 14;
float ampliZ = 0;

boolean bsaveFrames = false;

void setup(){
  size(1200,768, P3D);
  imageMode(CENTER);
  //rectMode(CENTER);
  
  println("...creating peasycam 3D perspective camera ...");
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(10500);
  
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
  
  if(files.length > 0){
    filename = path + files[quinaFile].getName();
    terra = loadImage(filename);
    terraW = terra.width;
    terraH = terra.height;
    migterraW = 0.5*terra.width;
    migterraH = 0.5*terra.height;
    for(int i=0; i<terraW; i+=saltPart){
      for(int j=0; j<terraH; j+=saltPart){
        color c = terra.get(i,j);
        float g = brightness(c);
        Particle pix = new Particle(i,j,g,c,saltPart);
        particles.add(pix);
      }
    }
  }
  else{
    exit();
  }
  
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
  
  cp5.addBang("reset_camera")
     .setPosition(200, 20)
     .setSize(20, 16)
     ;
  
  cp5.addToggle("bdrawTerra")
     .setPosition(200,60)
     .setSize(40,16)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
     
  cp5.addSlider("ampliZ")
     .setPosition(200,100)
     .setRange(0,10)
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
  
  println("########################################");
  println("START###################################");
  println("########################################");
}

void draw(){
  background(120);
  if(bdrawTerra){
    //tint(255,50);
    image(terra, migW, migH);
    //noTint();
  }
  
  pushMatrix();
  translate(-migterraW+migW, -migterraH+migH);
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.display();
  }
  popMatrix();
  
  if(bsaveFrames) saveFrame("./../frames/terra_#####.jpg");
  
  gui();
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw(); // GUI
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

public void reset_camera() {
  cam.reset();
}

void keyPressed(){
  if(key == 'c')  cam.reset();
  if(key == 't')  bdrawTerra = !bdrawTerra;
  if(key == 's')  bsaveFrames = !bsaveFrames;
}

void mousePressed() {
  if (cp5.isMouseOver()) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}

void llistatFitxers(int a) {
  quinaFile = a;
  filename = path + files[quinaFile].getName();
  terra = loadImage(filename);
}