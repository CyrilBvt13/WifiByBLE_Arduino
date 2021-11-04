#include <SoftwareSerial.h>

SoftwareSerial hc06(2,3);

String cmd="";

void setup() {
  //Initialize Serial Monitor
  Serial.begin(9600);
  //Initialize Bluetooth Serial Port
  hc06.begin(9600);
  Serial.println("Initialization.");
}

void loop() {
  //Read data from HC06
  while(hc06.available()>0){
    char buff=(char)hc06.read();
    cmd+=buff;

    if(buff =='*'){
      cmd = cmd.substring(0, cmd.length() - 1); // Delete last char *
      Serial.println(cmd);
    }
  }
}		
