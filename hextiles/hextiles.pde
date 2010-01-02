static final int arcCurvature = 3;
static final int tileSize = 50;

void setup() {
  size(400, 400);
  background(255, 255, 255);
  stroke(0);
  smooth();
  //noLoop();
  noFill();
  curveTightness(-0.5);
}

void draw() {
  float dx = tileSize * cos(radians(30)) * 2;
  int l = 0;
  for (float y = 0; y < height + tileSize; y += tileSize / 2) {
    for (float x = l % 2 * dx / 2; x < width + tileSize; x += dx) {
      //module1(x, y, tileSize, (int)random(6));
      module2(x, y, tileSize, (int)random(6));
    }
    l++;
  }
}

void module2(float cx, float cy, float size, int rotation) {
  translate(cx, cy);
  rotate(rotation * PI / 3);
  float smallArcRadius = size * tan(radians(30)) / 2;
  float bigArcRadius = size * cos(radians(30));
  arc(-size / (2 * cos(radians(30))), 0, smallArcRadius * 2, smallArcRadius * 2, -PI / 3, PI / 3);
  arc(bigArcRadius, -size / 2, bigArcRadius * 2, bigArcRadius * 2, 2 * PI / 3, PI);
  arc(bigArcRadius, size / 2, bigArcRadius * 2, bigArcRadius * 2, PI, 4 * PI / 3);
  rotate(-rotation * PI / 3);
  translate(-cx, -cy);
}

void module1(float cx, float cy, float size, int rotation) {
  float[] ssx = new float[6];
  float[] ssy = new float[6];
  float[] outx = new float[6];
  float[] outy = new float[6];
  float dx = size / 2 * cos(radians(30));
  float dy = size / 2 * sin(radians(30));
  setCoords(ssx, ssy, outx, outy, 0, cx, cy, 0, -size / 2);
  setCoords(ssx, ssy, outx, outy, 1, cx, cy, dx, -dy);
  setCoords(ssx, ssy, outx, outy, 2, cx, cy, dx, dy);
  setCoords(ssx, ssy, outx, outy, 3, cx, cy, 0, size / 2);
  setCoords(ssx, ssy, outx, outy, 4, cx, cy, -dx, dy);
  setCoords(ssx, ssy, outx, outy, 5, cx, cy, -dx, -dy);
  innerArc(ssx, ssy, outx, outy, 4, 5, rotation);
  innerArc(ssx, ssy, outx, outy, 0, 2, rotation);
  innerArc(ssx, ssy, outx, outy, 1, 3, rotation);
}

void innerArc(float[] ssx, float[] ssy, float[] outx, float[] outy, int sideStart, int sideEnd, int rotation) {
  curve(outx[rot(sideStart, rotation)], outy[rot(sideStart, rotation)],
  ssx[rot(sideStart, rotation)], ssy[rot(sideStart, rotation)],
  ssx[rot(sideEnd, rotation)], ssy[rot(sideEnd, rotation)],
  outx[rot(sideEnd, rotation)], outy[rot(sideEnd, rotation)]);
}

int rot(int base, int rotation) {
  return (base + rotation) % 6;
}

void setCoords(float[] ssx, float[] ssy, float[] outx, float[] outy, int i, float cx, float cy, float dx, float dy) {
  ssx[i] = cx + dx;
  ssy[i] = cy + dy;
  outx[i] = cx + arcCurvature * dx;
  outy[i] = cy + arcCurvature * dy;
}

