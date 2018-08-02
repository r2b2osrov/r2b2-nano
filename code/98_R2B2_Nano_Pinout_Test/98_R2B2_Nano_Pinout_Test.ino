                                                                                                                    //Title:         98_R2B2_Nano_Pinout_Test.ino
//Description:   Arduino IDE program to test R2B2 pinout 
//Authors:       Pau Roura (@proura)
//Date:          20180610
//Version:       0.1
//Notes:         
//

#include <WiFi.h>
#include <ESPmDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

const char* ssid = "BuLan";
const char* password = "00009999";

//Configuració del PWM pels 4 motors
int freq = 2000;
int resolution = 8;
int MotorChannelR = 0;
int MotorChannelL = 1;
int MotorChannelF = 2;
int MotorChannelB = 3;

bool run = true;

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

void setup(){
  Serial.begin(115200);
  
  Serial.println("Booting");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connection Failed! Rebooting...");
    delay(5000);
    ESP.restart();
  }
  
  ArduinoOTA
    .onStart([]() {
      run = false;
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
}

void loop(){
  ArduinoOTA.handle();

  if (run) {
    digitalWrite (motorR_IN1, LOW);
    digitalWrite (motorR_IN2, HIGH);
    digitalWrite (motorL_IN1, LOW);
    digitalWrite (motorL_IN2, HIGH);
    digitalWrite (motorF_IN1, LOW);
    digitalWrite (motorF_IN2, HIGH);
    digitalWrite (motorB_IN1, LOW);
    digitalWrite (motorB_IN2, HIGH);
  
    for (int i=0;i<150;i=i+5) {
      ledcWrite(MotorChannelR, i);
      ledcWrite(MotorChannelL, i);
      ledcWrite(MotorChannelF, i);
      ledcWrite(MotorChannelB, i);
      delay(5);
    }
    
    for (int i=150;i>0;i=i-5) {
      ledcWrite(MotorChannelR, i);
      ledcWrite(MotorChannelL, i);
      ledcWrite(MotorChannelF, i);
      ledcWrite(MotorChannelB, i);
      delay(5);
    }
    
    digitalWrite (motorR_IN1, HIGH);
    digitalWrite (motorR_IN2, LOW);
    digitalWrite (motorL_IN1, HIGH);
    digitalWrite (motorL_IN2, LOW);
    digitalWrite (motorF_IN1, HIGH);
    digitalWrite (motorF_IN2, LOW);
    digitalWrite (motorB_IN1, HIGH);
    digitalWrite (motorB_IN2, LOW);
   
    for (int i=0;i<150;i=i+5) {
      ledcWrite(MotorChannelR, i);
      ledcWrite(MotorChannelL, i);
      ledcWrite(MotorChannelF, i);
      ledcWrite(MotorChannelB, i);
      delay(5);
    }
    
    for (int i=150;i>0;i=i-5) {
      ledcWrite(MotorChannelR, i);
      ledcWrite(MotorChannelL, i);
      ledcWrite(MotorChannelF, i);
      ledcWrite(MotorChannelB, i);
      delay(5);
    }
  }
}
