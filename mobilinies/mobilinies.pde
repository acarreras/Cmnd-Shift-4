import controlP5.*;

int nmobiles = 5000;
ArrayList mobiles = new ArrayList();
float noisescale;
float a1, a2, a3, a4, a5, amax;
boolean bw = false;

ControlP5 cp5;
RadioButton fitxers;
String path; // path absolut a l'sketch
File[] files;
int quinaFile = 10;
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
  background(0);
  noFill();
  strokeWeight(.1);
  
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
  
  cp5.setAutoDraw(false);
  
  println("...variables de la app ...");
  migW = width*0.5;
  migH = height*0.5;
  
  println("...setting up particles ...");
  /*
  for(int f=0; f<nmobiles; f++){
    float posX = random(0,width)+tX;
    float posY = random(0,height)+tY;
    color cp = terra.get((int)posX,(int)posY);
    mobiles.add(new Mobile(f, cp, posX,posY));
  }
  */
  setupMobile();
    
  println("########################################");
  println("START###################################");
  println("########################################");
}

void setupMobile() {
  println("...setting up noise ...");
  
  noisescale = random(.01, .1);
  noiseDetail(int(random(2,10)));
  amax = random(10);
  a1 = random(1, amax);
  a2 = random(1, amax);
  a3 = random(1, amax);
  a4 = random(1, amax);
  a5 = 30;
  
  println("...drawing the background ...");
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
}

void draw() {
  noiseSeed((long)(millis()*.00005));
  for(int i=0; i<mobiles.size(); i++) {
    Mobile m = (Mobile)mobiles.get(i);
    m.update();
    m.display();
  }
  
  //gui();
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cp5.draw(); // GUI
  hint(ENABLE_DEPTH_TEST);
}

void keyPressed() {
  if (key== 's' || key== 'S'){
    save("./../pantallazos_baixa/mobilines" + frameCount + ".jpg");
  }
  else if (key == ' '){
    background(0);  
    setupMobile();
  }
  if(key == 'r' || key == 'R') setup();
  if(key == 'b' || key == 'B') bw=!bw;
}

void llistatFitxers(int a) {
  quinaFile = a;
  filename = path + files[quinaFile].getName();
  terra = loadImage(filename);
}

void mouseDragged(){
  for(int f=0; f<10; f++){
    float posX = mouseX + random(-5,5);
    float posY = mouseY + random(-5,5);
    float pX = posX+tX;
    float pY = posY+tY;
    color cp = terra.get((int)pX,(int)pY);
    mobiles.add(new Mobile(f, cp, posX,posY));
  }  
}