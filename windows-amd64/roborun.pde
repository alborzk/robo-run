// This program contains a "custom" OBJ file reader.
// If you are using it for assignment 4, please feel free to remove that code
// if you don't need it.

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

void setup() {
  size(640, 640, P3D);
  frameRate(60);
  colorMode(RGB, 1.0f);
  //perspective(0.9, float(width)/float(height), 1.6, 50);
  //frustum(-1.0f, 1.0f, 1.0f, -1.0f, 1f, 50.0f);
  //frustum(-1.0f, 1.0f, 0.4f, -1.5f, 0.8f, 50.0f);
  textureMode(NORMAL);
  grass = loadImage("assets/grass.jpg");
  snow = loadImage("assets/snow.jpg");  
  bark = loadImage("assets/bark.jpg");
  cork = loadImage("assets/cork.jpg");
  skyNight = loadImage("assets/night.jpg");
  skyDay = loadImage("assets/day.jpg");  
  water = loadImage("assets/water.jpg"); 
  duckskin = loadImage("assets/duck_skin.png");
  textureWrap(REPEAT);
  frog = loadShape("assets/12270_Frog_v1_L3.obj");
  duck = loadShape("assets/RubberDuck.obj");
  duck.setTexture(duckskin);
  
  ps = new ParticleSystem(new PVector(0,0,0));    

  Rotator head = new Rotator(new float[]{0,180,0}, new float[]{0,0,0}, new float[]{0,1,0}, 0, -30, 30, 1);
  Rotator rightShoulder = new Rotator(new float[]{0,90,0}, new float[]{0,0,0}, new float[]{1,0,0}, 30, -30, 30, 1);
  Rotator rightElbow = new Rotator(new float[]{0,-90,0}, new float[]{0,0.075f,0}, new float[]{1,0,0}, 30, -30, 30, 1);
  Rotator leftShoulder = new Rotator(new float[]{0,90,0}, new float[]{0,0,0}, new float[]{1,0,0}, -30, -30, 30, 1);
  Rotator leftElbow = new Rotator(new float[]{0,-90,0}, new float[]{0,0.075f,0}, new float[]{1,0,0}, -30, -30, 30, 1);
  Rotator rightThigh = new Rotator(new float[]{90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, -30, -30, 30, 1);
  Rotator rightKnee = new Rotator(new float[]{-90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, 0, 0, 45, 0.75f);
  Rotator leftThigh = new Rotator(new float[]{90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, 30, -30, 30, 1);
  Rotator leftKnee = new Rotator(new float[]{-90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, 45, 0, 45, 0.75f);
  rotators = new Rotator[] {
    head,
    rightShoulder,
    rightElbow,
    leftShoulder,
    leftElbow,
    rightThigh,
    rightKnee,
    leftThigh,
    leftKnee
  };
  
  robot = new Structure(
            new Shape[] {
              new Shape(new float[] {0.1f,0.15f,0.1f}, head),
              //new Shape("dodecahedron.obj", new float[] {0.2, 0.2, 0.2}, head),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.06f, -0.125f, 0.06f}, rightElbow)},
                  new float[][] {{-0.058f, -0.15f, -0.001f}},
                  new float[] {0.125f, 0.075f, 0.075f}, rightShoulder),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.06f, -0.125f, 0.06f}, leftElbow)},
                  new float[][] {{0.058f, -0.15f, -0.001f}},
                  new float[] {0.125f, 0.075f, 0.075f}, leftShoulder),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.1f, 0.15f, 0.1f}, rightKnee)},
                  new float[][] {{0.0f, -0.3f, 0.0f}},
                  new float[] {0.1f, 0.15f, 0.1f}, rightThigh),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.1f, 0.15f, 0.1f}, leftKnee)},
                  new float[][] {{0.0f, -0.3f, 0.0f}},
                  new float[] {0.1f, 0.15f, 0.1f}, leftThigh)
            }, new float[][] {
              {0, 0.4f, 0 },
              {-0.25f, 0.15f, 0},
              {0.25f, 0.15f, 0},
              {-0.15f, -0.3f, 0 },
              {0.15f, -0.3f, 0 }
            },
            new float[] {0.15f,0.25f,0.15f}, null);
            
    robotZ = -12;
  }

ParticleSystem ps;
PImage grass, bark, cork, skyDay, water, duckskin, skyNight, snow;
PShape frog, duck;
int projection = 0;
boolean thirdPerson = false;
boolean jumping = false;
boolean moving = true;
boolean freeLook = false;
boolean night = true;

Structure robot;
Rotator[] rotators;
float robotX, robotY, robotZ;
float moveSpeed, jumpSpeed;
float eyeX = robotX, eyeY = 0.8+robotY, eyeZ = -0.7+robotZ;
float centerX = robotX, centerY = -0.3+eyeY, centerZ = 1+robotZ;
float upX = 0, upY = -1, upZ = 0;
float freeLookX, freeLookY;

boolean frog1Dead = false;
float frog1Y = -0.7;
float frog1Jump = 0.1;

boolean frog2Dead = false;
float frog2Y = -0.7;
float frog2Jump = 0.1;

boolean frog3Dead = false;
float frog3Y = -0.7;
float frog3Jump = 0.1;

boolean frog4Dead = false;
float frog4Y = -0.7;
float frog4Jump = 0.1;
float t = 1;

void draw() {
  background(0.05, 0.05, 0.1);
  fill(1, 0, 0);
  stroke(1, 1, 1);
  strokeWeight(5.5);
  resetMatrix();
  
  if (night){
    ps.addParticle(); 
    ps.addParticle(); 
    lightFalloff(1, 0, 0.01);
    lightSpecular(0, 0, 0);
    ambientLight(1, 0.3, 1);
    directionalLight(1, 1, 1, 0, 0, -1);
    resetMatrix();    
  }
  
  //First Person Camera
  if (!thirdPerson){
    perspective(0.9, float(width)/float(height), 0.3, 100);
    eyeX = robotX;
    eyeY = 0.8 + robotY;
    eyeZ = robotZ;
    centerX = robotX + freeLookX;
    centerY = 0.6 + robotY + freeLookY;      
    centerZ = 1 + robotZ;
    upX = 0;
    upY = -1;
    upZ = 0;
    camera(eyeX,eyeY,eyeZ,centerX,centerY,centerZ,upX,upY,upZ);        
  }
  //Third Person Camera
  else{
    perspective(0.9, float(width)/float(height), 1.6, 100);
    eyeX = robotX;
    eyeY = 2 + robotY;
    eyeZ = -5 + robotZ;
    centerX = robotX;
    centerY = -1 + eyeY;
    centerZ = 1 + robotZ;
    upX = 0;
    upY = -1;
    upZ = 0;
    camera(eyeX,eyeY,eyeZ,centerX,centerY,centerZ,upX,upY,upZ);    
  }

  //Move Robot
  if (moving){
    moveSpeed = 0.05;
  }
  else{
    moveSpeed = 0;
  }
  
  //In the Z direction
  robotZ += moveSpeed;
  
  //Tree Collisions
  if (!jumping)
  {
    // Encounter 1: Tree Stump
    if ((robotZ >= 2) && (robotZ < 2.75) && (robotX == 0)){
      moving = false;
    }
    else if ((robotZ >= 2.75) && (robotZ < 3.5) && (robotX == 0)){
      robotZ = 3.55;      
      moving = true;
    }
    
    // Encounter 2: Tree Stump 1
    else if ((robotZ >= 13.8) && (robotZ < 14.75) && (robotX == -1)){
      moving = false;
    }
    else if ((robotZ >= 14.75) && (robotZ < 15.5) && (robotX == -1)){
      robotZ = 15.55;
      moving = true;
    }
    // Encounter 2: Tree Stump 2
    else if ((robotZ >= 13.8) && (robotZ < 14.75) && (robotX == 1)){
      moving = false;
    }
    else if ((robotZ >= 14.75) && (robotZ < 15.5) && (robotX == 1)){
      robotZ = 15.55;
      moving = true;
    }
    
    // Encounter 3: Tree Stump 1
    else if ((robotZ >= 26) && (robotZ < 26.75) && (robotX == 1)){
      moving = false;
    }
    else if ((robotZ >= 26.75) && (robotZ < 27.5) && (robotX == 1)){
      robotZ = 27.55;
      moving = true;
    }
    // Encounter 3: Tree Stump 2
    else if ((robotZ >= 26) && (robotZ < 26.75) && (robotX == 0)){
      moving = false;
    }
    else if ((robotZ >= 26.75) && (robotZ < 27.5) && (robotX == 0)){
      robotZ = 27.55;
      moving = true;
    }
    // Encounter 3: Tree Stump 3
    else if ((robotZ >= 29) && (robotZ < 29.75) && (robotX == 0)){
      moving = false;
    }
    else if ((robotZ >= 29.75) && (robotZ < 30.5) && (robotX == 0)){
      robotZ = 30.55;
      moving = true;
    }
    // Encounter 3: Tree Stump 4
    else if ((robotZ >= 29) && (robotZ < 29.75) && (robotX == -1)){
      moving = false;
    }
    else if ((robotZ >= 29.75) && (robotZ < 30.5) && (robotX == -1)){
      robotZ = 30.55;
      moving = true;
    } 
    
    // Encounter 7: Tree Stump 1
    else if ((robotZ >= 74) && (robotZ < 74.75) && (robotX == 0)){
      moving = false;
    }
    else if ((robotZ >= 74.75) && (robotZ < 75.5) && (robotX == 0)){
      robotZ = 75.55;
      moving = true;
    }
    // Encounter 7: Tree Stump 2
    else if ((robotZ >= 76) && (robotZ < 76.75) && (robotX == -1)){
      moving = false;
    }
    else if ((robotZ >= 76.75) && (robotZ < 77.5) && (robotX == -1)){
      robotZ = 77.55;
      moving = true;
    }   
    // Encounter 7: Tree Stump 3
    else if ((robotZ >= 76) && (robotZ <= 76.75) && (robotX == 1)){
      moving = false;
    }
    else if ((robotZ >= 76.75) && (robotZ < 77.5) && (robotX == 1)){
      robotZ = 77.55;
      moving = true;
    }    
  
    else{moving = true;}
  }
  
  // Frog Collisions
  //Encounter 5: Frog
  if ((frog1Y >= robotY-0.8) && (frog1Y <= robotY+0.8) && (robotZ >= 51.2) && (robotZ <= 52.3) && (robotX == 0)){
      frog1Dead = true;
      jumpSpeed = 0.16;
    }
    
    //Encounter 6: Frog
   if ((frog2Y >= robotY-0.8) && (frog2Y <= robotY+0.8) && (robotZ >= 63.2) && (robotZ <= 64.3) && (robotX == -1)){
      frog2Dead = true;
      jumpSpeed = 0.16;
    }
    
    //Encounter 7: Frog 1
    if ((frog3Y >= robotY-0.8) && (frog3Y <= robotY+0.8) && (robotZ >= 79.2) && (robotZ <= 80.3) && (robotX == 1)){
      frog3Dead = true;
      jumpSpeed = 0.16;
    }        
    //Encounter 7: Frog 2
    if ((frog4Y >= robotY-0.8) && (frog4Y <= robotY+0.8) && (robotZ >= 79.2) && (robotZ <= 80.3) && (robotX == -1)){
      frog4Dead = true;
      jumpSpeed = 0.16;
    }            
  
  //Water Collisions
  if (!jumping){
    if (robotZ >= 39.4 && robotZ <= 40.6){
      robotZ = -12f;
      frog1Dead = false; frog2Dead = false; frog3Dead = false; frog4Dead = false;
    }
    else if (robotZ >= 62.7 && robotZ <= 65.3){
      frog1Dead = false; frog2Dead = false; frog3Dead = false; frog4Dead = false;      
      robotZ = -12f;
    }
    else if (robotZ >= 78.7 && robotZ <= 81.3){
      frog1Dead = false; frog2Dead = false; frog3Dead = false; frog4Dead = false;
      robotZ = -12f;
    }    
  }  
  
  //Duck Collision
  if ((robotZ > 84f)){
      robotZ = -12f;
      frog1Dead = false; frog2Dead = false; frog3Dead = false; frog4Dead = false;
  }
  
  //In the Y direction
  robotY += jumpSpeed;
  
  //If robot is grounded
  if (robotY <= 0) {
    robotY = 0;
    jumpSpeed = 0;
    jumping = false;
  }
  else {
    jumpSpeed = jumpSpeed-0.006;
  }
  
  //Draw Skybox
  pushMatrix();
  translate(robotX, robotY, robotZ);
  scale(50,50,25);
  if (night)
    drawCube(skyNight,skyNight);
  else
    drawCube(skyDay,skyDay);
  popMatrix();
  
  //Draw Particles
  if (night){
    pushMatrix();
    if (!thirdPerson){
      translate(0, eyeY+5, eyeZ+1);
      ps.run();  
    }
    else{
      translate(0, eyeY+5, eyeZ+3);
      ps.run();
    }
    popMatrix();
  }
  
  
  //Draw Robot
  pushMatrix();
  translate(robotX, robotY, robotZ);
  robot.draw();
  popMatrix();
  
  //Draw Floor
  pushMatrix();
  translate(0, -0.75f, 0);
  noStroke();
  final float SQSIZE = 1f;
  for (float x = -2; x <2; x+=SQSIZE) {
    for (float z = -20; z < 90; z+=SQSIZE) {
      beginShape(QUADS);
      if (night)
        texture(snow);
      else
        texture(grass);
      vertex(x, 0, z, 0,0.5);
      vertex(x+SQSIZE, 0, z,0.5,0.5);
      vertex(x+SQSIZE, 0, z+SQSIZE, 0.5,0);
      vertex(x, 0, z+SQSIZE, 0,0);
      endShape();
    }
  }
  popMatrix();
  
  //Move Frog
  //In the Y direction
  frog2Y += frog2Jump;
  if (frog2Y <= -0.7) {
    if (!frog2Dead)
      frog2Jump = 0.1;
    else
      frog2Jump = 0;
   }
  else
    frog2Jump -= 0.002;
  
  frog3Y += frog3Jump;
  if (frog3Y <= -0.7) {
    if (!frog3Dead)
      frog3Jump = 0.1;
    else
      frog3Jump = 0;
   }
  else
    frog3Jump -= 0.002;
  
  frog1Y += frog1Jump;
  if (frog1Y <= -0.7) {
    if (!frog1Dead)
      frog1Jump = 0.1;
    else
      frog1Jump = 0;
   }
  else
    frog1Jump -= 0.002;
  
  frog4Y += frog3Jump;
  if (frog4Y <= -0.7) {
    if (!frog4Dead)
      frog4Jump = 0.1;
    else
      frog4Jump = 0;
   }
  else
    frog4Jump -= 0.002;
  
  //------------------------
  //Draw Encounter 1
  //Tree
  pushMatrix();
  translate(0,-0.5,3);
  scale(0.4,0.4,0.3);
  drawCube(bark,cork);
  popMatrix();
  //------------------------
  //Draw Encounter 2
  //Tree 1
  pushMatrix();
  translate(-1,-0.5,15);
  scale(0.3,0.9,0.3);
  drawCube(bark,cork);
  popMatrix();
  
  //Tree 2
  pushMatrix();
  translate(1,-0.5,15);
  scale(0.3,0.6,0.3);
  drawCube(bark,cork);
  popMatrix();  
//------------------------  
  //Draw Encounter 3
  //Tree 1
  pushMatrix();
  translate(1,-0.5,27);
  scale(0.4,0.6,0.3);
  drawCube(bark,cork);
  popMatrix();
  
  //Tree 2
  pushMatrix();
  translate(0,-0.5,27);
  scale(0.4,0.6,0.3);
  drawCube(bark,cork);
  popMatrix();
  
  //Tree 3
  pushMatrix();
  translate(0,-0.5,30);
  scale(0.4,0.9,0.3);
  drawCube(bark,cork);
  popMatrix();
  
  //Tree 4
  pushMatrix();
  translate(-1,-0.5,30);
  scale(0.4,0.9,0.3);
  drawCube(bark,cork);
  popMatrix();    
//------------------------  
  //Draw Encounter 4
  //Water
  pushMatrix();
  translate(0,-0.75,40);
  scale(1.98,0.01,0.6);
  drawCube(water,water);
  popMatrix();  
//------------------------  
  //Draw Encounter 5
  //Frog
  pushMatrix();
  translate(0,frog1Y,52);
  if (frog1Dead){
    rotateX(180);
  }
  rotateZ(radians(90));
  rotateY(radians(90));
  scale(0.12,0.12,0.12);
  shape(frog);
  popMatrix();
//------------------------  
  //Draw Encounter 6
  //Water
  pushMatrix();
  translate(0,-0.75,64);
  scale(1.98,0.01,1.3);
  drawCube(water,water);
  popMatrix();  
  
  //Frog
  pushMatrix();
  translate(-1.3,frog2Y,64);
  if (frog2Dead){
    rotateX(180);
  }
  rotateZ(radians(90));
  rotateY(radians(90));
  scale(0.12,0.12,0.12);
  shape(frog);
  popMatrix();
//------------------------  
  //Draw Encounter 7
  //Tree 1
  pushMatrix();
  translate(0,-0.5,75);
  scale(0.4,0.8,0.3);
  drawCube(bark,cork);
  popMatrix();
  
  //Tree 2
  pushMatrix();
  translate(-1,-0.5,77);
  scale(0.4,1.4,0.3);
  drawCube(bark,cork);
  popMatrix();
  
  //Tree 3
  pushMatrix();
  translate(1,-0.5,77);
  scale(0.4,1.4,0.3);
  drawCube(bark,cork);
  popMatrix();
  
  //Water
  pushMatrix();
  translate(0,-0.75,80);
  scale(1.98,0.01,1.3);
  drawCube(water,water);
  popMatrix();  
  
  //Frog 1
  pushMatrix();
  translate(1.3,frog3Y,80);
  if (frog3Dead){
    rotateX(180);
  }
  rotateZ(radians(90));
  rotateY(radians(90));
  scale(0.12,0.12,0.12);
  shape(frog);
  popMatrix();
  
  //Frog 2
  pushMatrix();
  translate(-1.3,frog4Y,80);
  if (frog4Dead){
    rotateX(180);
  }
  rotateZ(radians(90));
  rotateY(radians(90));
  scale(0.12,0.12,0.12);
  shape(frog);
  popMatrix();    
//------------------------  
  //Draw Encounter 8
  //Giant Duck
  pushMatrix();
  translate(0,0,87);
  rotateY(radians(90));
  scale(1.2,1.2,1.2);
  shape(duck);
  popMatrix();   
//------------------------    
  
  for (Rotator r: rotators) {
    r.update(1);
  }
}

void drawCube(PImage sideTex, PImage topTex) {
  noStroke();
 
  //Front
  beginShape(QUADS);
  texture(sideTex);
  vertex(-1, -1, 1, 0, 1);
  vertex(1, -1, 1, 1, 1);
  vertex( 1, 1, 1 , 1, 0);
  vertex(-1, 1, 1 , 0, 0);
  endShape();
  
  //Rear
  beginShape(QUADS);
  texture(sideTex);
  vertex(1, -1, -1, 0, 1);
  vertex(-1, -1, -1, 1, 1);
  vertex(-1, 1, -1 , 1, 0);
  vertex(1, 1, -1, 0, 0);
  endShape();
  
  //Left
  beginShape(QUADS);
  texture(sideTex);
  vertex( -1, -1, -1, 0, 1);
  vertex( -1, -1, 1 , 1, 1);
  vertex( -1, 1, 1 , 1, 0);
  vertex( -1, 1, -1 , 0, 0);
  endShape();
  
  //Right
  beginShape(QUADS);
  texture(sideTex);
  vertex(1, -1, 1, 0, 1);
  vertex( 1, -1, -1, 1, 1);
  vertex( 1, 1, -1 , 1, 0);
  vertex(1, 1, 1, 0, 0);
  endShape();
  
  //Top
  beginShape(QUADS);
  texture(topTex);
  vertex(-1, 1, 1, 0, 1);
  vertex( 1, 1, 1, 1, 1);
  vertex( 1, 1, -1 , 1, 0);
  vertex(-1, 1, -1, 0, 0);
  endShape();
  
  //Bottom
  beginShape(QUADS);
  texture(topTex);
  vertex(-1, -1, -1, 0, 1);
  vertex( 1, -1, -1, 1, 1);
  vertex( 1, -1, 1 , 1, 0);
  vertex(-1, -1, 1, 0, 0);
  endShape();  
  
  //For Reference
  //float[][] verts = {
  //    { -1, -1, -1},  // 0 llr
  //    { -1, -1, 1 },  // 1 llf
  //    { -1, 1, -1},  // 2 lur
  //    { -1, 1, 1 },  // 3 luf
  //    { 1, -1, -1 },  // 4 rlr
  //    { 1, -1, 1 },  // 5 rlf
  //    { 1, 1, -1 },  // 6 rur
  //    { 1, 1, 1 }     // 7 ruf
  //};
  
  //int[][] sides = {
  //    { 1, 5, 7, 3 }, // front
  //    { 4, 0, 2, 6 }, // rear
  //    { 0, 1, 3, 2 }, // left
  //    { 5, 4, 6, 7 }, // right
  //};
  
  //int[][] tops = {
  //    { 3, 7, 6, 2 }, // top
  //    { 0, 4, 5, 1 }, // bottom
  //};  
  
}

void keyPressed() {
  //JUMP
  if (key == ' ') {
    if (!jumping) {
      jumpSpeed = 0.15;
      moving = true;
      jumping = true;
    }
  }
  
  //CAMERA
  if (key == ENTER) {
      thirdPerson = !thirdPerson;
  }
  
  //CHANGE SCENE
  if (key == 'q') {
      night = !night;
  }  
  
  //SIDESTEP
  if (key == 'a'){
    if (robotX >= 0){
      robotX -= 1;
    }
  }
  
  if (key == 'd'){
    if (robotX <= 0){
      robotX += 1;
    }
  }  
}

void mouseDragged(){
    float x = 2.0 * mouseX / width - 1;
    float y = 2.0 * (height-mouseY+1) / height - 1;       
    if (!thirdPerson){
      if (x>-1 && x<=1)
        freeLookX = 2.0 * mouseX / width - 1;
      if (y>-1 && y<=1)  
        freeLookY = 2.0 * (height-mouseY+1) / height - 1;        
    }
}

void mouseReleased(){
  if (!thirdPerson){
    freeLookX = 0;
    freeLookY = 0;
  }
}

class Face {
  private int[] indices;
  private float[] colour;

  public Face(int[] indices, float[] colour) {
    this.indices = new int[indices.length];
    this.colour = new float[colour.length];
    System.arraycopy(indices, 0, this.indices, 0, indices.length);
    System.arraycopy(colour, 0, this.colour, 0, colour.length);
  }

  public void draw(ArrayList<float[]> vertices, boolean useColour) {
    if (useColour) {
      if (colour.length == 3)
        fill(colour[0], colour[1], colour[2]);
      else
        fill(colour[0], colour[1], colour[2], colour[3]);
    }

    if (indices.length == 1) {
      beginShape(POINTS);
    } else if (indices.length == 2) {
      beginShape(LINES);
    } else if (indices.length == 3) {
      beginShape(TRIANGLES);
    } else if (indices.length == 4) {
      beginShape(QUADS);
    } else {
      beginShape(POLYGON);
    }

    for (int i: indices) {
      vertex(vertices.get(i)[0], vertices.get(i)[1], vertices.get(i)[2]);
    }

    endShape();
  }
}

class Shape {
  // set this to NULL if you don't want outlines
  public float[] line_colour;

  protected ArrayList<float[]> vertices;
  protected ArrayList<Face> faces;
  
  private float[] scale;
  private Rotator rotator;

  public Shape(float[] scale, Rotator rotator) {
    // you could subclass Shape and override this with your own
    init(scale, rotator);

    // default shape: cube
    vertices.add(new float[] { -1.0f, -1.0f, 1.0f });
    vertices.add(new float[] { 1.0f, -1.0f, 1.0f });
    vertices.add(new float[] { 1.0f, 1.0f, 1.0f });
    vertices.add(new float[] { -1.0f, 1.0f, 1.0f });
    vertices.add(new float[] { -1.0f, -1.0f, -1.0f });
    vertices.add(new float[] { 1.0f, -1.0f, -1.0f });
    vertices.add(new float[] { 1.0f, 1.0f, -1.0f });
    vertices.add(new float[] { -1.0f, 1.0f, -1.0f });

    faces.add(new Face(new int[] { 0, 1, 2, 3 }, new float[] { 1.0f, 0.0f, 0.0f } ));
    faces.add(new Face(new int[] { 0, 3, 7, 4 }, new float[] { 1.0f, 1.0f, 0.0f } ));
    faces.add(new Face(new int[] { 7, 6, 5, 4 }, new float[] { 1.0f, 0.0f, 1.0f } ));
    faces.add(new Face(new int[] { 2, 1, 5, 6 }, new float[] { 0.0f, 1.0f, 0.0f } ));
    faces.add(new Face(new int[] { 3, 2, 6, 7 }, new float[] { 0.0f, 0.0f, 1.0f } ));
    faces.add(new Face(new int[] { 1, 0, 4, 5 }, new float[] { 0.0f, 1.0f, 1.0f } ));
  }

  public Shape(String filename, float[] scale, Rotator rotator) {
    init(scale, rotator);

    // TODO Use as you like
    // NOTE that there is limited error checking, to make this as flexible as possible
    BufferedReader input;
    String line;
    String[] tokens;

    float[] vertex;
    float[] colour;
    String specifyingMaterial = null;
    String selectedMaterial;
    int[] face;

    HashMap<String, float[]> materials = new HashMap<String, float[]>();
    materials.put("default", new float[] {0.5,0.5,0.5});
    selectedMaterial = "default";

    // vertex positions start at 1
    vertices.add(new float[] {0,0,0});

    int currentColourIndex = 0;

    // these are for error checking (which you don't need to do)
    int lineCount = 0;
    int vertexCount = 0, colourCount = 0, faceCount = 0;

    try {
      input = new BufferedReader(new FileReader(dataPath(filename)));

      line = input.readLine();
      while (line != null) {
        lineCount++;
        tokens = line.split("\\s+");

        if (tokens[0].equals("v")) {
          assert tokens.length == 4 : "Invalid vertex specification (line " + lineCount + "): " + line;

          vertex = new float[3];
          try {
            vertex[0] = Float.parseFloat(tokens[1]);
            vertex[1] = Float.parseFloat(tokens[2]);
            vertex[2] = Float.parseFloat(tokens[3]);
          } catch (NumberFormatException nfe) {
            assert false : "Invalid vertex coordinate (line " + lineCount + "): " + line;
          }

          System.out.printf("vertex %d: (%f, %f, %f)\n", vertexCount + 1, vertex[0], vertex[1], vertex[2]);
          vertices.add(vertex);

          vertexCount++;
        } else if (tokens[0].equals("newmtl")) {
          assert tokens.length == 2 : "Invalid material name (line " + lineCount + "): " + line;
          specifyingMaterial = tokens[1];
        } else if (tokens[0].equals("Kd")) {
          assert tokens.length == 4 : "Invalid colour specification (line " + lineCount + "): " + line;
          assert faceCount == 0 && currentColourIndex == 0 : "Unexpected (late) colour (line " + lineCount + "): " + line;

          colour = new float[3];
          try {
            colour[0] = Float.parseFloat(tokens[1]);
            colour[1] = Float.parseFloat(tokens[2]);
            colour[2] = Float.parseFloat(tokens[3]);
          } catch (NumberFormatException nfe) {
            assert false : "Invalid colour value (line " + lineCount + "): " + line;
          }
          for (float colourValue: colour) {
            assert colourValue >= 0.0f && colourValue <= 1.0f : "Colour value out of range (line " + lineCount + "): " + line;
          }

          if (specifyingMaterial == null) {
            System.out.printf("Error: no material name for colour %d: (%f %f %f)\n", colourCount + 1, colour[0], colour[1], colour[2]);
          } else {
            System.out.printf("material %s: (%f %f %f)\n", specifyingMaterial, colour[0], colour[1], colour[2]);
            materials.put(specifyingMaterial, colour);
          }

          colourCount++;
        } else if (tokens[0].equals("usemtl")) {
          assert tokens.length == 2 : "Invalid material selection (line " + lineCount + "): " + line;

          selectedMaterial = tokens[1];
        } else if (tokens[0].equals("f")) {
          assert tokens.length > 1 : "Invalid face specification (line " + lineCount + "): " + line;

          face = new int[tokens.length - 1];
          try {
            for (int i = 1; i < tokens.length; i++) {
              face[i - 1] = Integer.parseInt(tokens[i].split("/")[0]);
            }
          } catch (NumberFormatException nfe) {
            assert false : "Invalid vertex index (line " + lineCount + "): " + line;
          }

          System.out.printf("face %d: [ ", faceCount + 1);
          for (int index: face) {
            System.out.printf("%d ", index);
          }
          System.out.printf("] using material %s\n", selectedMaterial);

          colour = materials.get(selectedMaterial);
          if (colour == null) {
            System.out.println("Error: material " + selectedMaterial + " not found, using default.");
            colour = materials.get("default");
          }
          faces.add(new Face(face, colour));

          faceCount++;
        } else {
          System.out.println("Ignoring: " + line);
        }

        line = input.readLine();
      }
    } catch (IOException ioe) {
      System.out.println(ioe.getMessage());
      assert false : "Error reading input file " + filename;
    }
  }

  protected void init(float[] scale, Rotator rotator) {
    vertices = new ArrayList<float[]>();
    faces = new ArrayList<Face>();

    line_colour = new float[] { 1,1,1 };
    if (null == scale) {
      this.scale = new float[] { 1,1,1 };
    } else {
      this.scale = new float[] { scale[0], scale[1], scale[2] };
    }
    
    this.rotator = rotator;
  }

  public void rotate() {
    if (rotator != null) {
      translate(rotator.origin[0], rotator.origin[1], rotator.origin[2]);
      if (rotator.axis[0] > 0)
        rotateX(radians(rotator.angle));
      else if (rotator.axis[1] > 0)
        rotateY(radians(rotator.angle));
      else
        rotateZ(radians(rotator.angle));
      translate(-rotator.origin[0], -rotator.origin[1], -rotator.origin[2]);
    }
  }
  
  public void draw() {
    pushMatrix();
    scale(scale[0], scale[1], scale[2]);
    if (rotator != null && rotator.orientation != null) {
      rotateX(radians(rotator.orientation[0]));
      rotateY(radians(rotator.orientation[1]));
      rotateZ(radians(rotator.orientation[2]));
    }
    for (Face f: faces) {
      if (line_colour == null) {
        noStroke();
        f.draw(vertices, true);
      } else {
        stroke(line_colour[0], line_colour[1], line_colour[2]);
        f.draw(vertices, true);
      }
    }
    popMatrix();
  }
}

class Structure extends Shape {
  // this array can include other structures...
  private Shape[] contents;
  private float[][] positions;

  public Structure(Shape[] contents, float[][] positions, float[] scale, Rotator rotator) {
    super(scale, rotator);
    init(contents, positions);
  }

  public Structure(String filename, Shape[] contents, float[][] positions, float[] scale, Rotator rotator) {
    super(filename, scale, rotator);
    init(contents, positions);
  }

  private void init(Shape[] contents, float[][] positions) {
    this.contents = new Shape[contents.length];
    this.positions = new float[positions.length][3];
    System.arraycopy(contents, 0, this.contents, 0, contents.length);
    for (int i = 0; i < positions.length; i++) {
      System.arraycopy(positions[i], 0, this.positions[i], 0, 3);
    }
  }

  public void draw() {
    super.draw();
    for (int i = 0; i < contents.length; i++) {
      pushMatrix();
      translate(positions[i][0], positions[i][1], positions[i][2]);
      contents[i].rotate();
      contents[i].draw();
      popMatrix();
    }
  }
}

class Rotator {
  public float[] orientation;
  public float[] origin;
  public float[] axis;
  public float angle, startAngle, endAngle, vAngle;
  boolean up;
  
  public Rotator(float[] orientation, float[] origin, float[] axis, float angle, float startAngle, float endAngle, float vAngle) {
    this.orientation = new float[] {orientation[0], orientation[1], orientation[2]};
    this.origin = new float[] {origin[0], origin[1], origin[2]};
    this.axis = new float[] {axis[0], axis[1], axis[2]};
    this.angle = angle;
    this.startAngle = startAngle;
    this.endAngle = endAngle;
    this.vAngle = vAngle;
    this.up = true;
  }
  
  public void update(float elapsed) {
    if (up) {
      angle += elapsed * vAngle;
      if (angle > endAngle) {
        angle = endAngle - Math.abs(angle - endAngle);
        up = false;
      }
    } else {
      angle -= elapsed * vAngle;
      if (angle < startAngle) {
        angle = startAngle + Math.abs(angle - startAngle);
        up = true;
      }
    }
  }
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, -0.001, -0.001);
    velocity = new PVector(random(-0.05, 0.05), random(-0.01, 0), random(-0.01, 0.01));
    position = l.copy();
    lifespan = 600;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, 255, 255, lifespan);
    ellipse(position.x, position.y, random(0, 0.03),random(0, 0.03));
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
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
}
