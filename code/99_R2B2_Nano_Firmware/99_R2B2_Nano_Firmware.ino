
//Title:         99_R2B2_Nano_Firmware.ino
//Description:   Arduino IDE program to control R2B2_Nano 
//Authors:       Pau Roura (@proura)
//Date:          20180610
//Version:       0.1
//Notes:         
//
//
//   ¡¡¡¡¡IN DEVELOPMENT!!!!
// ¡¡¡¡¡NOT YET FUNCTIONAL!!!!!
//
//

//#define BLYNK_PRINT Serial
//#define BLYNK_USE_DIRECT_CONNECT

//#include <BlynkSimpleEsp32_BLE.h>
//#include <BLEDevice.h>
//#include <BLEServer.h>
#include <Wire.h>
#include <WiFi.h>
#include <ESPmDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

//Configuration
//Wifi ssid and password
const char* ssid = "BuLan";
const char* password = "00009999";
//clock_int = delay in de loop
const int clock_int = 100;
//speed_s = from 0 to 255 PWM of Stabilization
const int speed_s = 100;
//offset_s is the º of AcY = from 0 to 90 that no activate Stabilization
const int AngY_Offset_s = 13;

//Uncomment to disable "Brownout detector was triggered"
//#include "soc/soc.h"
//#include "soc/rtc_cntl_reg.h"

//char auth[] = "5629041522ee44dca545ccafec01f47e";
//WidgetTerminal terminal(V3);

//I2C address of the MPU-6050 Gyro/Acc
const int MPU_addr=0x68; 
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;

int16_t AG_Data[100][7]; 

int freq = 2000;
int resolution = 8;
int MotorChannelR = 0;
int MotorChannelL = 1;
int MotorChannelF = 2;
int MotorChannelB = 3;

//Pins del motor Dret
const int motorR_IN1 = 25;
const int motorR_IN2 = 33;
const int motorR_PWM = 32;
//Pins del motor Esquerra
const int motorL_IN1 = 5;
const int motorL_IN2 = 18;
const int motorL_PWM = 19; 
//Pins del motor Frontal
const int motorF_IN1 = 26;
const int motorF_IN2 = 27;
const int motorF_PWM = 14;
//Pins del motor Posterior
const int motorB_IN1 = 12;
const int motorB_IN2 = 13;
const int motorB_PWM = 15;

int joystick_X = 512;
int joystick_Y = 512;

bool estabilitzador = false;
bool manual = false;
bool debug = true;

//Activate/Desactivate Stabilizer
//BLYNK_WRITE(V0) {
//  estabilitzador = param.asInt();
//  if (estabilitzador) {
//    Blynk.setProperty(V2, "setlabel", "UP");
//    Blynk.setProperty(V4, "setlabel", "DOWN");
//  }
//  else {
//    Blynk.setProperty(V2, "setLabel", "ACCELERATE");
//    Blynk.setProperty(V4, "setLabel", "BRAKE");
//  }
//}
//
//BLYNK_WRITE(V1) {
//  int x = param[0].asInt();
//  int y = param[1].asInt();
//  joystick_X = x;
//  joystick_Y = y;
//
//  if (estabilitzador){
//    if (y>712) {
//      manual = true;
//      if (x>712){
//
//
//      } else if (x<312) {
//
//
//      } else {      
//
//      }
//    } else if (y<312) {
//      manual = true;
//      if (x>712){
//
//      } else if (x<312){
//
//      } else {
//
//      }
//      
//    } else {
//       if (x>712){
//
//      } else if (x<312) {
//
//      } else {
//        manual = false;
//
//      }
//    }
//  }
//  else {
//    if (y>712) {
//      manual = true;
//
//    } else if (y<312) {
//      manual = true;
//
//    } else {
//      manual = false;
//
//    }  
//  }
//}
//
//BLYNK_WRITE(V2) {
//  if (estabilitzador) {
//    //UP
//    if (param.asInt()) {
//      manual = true;
//
//    } else {
//      manual = false;
//
//    }    
//  } else {
//    //GAAAAS!
//    if (param.asInt()) {
//      manual = true;
//
//    } else {
//      manual = false;
//
//    }
//  }
//}
//
//BLYNK_WRITE(V3) {
//  if (String("debug") == param.asStr()){
//    debug = !debug;
//    if (debug) terminal.println("Debug text enabled!");
//    else terminal.println("Debug text disabled.");
//  } 
//  else if (String("gyro") == param.asStr()) {
//    terminal.println("Gyroscope data:");
//    terminal.println("===============");
//    terminal.print("GyX = "); terminal.println(GyX);
//    terminal.print("GyY = "); terminal.println(GyY);
//    terminal.print("GyZ = "); terminal.println(GyZ);
//  }
//  else {
//    terminal.println("Command not reconized!!!");  
//  }
//  terminal.flush();
//}
//
//BLYNK_WRITE(V4) {
//  if (estabilitzador) {
//    //DOWN!
//    if (param.asInt()) {
//      manual = true;
//
//    } else {
//      manual = false;
//
//    }    
//  } else {
//    //BRAKE!!
//    if (param.asInt()) {
//      manual = true;
//
//    } else {
//      manual = false;
//
//    }
//  }
//}

void read_AGD(){
  AcX=Wire.read()<<8|Wire.read(); // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
  AcY=Wire.read()<<8|Wire.read(); // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  AcZ=Wire.read()<<8|Wire.read(); // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
  Tmp=Wire.read()<<8|Wire.read(); // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L
  GyX=Wire.read()<<8|Wire.read(); // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY=Wire.read()<<8|Wire.read(); // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ=Wire.read()<<8|Wire.read(); // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
}

void push_AGD(int16_t AcXr, int16_t AcYr, int16_t AcZr, int16_t Tmpr, int16_t GyXr, int16_t GyYr, int16_t GyZr){
  int16_t AcXl,AcYl,AcZl,Tmpl,GyXl,GyYl,GyZl;
  for (int i=0;i<100;i++) {
    AcXl = AG_Data[i][0]; AG_Data[i][0] = AcXr; AcXr = AcXl;
    AcYl = AG_Data[i][1]; AG_Data[i][1] = AcYr; AcYr = AcYl;
    AcZl = AG_Data[i][2]; AG_Data[i][2] = AcZr; AcZr = AcZl;
    Tmpl = AG_Data[i][3]; AG_Data[i][3] = Tmpr; Tmpr = Tmpl;
    GyXl = AG_Data[i][4]; AG_Data[i][4] = GyXr; GyXr = GyXl;
    GyYl = AG_Data[i][5]; AG_Data[i][5] = GyYr; GyYr = GyYl;
    GyZl = AG_Data[i][6]; AG_Data[i][6] = GyZr; GyZr = GyZl;      
  }
}

void setup(){
  //Uncomment to disable "Brownout detector was triggered"
  //WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); //disable brownout detector
  Serial.begin(115200);

  Serial.println("Booting");
  Serial.println("Waiting for wifi connection...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connection Failed! Rebooting...");
    delay(5000);
    ESP.restart();
  }

   ArduinoOTA.setPassword("r2b2");
  
  ArduinoOTA
    .onStart([]() {
      String type;
      if (ArduinoOTA.getCommand() == U_FLASH)
      type = "sketch";
      else // U_SPIFFS
      type = "filesystem";
    
      Serial.println("Start updating " + type);
    })
    .onEnd([]() {
      Serial.println("\nEnd");
    })
    .onProgress([](unsigned int progress, unsigned int total) {
      Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
    })
    .onError([](ota_error_t error) {
      Serial.printf("Error[%u]: ", error);
      if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
      else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
      else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
      else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
      else if (error == OTA_END_ERROR) Serial.println("End Failed");
    });
  
  ArduinoOTA.begin();

  Serial.println("Ready");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

 // Blynk.begin(auth);

  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B); // PWR_MGMT_1 register
  Wire.write(0); // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);

  ledcSetup(MotorChannelR, freq, resolution);
  ledcSetup(MotorChannelL, freq, resolution);
  ledcSetup(MotorChannelF, freq, resolution);
  ledcSetup(MotorChannelB, freq, resolution);

  ledcAttachPin(motorR_PWM, MotorChannelR);
  ledcAttachPin(motorL_PWM, MotorChannelL);
  ledcAttachPin(motorF_PWM, MotorChannelF);
  ledcAttachPin(motorB_PWM, MotorChannelB);

  ledcWrite(MotorChannelR, 0);
  ledcWrite(MotorChannelL, 0);
  ledcWrite(MotorChannelF, 0); 
  ledcWrite(MotorChannelB, 0);

  pinMode (motorR_IN1, OUTPUT);
  pinMode (motorR_IN2, OUTPUT);
  pinMode (motorL_IN1, OUTPUT);
  pinMode (motorL_IN2, OUTPUT);
  pinMode (motorF_IN1, OUTPUT);
  pinMode (motorF_IN2, OUTPUT);
  pinMode (motorB_IN1, OUTPUT);
  pinMode (motorB_IN2, OUTPUT);

  digitalWrite (motorR_IN1, LOW);
  digitalWrite (motorR_IN2, LOW);
  digitalWrite (motorL_IN1, LOW);
  digitalWrite (motorL_IN2, LOW);
  digitalWrite (motorF_IN1, LOW);
  digitalWrite (motorF_IN2, LOW);
  digitalWrite (motorB_IN1, LOW);
  digitalWrite (motorB_IN2, LOW);

  for (int i=0; i<100; i++){
    push_AGD(0,0,0,0,0,0,0);
  }
}

void loop(){
  //Blynk.run();
  
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x3B); // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr,14,true); // request a total of 14 registers

  read_AGD();
  push_AGD(AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ); 

  if (estabilitzador & !manual) {
    int PotY = (AcY*255)/16384;
    int AngY = (AcY*90)/16384;
    if (debug) { messageln("Acy = " + String(AcY) + " | AngY = " + String(AngY) + " | M_BACK = " + String(PotY)); }
   
    if (AngY < -AngY_Offset_s) {
      run_motor_F(-PotY);
      run_motor_B(PotY);
      if (debug) { messageln(" M_FRONT = " + String(-PotY) + " | M_BACK = " + String(PotY) + " | Acy = " + String(AcY) + " | AngY = " + String(AngY)); }
    }
    else if (AngY > AngY_Offset_s) {
      run_motor_F(PotY);
      run_motor_B(-PotY);
      if (debug) { messageln(" M_FRONT = " + String(PotY) + " | M_BACK = " + String(-PotY) + " | Acy = " + String(AcY) + " | AngY = " + String(AngY)); }
    }
    else {
      run_motor_F(0);
      run_motor_B(0);
    }
  }
  else if (!estabilitzador & !manual) {
    run_motor_F(0);
    run_motor_B(0);
  }

//  message("AcX = "); message(String(AcX));
//  message(" | AcY = "); message(String(AcY));
//  message(" | AcZ = "); message(String(AcZ));
//  message(" | Tmp = "); message(String(Tmp/340.00+36.53));
//  message(" | GyX = "); message(String(GyX));
//  message(" | GyY = "); message(String(GyY));
//  message(" | GyZ = "); messageln(String(GyZ));
  delay(clock_int);
}

void message(String str) {
//  terminal.print(str);
  Serial.print(str);
}

void messageln(String str) {
//  terminal.println(str);
  Serial.println(str);
}

void run_motor_F(int val){
  if (val>0) {
    //if (debug) { messageln("Motor_F (+) : "+String(val));}
    digitalWrite(motorF_IN1,HIGH);
    digitalWrite(motorF_IN2,LOW);
    ledcWrite(MotorChannelF, val);
  } 
  else if (val<0){
    //if (debug) { messageln("Motor_F (-) : "+String(val));}
    digitalWrite(motorF_IN1,LOW);
    digitalWrite(motorF_IN2,HIGH);
    ledcWrite(MotorChannelF, -val);
  }
  else {
    //if (debug) { messageln("Motor_F (0) : "+String(val));}
    digitalWrite(motorF_IN1,LOW);
    digitalWrite(motorF_IN2,LOW);
    ledcWrite(MotorChannelF, 0);
  }
}

void run_motor_B(int val){
  if (val>0) {
    digitalWrite(motorB_IN1,HIGH);
    digitalWrite(motorB_IN2,LOW);
    ledcWrite(MotorChannelB, val);
  } 
  else if (val<0){
    digitalWrite(motorB_IN1,LOW);
    digitalWrite(motorB_IN2,HIGH);
    ledcWrite(MotorChannelB, -val);
  }
  else {
    digitalWrite(motorB_IN1,LOW);
    digitalWrite(motorB_IN2,LOW);
    ledcWrite(MotorChannelB, 0);
  }
}


