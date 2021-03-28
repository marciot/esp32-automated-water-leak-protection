#define SENSOR_PIN 4  // Touch 0 pin = GPIO 4
#define SET_PIN    16 // Relay SET Pin = GPIO 16
#define UNSET_PIN  17 // Relay UNSET Pin = GPIO 17
#define LOW_SENSE_THRESHOLD 10 // Threshold for detecting water
#define HIGH_SENSE_THRESHOLD 50 // Threshold for detecting no water
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
  pinMode(SET_PIN, OUTPUT);
  pinMode(UNSET_PIN, OUTPUT);
  openRelay();
}
void loop() {
  const int value = touchRead(SENSOR_PIN);
  if(value < LOW_SENSE_THRESHOLD && isOpen == true) {
    closeRelay();
  }
  if(value > HIGH_SENSE_THRESHOLD && isOpen == false) {
    openRelay();
  }
  delay(1000); // Wait one second
}
