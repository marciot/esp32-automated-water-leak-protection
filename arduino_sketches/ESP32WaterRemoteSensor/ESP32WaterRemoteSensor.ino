#define WIFI_SSID "enter-your-ssid-here"
#define WIFI_PSK  "enter-your-password-here"
#define CONTROLLER_IP "192.168.1.92"
#define SENSOR_PIN 4  // Touch 0 pin = GPIO 4
#define SET_PIN    16 // Relay SET Pin = GPIO 16
#define UNSET_PIN  17 // Relay UNSET Pin = GPIO 17
#define LOW_SENSE_THRESHOLD 10 // Threshold for detecting water
#define HIGH_SENSE_THRESHOLD 50 // Threshold for detecting no water
#include <WiFi.h>
#include <HTTPClient.h>
bool isOpen;
void sendRequest(char* url) {
  HTTPClient http;
  http.begin(url);
  int httpCode = http.GET();
  if (httpCode > 0) {
    Serial.print("GET");
    Serial.print(url);
    Serial.print(" Status: ");
    Serial.println(httpCode);
  } else {
    Serial.println("Error on HTTP request");
  }
  http.end();
  isOpen = false;
}
void closeRelay() {
  sendRequest("http://" CONTROLLER_IP "/close");
  isOpen = true;
}
void openRelay() {
  sendRequest("http://" CONTROLLER_IP "/open");
  isOpen = true;
}
void setup() {
  Serial.begin(115200);
  delay(1000); // give me time to bring up serial monitor
  Serial.println("ESP32 Water Shut-Off Controller");
  pinMode(SET_PIN, OUTPUT);
  pinMode(UNSET_PIN, OUTPUT);
  openRelay();
  // Connect to Wi-Fi network with SSID and password
  Serial.println("Setting up WiFi");
  WiFi.begin(WIFI_SSID, WIFI_PSK);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.print("Connected. IP=");
  Serial.println(WiFi.localIP());
}
void loop() {
  const int value = touchRead(SENSOR_PIN);
  if(value < LOW_SENSE_THRESHOLD && isOpen == true) {
    closeRelay();
  }
  if(value > HIGH_SENSE_THRESHOLD && isOpen == false) {
    openRelay();
  }
}
