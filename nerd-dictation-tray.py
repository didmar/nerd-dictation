#!/usr/bin/env python3
"""
Simple pystray-based system tray GUI for nerd-dictation
Cross-platform system tray icon
"""

import pystray
from PIL import Image, ImageDraw
import os
import subprocess
import tempfile
import threading
import time
import signal
import sys

class NerdDictationTray:
    def __init__(self):
        self.cookie_path = os.path.join(tempfile.gettempdir(), "nerd-dictation.cookie")
        self.nerd_dictation_toggle_cmd = "./toggle.sh"
        
        # Track current state
        self.current_state = "stopped"
        self.state_lock = threading.Lock()
        
        # Create icons
        self.icon_stopped = self.create_icon("red")
        self.icon_recording = self.create_icon("green")
        self.icon_suspended = self.create_icon("yellow")
        
        # Create the tray icon with menu
        self.tray_icon = pystray.Icon(
            "nerd-dictation",
            self.icon_stopped,
            "Nerd Dictation: Stopped",
            menu=self.create_menu()
        )
        
        # Start monitoring thread
        self.monitoring = True
        self.monitor_thread = threading.Thread(target=self.monitor_state, daemon=True)
        self.monitor_thread.start()
    
    def create_icon(self, color):
        """Create a simple colored circle icon"""
        # Create a 64x64 image
        image = Image.new('RGB', (64, 64), color='white')
        draw = ImageDraw.Draw(image)
        
        # Draw a circle
        if color == "red":
            fill_color = '#FF0000'
        elif color == "green":
            fill_color = '#00FF00'
        elif color == "yellow":
            fill_color = '#FFFF00'
        else:
            fill_color = '#808080'
        
        draw.ellipse([8, 8, 56, 56], fill=fill_color, outline='black', width=2)
        
        # Add microphone symbol
        draw.rectangle([28, 20, 36, 40], fill='black')
        draw.rectangle([26, 40, 38, 44], fill='black')
        draw.rectangle([30, 44, 34, 48], fill='black')
        
        return image
    
    def get_status_text(self):
        """Get current status text for menu"""
        with self.state_lock:
            return f"Status: {self.current_state.title()}"
    
    def create_menu(self):
        """Create the context menu"""
        return pystray.Menu(
            pystray.MenuItem(
                self.get_status_text,
                None,
                enabled=False
            ),
            pystray.Menu.SEPARATOR,
            pystray.MenuItem("Toggle Dictation", self.toggle_dictation),
            pystray.Menu.SEPARATOR,
            pystray.MenuItem("Quit", self.quit_app)
        )
    
    def get_dictation_state(self):
        """Get current dictation state"""
        if not os.path.exists(self.cookie_path):
            return "stopped"
        
        try:
            with open(self.cookie_path, 'r') as f:
                pid = int(f.read().strip())
            
            # Check if process is running
            try:
                os.kill(pid, 0)  # Signal 0 just checks if process exists
                return "running"
            except OSError:
                # Process doesn't exist, remove stale cookie
                try:
                    os.remove(self.cookie_path)
                except OSError:
                    pass
                return "stopped"
        except (ValueError, IOError):
            return "stopped"
    
    def update_status(self, new_state):
        """Update the tray icon and title based on state"""
        with self.state_lock:
            if new_state == self.current_state:
                return  # No change needed
            
            self.current_state = new_state
            
            # Update icon and title
            if new_state == "stopped":
                self.tray_icon.icon = self.icon_stopped
                self.tray_icon.title = "Nerd Dictation: Stopped"
            elif new_state == "running":
                self.tray_icon.icon = self.icon_recording
                self.tray_icon.title = "Nerd Dictation: Recording"
            elif new_state == "suspended":
                self.tray_icon.icon = self.icon_suspended
                self.tray_icon.title = "Nerd Dictation: Suspended"
            
            # Update menu
            self.tray_icon.menu = self.create_menu()
    
    def monitor_state(self):
        """Monitor dictation state in background thread"""
        while self.monitoring:
            try:
                current_state = self.get_dictation_state()
                self.update_status(current_state)
                time.sleep(2)  # Check every 2 seconds
            except Exception as e:
                print(f"Error monitoring state: {e}")
                time.sleep(5)  # Wait longer on error
    
    def toggle_dictation(self, icon=None, item=None):
        """Start or stop dictation"""
        try:
            subprocess.Popen([self.nerd_dictation_toggle_cmd])
            print("Toggling dictation...")
        except Exception as e:
            print(f"Error toggling dictation: {e}")
    
    def quit_app(self, icon=None, item=None):
        """Quit the application"""
        self.monitoring = False
        
        # Stop dictation if running
        try:
            if self.get_dictation_state() == "running":
                subprocess.Popen([self.nerd_dictation_toggle_cmd])
            print("Stopping dictation...")
        except Exception as e:
            print(f"Error stopping dictation during quit: {e}")
        
        # Stop the tray icon
        if icon:
            icon.stop()
        else:
            self.tray_icon.stop()
    
    def run(self):
        """Start the tray icon"""
        try:
            # Set up signal handlers
            def signal_handler(signum, frame):
                print(f"\nReceived signal {signum}, shutting down...")
                self.quit_app()
                sys.exit(0)
            
            signal.signal(signal.SIGINT, signal_handler)
            signal.signal(signal.SIGTERM, signal_handler)
            
            print("Starting tray icon...")
            self.tray_icon.run()
        except Exception as e:
            print(f"Error running tray icon: {e}")
            sys.exit(1)

def main():
    try:
        # Create and run tray
        tray = NerdDictationTray()
        tray.run()
    except KeyboardInterrupt:
        print("\nShutting down...")
        sys.exit(0)
    except Exception as e:
        print(f"Error: {e}")
        print("Make sure you have the required dependencies installed:")
        print("  pip install pystray Pillow")
        print("Or install system packages:")
        print("  sudo apt install python3-pystray python3-pil")
        sys.exit(1)

if __name__ == "__main__":
    main()
