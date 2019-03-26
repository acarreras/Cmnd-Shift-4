import controlP5.*;

ControlP5 cp5;
RadioButton fitxers;
String path; // path absolut a l'sketch
File[] files;
int quinaFile = 0;

float migW;
float migH;

PImage terra;
String filename = "";

void setup(){
  size(1200,768);
  imageMode(CENTER);
  
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
  
  cp5 = new ControlP5(this);
  fitxers = cp5.addRadioButton("llistatFitxers")
    .setPosition(20, 20)
    .setSize(20, 12)
  ;
  for(int i=0; i<files.length; i++){
    File f = files[i];    
    fitxers.addItem(f.getName(), i);
  } 
  
  migW = width*0.5;
  migH = height*0.5;
}

void draw(){
  background(120);
  image(terra, migW, migH);
}

void llistatFitxers(int a) {
  quinaFile = a;
  filename = path + files[quinaFile].getName();
  terra = loadImage(filename);
}