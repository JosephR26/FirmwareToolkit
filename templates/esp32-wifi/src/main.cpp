/**
 * ESP32 WiFi Template
 *
 * Template for WiFi-enabled ESP32 projects with automatic reconnection
 * and best practices for network management.
 *
 * IMPORTANT: Create a 'config.h' file with your WiFi credentials
 */

#include <Arduino.h>
#include <WiFi.h>

// WiFi Configuration - REPLACE THESE OR USE config.h
#ifndef WIFI_SSID
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"
#endif

#define SERIAL_BAUD 115200
#define LED_PIN 2
#define WIFI_TIMEOUT_MS 20000
#define WIFI_RETRY_DELAY_MS 5000

// Function prototypes
void setup();
void loop();
void connectToWiFi();
void printSystemInfo();
void printWiFiInfo();

/**
 * Setup function
 */
void setup() {
    Serial.begin(SERIAL_BAUD);
    while (!Serial && millis() < 3000);

    Serial.println("\n\n========================================");
    Serial.println("ESP32 WiFi Firmware Starting...");
    Serial.println("========================================");

    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);

    printSystemInfo();

    // Set WiFi mode
    WiFi.mode(WIFI_STA);
    WiFi.setAutoReconnect(true);

    // Connect to WiFi
    connectToWiFi();

    Serial.println("\n[INFO] Setup complete!");
    Serial.println("========================================\n");
}

/**
 * Main loop
 */
void loop() {
    // Check WiFi connection status
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("[WARNING] WiFi disconnected - attempting reconnection...");
        digitalWrite(LED_PIN, HIGH);
        connectToWiFi();
    } else {
        // WiFi connected - slow blink
        digitalWrite(LED_PIN, HIGH);
        delay(100);
        digitalWrite(LED_PIN, LOW);
        delay(900);
    }

    // Print status periodically
    static uint32_t lastStatus = 0;
    if (millis() - lastStatus > 10000) {
        lastStatus = millis();
        Serial.print("[STATUS] Free Heap: ");
        Serial.print(ESP.getFreeHeap());
        Serial.print(" bytes | WiFi RSSI: ");
        Serial.print(WiFi.RSSI());
        Serial.println(" dBm");
    }

    // Add your code here
}

/**
 * Connect to WiFi with timeout and retry logic
 */
void connectToWiFi() {
    Serial.println("\n[WiFi] Connecting...");
    Serial.print("  SSID: ");
    Serial.println(WIFI_SSID);

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    uint32_t startAttempt = millis();

    while (WiFi.status() != WL_CONNECTED &&
           (millis() - startAttempt) < WIFI_TIMEOUT_MS) {
        digitalWrite(LED_PIN, !digitalRead(LED_PIN)); // Fast blink while connecting
        delay(500);
        Serial.print(".");
    }

    if (WiFi.status() == WL_CONNECTED) {
        Serial.println("\n[WiFi] Connected!");
        printWiFiInfo();
        digitalWrite(LED_PIN, HIGH);
    } else {
        Serial.println("\n[WiFi] Connection failed!");
        Serial.println("  Retrying in 5 seconds...");
        digitalWrite(LED_PIN, LOW);
        delay(WIFI_RETRY_DELAY_MS);
        connectToWiFi(); // Recursive retry
    }
}

/**
 * Print system information
 */
void printSystemInfo() {
    Serial.println("\n[SYSTEM INFO]");
    Serial.print("  Chip Model: ");
    Serial.println(ESP.getChipModel());
    Serial.print("  CPU Frequency: ");
    Serial.print(ESP.getCpuFreqMHz());
    Serial.println(" MHz");
    Serial.print("  Free Heap: ");
    Serial.print(ESP.getFreeHeap());
    Serial.println(" bytes");
    Serial.print("  MAC Address: ");
    Serial.println(WiFi.macAddress());
}

/**
 * Print WiFi connection information
 */
void printWiFiInfo() {
    Serial.println("\n[WiFi INFO]");
    Serial.print("  IP Address: ");
    Serial.println(WiFi.localIP());
    Serial.print("  Gateway: ");
    Serial.println(WiFi.gatewayIP());
    Serial.print("  Subnet Mask: ");
    Serial.println(WiFi.subnetMask());
    Serial.print("  DNS Server: ");
    Serial.println(WiFi.dnsIP());
    Serial.print("  RSSI: ");
    Serial.print(WiFi.RSSI());
    Serial.println(" dBm");
}
