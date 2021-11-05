#include <ESP8266WiFi.h>

String codeVersion = "Version 1.0 Aug 2021 by CyrilBvt13";

char* SSID ;
char* password ;

int pinGPIO2 = 2;

//WiFiServer WebServer(80);
WiFiClient client;

void setup() {
  Serial.begin(115200);
  delay(10);
  Serial.println();
  Serial.println();
  Serial.println(codeVersion);

  pinMode(pinGPIO2, OUTPUT);
  digitalWrite(pinGPIO2, LOW);

  Serial.println();
  WiFi.disconnect();
  WiFi.mode(WIFI_STA);
  
}

void loop() {
  while(//on a pas le login) {
    //ON ATTEND LES INFOS DE CONNEXION
    }
  //ON A LES INFOS DE CONNEXION
  Serial.print("Connecting to ");
  Serial.println(SSID);
  WiFi.begin(SSID, password);
  
    while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");    
  }
  
  Serial.println("");
  Serial.println("Connected to WiFi");
  
  //ON ACTIVE LE PIN GPIO2 POUR DIRE A L'ARDUINO QU'ON EST CONNECTE
  analogWrite(pinGPIO2, 1023);
  ledStatus = 1;

  while(//On reçoit des infos) {
    //ON ENVOIE LES INFOS PAR WIFI A L'API
    }
}
