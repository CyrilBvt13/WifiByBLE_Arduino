  
#include <SoftwareSerial.h>
#include <EEPROM.h>

SoftwareSerial hc06(2,3);

//Command sent to HC06
String cmd="";

//EEPROM adresses
int addrFirstCheckConnexion = 0;
int addrCredentials = 1;

char string[20]; //UTILITE??

void setup() {
  //Initialize Serial Monitor
  Serial.begin(9600);
  //Initialize Bluetooth Serial Port
  hc06.begin(9600);
  Serial.println("Initialization OK.");
  //Clearing the EEPROM
  //for (int i = 0 ; i < EEPROM.length() ; i++) {
  //  EEPROM.write(i, 0);
  }
}

void loop() {
    /*Testing if connection works*/
  if(testConnexion()){
    Serial.println("Connection OK.");
    /*Sending data to ESP8266*/
    
    //ADD YOUR CODE HERE!
    
  }
  else{
     Serial.println("Connection FAILED.");
     /*Checking if it's the first time we connect*/
     if(checkFirstConnexion()){
      Serial.println("First connection.");
      /*wait for bluetooth credentials*/
      while(hc06.available()>0){
        bool credentialsSent = false;
        while(credentialsSent == false){
        char buff=(char)hc06.read();
        cmd+=buff;
        if(buff =='*'){
          cmd = cmd.substring(0, cmd.length() - 1); // Delete last char *
          Serial.println(cmd);
          /*Writing credentials to EEPROM*/
          writeCredentials(cmd);
          /*Writing that next time will not be the first connexion to EEPROM*/
          EEPROM.write(addrFirstCheckConnexion, 1);
          credentialsSent = true;          
          /*Sending credentials to ESP8266*/
          sendCredentials(cmd);
        }
      }
      }
    } else{
      Serial.println("Not the first connection.");
      /*Connecting*/
      /*Reading credentials from EEPROM*/
      cmd = readCredentials();
      /*Sending credentials to ESP8266*/ 
      sendCredentials(cmd);
    }
  }
  Serial.println("----- Waiting -----");
  delay(60000);
}

bool checkFirstConnexion(){
  Serial.println("Checking if first connection...");
  /*Checking if it's the first time we connect*/
  int value = EEPROM.read(addrFirstCheckConnexion);

  if(value == 1){
    return false;      
  }
  else{
    return true;
  }
}

bool testConnexion(){
  Serial.println("Testing connection...");
  /*we test the connection*/
  /*if OK returns true*/
  /*if !OK returns false*/
  if(digitalRead(pin) == HIGH){
    return true;
  }
  else{
    return false;
  }  
}

void writeCredentials(String cmd){
  Serial.println("Writing credentials to EEPROM...");
  /*Writing credentials to EEPROM*/
  //We have to go through the whole chain cmd = 'SSID==wiFiSSIDPSW==wiFiPSW*
  int i=0;
  /*Wrinting expected String length in EEPROM*/
  
  Serial.println(itoa(addrCredentials,string,10)); // -- DELETE
  Serial.println(cmd.length()); // -- DELETE
  
  EEPROM.write(addrCredentials, cmd.length());
  addrCredentials++;

  /*Writing credentials to EEPROM*/
  while(cmd[i] != '\0'){
    
      Serial.println(itoa(addrCredentials,string,10)); // -- DELETE
      Serial.println(cmd.substring(i,i+1)); // -- DELETE
    
      EEPROM.write(addrCredentials, cmd.substring(i,i+1);
      addrCredentials++;
      i++;
  }
  Serial.println("Writing credentials to EEPROM OK.");
}


String readCredentials(){
  String credentials;
  
  /*Reading string lenght expecred*/
  int credLenght = EEPROM.read(addrCredentials);
  /*Reading credentials stored in EEPROM*/
  for(i=0;i<credLenght;i++){
    credentials[i] = EEPROM.read(addrCredentials+1+i);
  }
  return credentials;
}

void sendCredentials(String cmd){
  //On passe par les pins TX/RX croisées ou on peut spécifier d'autres pins :
  //https://www.arduino.cc/en/Tutorial/LibraryExamples/SoftwareSerialExample
}
