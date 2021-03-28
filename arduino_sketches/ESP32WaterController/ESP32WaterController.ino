#define WIFI_SSID "mlt_dsl"
#define WIFI_PSK  "eg1me9di!"
#define SENSOR_PIN 4  // Touch 0 pin = GPIO 4
#define SET_PIN    16 // Relay SET Pin = GPIO 16
#define UNSET_PIN  17 // Relay UNSET Pin = GPIO 17
#define LOW_SENSE_THRESHOLD 10 // Threshold for detecting no water
#define HIGH_SENSE_THRESHOLD 50 // Threshold for detecting water
#include <WiFi.h>
#include <HTTPSServer.hpp>
#include <SSLCert.hpp>
#include <HTTPRequest.hpp>
#include <HTTPResponse.hpp>
using namespace httpsserver;
HTTPServer server = HTTPServer();
void handleRoot(HTTPRequest * req, HTTPResponse * res);
void handleCloseRelay(HTTPRequest * req, HTTPResponse * res);
void handleOpenRelay(HTTPRequest * req, HTTPResponse * res);
void handle404(HTTPRequest * req, HTTPResponse * res);
bool isOpen;
void closeRelay() {
  Serial.println("Closing relay");
  digitalWrite(SET_PIN, HIGH);
  delay(20);
  digitalWrite(SET_PIN, LOW);
  isOpen = false;
}
void openRelay() {
  Serial.println("Opening relay");
  digitalWrite(UNSET_PIN, HIGH);
  delay(20);
  digitalWrite(UNSET_PIN, LOW);
  isOpen = true;
}
void setup() {
  Serial.begin(115200);
  delay(1000); // give me time to bring up serial monitor
  Serial.println("ESP32 Water Shut-Off Controller");
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
  ResourceNode * nodeRoot    = new ResourceNode("/", "GET", &handleRoot);
  ResourceNode * nodeOpen    = new ResourceNode("/open", "GET", &handleOpenRelay);
  ResourceNode * nodeClose   = new ResourceNode("/close", "GET", &handleCloseRelay);
  ResourceNode * node404     = new ResourceNode("", "GET", &handle404);
  server.registerNode(nodeRoot);
  server.registerNode(nodeOpen);
  server.registerNode(nodeClose);
  server.setDefaultNode(node404);
  Serial.println("Starting server...");
  server.start();
  if (server.isRunning()) {
    Serial.println("Server ready.");
  }
}
void loop() {
  const int value = touchRead(SENSOR_PIN);
  if(value < LOW_SENSE_THRESHOLD && isOpen == true) {
    closeRelay();
  }
  if(value > HIGH_SENSE_THRESHOLD && isOpen == false) {
    openRelay();
  }
  server.loop();
}
void handleOpenRelay(HTTPRequest * req, HTTPResponse * res) {
  openRelay();
  handleRoot(req, res);
}
void handleCloseRelay(HTTPRequest * req, HTTPResponse * res) {
  closeRelay();
  handleRoot(req, res);
}
void handleRoot(HTTPRequest * req, HTTPResponse * res) {
  res->setHeader("Content-Type", "text/html");
  res->println("<!DOCTYPE html>");
  res->println("<html>");
  res->println("<head><title>ESP32 Water Shut-Off Controller</title></head>");
  res->println("<body>");
  if(isOpen) {
    res->println("<h1>The relay is open</h1>");
  } else {
    res->println("<h1>The relay is closed</h1>");
  }
  res->print("<p>Your server is running for ");
  res->print((int)(millis()/1000), DEC);
  res->println(" seconds.</p>");
  res->println("</body>");
  res->println("</html>");
}
void handle404(HTTPRequest * req, HTTPResponse * res) {
  req->discardRequestBody();
  res->setStatusCode(404);
  res->setStatusText("Not Found");
  res->setHeader("Content-Type", "text/html");
  res->println("<!DOCTYPE html>");
  res->println("<html>");
  res->println("<head><title>Not Found</title></head>");
  res->println("<body><h1>404 Not Found</h1><p>The requested resource was not found on this server.</p></body>");
  res->println("</html>");
}
