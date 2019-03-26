float migW;
float migH;

PImage terra;
String filename = "../imatges/22o12m50.28sS-129o4m49s.jpg";

void setup(){
  size(1200,768);
  imageMode(CENTER);
  migW = width*0.5;
  migH = height*0.5;
  terra = loadImage(filename);
}

void draw(){
  background(255);
  image(terra, migW, migH);
}