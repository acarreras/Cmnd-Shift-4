int xOffset = 0; int yOffset = 0;
int xSpeed = 1; int ySpeed = -2;
int forwardSpeed = 3;
int backwardSpeed = -3;

float heroForward;
float heroBackward;
float xHero; float yHero;
float sizeHero;

PImage txtr;

void setup() {
  size(512, 256);
  noStroke();
  rectMode(RADIUS);

  txtr = loadImage("fons.jpg");

  // Initialize variables which depend on the sketch's
  // dimensions.
  xHero = width * 0.5;
  yHero = height * 0.5;
  sizeHero = min(width, height) * 0.075;

  // To create illusion of hero speeding up and slowing down.  
  float heroOffset = width * 0.125;
  heroBackward = xHero - heroOffset;
  heroForward = xHero + heroOffset;
}

void draw() {

  // Update variables.
  float mousePercent = mouseX / float(width);
  xHero = lerp(heroBackward, heroForward, mousePercent);
  xSpeed = round(lerp(backwardSpeed, forwardSpeed, mousePercent));
  xOffset += xSpeed;
  yOffset += ySpeed;

  // Load sketch pixels into memory.
  loadPixels();

  // Load texture pixels into memory.
  txtr.loadPixels();

  // Create shortcuts to texture fields.
  int txtrH = txtr.height;
  int txtrW = txtr.width;
  color[] px = txtr.pixels;

  // Loop through the height of the sketch. Monitor
  // the pixel index by declaring i in the outer-loop,
  // then incrementing it in the inner-loop.
  for (int i = 0, y = 0; y < height; ++y) {

    // Add the offset to y, then modulate by the
    // texture's height so as to not go out-of bounds.
    int yTxtr = floorMod(y + yOffset, txtrH);

    // Loop through the width of the sketch.
    for (int x = 0; x < width; ++x, ++i) {

      // Add the offset to x, then modulate by the
      // texture width.
      int xTxtr = floorMod(x + xOffset, txtrW);

      // Calculate the texture index from (x, y).
      int iTxtr = xTxtr + yTxtr * txtrW;

      // Set the sketch pixel at index i.
      pixels[i] = px[iTxtr];
    }
  }

  // Update the sketch pixels.
  updatePixels();

  // Draw the 'hero'.
  fill(0xff007fff);
  rect(xHero, yHero, sizeHero, sizeHero);

  // Monitor frame rate for slowdown.
  surface.setTitle(String.format("%.1f", frameRate));
}

// Wrap the Java Math function.
static int floorMod(int a, int b) {
  return Math.floorMod(a, b);
}