void setup() {
  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0){
    char in = Serial.read();

    if(in == 'w'){
      Serial.println("NFC");
    }
  }

  // Dump debug info about the card; PICC_HaltA() is automatically called
  //mfrc522.PICC_DumpToSerial(&(mfrc522.uid));
  String strBuf[mfrc522.uid.size];
  for (byte i = 0; i < mfrc522.uid.size; i++) {
      strBuf[i] =  String(mfrc522.uid.uidByte[i], HEX);  // (E)using a constant integer
      if(strBuf[i].length() == 1){  // 1桁の場合は先頭に0を追加
        strBuf[i] = "0" + strBuf[i];
      }
      Serial.print(strBuf[i].c_str());
  }
  Serial.println();
  delay(1500);
}
