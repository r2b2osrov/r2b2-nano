//Configuració del PWM pels 4 motors
int freq = 2000;
int resolution = 8;
int MotorChannelR = 0;
int MotorChannelL = 1;
int MotorChannelF = 2;
int MotorChannelB = 3;

//Pins del motor Dret
const int motorR_IN1 = 19;
const int motorR_IN2 = 18;
const int motorR_PWM = 5;
//Pins del motor Esquerra
const int motorL_IN1 = 39;
const int motorL_IN2 = 13;
const int motorL_PWM = 32; 
//Pins del motor Frontal
const int motorF_IN1 = 33;
const int motorF_IN2 = 25;
const int motorF_PWM = 26;
//Pins del motor Posterior
const int motorB_IN1 = 27;
const int motorB_IN2 = 14;
const int motorB_PWM = 12;

void setup(){
  Serial.begin(115200);

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
  digitalWrite (motorR_IN1, LOW);
  digitalWrite (motorR_IN2, LOW);
  digitalWrite (motorL_IN1, LOW);
  digitalWrite (motorL_IN2, LOW);
  digitalWrite (motorF_IN1, LOW);
  digitalWrite (motorF_IN2, LOW);
  digitalWrite (motorB_IN1, LOW);
  digitalWrite (motorB_IN2, LOW);

  for (int i=0;i<255;i++) {
    ledcWrite(MotorChannelR, i);
    ledcWrite(MotorChannelL, i);
    ledcWrite(MotorChannelF, i);
    ledcWrite(MotorChannelB, i);
    delay(10);
  }

  digitalWrite (motorR_IN1, HIGH);
  digitalWrite (motorR_IN2, HIGH);
  digitalWrite (motorL_IN1, HIGH);
  digitalWrite (motorL_IN2, HIGH);
  digitalWrite (motorF_IN1, HIGH);
  digitalWrite (motorF_IN2, HIGH);
  digitalWrite (motorB_IN1, HIGH);
  digitalWrite (motorB_IN2, HIGH);

  for (int i=255;i>0;i--) {
    ledcWrite(MotorChannelR, i);
    ledcWrite(MotorChannelL, i);
    ledcWrite(MotorChannelF, i);
    ledcWrite(MotorChannelB, i);
    delay(10);
  }
  
  Serial.println(millis());
}





