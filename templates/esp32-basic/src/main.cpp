/**
 * ESP32 Basic Template
 *
 * This template provides a solid starting point for ESP32 projects
 * with best practices for memory management and error handling.
 */

#include <Arduino.h>

// Configuration
#define SERIAL_BAUD 115200
#define LED_PIN 2  // Built-in LED on most ESP32 boards

// Function prototypes
void setup();
void loop();
void printSystemInfo();

/**
 * Setup function - runs once at startup
 */
void setup() {
    // Initialize serial communication
    Serial.begin(SERIAL_BAUD);
    while (!Serial && millis() < 3000); // Wait for serial or timeout

    Serial.println("\n\n========================================");
    Serial.println("ESP32 Firmware Starting...");
    Serial.println("========================================");

    // Initialize LED pin
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);

    // Print system information
    printSystemInfo();

    Serial.println("\n[INFO] Setup complete!");
    Serial.println("========================================\n");
}

/**
 * Main loop function
 */
void loop() {
    // Blink LED to show we're alive
    digitalWrite(LED_PIN, HIGH);
    delay(500);
    digitalWrite(LED_PIN, LOW);
    delay(500);

    // Print heartbeat
    static uint32_t loopCount = 0;
    loopCount++;

    if (loopCount % 10 == 0) {
        Serial.print("[HEARTBEAT] Loop: ");
        Serial.print(loopCount);
        Serial.print(" | Free Heap: ");
        Serial.print(ESP.getFreeHeap());
        Serial.println(" bytes");
    }

    // Add your code here
}

/**
 * Print system information
 */
void printSystemInfo() {
    Serial.println("\n[SYSTEM INFO]");
    Serial.print("  Chip Model: ");
    Serial.println(ESP.getChipModel());
    Serial.print("  Chip Revision: ");
    Serial.println(ESP.getChipRevision());
    Serial.print("  CPU Frequency: ");
    Serial.print(ESP.getCpuFreqMHz());
    Serial.println(" MHz");
    Serial.print("  Flash Size: ");
    Serial.print(ESP.getFlashChipSize() / 1024 / 1024);
    Serial.println(" MB");
    Serial.print("  Free Heap: ");
    Serial.print(ESP.getFreeHeap());
    Serial.println(" bytes");
    Serial.print("  SDK Version: ");
    Serial.println(ESP.getSdkVersion());
}
