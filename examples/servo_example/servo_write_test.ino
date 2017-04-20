#include <Servo.h> 

Servo myservo;

void setup() 
{ 
  myservo.attach(9);
  myservo.write(70);  // set servo to mid-point
} 

void loop() {
  for (int i=10; i<170; i++) {
    myservo.write(i);
    delay(10);
  }

  for (int i=170; i>10; i--) {
    myservo.write(i);
    delay(10);
  }
}

