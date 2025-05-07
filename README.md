# LaserGate-Timer
Contains Arduino and Processing 4 code for implementing a laser based timing gate for line following robots in a closed circuit
A real-time timer and visualization for a line following robot, using Arduino and Processing. The timer starts when the laser beam is crossed, animates a progress path in Processing, and stops (or signals time-out) when the beam is broken again.

---

## 🧰 Hardware Requirements

- **Microcontroller**  
  - Arduino Uno **or** Arduino Nano (5 V logic)

- **Laser Emitter Module**  
  - 5 V laser diode module  
  - Power directly from Arduino’s 5 V pin **or** a 5 V buck converter (if using higher-voltage supply)

- **LDR Receiver Module**  
  - LDR (photoresistor) + simple comparator or voltage divider  
  - Connect LDR divider output to an Arduino analog/digital pin (A3 in code)

- **Buzzer**  
  - 5 V piezo buzzer on digital pin 9 for start/stop beeps

- **Wiring Diagram (simplified)**  
  ```text
   +5 V ──┬── Laser V+  
          ├── Buzzer V+ (via pin 9)  
          └── Vcc for LDR divider  
  GND  ──┬── Laser GND  
          ├── Buzzer GND  
          └── LDR divider GND  
  A3   ←── LDR divider output  
  D9   →── Buzzer drive

📦 Software Requirements

Arduino IDE (v1.8+)
Processing IDE (v3+)
Processing Serial Library (built-in)
Processing Sound Library (optional, for beeps)


⚙️ Installation & Setup

Upload Arduino Sketch
Open TraceRaceTimer.ino in Arduino IDE
Ensure laserPin = A3, buzzerPin = 9 match your wiring
Upload to your Uno/Nano


Identify Your Serial Port

In Processing, run:
println(Serial.list());
Note your Arduino port (e.g. /dev/tty.usbserial-1120 or COM3)

Configure & Run Processing Sketch

Open TraceRaceTimer.pde in Processing IDE

Set your port name:
String portName = "/dev/tty.usbserial-1120";  // or "COM3"
Press Run ▶; it will open fullscreen visualization

🚀 How It Works
Place Your Bot across the laser → serial message STATUS:PLACE_YOUR_BOT

Timer Ready! once the beam is first broken → STATUS:TIMER_READY

Timer Running… when the beam is cleared again → STATUS:TIMER_STARTED

Progress Path animates along a “snake” grid in Processing for up to 5 minutes

Timer Stops on next obstruction → STATUS:TIMER_STOPPED
