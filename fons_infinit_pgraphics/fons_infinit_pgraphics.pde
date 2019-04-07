// Import the processing.awt library to reference the
// graphics renderer, based on Java's AWT library.
import processing.awt.PGraphicsJava2D;

PGraphicsJava2D renderer;
Avatar hero;
boolean[] pressed = new boolean[256];


int refMarks = 50;
float markerSize = 6.0;
float refSpan;
color red = color(255.0, 0.0, 0.0, 255.0);
color blue = color(0.0, 0.0, 255.0, 255.0);

void setup() {
  size(512, 256, JAVA2D);

  // Gain access to the sketch's graphics renderer, g.
  renderer = (PGraphicsJava2D)g;

  // Create a new Avatar and assign it to hero.
  hero = new Avatar(width * 0.5, height * 0.5, /* ( x, y ) */
    0.0, 25.0, /* rotation angle, size */
    0.05, 3.0, /* rotation speed, move speed */
    radians(140.0), /* wing sweep */
    color(0.0, 127.0, 255.0)); /* fill color */
}

void draw() {
  background(0.0);
  drawRefMarks(50, width * 1.25, 6.0, 1.5, 
    0xffff0000, 0xff0000ff);
  
  // A, D, W and S keys.
  hero.move(pressed, 65, 68, 87, 83);
  hero.draw(renderer);
}

void drawRefMarks(int refMarks, float refSpan, float markerSize, 
  float strokeWeight, color color0, color color1) {

  // Wrap reference marks in push- and popStyle so that their
  // use of stroke and color does not leak over into other
  // shapes we want to draw.
  pushStyle();
  strokeWeight(1.5);

  // Convert the index i's progress through the for-loop
  // to a percentage by multiplying it by 1 / (count - 1).
  float toPercent = 1.0 / float(refMarks - 1);

  // Loop through vertical span.
  for (int i = 0; i < refMarks; ++i) {
    float iPrc = i * toPercent;

    // Linear interpolation from negative to positive span.
    float my = lerp(-refSpan, refSpan, iPrc);

    // Loop through horizontal span.
    for (int j = 0; j < refMarks; ++j) {
      float jPrc = j * toPercent;
      float mx = lerp(-refSpan, refSpan, jPrc);

      // Average the horizontal and vertical percent
      // to get a percent for mixing colors.
      float kPrc = (iPrc + jPrc) * 0.5;

      // Mix red and blue; use Hue, Saturation and Brightness
      // as the color space.
      color strokeColor = lerpColor(red, blue, kPrc, HSB);
      stroke(strokeColor);

      // Draw a horizontal line.
      line(mx - markerSize, my, mx + markerSize, my);

      // Draw a vertical line.
      line(mx, my - markerSize, mx, my + markerSize);
    }
  }
  popStyle();
}