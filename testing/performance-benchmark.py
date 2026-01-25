#!/usr/bin/env python3
"""
ESP32 Performance Benchmark
Analyzes firmware performance metrics from serial output
"""

import serial
import serial.tools.list_ports
import time
import statistics
import argparse
from datetime import datetime


class PerformanceBenchmark:
    def __init__(self, port=None, baudrate=115200):
        """Initialize performance benchmark"""
        self.port = port or self.auto_detect_port()
        self.baudrate = baudrate
        self.serial = None
        self.metrics = {
            'loop_times': [],
            'memory_readings': [],
            'cpu_usage': [],
            'wifi_rssi': []
        }

    def auto_detect_port(self):
        """Auto-detect ESP32 port"""
        ports = serial.tools.list_ports.comports()
        for port in ports:
            if any(chip in port.description.lower() for chip in ['cp210', 'ch340', 'ftdi']):
                return port.device
        return ports[0].device if ports else None

    def connect(self):
        """Connect to serial port"""
        try:
            self.serial = serial.Serial(self.port, self.baudrate, timeout=1)
            time.sleep(2)
            print(f"[INFO] Connected to {self.port}")
            return True
        except Exception as e:
            print(f"[ERROR] Connection failed: {e}")
            return False

    def collect_metrics(self, duration=60):
        """Collect performance metrics for specified duration"""
        print(f"\n[INFO] Collecting metrics for {duration} seconds...")
        print("[INFO] Monitoring serial output...\n")

        start_time = time.time()
        last_print = time.time()

        while (time.time() - start_time) < duration:
            try:
                line = self.serial.readline().decode('utf-8', errors='ignore').strip()

                if line:
                    # Print live feed every 5 seconds
                    if time.time() - last_print > 5:
                        elapsed = int(time.time() - start_time)
                        print(f"[{elapsed}s] {line}")
                        last_print = time.time()

                    # Extract metrics
                    line_lower = line.lower()

                    # Memory readings
                    if 'heap' in line_lower or 'memory' in line_lower:
                        try:
                            mem = int(''.join(filter(str.isdigit, line)))
                            self.metrics['memory_readings'].append(mem)
                        except:
                            pass

                    # WiFi RSSI
                    if 'rssi' in line_lower:
                        try:
                            rssi = int(''.join(c for c in line if c.isdigit() or c == '-'))
                            self.metrics['wifi_rssi'].append(rssi)
                        except:
                            pass

                    # Loop time
                    if 'loop' in line_lower and 'ms' in line_lower:
                        try:
                            loop_time = float(''.join(c for c in line if c.isdigit() or c == '.'))
                            self.metrics['loop_times'].append(loop_time)
                        except:
                            pass

            except KeyboardInterrupt:
                print("\n[INFO] Benchmark interrupted by user")
                break
            except:
                pass

        self.serial.close()

    def analyze_metrics(self):
        """Analyze collected metrics and generate report"""
        print("\n" + "=" * 60)
        print("PERFORMANCE BENCHMARK REPORT")
        print("=" * 60)
        print(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"Port: {self.port}")
        print(f"Baudrate: {self.baudrate}")
        print("=" * 60)

        # Memory Analysis
        if self.metrics['memory_readings']:
            mem = self.metrics['memory_readings']
            print("\n[MEMORY ANALYSIS]")
            print(f"  Samples:     {len(mem)}")
            print(f"  Initial:     {mem[0]:,} bytes")
            print(f"  Final:       {mem[-1]:,} bytes")
            print(f"  Average:     {statistics.mean(mem):,.0f} bytes")
            print(f"  Min:         {min(mem):,} bytes")
            print(f"  Max:         {max(mem):,} bytes")
            print(f"  Std Dev:     {statistics.stdev(mem):,.0f} bytes" if len(mem) > 1 else "  Std Dev:     N/A")

            leak = mem[0] - mem[-1]
            leak_percent = (leak / mem[0]) * 100
            print(f"  Memory Leak: {leak:,} bytes ({leak_percent:.2f}%)")

            if leak_percent < 5:
                print("  Status:      ✓ GOOD - No significant leaks")
            elif leak_percent < 10:
                print("  Status:      ⚠ WARNING - Minor leak detected")
            else:
                print("  Status:      ✗ CRITICAL - Significant leak!")

        # Loop Time Analysis
        if self.metrics['loop_times']:
            loops = self.metrics['loop_times']
            print("\n[LOOP PERFORMANCE]")
            print(f"  Samples:     {len(loops)}")
            print(f"  Average:     {statistics.mean(loops):.2f} ms")
            print(f"  Min:         {min(loops):.2f} ms")
            print(f"  Max:         {max(loops):.2f} ms")
            print(f"  Median:      {statistics.median(loops):.2f} ms")
            print(f"  Std Dev:     {statistics.stdev(loops):.2f} ms" if len(loops) > 1 else "  Std Dev:     N/A")

            avg_loop = statistics.mean(loops)
            if avg_loop < 10:
                print("  Status:      ✓ EXCELLENT - Very responsive")
            elif avg_loop < 50:
                print("  Status:      ✓ GOOD - Acceptable performance")
            elif avg_loop < 100:
                print("  Status:      ⚠ WARNING - Slow loops")
            else:
                print("  Status:      ✗ CRITICAL - Very slow!")

        # WiFi RSSI Analysis
        if self.metrics['wifi_rssi']:
            rssi = self.metrics['wifi_rssi']
            print("\n[WIFI SIGNAL STRENGTH]")
            print(f"  Samples:     {len(rssi)}")
            print(f"  Average:     {statistics.mean(rssi):.1f} dBm")
            print(f"  Min:         {min(rssi)} dBm")
            print(f"  Max:         {max(rssi)} dBm")
            print(f"  Std Dev:     {statistics.stdev(rssi):.1f} dBm" if len(rssi) > 1 else "  Std Dev:     N/A")

            avg_rssi = statistics.mean(rssi)
            if avg_rssi > -50:
                print("  Status:      ✓ EXCELLENT - Strong signal")
            elif avg_rssi > -60:
                print("  Status:      ✓ GOOD - Adequate signal")
            elif avg_rssi > -70:
                print("  Status:      ⚠ FAIR - Weak signal")
            else:
                print("  Status:      ✗ POOR - Very weak signal")

        print("\n" + "=" * 60)
        print("END OF REPORT")
        print("=" * 60)


def main():
    parser = argparse.ArgumentParser(description='ESP32 Performance Benchmark')
    parser.add_argument('-p', '--port', help='Serial port')
    parser.add_argument('-b', '--baudrate', type=int, default=115200, help='Baud rate')
    parser.add_argument('-d', '--duration', type=int, default=60, help='Duration in seconds')

    args = parser.parse_args()

    benchmark = PerformanceBenchmark(port=args.port, baudrate=args.baudrate)

    if benchmark.connect():
        benchmark.collect_metrics(duration=args.duration)
        benchmark.analyze_metrics()


if __name__ == "__main__":
    main()
