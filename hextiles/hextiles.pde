// params
static final int tileSize = 50;
static final int transitionSteps = 50;
static final int transitionDelay = 20;

// constants
static final int currMask = 0xf;
static final int currShift = 0;
static final int nextMask = 0xf0;
static final int nextShift = 4;
static final int stepMask = 0xff00;
static final int stepShift = 8;
static final float centreDistX = tileSize * cos(radians(30)) * 2;

// globals
int[][] pattern;
boolean firstFrame;
int delayCounter = 0;

void setup() {
  size(900, 450);
  background(255, 255, 255);
  stroke(0);
  smooth();
  noFill();
  frameRate(50);
  firstFrame = true;
  pattern = new int[(int) ((width + tileSize) / centreDistX + 1)][ 2 * (int) ((height + tileSize) / tileSize + 1)];
  // create the initial pattern
  for (int y = 0; y < pattern[0].length; y++) {
    for (int x = 0; x < pattern.length; x++) {
      int rot = (int) random(6);
      setCurr(x, y, rot);
      setNext(x, y, rot);
    }
  }
}

void draw() {
  if (firstFrame) {
      drawInitial();
      firstFrame = false;
      return;
  }
  if (delayCounter == 0) startTransitionOfARandomTile();
  drawTransitions();
  delayCounter = (delayCounter + 1) % transitionDelay;
}

void drawInitial() {
  for (int y = 0; y < pattern[0].length; y ++) {
    for (int x = 0; x < pattern.length; x++) {
      module(toScreenCoordX(x, y), toScreenCoordY(y), tileSize, getCurr(x, y));
    }
  }
}

void startTransitionOfARandomTile() {
  int x = (int) random(pattern.length);
  int y = (int) random(pattern[0].length);
  int curr = getCurr(x, y);
  if (curr != getNext(x, y)) return;
  setNext(x, y, (curr + (int) random(5) + 1) % 6);
}

void drawTransitions() {
  for (int y = 0; y < pattern[0].length; y++) {
    for (int x = 0; x < pattern.length; x++) {
      int curr = getCurr(x, y);
      int next = getNext(x, y);
      if (curr != next) {
        float scrX = toScreenCoordX(x, y);
        float scrY = toScreenCoordY(y);
        blankModule(scrX, scrY, tileSize);
        int step = getStep(x, y);
        if (step < transitionSteps - 1) {
          transitionModule(scrX, scrY, tileSize, curr, next, step);
        } else {
          module(scrX, scrY, tileSize, next);
          setCurr(x, y, next);
        }
        step = (step + 1) % transitionSteps;
        setStep(x, y, step);
      }
    }
  }
}

void blankModule(float cx, float cy, float size) {
  translate(cx, cy);
  noSmooth();
  fill(255, 255, 255);
  noStroke();
  float side = size * tan(radians(30));
  quad(-side, 0, 0, 0, side / 2, -size / 2, -side / 2, -size / 2);
  quad(0, 0, side / 2, size / 2, side, 0, side / 2, -size / 2);
  quad(-side, 0, -side / 2, size / 2, side / 2, size / 2, 0, 0);
  noFill();
  stroke(0, 0, 0);
  smooth();
  translate(-cx, -cy);
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

// transition
void transitionModule(float cx, float cy, float size, int fromRotation, int toRotation, int step) {
  int rotation = step > transitionSteps / 2 ? toRotation : fromRotation;
  float[] ssx = new float[6];
  float[] ssy = new float[6];
  float[] outx = new float[6];
  float[] outy = new float[6];
  float dx = size / 2 * cos(radians(30));
  float dy = size / 2 * sin(radians(30));
  float straightness = map(transitionSteps / 2 - (int) abs(step - (transitionSteps / 2)), 0, transitionSteps / 2, 4.5, 9);
  setCoords(ssx, ssy, outx, outy, 0, cx, cy, 0, -size / 2, straightness);
  setCoords(ssx, ssy, outx, outy, 1, cx, cy, dx, -dy, straightness);
  setCoords(ssx, ssy, outx, outy, 2, cx, cy, dx, dy, straightness);
  setCoords(ssx, ssy, outx, outy, 3, cx, cy, 0, size / 2, straightness);
  setCoords(ssx, ssy, outx, outy, 4, cx, cy, -dx, dy, straightness);
  setCoords(ssx, ssy, outx, outy, 5, cx, cy, -dx, -dy, straightness);
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
 
void setCoords(float[] ssx, float[] ssy, float[] outx, float[] outy, int i, float cx, float cy, float dx, float dy, float straightness) {
  ssx[i] = cx + dx;
  ssy[i] = cy + dy;
  outx[i] = cx + straightness * dx;
  outy[i] = cy + straightness * dy;
}

int getCurr(int x, int y) {
  return (pattern[x][y] & currMask) >> currShift;
}

void setCurr(int x, int y, int value) {
  pattern[x][y] = (pattern[x][y] & ~currMask) | (value << currShift);
}

int getNext(int x, int y) {
  return (pattern[x][y] & nextMask) >> nextShift;
}

void setNext(int x, int y, int value) {
  pattern[x][y] = (pattern[x][y] & ~nextMask) | (value << nextShift);
}

int getStep(int x, int y) {
  return (pattern[x][y] & stepMask) >> stepShift;
}

void setStep(int x, int y, int value) {
  pattern[x][y] = (pattern[x][y] & ~stepMask) | (value << stepShift);
}

float toScreenCoordX(int x, int y) {
  return y % 2 * centreDistX / 2 + x * centreDistX;
}

float toScreenCoordY(int y) {
  return y * tileSize / 2;
}


