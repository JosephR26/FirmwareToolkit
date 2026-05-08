#!/usr/bin/env python3
"""
Serial Port Testing Utility
Automated testing tool for ESP32 firmware via serial communication
"""

import serial
import serial.tools.list_ports
import time
import sys
import argparse
from datetime import datetime


class SerialTester:
    def __init__(self, port=None, baudrate=115200, timeout=5):
        """Initialize serial tester"""
        self.port = port or self.auto_detect_port()
        self.baudrate = baudrate
        self.timeout = timeout
        self.serial = None

    def auto_detect_port(self):
        """Auto-detect ESP32 serial port"""
        ports = serial.tools.list_ports.comports()
        for port in ports:
            # Common ESP32 USB-UART chips
            if any(chip in port.description.lower() for chip in ['cp210', 'ch340', 'ftdi']):
                print(f"[INFO] Auto-detected port: {port.device}")
                return port.device

        if ports:
            print(f"[WARNING] Could not auto-detect ESP32, using: {ports[0].device}")
            return ports[0].device

        raise Exception("No serial ports found")

    def connect(self):
        """Connect to serial port"""
        try:
            self.serial = serial.Serial(
                port=self.port,
                baudrate=self.baudrate,
                timeout=self.timeout
            )
            print(f"[SUCCESS] Connected to {self.port} @ {self.baudrate} baud")
            time.sleep(2)  # Wait for ESP32 to reset
            return True
        except serial.SerialException as e:
            print(f"[ERROR] Failed to connect: {e}")
            return False

    def disconnect(self):
        """Disconnect from serial port"""
        if self.serial and self.serial.is_open:
            self.serial.close()
            print("[INFO] Disconnected")

    def read_line(self, timeout=None):
        """Read a line from serial"""
        if timeout:
            old_timeout = self.serial.timeout
            self.serial.timeout = timeout

        try:
            line = self.serial.readline().decode('utf-8', errors='ignore').strip()
            return line
        finally:
            if timeout:
                self.serial.timeout = old_timeout

    def send_command(self, command):
        """Send command to ESP32"""
        self.serial.write(f"{command}\n".encode('utf-8'))
        time.sleep(0.1)

    def wait_for_pattern(self, pattern, timeout=10):
        """Wait for a specific pattern in serial output"""
        start_time = time.time()
        while (time.time() - start_time) < timeout:
            line = self.read_line(timeout=1)
            if line and pattern.lower() in line.lower():
                return True, line
        return False, None

    def test_boot_sequence(self):
        """Test that ESP32 boots correctly"""
        print("\n[TEST] Boot Sequence")
        print("-" * 50)

        success, line = self.wait_for_pattern("setup", timeout=10)
        if success:
            print(f"[PASS] Boot detected: {line}")
            return True
        else:
            print("[FAIL] Boot not detected within timeout")
            return False

    def test_heartbeat(self, duration=30):
        """Test that firmware is sending heartbeat messages"""
        print(f"\n[TEST] Heartbeat Detection ({duration}s)")
        print("-" * 50)

        start_time = time.time()
        heartbeat_count = 0

        while (time.time() - start_time) < duration:
            line = self.read_line(timeout=1)
            if line:
                print(f"  {line}")
                if "heartbeat" in line.lower() or "loop" in line.lower():
                    heartbeat_count += 1

        if heartbeat_count > 0:
            print(f"[PASS] Detected {heartbeat_count} heartbeats")
            return True
        else:
            print("[FAIL] No heartbeats detected")
            return False

    def test_memory_stability(self, duration=60):
        """Test for memory leaks"""
        print(f"\n[TEST] Memory Stability ({duration}s)")
        print("-" * 50)

        memory_readings = []
        start_time = time.time()

        while (time.time() - start_time) < duration:
            line = self.read_line(timeout=1)
            if line and "heap" in line.lower():
                print(f"  {line}")
                # Extract memory value (assumes format like "Free Heap: 12345 bytes")
                try:
                    mem = int(''.join(filter(str.isdigit, line)))
                    memory_readings.append(mem)
                except ValueError:
                    pass

        if len(memory_readings) >= 2:
            initial = memory_readings[0]
            final = memory_readings[-1]
            leak = initial - final
            leak_percent = (leak / initial) * 100

            print(f"\n  Initial Heap: {initial} bytes")
            print(f"  Final Heap:   {final} bytes")
            print(f"  Leak:         {leak} bytes ({leak_percent:.2f}%)")

            if leak_percent < 10:  # Less than 10% leak is acceptable
                print("[PASS] Memory stable")
                return True
            else:
                print("[FAIL] Significant memory leak detected")
                return False
        else:
            print("[SKIP] Not enough memory readings")
            return None

    def run_all_tests(self):
        """Run all automated tests"""
        print("=" * 50)
        print("ESP32 Firmware Automated Test Suite")
        print("=" * 50)
        print(f"Port: {self.port}")
        print(f"Baudrate: {self.baudrate}")
        print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("=" * 50)

        if not self.connect():
            return False

        results = []

        try:
            results.append(("Boot Sequence", self.test_boot_sequence()))
            results.append(("Heartbeat", self.test_heartbeat(30)))
            results.append(("Memory Stability", self.test_memory_stability(60)))

            # Print summary
            print("\n" + "=" * 50)
            print("Test Summary")
            print("=" * 50)

            passed = sum(1 for _, result in results if result is True)
            failed = sum(1 for _, result in results if result is False)
            skipped = sum(1 for _, result in results if result is None)

            for name, result in results:
                status = "PASS" if result is True else ("FAIL" if result is False else "SKIP")
                print(f"  {name:.<40} {status}")

            print("=" * 50)
            print(f"Passed:  {passed}")
            print(f"Failed:  {failed}")
            print(f"Skipped: {skipped}")
            print("=" * 50)

            return failed == 0

        finally:
            self.disconnect()


def main():
    parser = argparse.ArgumentParser(description='ESP32 Serial Testing Utility')
    parser.add_argument('-p', '--port', help='Serial port (auto-detect if not specified)')
    parser.add_argument('-b', '--baudrate', type=int, default=115200, help='Baud rate (default: 115200)')
    parser.add_argument('-t', '--timeout', type=int, default=5, help='Timeout in seconds (default: 5)')

    args = parser.parse_args()

    tester = SerialTester(port=args.port, baudrate=args.baudrate, timeout=args.timeout)
    success = tester.run_all_tests()

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
