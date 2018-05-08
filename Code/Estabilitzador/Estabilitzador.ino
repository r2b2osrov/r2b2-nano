#define BLYNK_PRINT Serial

#define BLYNK_USE_DIRECT_CONNECT

#include <BlynkSimpleEsp32_BLE.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include<Wire.h>

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "5629041522ee44dca545ccafec01f47e";
WidgetTerminal terminal(V3);

const int MPU_addr=0x68; // I2C address of the MPU-6050
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;

int freq = 2000;
int ledChannelE_F = 0;
int ledChannelD_F = 1;
int ledChannelP_F = 2;
int ledChannelF_F = 3;
int ledChannelE_B = 4;
int ledChannelD_B = 5;
int ledChannelP_B = 6;
int ledChannelF_B = 7;
int resolution = 8;

const int motorD_F = 27;
const int motorD_B = 19;
const int motorE_F = 26;
const int motorE_B = 17;
const int motorP_F = 5;
const int motorP_B = 18;
const int motorF_F = 25;
const int motorF_B = 16;

int joystick_X = 512;
int joystick_Y = 512;

bool estabilitzador = false;
bool manual = false;
bool debug = false;

BLYNK_WRITE(V1) {
  int x = param[0].asInt();
  int y = param[1].asInt();
  joystick_X = x;
  joystick_Y = y;

  // Do something with x and y

  if (estabilitzador){
    if (y>512) {
      manual = true;
      ledcWrite(ledChannelD_F, 255);
      ledcWrite(ledChannelE_F, 255);
      ledcWrite(ledChannelD_B, 0);
      ledcWrite(ledChannelE_B, 0);
    } else if (y<512) {
      manual = true;
      ledcWrite(ledChannelD_F, 0);
      ledcWrite(ledChannelE_F, 0);
      ledcWrite(ledChannelD_B, 255);
      ledcWrite(ledChannelE_B, 255);
    } else {
      manual = false;
      ledcWrite(ledChannelD_F, 0);
      ledcWrite(ledChannelE_F, 0);
      ledcWrite(ledChannelD_B, 0);
      ledcWrite(ledChannelE_B, 0);
    }
  }
  else {
    if (y>512) {
      manual = true;
      ledcWrite(ledChannelF_F, 255);
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_B, 0);
      ledcWrite(ledChannelP_B, 0);
    } else if (y<512) {
      manual = true;
      ledcWrite(ledChannelF_F, 0);
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_B, 0);
      ledcWrite(ledChannelP_B, 255);
    } else {
      manual = false;
      ledcWrite(ledChannelF_F, 0);
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_B, 0);
      ledcWrite(ledChannelP_B, 0);
    }  
  }

  if (debug) {
    terminal.print("X = ");
    terminal.print(x);
    terminal.print("; Y = ");
    terminal.println(y);
    terminal.flush(); 
  }

}

BLYNK_WRITE(V3) {
  if (String("debug") == param.asStr()){
    debug = !debug;
    if (debug) terminal.println("Debug text enabled!");
    else terminal.println("Debug text disabled.");
  } 
  else if (String("gyro") == param.asStr()) {
    terminal.println("Gyroscope data:");
    terminal.println("===============");
    terminal.print("GyX = "); terminal.println(GyX);
    terminal.print("GyY = "); terminal.println(GyY);
    terminal.print("GyZ = "); terminal.println(GyZ);
  }
  else {
    terminal.println("Comanda no reconeguda!!!");  
  }
  terminal.flush();
}

BLYNK_WRITE(V2) {
  if (estabilitzador) {
    //UP
    if (param.asInt()) {
      manual = true;
      ledcWrite(ledChannelP_F, 255);
      ledcWrite(ledChannelF_F, 255);
      ledcWrite(ledChannelP_B, 0);
      ledcWrite(ledChannelF_B, 0);
    } else {
      manual = false;
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_F, 0);
      ledcWrite(ledChannelP_B, 0);
      ledcWrite(ledChannelF_B, 0);
    }    
  } else {
    //GAAAAS!
    if (param.asInt()) {
      manual = true;
      ledcWrite(ledChannelD_F, 255);
      ledcWrite(ledChannelE_F, 255);
      ledcWrite(ledChannelD_B, 0);
      ledcWrite(ledChannelE_B, 0);
    } else {
      manual = false;
      ledcWrite(ledChannelD_F, 0);
      ledcWrite(ledChannelE_F, 0);
      ledcWrite(ledChannelD_B, 0);
      ledcWrite(ledChannelE_B, 0);
    }
  }
}

BLYNK_WRITE(V4) {
  if (estabilitzador) {
    //DOWN!
    if (param.asInt()) {
      manual = true;
      ledcWrite(ledChannelP_B, 255);
      ledcWrite(ledChannelF_B, 255);
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_F, 0);
    } else {
      manual = false;
      ledcWrite(ledChannelP_B, 0);
      ledcWrite(ledChannelF_B, 0);
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_F, 0);
    }    
  } else {
    //BRAKE!!
    if (param.asInt()) {
      manual = true;
      ledcWrite(ledChannelD_B, 255);
      ledcWrite(ledChannelE_B, 255);
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_F, 0);
    } else {
      manual = false;
      ledcWrite(ledChannelD_B, 0);
      ledcWrite(ledChannelE_B, 0);
      ledcWrite(ledChannelP_F, 0);
      ledcWrite(ledChannelF_F, 0);
    }
  }
}

BLYNK_WRITE(V0) {
  estabilitzador = param.asInt();
  if (estabilitzador) {
    Blynk.setProperty(V2, "setlabel", "UP");
    Blynk.setProperty(V4, "setlabel", "DOWN");
  }
  else {
    Blynk.setProperty(V2, "setLabel", "ACCELERATE");
    Blynk.setProperty(V4, "setLabel", "BRAKE");
  }
}

void setup(){
  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B); // PWR_MGMT_1 register
  Wire.write(0); // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);

  Serial.begin(115200);
  Serial.println("Waiting for connections...");
  Blynk.begin(auth);

  ledcSetup(ledChannelE_F, freq, resolution);
  ledcSetup(ledChannelD_F, freq, resolution);
  ledcSetup(ledChannelP_F, freq, resolution);
  ledcSetup(ledChannelF_F, freq, resolution);
  ledcSetup(ledChannelE_B, freq, resolution);
  ledcSetup(ledChannelD_B, freq, resolution);
  ledcSetup(ledChannelP_B, freq, resolution);
  ledcSetup(ledChannelF_B, freq, resolution);

  ledcAttachPin(motorD_F, ledChannelD_F);
  ledcAttachPin(motorE_F, ledChannelE_F);
  ledcAttachPin(motorP_F, ledChannelP_F);
  ledcAttachPin(motorF_F, ledChannelF_F);
  ledcAttachPin(motorD_B, ledChannelD_B);
  ledcAttachPin(motorE_B, ledChannelE_B);
  ledcAttachPin(motorP_B, ledChannelP_B);
  ledcAttachPin(motorF_B, ledChannelF_B);

  ledcWrite(ledChannelP_F, 0);
  ledcWrite(ledChannelF_F, 0);
  ledcWrite(ledChannelE_F, 0); 
  ledcWrite(ledChannelD_F, 0);
  ledcWrite(ledChannelP_B, 0);
  ledcWrite(ledChannelF_B, 0);
  ledcWrite(ledChannelE_B, 0); 
  ledcWrite(ledChannelD_B, 0);
}

void loop(){
  Blynk.run();
  
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x3B); // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr,14,true); // request a total of 14 registers

//  AcX=Wire.read()<<8|Wire.read(); // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
//  AcY=Wire.read()<<8|Wire.read(); // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
//  AcZ=Wire.read()<<8|Wire.read(); // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
//  Tmp=Wire.read()<<8|Wire.read(); // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L
  GyX=Wire.read()<<8|Wire.read(); // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY=Wire.read()<<8|Wire.read(); // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ=Wire.read()<<8|Wire.read(); // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)

//  Serial.print("AcX = "); Serial.print(AcX);
//  Serial.print(" | AcY = "); Serial.print(AcY);
//  Serial.print(" | AcZ = "); Serial.print(AcZ);
//  Serial.print(" | Tmp = "); Serial.print(Tmp/340.00+36.53); //equation for temperature in degrees C from datasheet
//  Serial.print(" | GyX = "); Serial.print(GyX);
//  Serial.print(" | GyY = "); Serial.print(GyY);
//  Serial.print(" | GyZ = "); Serial.println(GyZ);

  if (estabilitzador & !manual) {   
    if (GyY<0) {
      ledcWrite(ledChannelP_F, 255);
      ledcWrite(ledChannelF_F, 0); 
      if (debug) { terminal.print(" M_POST_F = "); terminal.println(((-GyY*255)/16000)); }
    }
    else {
      ledcWrite(ledChannelF_F, 255);
      ledcWrite(ledChannelP_F, 0);
      if (debug) { terminal.print(" M_FRON_F = "); terminal.println(((GyY*255)/16000)); }
    }
    
    //terminal.flush(); 
  }

  if (!estabilitzador & !manual) {
    ledcWrite(ledChannelP_F, 0);
    ledcWrite(ledChannelF_F, 0);
    ledcWrite(ledChannelE_F, 0); 
    ledcWrite(ledChannelD_F, 0);
    ledcWrite(ledChannelP_B, 0);
    ledcWrite(ledChannelF_B, 0);
    ledcWrite(ledChannelE_B, 0); 
    ledcWrite(ledChannelD_B, 0);
  }

  delay(200);
}





