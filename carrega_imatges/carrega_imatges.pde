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

void setup(){
  size(1200,768, P3D);
  imageMode(CENTER);
  
  println("...creating peasycam 3D perspective camera ...");
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(1500);
  
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
  }
  
  println("...creating controls ...");
  cp5 = new ControlP5(this);
  fitxers = cp5.addRadioButton("llistatFitxers")
    .setPosition(20, 20)
    .setSize(20, 12)
  ;
  for(int i=0; i<files.length; i++){
    File f = files[i];    
    fitxers.addItem(f.getName(), i);
  }
  fitxers.activate(quinaFile);
  
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
  image(terra, migW, migH);
  
  gui();
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw(); // GUI
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}
void llistatFitxers(int a) {
  quinaFile = a;
  filename = path + files[quinaFile].getName();
  terra = loadImage(filename);
}