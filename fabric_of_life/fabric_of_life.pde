int step = 3;
int stepCount = 500 / step;
float[] thread = new float[stepCount * 2];

void setup() {
  size(800, 800);
  colorMode(HSB);
  stroke(255, 128, 255);
  background(0, 0, 0);
  smooth();
  noFill();
  noLoop();
} 

void draw() {
  Person[] people = createPeople(10, 1000);
  timeFlow(500, people);
}

void testGradient() {
  float prev = 400;
  for (int i = 0; i < stepCount; i++) {
    thread[2*i] = i * step;
    prev = prev + random(-5 * step, 5 * step);
    thread[2*i+1] = prev;
  }
  for (int i = 1; i < stepCount - 2; i++) {
    stroke(169, i * step / 2, 255);
    curve(thread[2*i - 2], thread[2*i - 1], 
          thread[2*i], thread[2*i + 1], 
          thread[2*i + 2], thread[2*i + 3], 
          thread[2*i + 4], thread[2*i + 5]);
  }
}  

Person[] createPeople(int initialPopulation, int maxPopulation) {
  Person[] people = new Person[maxPopulation];
  for (int i = 0; i < initialPopulation; i++) people[i] = new Person(0, null, null);
  return people;
}

void timeFlow(int maxTime, Person[] people) {
  for (int t = 0; t < maxTime; t++) {
    for (int i = 0; i < people.length; i++) {
      if (people[i] == null) continue;
      switch (people[i].timeFlow(t, people)) {
        case Person.DEATH: 
          // TODO: draw last segments here, before the person is removed
          //int[] positions = 
          people[i] = null; 
          break;
      }
    }
    calcCurrentPositions(t, people);
    drawCurveSegments(t, people);
    // TODO: draw next segments of existing people
  }
}

void calcCurrentPositions(int currentTime, Person[] people) {
  // TODO -- take dependencies into account
  for (int i = 0; i < people.length; i++) {
    if (people[i] == null) continue;
    people[i].setPosition(currentTime, (i + 1) * 20);
  }
}

void drawCurveSegments(int currentTime, Person[] people) {
  for (int i = 0; i < people.length; i++) {
    if (people[i] == null) continue;
    int[] pos = people[i].getPositionsTo(currentTime);
    if (pos == null) continue;
    stroke(people[i].sex, people[i].getAge(currentTime) * 2.5, 255);
    curve((currentTime - 3) * step, pos[0], 
          (currentTime - 2) * step, pos[1], 
          (currentTime - 1) * step, pos[2], 
          (currentTime - 0) * step, pos[3]);
  }
}

class Dependency {
  Person whoDepends;
  float level;
  Dependency(Person whoDepends, float level) {
    this.whoDepends = whoDepends;
    this.level = level;
  }
}

class Person {
  // events
  static final int NOTHING = 0;
  static final int DEATH = 1;
  static final int MALE = 20;
  static final int FEMALE = 30;
  
  Dependency[][] dependencies;
  int[] positions;
  int sex;
  Person mother;
  Person father;
  Person partner;
  int birthTime;
  
  Person(int currentTime, Person mother, Person father) {
    this.birthTime = currentTime;
    this.sex = random(0.0, 1.0) > 0.52 ? MALE : FEMALE;
    this.mother = mother;
    this.father = father;
    dependencies = new Dependency[200][];
    positions = new int[200];
    
    if (mother != null) mother.addDependency(currentTime, new Dependency(this, 1));
    // TODO: variable
    if (father != null) father.addDependency(currentTime, new Dependency(this, 0.8));
  }
  
  int timeFlow(int currentTime, Person[] people) {
    int age = getAge(currentTime);
    if (random(0.0, 1.0) > 1.0 - (float)(age*age)/41260) return DEATH;
    if (age < 18) {
      if (mother != null) mother.addDependency(currentTime, new Dependency(this, 1 - age/50));
      if (father != null) father.addDependency(currentTime, new Dependency(this, 1 - age/50));
    }
    // TODO: find a partner
    // TODO: have kids
    return NOTHING;
  }
  
  void addDependency(int time, Dependency dependency) {
    // TODO
  }
  
  int getAge(int time) {
    return time - birthTime;
  }
  
  void setPosition(int time, int position) {
    positions[getAge(time)] = position;
  }
  
  int[] getPositionsTo(int time) {
    int[] pos = new int[4];
    if (time - birthTime < 2) return null;
    else if (time - birthTime == 2) {
      pos[0] = positions[0];
      for (int i = 0; i < 3; i++) pos[i + 1] = positions[i];
    } else {
      for (int i = 0; i < 4; i++) pos[i] = positions[time - birthTime - 3 + i];
    }
    return pos;
  }
}
