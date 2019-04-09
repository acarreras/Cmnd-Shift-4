class Drop {
  float posX, posY, INCREM, PRLN;
  color  c;

  Drop(float _x, float _y, color _c) {
    posX = _x;
    posY = _y;
    c = _c;
  }

  public void move() {
    update();
    borders();
    display();
  }

  void update() {
    INCREM += 0.00002;
    float n = noise(posX * 0.005, posY * 0.01, INCREM); //0.00001
    // float pi = map(second(),0,60,0,10*PI);
    PRLN = n * TWO_PI/1.4; // ampleur du courant 

    posX += random(-0.2,0.2) * cos(PRLN);
    posY += 1.5 * sin(PRLN); // velocitat gota
  }

  void borders() {
    if (posX < 0) {
      //posX = width;
      posX = random(0, width);
    }
    if (posX > width ) {
      // posX =  0;
      posX = random(0, width);
    }
    if (posY < 0 ) {
      // posY = height;
      posY = random(0, height);
    }
    if (posY > height) {
      // posY = 0;
      posY = random(0, height);
    }
  }

  void display() {
    if (posX > 0 && posX < width && posY > 0  && posY < height) {
      pixels[(int)posX + (int)posY * width] = color(c);
    }
  }
}