// By default, classes defined in the Processing IDE are
// nested classes inside a main class which corresponds
// to the main sketch where setup and draw are defined.
// Marking a class static allows a class to use a few more
// features, but means that some Processing functions, like
// random and line, are no longer available without a
// PApplet or PGraphics object.
static class Avatar {
  color fill = 0xff007fff;
  float x = 0.0; float y = 0.0;
  float rot = 0.0;
  float size = 25.0;
  float rotSpeed = 0.05;
  float moveSpeed = 3.0;
  float wingSweep = radians(140.0);

  // Temporary containers to minimize the number of
  // times the cosine and sine of rot are calculated.
  float cosRot = 1.0;
  float sinRot = 0.0;
  float cosWing = cos(wingSweep);
  float sinWing = sin(wingSweep);

  // Constructors.
  Avatar() {
  }

  Avatar(float x, float y, float rot, float size, 
    float rotSpeed, float moveSpeed, float wingSweep, 
    color fill) {
    set(x, y, rot, rotSpeed, moveSpeed, size, 
      wingSweep, fill);
  }

  // As many methods / functions as possible return this
  // Avatar instance so that the methods are chainable.
  Avatar draw(PGraphicsJava2D rndr) {
    float crcw = cosRot * cosWing;
    float srcw = sinRot * cosWing;
    float srsw = sinRot * sinWing;
    float crsw = cosRot * sinWing;
    
    rndr.pushStyle();
    rndr.noStroke();
    rndr.fill(fill);
    rndr.triangle(
      x + cosRot * size, 
      y + sinRot * size, 
      x + (crcw - srsw) * size, 
      y + (srcw + crsw) * size, 
      x + (crcw + srsw) * size, 
      y + (srcw - crsw) * size);
    rndr.popStyle();
    return this;
  }

  Avatar move(boolean[] pressed, 
    int leftKey, int rightKey, int upKey, int downKey) {
    if (pressed[leftKey]) {
      rot -= rotSpeed;
    }
    if (pressed[rightKey]) {
      rot += rotSpeed;
    }
    cosRot = cos(rot);
    sinRot = sin(rot);
    if (pressed[upKey]) {
      x = x + cosRot * moveSpeed;
      y = y + sinRot * moveSpeed;
    }
    if (pressed[downKey]) {
      x = x - cosRot * moveSpeed;
      y = y - sinRot * moveSpeed;
    }
    return this;
  }

  Avatar screenWrap(float w, float h) {
    x = floorMod(x, w); y = floorMod(y, h);
    return this;
  }

  Avatar set(float x, float y, float rot, 
    float rotSpeed, float moveSpeed, float size, 
    float wingSweep, color fill) {

    // The variable x passed in by the set function has
    // function or local scope; the variable x declared
    // at the top of this code has class-level scope.
    // The 'this' keyword is used to distinguish between
    // the two; it is an object's form of self-reference.
    this.x = x; this.y = y;
    this.rot = rot;
    cosRot = cos(this.rot);
    sinRot = sin(this.rot);
    this.rotSpeed = rotSpeed;
    this.moveSpeed = moveSpeed;
    this.size = size;
    this.wingSweep = wingSweep;
    cosWing = cos(wingSweep);
    sinWing = sin(wingSweep);
    this.fill = fill;
    return this;
  }
}

// Wrap the Java Math function.
static int floorMod(float a, float b) {
  return Math.floorMod((int)a, (int)b);
}