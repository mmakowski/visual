static final int tileSize = 30;

void setup() {
  size(1000, 800);
  background(255, 255, 255);
  stroke(0);
  smooth();
  noLoop();
  noFill();
}

void draw() {
  float dx = tileSize * cos(radians(30)) * 2;
  int l = 0;
  for (float y = 0; y < height + tileSize; y += tileSize / 2) {
    for (float x = l % 2 * dx / 2; x < width + tileSize; x += dx) {
      module(x, y, tileSize, (int)random(6));
    }
    l++;
  }
}

void module(float cx, float cy, float size, int rotation) {
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

