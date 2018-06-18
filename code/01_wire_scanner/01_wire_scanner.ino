//Title:         01_wire_scanner.ino
//Description:   Arduino IDE program to look for 1 Wire device address
//Authors:       Pau Roura (@proura)
//Date:          20180610
//Version:       0.1
//Notes:         
//

#include <Wire.h>

void setup() {
  Serial.begin (115200);
  while (!Serial){
  }

  Serial.println ();
  Serial.println ("I2C scanner. Scanning ...");
  byte count = 0;
  Wire.begin(21, 22);
  
  for (byte i = 8; i < 120; i++){
    Wire.beginTransmission (i);
    if (Wire.endTransmission () == 0){
      Serial.print ("Found address: ");
      Serial.print (i, DEC);
      Serial.print (" (0x");
      Serial.print (i, HEX);
      Serial.println (")");
      count++;
      delay (1);
    } 
  }
  
  Serial.println ("Done.");
  Serial.print ("Found ");
  Serial.print (count, DEC);
  Serial.println (" device(s).");
}

void loop() {}
