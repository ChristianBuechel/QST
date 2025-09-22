  String input = "";
  
  void setup() {
    Serial.begin(115200);
    Serial.println("Ready for input...");
  }
  
  void loop() {
    while (Serial.available() > 0) {
      char c = Serial.read();
      input += c;
  
      // Optional: limit input length to avoid overflow
      if (input.length() > 20) {
        input = ""; // reset if too long
        Serial.println("Input too long. Resetting.");
      }
  
      // Check for known commands
      if (input == "B") {
        Serial.write(13);
        Serial.print("19.1234v 040%");
        input = "";
      } else if (input == "E") {
        Serial.write(13);
        Serial.print("213+414+425+436-044+455");
        input = "";
      } else if (input == "H") {
        Serial.write(13);
        Serial.print("");
        input = "";
      } else if (input == "N") {
        input = "";
        serialFlush();
      }
      else if (input == "F") {
        input = "";
        serialFlush();
      }// You can add more commands here
      else if (input == "D") {
        input = "";
        serialFlush();
      }// You can add more commands here
      else if (input == "V") {
        input = "";
        serialFlush();
      }// You can add more commands here
      else if (input == "R") {
        input = "";
        serialFlush();
      }// You can add more commands here
      else if (input == "C") {
        input = "";
        serialFlush();
      }// You can add more commands here
      else if (input == "L") {
        input = "";
      }// You can add more commands here
    }
  }
  
  void serialFlush(){
        delay(100);
  while(Serial.available() > 0) {
      char t = Serial.read();
    }
  }
