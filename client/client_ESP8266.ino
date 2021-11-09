#include <ESP8266WiFi.h>

String codeVersion = "Version 1.0 Aug 2021 by CyrilBvt13";

bool credentialsReceived = false;

String cmd="";
char* SSID ;
char* password ;

int pinGPIO2 = 2;

void setup() {
  Serial.begin(115200);
  delay(10);
  Serial.println(codeVersion);

  pinMode(pinGPIO2, OUTPUT);
  digitalWrite(pinGPIO2, LOW);

  Serial.println();
  WiFi.disconnect();
  WiFi.mode(WIFI_STA);
  
}

void loop() {
  Serial.print("Wainting for credentials ");
  while(credentialsReceived==false) {
    delay(500);
    Serial.print(".");    
    while(Serial.available()>0){
        bool credentialsSent = false;
        while(credentialsSent == false){
          char buff=(char)Serial.read();
          cmd+=buff;
          if(buff =='*'){
            cmd = cmd.substring(0, cmd.length() - 1); // Delete last char *        
            credentialsSent = true;
          }
      }
    //ON DECOUPE CMD EN SSID ET PASSWORD SSID==wiFiSSID/PSW==wiFiPSW*
    int i=5;
    while(cmd[i]!='/'){
        SSID = SSID + cmd[i];
        i++;
    }
    i++;
    while(i<cmd.length() - 1){
        password = password + cmd[i];
        i++;
    }
    credentialsReceived=true;
  }
  Serial.print("Credentials received!");
  Serial.print("Connecting to ");
  Serial.println(SSID);
  WiFi.begin(SSID, password);
  
    while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");    
  }
  
  Serial.println("");
  Serial.println("Connected to WiFi");
  
  //We set GPIO2 to HIGH for telling the arduino we are connected
  analogWrite(pinGPIO2, 1023);

  while(Serial.available()>0) {
    String datas="";
    char buff=(char)Serial.read();
          datas+=buff;
          if(buff =='*'){
            datas = datas.substring(0, datas.length() - 1); // Delete last char *        
          }
    //Create a POST request
    //https://randomnerdtutorials.com/esp8266-nodemcu-http-get-post-arduino/
    
    //ADD YOUR CODE HERE!
    
    }
  }
}
