import controlP5.*;
import processing.pdf.*;

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/6707*@* */
ArrayList points = new ArrayList();
boolean md = false;
int numPoints = 10000;

boolean brecord = false;
int scalePG = 2;

ControlP5 cp5;
RadioButton fitxers;
String path; // path absolut a l'sketch
File[] files;
int quinaFile = 9;
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

boolean bsaveFrames = false;

void setup(){
  size(1200,768);
  //imageMode(CENTER);
  smooth();
  colorMode(HSB,360,100,100);
  
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
  
  /*
  println("...creating points ...");
  for(int f=0; f<numPoints; f++){
    float posX = random(0,width)+tX;
    float posY = random(0,height)+tY;
    color cp = terra.get((int)posX,(int)posY);
    points.add(new Point(posX,posY,cp));
  }
  */
  
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

void draw(){
  
  noiseDetail(8,0);
  //noiseSeed(1);
  for(int i=points.size()-1; i>0; i--){
    Point p = (Point)points.get(i);
    p.update();
    if(p.finished){
      points.remove(i);
    }
  }
  
  if(bsaveFrames) saveFrame("./../frames/terra_#####.jpg");
  if (brecord) {
    save("./../pantallazos_baixa/terra_" + quinaFile + "_" + frameCount + ".jpg");
    brecord = false;
  }
  if( (bsaveFrames == true)||(brecord == true) ){
  }
  else{
    //gui();
  }
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cp5.draw(); // GUI
  hint(ENABLE_DEPTH_TEST);
}

void keyPressed(){
  if(key == 't')  bdrawTerra = !bdrawTerra;
  if(key == 's')  bsaveFrames = !bsaveFrames;
  if(key == ' ')  brecord = !brecord;
  if(keyCode == ENTER){
    PGraphics PGpx = createGraphics(width*scalePG, height*scalePG, P3D);
    brecord = true;
    beginRecord(PGpx);
    PGpx.background(#ffffff, 0); // Clear the offscreen canvas (make it transparent)
    PGpx.scale(scalePG);
    draw();
    PGpx.save("myImage.png"); // Save image as PNG (JPGs can't have an alpha channel) and save it before endRecord()
    endRecord();
    brecord = false;
  }
}

void llistatFitxers(int a) {
  quinaFile = a;
  filename = path + files[quinaFile].getName();
  terra = loadImage(filename);
}

void mousePressed(){
  for(int f=0; f<10; f++){
    float posX = mouseX + random(-5,5);
    float posY = mouseY + random(-5,5);
    float pX = posX+tX;
    float pY = posY+tY;
    color cp = terra.get((int)pX,(int)pY);
    points.add(new Point(posX,posY,cp));
  }  
}

void mouseDragged(){
  for(int f=0; f<10; f++){
    float posX = mouseX + random(-5,5);
    float posY = mouseY + random(-5,5);
    float pX = posX+tX;
    float pY = posY+tY;
    color cp = terra.get((int)pX,(int)pY);
    points.add(new Point(posX,posY,cp));
  }  
}