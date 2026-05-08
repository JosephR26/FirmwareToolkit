#!/usr/bin/env python3
"""
Serial Port Manager with Auto-Detection and Favorites
Manages ESP32 serial ports with smart detection and history
"""

import serial
import serial.tools.list_ports
import json
import os
from datetime import datetime


class SerialPortManager:
    def __init__(self):
        self.config_file = os.path.expanduser("~/.esp32_ports.json")
        self.config = self.load_config()

    def load_config(self):
        """Load configuration from file"""
        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, 'r') as f:
                    return json.load(f)
            except (json.JSONDecodeError, OSError):
                pass
        return {"favorites": [], "history": [], "default": None}

    def save_config(self):
        """Save configuration to file"""
        with open(self.config_file, 'w') as f:
            json.dump(self.config, f, indent=2)

    def detect_esp32_ports(self):
        """Auto-detect ESP32 ports"""
        ports = []
        for port in serial.tools.list_ports.comports():
            # Common ESP32 USB-UART chips
            if any(chip in port.description.lower() for chip in
                   ['cp210', 'ch340', 'ftdi', 'usb serial', 'uart']):
                ports.append({
                    "port": port.device,
                    "description": port.description,
                    "hwid": port.hwid
                })
        return ports

    def add_favorite(self, port, name=None):
        """Add port to favorites"""
        fav = {
            "port": port,
            "name": name or port,
            "added": datetime.now().isoformat()
        }
        if fav not in self.config["favorites"]:
            self.config["favorites"].append(fav)
            self.save_config()
            print(f"✓ Added {port} to favorites")

    def remove_favorite(self, port):
        """Remove port from favorites"""
        self.config["favorites"] = [f for f in self.config["favorites"] if f["port"] != port]
        self.save_config()
        print(f"✓ Removed {port} from favorites")

    def add_to_history(self, port):
        """Add port to history"""
        entry = {
            "port": port,
            "timestamp": datetime.now().isoformat()
        }
        self.config["history"].insert(0, entry)
        # Keep only last 10
        self.config["history"] = self.config["history"][:10]
        self.save_config()

    def set_default(self, port):
        """Set default port"""
        self.config["default"] = port
        self.save_config()
        print(f"✓ Set {port} as default")

    def get_recommended_port(self):
        """Get recommended port (default > last used > auto-detected)"""
        # Check default
        if self.config.get("default"):
            return self.config["default"]

        # Check history
        if self.config["history"]:
            return self.config["history"][0]["port"]

        # Auto-detect
        detected = self.detect_esp32_ports()
        if detected:
            return detected[0]["port"]

        return None

    def list_ports(self):
        """List all information"""
        print("\n" + "="*60)
        print("ESP32 SERIAL PORT MANAGER")
        print("="*60)

        # Default port
        print(f"\n[DEFAULT PORT]")
        if self.config.get("default"):
            print(f"  {self.config['default']}")
        else:
            print(f"  (not set)")

        # Detected ports
        print(f"\n[DETECTED PORTS]")
        detected = self.detect_esp32_ports()
        if detected:
            for i, port in enumerate(detected, 1):
                print(f"  {i}. {port['port']} - {port['description']}")
        else:
            print(f"  No ESP32 ports detected")

        # Favorites
        print(f"\n[FAVORITES]")
        if self.config["favorites"]:
            for i, fav in enumerate(self.config["favorites"], 1):
                print(f"  {i}. {fav['name']} ({fav['port']})")
        else:
            print(f"  No favorites")

        # History
        print(f"\n[RECENT USAGE]")
        if self.config["history"]:
            for entry in self.config["history"][:5]:
                ts = entry["timestamp"][:19].replace('T', ' ')
                print(f"  {entry['port']} - {ts}")
        else:
            print(f"  No history")

        print(f"\n[RECOMMENDED PORT]")
        recommended = self.get_recommended_port()
        if recommended:
            print(f"  {recommended}")
        else:
            print(f"  None available")

        print("="*60 + "\n")


def main():
    import argparse

    parser = argparse.ArgumentParser(description='ESP32 Serial Port Manager')
    parser.add_argument('--list', action='store_true', help='List all ports and info')
    parser.add_argument('--detect', action='store_true', help='Detect ESP32 ports')
    parser.add_argument('--add-favorite', metavar='PORT', help='Add port to favorites')
    parser.add_argument('--remove-favorite', metavar='PORT', help='Remove from favorites')
    parser.add_argument('--set-default', metavar='PORT', help='Set default port')
    parser.add_argument('--get-recommended', action='store_true', help='Get recommended port')
    parser.add_argument('--name', metavar='NAME', help='Name for favorite port')

    args = parser.parse_args()

    manager = SerialPortManager()

    if args.list:
        manager.list_ports()
    elif args.detect:
        ports = manager.detect_esp32_ports()
        for port in ports:
            print(f"{port['port']}: {port['description']}")
    elif args.add_favorite:
        manager.add_favorite(args.add_favorite, args.name)
    elif args.remove_favorite:
        manager.remove_favorite(args.remove_favorite)
    elif args.set_default:
        manager.set_default(args.set_default)
    elif args.get_recommended:
        port = manager.get_recommended_port()
        if port:
            print(port)
        else:
            exit(1)
    else:
        manager.list_ports()


if __name__ == "__main__":
    main()
