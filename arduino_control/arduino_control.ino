#include <Adafruit_ATParser.h>
#include <Adafruit_BLE.h>
#include <Adafruit_BLEBattery.h>
#include <Adafruit_BLEEddystone.h>
#include <Adafruit_BLEGatt.h>
#include <Adafruit_BLEMIDI.h>
#include <Adafruit_BluefruitLE_SPI.h>
#include <Adafruit_BluefruitLE_UART.h>

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 13 as an output.
  pinMode(13, OUTPUT);
}
 
// the loop function runs over and over again forever
void loop() {
  digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(2000);              // wait for a second
  digitalWrite(13, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);              // wait for a second
}

/*#include <Servo.h>
#include <SPI.h>
#include "Adafruit_BLE_UART.h"
#include <String.h>

Servo myservo;



//This function is called whenever select ACI events happen
void aciCallback(aci_evt_opcode_t event) {
  switch(event)
  {
    case ACI_EVT_DEVICE_STARTED:
      Serial.println(F("Advertising started"));
      break;
    case ACI_EVT_CONNECTED:
      Serial.println(F("Connected!"));
      break;
    case ACI_EVT_DISCONNECTED:
      Serial.println(F("Disconnected or advertising timed out"));
      break;
    default:
      break;
  }
}




//This function is called whenever data arrives on the RX channel
void rxCallback(uint8_t *buffer, uint8_t len)
{

  //convert the incoming data into a string, to make it easier to work with
  String receivedString;
  
  for (int i=0; i<len;i++) {
    if ((char)buffer[i] != ' ' && (char)buffer[i] != '\n') {
      receivedString += (char)buffer[i]; 
      }
  }

  //print out the string that was received
  Serial.println(receivedString);

  //count how many "dots" are in the received string, and record the indices of the dots
  int dotIndices[2];
  int dotCounter = 0;
  for (int c=0; c<receivedString.length();c++) {
    if (receivedString[c] == '.') {
      dotIndices[dotCounter] = c;
      dotCounter++;
    }
  }

  //if the dotCounter is 2, this is an RGB packet
  if (dotCounter==2) {
    
  }

  //if we didn't receive a color command, check if the string could be a special command
  
  if (receivedString == "off") {
    Serial.println("off");
    
  } else if (receivedString == "slowFade") {
    
  } else if (receivedString == "fastFade") {
    
  } else if (receivedString == "cut") {
    
  } else if (receivedString == "flash") {
    
  }
    
}

void setup() {
  // put your setup code here, to run once:

  myservo.attach(12);
  myservo.write(70);
}

void loop() {
  // put your main code here, to run repeatedly:
  for (int i=0; i<170; i++) {
    //myservo.write(i);
    //delay(10);
  }

  for (int i=170; i>10; i--) {
    //myservo.write(i);
    //delay(10);
  }
}*/
