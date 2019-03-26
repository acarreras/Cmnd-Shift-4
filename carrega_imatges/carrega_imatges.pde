float migW;
float migH;

PImage terra;
String filename = "../imatges/22o12m50.28sS-129o4m49s.jpg";

void setup(){
  size(1200,768);
  String path = sketchPath();
  println("path: " + path);
  String s1 = path.substring(0,path.lastIndexOf("/")+1);
  println("path s1: " + s1);
  path = s1 + "imatges/";
  println("path2: " + path);
  File[] files = listFiles(path);
  for (int i=0; i<files.length; i++) {
    File f = files[i];    
    println("file " + i + ": " + f.getName());
  }
  imageMode(CENTER);
  migW = width*0.5;
  migH = height*0.5;
  terra = loadImage(filename);
}

void draw(){
  background(255);
  image(terra, migW, migH);
}