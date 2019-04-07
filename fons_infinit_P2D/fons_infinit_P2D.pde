// Texture coordinates are sometimes referred to
// by u and v, or, in shader languages, s and t.
float u = 0.0; float v = 0.0;

// Since we're no longer working in pixels, these
// can change from ints to floats.
float xOffset = 0.0; float yOffset = 0.0;
float xSpeed = 2; float ySpeed = 1;
float forwardSpeed = 2;
float backwardSpeed = -2;
/* ... */

PImage txtr;

void setup() {

  // Use int constant P2D to switch renderers.
  size(512, 256, P2D);
  noStroke();
  rectMode(RADIUS);
  txtr = loadImage("fons.jpg");

  // Set texture coordinates to range 0 .. 1.
  textureMode(NORMAL);
  
  // This will wrap the texture for us without
  // our needing the float floorMod.
  textureWrap(REPEAT);
}

void draw() {
  /* ... */

  // xSpeed is no longer rounded to an int.
  float mousePercent = mouseX / float(width);
  
  xSpeed = lerp(backwardSpeed, forwardSpeed, mousePercent);
  xOffset += xSpeed; yOffset += ySpeed;

  // Draw a square. The vertex coordinate parameters
  // are vertex(x, y, u, v);
  beginShape(QUADS);
  texture(txtr);
  vertex(0.0, 0.0, xOffset, yOffset);
  vertex(width, 0.0, xOffset + u, yOffset);
  vertex(width, height, xOffset + u, yOffset + v);
  vertex(0.0, height, xOffset, yOffset + v);
  endShape(CLOSE);
  /* ... */
  
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
    int yTxtr = floorMod((int)(y + yOffset), txtrH);

    // Loop through the width of the sketch.
    for (int x = 0; x < width; ++x, ++i) {

      // Add the offset to x, then modulate by the
      // texture width.
      int xTxtr = floorMod((int)(x + xOffset), txtrW);

      // Calculate the texture index from (x, y).
      int iTxtr = xTxtr + yTxtr * txtrW;

      // Set the sketch pixel at index i.
      pixels[i] = px[iTxtr];
    }
  }

  // Update the sketch pixels.
  updatePixels();

  // Monitor frame rate for slowdown.
  surface.setTitle(String.format("%.1f", frameRate));

}

// Wrap the Java Math function.
static int floorMod(int a, int b) {
  return Math.floorMod(a, b);
}