import controlP5.*;
import peasy.*;
import themidibus.*;
import processing.pdf.*;

boolean brecord = false;
int scalePG = 2;

ControlP5 cp5;
RadioButton fitxers;
String path; // path absolut a l'sketch
File[] files;
int quinaFile = 5;
String filename = "";

PeasyCam cam;
int minCamDist = 100;
int maxCamDist = 6500;
double camDist = minCamDist;
double camRotationX = 0;
double camRotationY = 0;
double camRotationZ = 0;
double camPanX = 0;
double camPanY = 0;
double camLookX = 0;
double camLookY = 0;
double camLookZ = 0;

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

MidiBus myBus;

void setup(){
  size(1200,768, P3D);
  imageMode(CENTER);
  //rectMode(CENTER);
  
  println("...setting up midi controller ...");
  //MidiBus.list();
  myBus = new MidiBus(this, 0,-1);
  
  println("...creating peasycam 3D perspective camera ...");
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(minCamDist);
  cam.setMaximumDistance(maxCamDist);
  //cam.setYawRotationMode();   // like spinning a globe
  cam.setPitchRotationMode(); // like a somersault
  //cam.setRollRotationMode();  // like a radio knob
  //cam.setSuppressRollRotationMode();  // Permit pitch/yaw only.
  //cam.setFreeRotationMode(); // default mode
  
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
  
  println("...creating particles ...");
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
        float g = brightness(c);//255-brightness(c);
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
  if (brecord) {
    String data = year() + nf(month(),2) + nf(day(),2);
    data += "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2);
    beginRaw(PDF, "./../pantallazos_alta/" + data + ".pdf"); 
  }
  
  cam.setDistance(camDist);
  cam.rotateX(camRotationX);
  cam.lookAt(camLookX, camLookY, camLookZ);
  //cam.rotateY(camRotationY);
  //cam.rotateZ(camRotationZ);
  //cam.pan(camPanX, camPanY);
  
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
  if (brecord) {
    endRaw();
    brecord = false;
  }
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

void controllerChange(int c, int n, int v) {
  println("midi channel: " + c + "number: " + n + "value: " + v);
  if(n == 0){
    camDist = map(v, 0,127, minCamDist,maxCamDist);
  }
  else if(n == 1){
    camLookX = map(v, 0,127, -2000,2000);
  }
  else if(n == 2){
    camLookY = map(v, 0,127, -2000,2000);
  }
  else if(n == 3){
    camLookZ = map(v, 0,127, -1500,1500);
  }
  else if(n == 7){
    ampliZ = map(v, 0,127, 0.0,2.5);
  }
  else if(n == 16){
    camRotationX = map(v, 0,127, 0.0,-1.0); //vel
  }
  else if(n == 17){
    camRotationY = map(v, 0,127, 0,TWO_PI); //vel
  }
  else if(n == 18){
    camRotationZ = map(v, 0,127, 0,TWO_PI); //vel
  }
  else if(n == 19){
    camPanX = map(v, 0,127, -500,500); //vel
  }
  else if(n == 20){
    camPanY = map(v, 0,127, -2000,2000); //vel
  }
}