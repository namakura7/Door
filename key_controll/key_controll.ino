#include "Servo.h"

// サーボのピン
#define SERVO 10
#define OPEN_ANGLE  90
#define CLOSE_ANGLE 0

#define SWITCH 2
#define WAIT_TIME 6000

Servo servo;
bool status; // true:OPEN false:CLOSE

void setup(){
  Serial.begin(9600);
  pinMode(SWITCH, INPUT_PULLUP);
  status = true;
}

void loop(){
  // 受信したデータが存在する
  if (Serial.available() > 0){
    //文字の読み込み
    char in = Serial.read();

    if (in == '1') {
      servo.attach(SERVO);

      int angle;

      if(status)
        angle = OPEN_ANGLE;
      else
        angle = CLOSE_ANGLE;
      
      servo.write(angle);
      status = !status;

      delay(1000);
      servo.detach();
    }
    else if(in == '0'){
      char* temp;

      if(status)
        temp = "OPEN ";
      else
        temp = "CLOSE";

      Serial.println(temp);
      delay(1000);
    }
    else if(in == 'w'){
      Serial.println("KEY");
    }
  }
  else if(digitalRead(SWITCH) == LOW){
    int angle;

    if(status){
      angle = OPEN_ANGLE;
      delay(WAIT_TIME);
    }
    else
      angle = CLOSE_ANGLE;

    servo.write(angle);
    status = !status;
    delay(1000);
    servo.detach();
  }
}
