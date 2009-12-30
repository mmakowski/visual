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
       float prev = 400;
       for (int i = 0; i < stepCount; i++) {
         thread[2*i] = i * step;
         prev = prev + random(-5 * step, 5 * step);
         thread[2*i+1] = prev;
       }
       for (int i = 1; i < stepCount - 2; i++) {
         stroke(255, i * step / 2, 255);
         curve(thread[2*i - 2], thread[2*i - 1], 
               thread[2*i], thread[2*i + 1], 
               thread[2*i + 2], thread[2*i + 3], 
               thread[2*i + 4], thread[2*i + 5]);
       }
     }


