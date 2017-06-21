/*
Adafruit Arduino - Lesson 16. Stepper
*/
#include <Stepper.h>

// RIGHT MOTOR
int R_in1Pin = 13; // the not PWM one
int R_in2Pin = 12; // looks same for Adafruit Feather M0
int R_in3Pin = 11;
int R_in4Pin = 10;

// LEFT MOTOR
int L_in1Pin = 9; // the not PWM one
int L_in2Pin = 6; 
int L_in3Pin = 5;
int L_in4Pin = A1;

Stepper left_motor(512, L_in1Pin, L_in2Pin, L_in3Pin, L_in4Pin);  
Stepper right_motor(512, R_in1Pin, R_in2Pin, R_in3Pin, R_in4Pin); 

void setup() {
  
  pinMode(R_in1Pin, OUTPUT);
  pinMode(R_in2Pin, OUTPUT);
  pinMode(R_in3Pin, OUTPUT);
  pinMode(R_in4Pin, OUTPUT);
  
  pinMode(L_in1Pin, OUTPUT);
  pinMode(L_in2Pin, OUTPUT);
  pinMode(L_in3Pin, OUTPUT);
  pinMode(L_in4Pin, OUTPUT);

  // this line is for Leonardo's, it delays the serial interface
  // until the terminal window is opened
  while (!Serial);
  
  Serial.begin(9600);

  // set the speed of the motors
  // probably want to keep this low so that motors don't draw too much power
  left_motor.setSpeed(5);
  right_motor.setSpeed(5);
}

void loop() {
  
  if (Serial.available())
  {
    int steps = Serial.parseInt();
    Serial.println(steps);
    
    left_motor.step(steps);
    right_motor.step(steps);

    delay(1000);
  }
}
