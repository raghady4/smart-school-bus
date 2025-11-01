#include <SPI.h>
#include <MFRC522.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// ==== دوال معرفة مسبقاً ====
void handleButton();
void handlePIR();
void handleRFID();
void sendSensorData(float temperature, bool motion);
void sendNFCLog(String uid);

// ==== PIR Setup ====
int pirPin = 13;
int buttonPin = 15;
bool enabled = false;
unsigned long motionStartTime = 0;
bool motionActive = false;
const unsigned long requiredDuration = 2000;
bool lastButtonState = HIGH;
bool buttonState = HIGH;
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;


// ==== RFID Setup ====
#define SS_PIN 5
#define RST_PIN 22
MFRC522 mfrc522(SS_PIN, RST_PIN);

// ==== WiFi & API ====
const char* ssid = "Galaxy A1207B"; //Galaxy A1207B
const char* password = "soso 1234";
const char* sensorApiUrl = "http://192.168.186.176:8000/api/devices/3/sensors";
const char* nfcLogApiUrl = "http://192.168.186.176:8000/api/nfc_details";
const char* contentType = "application/json";

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  Serial.print("جاري الاتصال بشبكة WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nتم الاتصال بالشبكة!");

  pinMode(pirPin, INPUT);
  pinMode(buttonPin, INPUT_PULLUP);

  SPI.begin();
  mfrc522.PCD_Init();
  Serial.println("الرجاء وضع البطاقة أمام القارئ...");
}

void loop() {
  handleButton();
  handlePIR();
  handleRFID();
}

void handleButton() {
  int reading = digitalRead(buttonPin);
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading != buttonState) {
      buttonState = reading;
      if (buttonState == LOW) {
        enabled = true;
        Serial.println("تم تفعيل الحساس");
      } else {
        enabled = false;
        Serial.println("تم إيقاف الحساس");
      }
    }
  }
  lastButtonState = reading;
}

void handlePIR() {
  if (!enabled) return;

  int motion = digitalRead(pirPin);
  if (motion == HIGH) {
    if (!motionActive) {
      motionStartTime = millis();
      motionActive = true;
    } else if (millis() - motionStartTime >= requiredDuration) {
      Serial.println("تم الكشف عن حركة حقيقية!");
      sendSensorData(9.0, true);
      delay(2000);
    }
  } else {
    motionActive = false;
  }
}

void handleRFID() {
  if (!mfrc522.PICC_IsNewCardPresent()) return;
  if (!mfrc522.PICC_ReadCardSerial()) return;

  String uid = "";
  Serial.print("رقم البطاقة: ");
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    uid += String(mfrc522.uid.uidByte[i] < 0x10 ? "0" : "");
    uid += String(mfrc522.uid.uidByte[i], HEX);
  }
  uid.toUpperCase();
  Serial.println(uid);

  sendNFCLog(uid);

  mfrc522.PICC_HaltA();
  mfrc522.PCD_StopCrypto1();
  delay(500);
}

void sendSensorData(float temperature, bool motion) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(sensorApiUrl);
    http.addHeader("Content-Type", contentType);

    JsonDocument doc;
    doc["temperature"] = temperature;
    doc["motion"] = motion;

    String requestBody;
    serializeJson(doc, requestBody);
    Serial.println("Sending Sensor Data:");
    Serial.println(requestBody);

    int httpResponseCode = http.POST(requestBody);
    Serial.print("Sensor HTTP Response code: ");
    Serial.println(httpResponseCode);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println("Sensor Response:");
      Serial.println(response);
    }
    http.end();
  } else {
    Serial.println("WiFi غير متصل");
  }
}

void sendNFCLog(String uid) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi غير متصل (NFC)");
    return;
  }

  HTTPClient http;

  // 1. جلب log_id
  String fetchUrl = "http://192.168.186.176:8000/api/nfc-logs/fetch-log-id";
  http.begin(fetchUrl);
  http.addHeader("Content-Type", contentType);

  JsonDocument fetchDoc;
  fetchDoc["uid"] = uid;
  String fetchBody;
  serializeJson(fetchDoc, fetchBody);

  int fetchResponse = http.POST(fetchBody);
  if (fetchResponse != 200) {
Serial.println("❌ فشل في جلب log_id");
    http.end();
    return;
  }

  String response = http.getString();
  Serial.println("🔁 Log Response:");
  Serial.println(response);
  http.end();

  JsonDocument resDoc;
  deserializeJson(resDoc, response);
  int log_id = resDoc["log_id"];

  // 2. إرسال nfc_detail
  String detailsUrl = "http://192.168.186.176:8000/api/nfc-details";
  http.begin(detailsUrl);
  http.addHeader("Content-Type", contentType);

  JsonDocument detailDoc;
  detailDoc["log_id"] = log_id;

  String detailBody;
  serializeJson(detailDoc, detailBody);

  int detailsResponse = http.POST(detailBody);
  Serial.print("NFC Detail HTTP Response: ");
  Serial.println(detailsResponse);

  if (detailsResponse > 0) {
    Serial.println(http.getString());
  }

  http.end();
}
