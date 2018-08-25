import mqtt.*;
import toxi.geom.*;
import toxi.processing.*;

MQTTClient client;
ToxiclibsSupport gfx;

String r2b2Id = "3291342516";

String MQTTServer = "192.168.82.106";

boolean forward = false;
boolean backward = false;
boolean right = false;
boolean left = false;
boolean up = false;
boolean down = false;
boolean rotXP = false;
boolean rotXN = false;

boolean inMoveH = false;
boolean inMoveV = false;

int power = 100;
int interval = 0;

///////////////////////GRAPHIC//////////////////
char[] teapotPacket = new char[14];
float[] q = new float[4];
Quaternion quat = new Quaternion(1, 0, 0, 0);
////////////////////////////////////////////////

PFont f;
String console[] = new String[10]; 
boolean overRST = false;
boolean overPING = false;
boolean overGyrAcc = false;
boolean overTEMP = false;
boolean overCLBT = false;
boolean overSTOP = false;
boolean overPWRUP = false;
boolean overPWRDW = false;

void setup() {
  size(displayWidth, displayHeight, P3D);
  orientation(LANDSCAPE);
  
  for (int i=0; i<10; i++){
    console[i] = "";
  }
    
  gfx = new ToxiclibsSupport(this);
  
  client = new MQTTClient(this);
  client.connect("mqtt://" + MQTTServer, "Pro-" + r2b2Id);
  client.subscribe("r2b2/" + r2b2Id + "/#");  
  f = createFont("Arial",16,true);  
}

void draw() {
  if (millis() - interval > 300) {
        client.publish("r2b2/" + r2b2Id + "/tasks", "getGyrAcc");
        ping();
        interval = millis();
  } 
  
  if (forward & !backward) {
    inMoveH = true;
    if (left) {
      client.publish("r2b2/" + r2b2Id + "/tasks", "mRF " + power);
      client.publish("r2b2/" + r2b2Id + "/tasks", "mLB " + power);
    }
    else if (right) {
      client.publish("r2b2/" + r2b2Id + "/tasks", "mLF " + power);
      client.publish("r2b2/" + r2b2Id + "/tasks", "mRB " + power);
    }
    else {
      client.publish("r2b2/" + r2b2Id + "/tasks", "mRF " + power);
      client.publish("r2b2/" + r2b2Id + "/tasks", "mLF " + power);
    }
  }
  else if (!forward & backward) {
    inMoveH = true;
    if (left) {
      client.publish("r2b2/" + r2b2Id + "/tasks", "mRB " + power);
      client.publish("r2b2/" + r2b2Id + "/tasks", "mLF " + power);
    }
    else if (right) {
      client.publish("r2b2/" + r2b2Id + "/tasks", "mLB " + power);
      client.publish("r2b2/" + r2b2Id + "/tasks", "mRF " + power);
    }
    else {
      client.publish("r2b2/" + r2b2Id + "/tasks", "mRB " + power);
      client.publish("r2b2/" + r2b2Id + "/tasks", "mLB " + power);
    }
  }
  else if (!forward & !backward & inMoveH) {
    client.publish("r2b2/" + r2b2Id + "/tasks", "mRS");
    client.publish("r2b2/" + r2b2Id + "/tasks", "mLS");
    inMoveH = false;
  }
  
  if (up) {
    inMoveV = true;
    client.publish("r2b2/" + r2b2Id + "/tasks", "mBF " + power);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mFF " + power);
  }
  else if (down) {
    inMoveV = true;
    client.publish("r2b2/" + r2b2Id + "/tasks", "mBB " + power);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mFB " + power);
  }
  else if (rotXP) {
    inMoveV = true;
    client.publish("r2b2/" + r2b2Id + "/tasks", "mBB " + power);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mFF " + power);
  }
  else if (rotXN){
    inMoveV = true;
    client.publish("r2b2/" + r2b2Id + "/tasks", "mBF " + power);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mFB " + power);
  }
  else if (!up & !down & !rotXP & !rotXN & inMoveV) {
    client.publish("r2b2/" + r2b2Id + "/tasks", "mBS");
    client.publish("r2b2/" + r2b2Id + "/tasks", "mFS");
    inMoveV = false;
  }
  
  /////////////GRAPHIC///////////////////
  
  up = false;
  down = false;
  rotXP = false;
  rotXN = false;
  forward = false;
  backward = false;
  right = false;
  left = false;
      
  if (touches.length == 0){
      overRST = false;
      overPING = false;
      overGyrAcc = false;
      overTEMP = false;
      overCLBT = false;
      overSTOP = false;
      overPWRUP = false;
      overPWRDW = false;
  }
  else {     
      for (int i = 0; i < touches.length; i++) {
          if( touches[i].x > 0 && touches[i].x < 100 && touches[i].y > height-50 && touches[i].y < height) {
            if (!overSTOP) stopMotors();
            overSTOP = true;
          }
          else overSTOP = false;
          
          if( touches[i].x > 100 && touches[i].x < 200 && touches[i].y > height-50 && touches[i].y < height) {
            if (!overCLBT) calibrate();
            overCLBT = true;      
          }
          else overCLBT = false;
          
          if( touches[i].x > 200 && touches[i].x <300 && touches[i].y > height-50 && touches[i].y < height) {
            if (!overTEMP) getTemp();
            overTEMP = true; 
          }
          else overTEMP = false;
          
          if( touches[i].x > 300 && touches[i].x < 400 && touches[i].y > height-50 && touches[i].y < height) {
            if (!overGyrAcc) getGyrAcc();
            overGyrAcc = true;
          }
          else overGyrAcc = false;
          
          if( touches[i].x > 400 && touches[i].x < 500 && touches[i].y > height-50 && touches[i].y < height) {
            if (!overPING) ping();
            overPING = true;
          }
          else overPING = false;
          
          if( touches[i].x > 500 && touches[i].x < 600 && touches[i].y > height-50 && touches[i].y < height)  {
            if (!overRST) testMotor();
            overRST = true;
          }
          else overRST = false;
          
          if( touches[i].x > 10 && touches[i].x < 60 && touches[i].y > 50 && touches[i].y < 90) {
            if (!overPWRUP) powerUP();
            overPWRUP = true;
          }
          else overPWRUP = false;
          
          if( touches[i].x > 10 && touches[i].x < 60 && touches[i].y > 90 && touches[i].y < 140) {
            if (!overPWRDW) powerDOWN();
            overPWRDW = true;
          }
          else overPWRDW = false;
          
          if( touches[i].x > 10 && touches[i].x < 110 && touches[i].y > 200 && touches[i].y < 300) up = true; 
          if( touches[i].x > 10 && touches[i].x < 110 && touches[i].y > 310 && touches[i].y < 410) down = true;
          if( touches[i].x > 120 && touches[i].x < 220 && touches[i].y > 200 && touches[i].y < 300) rotXP = true;
          if( touches[i].x > 120 && touches[i].x < 220 && touches[i].y > 310 && touches[i].y < 410) rotXN = true;
          if( touches[i].x > width - 330 && touches[i].x < width - 230 && touches[i].y > 200 && touches[i].y < 300) { forward = true; right = true; } 
          if( touches[i].x > width - 330 && touches[i].x < width - 230 && touches[i].y > 310 && touches[i].y < 410) { backward = true; right = true; }
          if( touches[i].x > width - 220 && touches[i].x < width - 120 && touches[i].y > 200 && touches[i].y < 300) forward = true;
          if( touches[i].x > width - 220 && touches[i].x < width - 120 && touches[i].y > 310 && touches[i].y < 410) backward = true;
          if( touches[i].x > width - 110 && touches[i].x < width - 10 && touches[i].y > 200 && touches[i].y < 300) { forward = true; left=true; }
          if( touches[i].x > width - 110 && touches[i].x < width - 10 && touches[i].y > 310 && touches[i].y < 410) { backward = true; left=true; }
          
      }
  }
  
  background(0);
  
  textFont(f,16);                  
  fill(255);                         
  text("R2B2-NANO Control v0.1",10,20);
  text("Motor Power:" + power,10,40);
  
  rect(0, height-250, width, 250);

  fill(255);
  stroke(200,200,200);
  if (overSTOP) fill(150,150,150);
  rect(0, height-50, 100, 50);
  fill(255);
  if (overCLBT) fill(150,150,150);
  rect(100, height-50, 100, 50);
  fill(255);
  if (overTEMP) fill(150,150,150);
  rect(200, height-50, 100, 50);
  fill(255);
  if (overGyrAcc) fill(150,150,150);
  rect(300, height-50, 100, 50);
  fill(255);
  if (overPING) fill(150,150,150);
  rect(400, height-50, 100, 50);
  fill(255);
  if (overRST) fill(150,150,150);
  rect(500, height-50, 100, 50);
  fill(255);
  
  fill(255,0,0);
  text(console[0],10,height-230);
  text(console[1],10,height-210);
  text(console[2],10,height-190);
  text(console[3],10,height-170);
  text(console[4],10,height-150);
  text(console[5],10,height-130);
  text(console[6],10,height-110);
  text(console[7],10,height-90);
  text(console[8],10,height-70);
  
  fill(255);
  if (overPWRUP) fill(150,150,150);
  rect(10, 50, 50, 40);
  fill(255);
  if (overPWRDW) fill(150,150,150);
  rect(10, 90, 50, 40);
  fill(255);
  if (up) fill(150,150,150);
  rect(10, 200, 100, 100);
  fill(255);
  if (down) fill(150,150,150);
  rect(10, 310, 100, 100);
  fill(255);
  if (rotXP) fill(150,150,150);
  rect(120, 200, 100, 100);
  fill(255);
  if (rotXN) fill(150,150,150);
  rect(120, 310, 100, 100);
  fill(255);
  
  if (forward && right) fill(150,150,150);
  rect(width - 330, 200, 100, 100);
  fill(255);
  if (backward && right) fill(150,150,150);
  rect(width - 330, 310, 100, 100);
  fill(255);
  if (forward) fill(150,150,150);
  rect(width - 220, 200, 100, 100);
  fill(255);
  if (backward) fill(150,150,150);
  rect(width - 220, 310, 100, 100);
  fill(255);
  if (forward && left) fill(150,150,150);
  rect(width - 110, 200, 100, 100);
  fill(255);
  if (backward && left) fill(150,150,150);
  rect(width - 110, 310, 100, 100);
  fill(255);
  
  fill(0);
  text("STOP(r)",25,height-20);
  text("CLBT(c)",125,height-20);
  text("TEMP(t)",225,height-20);
  text("GyrAcc(g)",315,height-20);
  text("PING(p)",425,height-20);
  text("RST(-)",525,height-20);
  text("P+(q)",15,75);
  text("P-(a)",15,115);
  
  text("UP",15,250);
  text("DW",15,350);
  text("R+",125,250);
  text("R-",125,350);
  
  text("FL",width - 315,250);
  text("BL",width - 315,350);
  text("FW",width - 205,250);
  text("BW",width - 205,350);
  text("FR",width - 95,250);
  text("BR",width - 95,350);
  
  stroke(0);
  pushMatrix();
  translate(width / 2, height / 3 + 50);
  scale(3);
  
  float[] axis = quat.toAxisAngle();
  rotateZ(axis[0]);
  rotateX(axis[1]*2+0.3);

  // draw main body in red
  fill(255, 0, 0, 200);
  box(10, 10, 200);
  
  // draw front-facing tip in blue
  fill(0, 0, 255, 200);
  pushMatrix();
  translate(0, 0, -120);
  rotateX(PI/2);
  drawCylinder(0, 10, 20, 8);
  popMatrix();
  
  // draw wings and tail fin in green
  
  pushMatrix();
  if (up | rotXN) fill(0, 255, 0, 200);
  else if  (down | rotXP) fill(255, 0, 0, 200);
  else fill(255, 255, 0, 200);
  translate(0, 0, -65); drawCylinder(15, 15, 34, 20);
  popMatrix();
  
  pushMatrix();
  if (up | rotXP) fill(0, 255, 0, 200);
  else if  (down | rotXN) fill(255, 0, 0, 200);
  else fill(255, 255, 0, 200);
  translate(0, 0, 65); drawCylinder(15, 15, 34, 20);
  popMatrix();
  
  pushMatrix();
  if (forward & !left | forward & right | backward & left) fill(0, 255, 0, 200);
  else if  (forward & left & !right | backward & right | backward & !left) fill(255, 0, 0, 200);
  else fill(255, 255, 0, 200);
  translate(-46, 17, 0);rotateX(PI/2); drawCylinder(15, 15, 34, 20);
  popMatrix();
  
  pushMatrix();
  if (forward & !right | forward & left | backward & right) fill(0, 255, 0, 200);
  else if  (forward & !left & right | backward & left | backward & !right) fill(255, 0, 0, 200);
  else fill(255, 255, 0, 200);
  translate(46, 17, 0);rotateX(PI/2); drawCylinder(15, 15, 34, 20);
  popMatrix();
  
  fill(255, 255, 0, 200);
  beginShape(QUADS);
  vertex(-35,0,-50); vertex(35,0,-50); vertex(35,0,50); vertex(-35,0,50);
  vertex(-35,12,-50); vertex(35,12,-50); vertex(35,12,50); vertex(-35,12,50);
  vertex(-35,0,-50); vertex(-35,12,-50); vertex(35,12,-50); vertex(35,0,-50);
  vertex(-35,0,50); vertex(-35,12,50); vertex(35,12,50); vertex(35,0,50);
  vertex(-35,0,50); vertex(-35,12,50); vertex(-35,12,-50); vertex(-35,0,-50);
  vertex(35,0,50); vertex(35,12,50); vertex(35,12,-50); vertex(35,0,-50);
  vertex(-30,12,-45); vertex(30,12,-45); vertex(30,12,45); vertex(-30,12,45);
  vertex(-30,24,-45); vertex(30,24,-45); vertex(30,24,45); vertex(-30,24,45);
  vertex(-30,12,-45); vertex(-30,24,-45); vertex(30,24,-45); vertex(30,12,-45);
  vertex(-30,12,45); vertex(-30,24,45); vertex(30,24,45); vertex(30,12,45);
  vertex(-30,12,45); vertex(-30,24,45); vertex(-30,24,-45); vertex(-30,12,-45);
  vertex(30,12,45); vertex(30,24,45); vertex(30,24,-45); vertex(30,12,-45);
  endShape();
 
  
  popMatrix();
  ////////////////////////////////////////////////////////////
}

void keyPressed() { 
  if (keyCode == 37) right = true;
  else if (keyCode == 38) forward = true;
  else if (keyCode == 39) left = true;
  else if (keyCode == 40) backward = true;
  else if (key == 'w') up = true;
  else if (key == 's') down = true;
  else if (key == 'e') rotXP = true;
  else if (key == 'd') rotXN = true;
  else if (key == 'r') stopMotors();
  else if (key == 'c') calibrate();
  else if (key == 'p') ping();
  else if (key == 'g') getGyrAcc();
  else if (key == 't') getTemp();
  else if (key == 'q') powerUP();
  else if (key == 'a') powerDOWN();
  else if (keyCode == 49) client.publish("r2b2/" + r2b2Id + "/tasks", "mRF " + power);
  else if (keyCode == 50) client.publish("r2b2/" + r2b2Id + "/tasks", "mLF " + power);
  else if (keyCode == 51) client.publish("r2b2/" + r2b2Id + "/tasks", "mFF " + power);
  else if (keyCode == 52) client.publish("r2b2/" + r2b2Id + "/tasks", "mBF " + power);
  else if (keyCode == 55) client.publish("r2b2/" + r2b2Id + "/tasks", "mRB " + power);
  else if (keyCode == 56) client.publish("r2b2/" + r2b2Id + "/tasks", "mLB " + power);
  else if (keyCode == 57) client.publish("r2b2/" + r2b2Id + "/tasks", "mFB " + power);
  else if (keyCode == 48) client.publish("r2b2/" + r2b2Id + "/tasks", "mBB " + power);
  
}

void keyReleased(){
  if (keyCode == 37) right = false;
  else if (keyCode == 38) forward = false;
  else if (keyCode == 39) left = false;
  else if (keyCode == 40) backward = false;
  else if (key == 'w') up = false;
  else if (key == 's') down = false;
  else if (key == 'e') rotXP = false;
  else if (key == 'd') rotXN = false;
}

//void mousePressed() {
//  if (overPWRUP) powerUP();
//  if (overPWRDW) powerDOWN();
//  if (overSTOP) stopMotors();
//  if (overCLBT) calibrate();
//  if (overPING) ping();
//  if (overGyrAcc) getGyrAcc();
//  if (overTEMP) getTemp();  
//}

void powerUP(){
  power = power + 10;
}

void powerDOWN(){
  power = power - 10;
}

void stopMotors(){
  client.publish("r2b2/" + r2b2Id + "/tasks", "stop");
} 

void calibrate() {
  client.publish("r2b2/" + r2b2Id + "/tasks", "calibrate");
}

void ping() {
  client.publish("r2b2/" + r2b2Id + "/tasks", "ping");
}

void getGyrAcc(){
  client.publish("r2b2/" + r2b2Id + "/tasks", "getGyrAcc");
}

void getTemp(){
  client.publish("r2b2/" + r2b2Id + "/tasks", "getTemp");
}

void testMotor(){
  for (int j=0;j<100;j=j+2){
    client.publish("r2b2/" + r2b2Id + "/tasks", "mBB " + j);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mFB " + j);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mRB " + j);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mLB " + j);
    delay(100);
  }
  for (int j=100;j>0;j=j-2){
    client.publish("r2b2/" + r2b2Id + "/tasks", "mBB " + j);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mFB " + j);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mRB " + j);
    client.publish("r2b2/" + r2b2Id + "/tasks", "mLB " + j);
    delay(100);
  }
  client.publish("r2b2/" + r2b2Id + "/tasks", "stop");  
}

void messageReceived(String topic, byte[] payload) {
  String missatge = new String(payload);
  //if (!topic.substring(topic.length()-3, topic.length()).equals("mpu") && !missatge.equals("getGyrAcc")) pushMessage(topic + " : " + missatge);
  if (topic.substring(topic.length()-3, topic.length()).equals("tmp")) pushMessage(topic + " : " + missatge);
  else if (topic.substring(topic.length()-4, topic.length()).equals("info")) pushMessage(topic + " : " + missatge);
  
  if (topic.substring(topic.length()-3, topic.length()).equals("mpu")) 
  {
    int p1 = missatge.indexOf(" ");
    int p2 = missatge.indexOf(" ", p1+1);
    int p3 = missatge.indexOf(" ", p2+1);
    int p4;
    if (missatge.indexOf(" ", p3+1) < 0) p4 = missatge.length();
    else p4 = missatge.indexOf(" ", p3+1);
    
    q[0] = (float(missatge.substring(0   ,p1)) / 2.0f ) / 16384.0f;
    q[1] = (float(missatge.substring(p1+1,p2)) / 2.0f ) / 16384.0f;
    q[2] = (float(missatge.substring(p2+1,p3)) / 2.0f ) / 16384.0f;
    q[3] = 0;
    quat.set(q[0], q[1], q[2], q[3]);
  }
}

void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {
    float angle = 0;
    float angleIncrement = TWO_PI / sides;
    beginShape(QUAD_STRIP);
    for (int i = 0; i < sides + 1; ++i) {
        vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
        vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
        angle += angleIncrement;
    }
    endShape();
    
    if (topRadius != 0) {
        angle = 0;
        beginShape(TRIANGLE_FAN);
        
        vertex(0, 0, 0);
        for (int i = 0; i < sides + 1; i++) {
            vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
            angle += angleIncrement;
        }
        endShape();
    }
  
    if (bottomRadius != 0) {
        angle = 0;
        beginShape(TRIANGLE_FAN);
    
        vertex(0, tall, 0);
        for (int i = 0; i < sides + 1; i++) {
            vertex(bottomRadius * cos(angle), tall, bottomRadius * sin(angle));
            angle += angleIncrement;
        }
        endShape();
    }
}

void pushMessage(String missatge){
  for (int i=9; i>0; i--){
    console[i] = console[i-1];
  }
  console[0] = missatge;
}
