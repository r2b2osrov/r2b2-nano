                                                                                                                    //Title:         98_R2B2_Nano_Pinout_Test.ino
//Description:   Arduino IDE program for R2B2 
//Authors:       Pau Roura (@proura)
//Date:          20180730
//Version:       0.1
//Notes:         
//

#include <WiFi.h>
#include <ESPmDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include <PubSubClient.h>
#include <MPU6050_tockn.h>
#include <Wire.h>

const int R2B2id = ESP.getEfuseMac();
const char* ssid = "BuLan";
const char* password = "00009999";
const char* mqttServer = "192.168.82.106";
const int   mqttPort = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

MPU6050 mpu6050(Wire);

//Configuració del PWM pels 4 motors
const int freq = 2000;
const int resolution = 8;
const int MotorChannelR = 0;
const int MotorChannelL = 1;
const int MotorChannelF = 2;
const int MotorChannelB = 3;

bool connected = false;
long timer = 0;
long timer2 = 0;
long C_Alive = 0;
long old_C_Alive = 0;
char topic[50];
char msg[250];
char host[50];

//Pins del motor Dret
const int motorR_IN1 = 26;
const int motorR_IN2 = 27;
const int motorR_PWM = 14;
//Pins del motor Esquerra
const int motorL_IN1 = 5;
const int motorL_IN2 = 18;
const int motorL_PWM = 19; 
//Pins del motor Frontal
const int motorF_IN1 = 25;
const int motorF_IN2 = 33;
const int motorF_PWM = 32;
//Pins del motor Posterior
const int motorB_IN1 = 12;
const int motorB_IN2 = 13;
const int motorB_PWM = 15;

void setup(){
  Serial.begin(115200);
  Serial.println("Booting");

  initializeMotors();
  initializeWifi();
  initializeOTA((char*)R2B2id);
  initializeMQTT();
  initializeMPU();

}

void loop(){
  ArduinoOTA.handle();
  if (!client.connected()) {
    motorStop();
    reconnect();
  }else{
    if((millis() - timer2 > 1000)){
      if (C_Alive == old_C_Alive) motorStop();
      old_C_Alive = C_Alive; 
      timer2 = millis();     
    }      
  }
  client.loop();
}

void initializeMotors(){
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
}

void initializeWifi(){
  WiFi.mode(WIFI_STA);
  WiFi.onEvent(WiFiEvent);
  WiFi.begin(ssid, password);
  Serial.println("Connecting WiFi...");
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connection Failed! Rebooting...");
    delay(5000);
    ESP.restart();
  }  
}

void WiFiEvent(WiFiEvent_t event){
    switch(event) {
      case SYSTEM_EVENT_STA_GOT_IP:
          Serial.print("WiFi connected! IP address: ");
          Serial.println(WiFi.localIP());  
          connected = true;
          break;
      case SYSTEM_EVENT_STA_DISCONNECTED:
          Serial.println("WiFi lost connection");
          connected = false;
          break;
    }
}

void initializeOTA(const char * host_name){
  sprintf(host, "r2b2-%u", host_name);
  ArduinoOTA.setHostname(host);
  ArduinoOTA
    .onStart([]() {
      String type;
      if (ArduinoOTA.getCommand() == U_FLASH) type = "sketch";
      else type = "filesystem";
      Serial.println("Start updating " + type);
    })
    .onEnd([]() {
      Serial.println("\nEnd");
    })
    .onProgress([](unsigned int progress, unsigned int total) {
      Serial.printf("Progress: %u%%\r", (progress / (total / 100)));

      //Send Upload Info to MQTT
      if((millis() - timer > 250) || ((progress / (total / 100)) == 100 )){
        sprintf(msg, "upload %u%%\r", (progress / (total / 100)));
        sprintf(topic, "r2b2/%u/info", R2B2id);
        client.publish(topic, msg);
        timer = millis();
      }
      
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
}

void initializeMQTT(){
  client.setServer(mqttServer, mqttPort);
  client.setCallback(callback);
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection... ");
    
    if (client.connect(host)) {
      Serial.println("Connected!");
      sprintf(topic, "r2b2/%u/info", R2B2id);
      client.publish(topic, "Hello from R2B2-nano!");
      client.publish(topic, host);
      sprintf(topic, "r2b2/%u/tasks", R2B2id);
      client.subscribe(topic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 3 seconds");
      delay(3000);
    }
  }
}
 
void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i=0;i<length;i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  String str = String((char *)payload);
  str = str.substring(0, length);

  if ( str == "ping" ) pong();
  if ( str == "calibrate" ) calibrate();
  if ( str == "getGyrAcc" ) getGyrAcc();
  if ( str == "getTemp" ) getTemp();
  if ( str == "stop" ) motorStop();
  if ( str.substring(0, 3) == "mRF" ) motorRForward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mRB" ) motorRBackward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mRS" ) motorRStop();

  if ( str.substring(0, 3) == "mLF" ) motorLForward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mLB" ) motorLBackward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mLS" ) motorLStop();

  if ( str.substring(0, 3) == "mFF" ) motorFForward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mFB" ) motorFBackward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mFS" ) motorFStop();

  if ( str.substring(0, 3) == "mBF" ) motorBForward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mBB" ) motorBBackward(str.substring(4, length).toInt());
  if ( str.substring(0, 3) == "mBS" ) motorBStop();
}

void initializeMPU(){
  pinMode (21, INPUT_PULLUP);
  pinMode (23, INPUT_PULLUP);
  Wire.begin();
  mpu6050.begin();
}

void calibrate() {
  Wire.begin();
  mpu6050.begin();
  mpu6050.calcGyroOffsets(true);
  sprintf(topic, "r2b2/%u/info", R2B2id);
  client.publish(topic, "Calibrated!");
}

void pong() {
  sprintf(topic, "r2b2/%u/alive", R2B2id);
  client.publish(topic, "pong");
  C_Alive++;
}

void getGyrAcc() {
  mpu6050.update();   
  sprintf(topic, "r2b2/%u/mpu", R2B2id);
  sprintf(msg, "%ld %ld %ld %ld %ld %ld", mpu6050.getRawAccX(), mpu6050.getRawAccY(), mpu6050.getRawAccZ(), mpu6050.getRawGyroX(), mpu6050.getRawGyroY(), mpu6050.getRawGyroZ());
  client.publish(topic, msg); 
}

void getTemp() {
  mpu6050.update();   
  sprintf(topic, "r2b2/%u/tmp", R2B2id);
  sprintf(msg, "%f", mpu6050.getTemp());
  client.publish(topic, msg); 
}

void motorRForward(int motorPWM){
  ledcWrite(MotorChannelR, motorPWM);
  digitalWrite (motorR_IN1, HIGH);
  digitalWrite (motorR_IN2, LOW);
}

void motorRBackward(int motorPWM){
  ledcWrite(MotorChannelR, motorPWM);
  digitalWrite (motorR_IN1, LOW);
  digitalWrite (motorR_IN2, HIGH);
}

void motorRStop(){
  ledcWrite(MotorChannelR, 0);
  digitalWrite (motorR_IN1, LOW);
  digitalWrite (motorR_IN2, LOW);
}

void motorLForward(int motorPWM){
  ledcWrite(MotorChannelL, motorPWM);
  digitalWrite (motorL_IN1, HIGH);
  digitalWrite (motorL_IN2, LOW);
}

void motorLBackward(int motorPWM){
  ledcWrite(MotorChannelL, motorPWM);
  digitalWrite (motorL_IN1, LOW);
  digitalWrite (motorL_IN2, HIGH);
}

void motorLStop(){
  ledcWrite(MotorChannelL, 0);
  digitalWrite (motorL_IN1, LOW);
  digitalWrite (motorL_IN2, LOW);
}

void motorFForward(int motorPWM){
  ledcWrite(MotorChannelF, motorPWM);
  digitalWrite (motorF_IN1, HIGH);
  digitalWrite (motorF_IN2, LOW);
}

void motorFBackward(int motorPWM){
  ledcWrite(MotorChannelF, motorPWM);
  digitalWrite (motorF_IN1, LOW);
  digitalWrite (motorF_IN2, HIGH);
}

void motorFStop(){
  ledcWrite(MotorChannelF, 0);
  digitalWrite (motorF_IN1, LOW);
  digitalWrite (motorF_IN2, LOW);
}

void motorBForward(int motorPWM){
  ledcWrite(MotorChannelB, motorPWM);
  digitalWrite (motorB_IN1, HIGH);
  digitalWrite (motorB_IN2, LOW);
}

void motorBBackward(int motorPWM){
  ledcWrite(MotorChannelB, motorPWM);
  digitalWrite (motorB_IN1, LOW);
  digitalWrite (motorB_IN2, HIGH);
}

void motorBStop(){
  ledcWrite(MotorChannelB, 0);
  digitalWrite (motorB_IN1, LOW);
  digitalWrite (motorB_IN2, LOW);
}

void motorStop(){
  motorRStop();
  motorLStop();
  motorFStop();
  motorBStop();
}
