#define SWITCH 2
#define LED 7
#define WAIT_TIME 2000

void setup() {
  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0){
    char in = Serial.read();

    if(in == 'w'){
      Serial.println("BUTTON");
    }
  }

  if (digitalRead(SWITCH) == LOW)
  {
    digitalWrite(LED, HIGH);
    Serial.println("PUSH");
    delay(WAIT_TIME);
    digitalWrite(LED, LOW);
  }
}
