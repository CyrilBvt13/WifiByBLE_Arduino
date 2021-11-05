#include <ESP8266WiFi.h>

String codeVersion = "Version 1.0  Aug 2021 by CyrilBvt13";

const char* SSID = "YourSSID";
const char* password = "YourPassword";

int pinGPIO2 = 2;

WiFiServer WebServer(80);
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
  Serial.print("Connecting to ");
  Serial.println(SSID);
  WiFi.begin(SSID, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("Connected to WiFi");
  
  analogWrite(pinGPIO2, 1023);
  ledStatus = 1;

  WebServer.begin();
  Serial.println("Web Server started");

  Serial.print("You can connect to the ESP8266 at this URL: ");
  Serial.print("http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");
}

void loop() {
  client = WebServer.available();
  if (!client) {
    return;
  }

  Serial.println("User connected");
  while (!client.available()) {
    delay(1);
  }

  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: text/html; charset=UTF-8");
  client.println("");
  client.println("<!DOCTYPE HTML>");
  client.println("<html>");
  client.println("<body>");

  client.print("Hi gorgeous!</br>");

  client.println("</body>");
  client.println("</html>");

  delay(1);
  Serial.println("User disconnected");
  Serial.println("");

}
