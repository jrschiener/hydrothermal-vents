import processing.sound.*;

PinkNoise noise;
LowPass lowPass;

float amp=0.0;

ParticleSystem ps;
ParticleSystem ps2;
ParticleSystem ps3;
ParticleSystem ps4;



//Sea life variables
int quantity = 40;
float [] xPosition = new float[quantity];
float [] yPosition = new float[quantity];
int [] flakeSize = new int[quantity];
int [] direction = new int[quantity];
int minFlakeSize = 1;
int maxFlakeSize = 5;

void setup() {
 
  size(1000, 500, P3D);
  //for phone 
  //size(screen.width, screen.height);
  PImage img = loadImage("Gray+Circle.png");
  ps = new ParticleSystem(0, new PVector(width/2, height-200), img);
  ps2 = new ParticleSystem(0, new PVector(width/2.2, height-150), img);
  ps3 = new ParticleSystem(0, new PVector(width/2, height-100), img);
  ps4 = new ParticleSystem(0, new PVector(width/3.3, height-100), img);


  
  //Snowflake effect for floating sea life
  frameRate(15);
  noStroke();
  smooth();
  
  for(int i = 0; i < quantity; i++) {
    flakeSize[i] = round(random(minFlakeSize, maxFlakeSize));
    xPosition[i] = random(0, width);
    yPosition[i] = random(0, height);
    direction[i] = round(random(0, 1));
  }
  
    //Create noise generator
  noise = new PinkNoise(this);
  lowPass = new LowPass(this);
  
  noise.play(0.5);
  lowPass.process(noise, 800);
  
}

void draw() {
  background(0);
  
  //Vent smoke #1
  float dx = (-0.3);
  PVector wind = new PVector(0, dx);
  ps.applyForce(wind);
  ps.run();
  for (int i = 0; i < 2; i++) {
    ps.addParticle();
  }
  
  //Vent smoke #2
  float dy = (-0.3);
  PVector wind2 = new PVector (0, dy);
  ps2.applyForce(wind2);
  ps2.run();
  for (int i = 0; i < 2; i++) {
    ps2.addParticle();
  }
  
  //Vent smoke #3
  float dz = (-0.3);
  PVector wind3 = new PVector (0, dz);
  ps3.applyForce(wind3);
  ps3.run();
  for (int i = 0; i < 2; i++) {
    ps3.addParticle();
  }
  
  //Vent smoke #4
  float da = (-0.3);
  PVector wind4 = new PVector (0, da);
  ps4.applyForce(wind4);
  ps4.run();
  for (int i = 0; i < 2; i++) {
    ps4.addParticle();
  }
  


//Draw vent structure
  pushMatrix();
  lights(); //needed for 3D affect of vent structure
  translate(width / 2, height / 2);
  noStroke();
  fill(255, 255, 255, 50);
  translate(-40, 50, 0);
  drawCylinder1(30, 180, 200, 16); // Draw a mix between a cylinder and a cone 
  popMatrix();
  
  pushMatrix();
  lights(); //needed for 3D affect of vent structure
  translate(width / 3, height / 2.5);
  noStroke();
  fill(255, 255, 255, 50);
  translate(-40, 150, 0);
  drawCylinder1(20, 180, 200, 10); // Draw a mix between a cylinder and a cone 
  popMatrix();
  
//Next, draw sea life
  for(int i = 0; i < xPosition.length; i++) {
    
    ellipse(xPosition[i], yPosition[i], flakeSize[i], flakeSize[i]);
    
    if(direction[i] == 0) {
      xPosition[i] += map(flakeSize[i], minFlakeSize, maxFlakeSize, .1, .5);
    } else {
      xPosition[i] -= map(flakeSize[i], minFlakeSize, maxFlakeSize, .1, .5);
    }
    
    yPosition[i] += flakeSize[i] + direction[i]; 
    
    if(xPosition[i] > width + flakeSize[i] || xPosition[i] < -flakeSize[i] || yPosition[i] > height + flakeSize[i]) {
      xPosition[i] = random(0, width);
      yPosition[i] = -flakeSize[i];
    } 
  }
  

 
}
  

void drawCylinder1(float topRadius, float bottomRadius, float tall, int sides) {
  float angle = 0;
  float angleIncrement = TWO_PI / sides;
  beginShape(QUAD_STRIP);
  for (int i = 0; i < sides + 1; ++i) {
    vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
    vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
    angle += angleIncrement;
  }
  endShape();
  
  // Draw the circular top cap
  if (topRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);
    
    // Center point
    vertex(0, 0, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }

  // Draw the circular bottom cap
  if (bottomRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);

    // Center point
    vertex(0, tall, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(bottomRadius * cos(angle), tall, bottomRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  PVector origin;                   // An origin point for where particles are birthed
  PImage img;

  ParticleSystem(int num, PVector v, PImage img_) {
    particles = new ArrayList<Particle>();              // Initialize the arraylist
    origin = v.copy();                                   // Store the origin point
    img = img_;
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin, img));         // Add "num" amount of particles to the arraylist
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  // Method to add a force vector to all particles currently in the system
  void applyForce(PVector dir) {
    // Enhanced loop!!!
    for (Particle p : particles) {
      p.applyForce(dir);
    }
  }  

  void addParticle() {
    particles.add(new Particle(origin, img));
  }
}



// A simple Particle class, renders the particle as an image

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float lifespan;
  PImage img;

  Particle(PVector l, PImage img_) {
    acc = new PVector(0, 0);
    float vx = randomGaussian()*0.3;
    float vy = randomGaussian()*0.3 - 1.0;
    vel = new PVector(vx, vy);
    loc = l.copy();
    lifespan = 100.0;
    img = img_;
  }

  void run() {
    update();
    render();
  }

  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  void applyForce(PVector f) {
    acc.add(f);
  }  

  // Method to update position
  void update() {
    vel.add(acc);
    loc.add(vel);
    lifespan -= 2.5;
    acc.mult(0); // clear Acceleration
  }

  // Method to display
  void render() {
    imageMode(CENTER);
    tint(255, lifespan);
    image(img, loc.x, loc.y);
    // Drawing a circle instead
    // fill(255,lifespan);
    // noStroke();
    // ellipse(loc.x,loc.y,img.width,img.height);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}