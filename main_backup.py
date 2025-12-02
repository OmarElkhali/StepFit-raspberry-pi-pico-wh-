from machine import Pin, I2C
import network
import time
import math
from mpu6050 import MPU6050
from step_detector import StepDetector
from simple_ws import SimpleWebSocketServer

# ---------- Wi-Fi setup ----------
SSID = "Fibre_inwi_81B3"
PASSWORD = "48DC2D7EF98B"

print("[INFO] Connecting to Wi-Fi...")
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(SSID, PASSWORD)

timeout = 15
start_time = time.time()
while not wlan.isconnected() and time.time() - start_time < timeout:
    print(".", end="")
    time.sleep(0.5)

if not wlan.isconnected():
    print("\n[ERROR] Failed to connect to Wi-Fi")
    raise SystemExit()

ip = wlan.ifconfig()[0]
print(f"\n[INFO] Connected! IP: {ip}")
print(f"[INFO] Connect to: ws://{ip}:80/ws")

# ---------- Start WebSocket Server ----------
ws_server = SimpleWebSocketServer(port=80)
ws_server.start()
time.sleep(2)

# ---------- MPU6050 & StepDetector ----------
print("[INFO] Initializing sensors...")
i2c = I2C(0, scl=Pin(1), sda=Pin(0))
mpu = MPU6050(i2c)
step_detector = StepDetector(step_length=0.7)

# ---------- Main Loop ----------
print("[INFO] Starting main loop...")
counter = 0

while True:
    try:
        # Read sensor
        accel = mpu.get_accel_data()
        magnitude = math.sqrt(accel['x']**2 + accel['y']**2 + accel['z']**2)
        
        # Detect steps
        if step_detector.update(magnitude):
            print(f"[STEP] {step_detector.step_count} steps @ {step_detector.get_speed():.2f} m/s")
        
        # Send to WebSocket clients every 0.5 seconds
        counter += 1
        if counter >= 10:
            counter = 0
            client_count = ws_server.get_client_count()
            if client_count > 0:
                message = '{"steps":%d,"speed":%.2f}' % (
                    step_detector.step_count,
                    step_detector.get_speed()
                )
                active = ws_server.broadcast(message)
                if active != client_count:
                    print(f"[WS] Active clients: {active}")
        
        time.sleep(0.05)
        
    except KeyboardInterrupt:
        print("\n[INFO] Shutting down...")
        break
    except Exception as e:
        print(f"[ERROR] {e}")
        import sys
        sys.print_exception(e)
        time.sleep(1)
