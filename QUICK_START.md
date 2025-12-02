# Quick Start Guide - Bluetooth Pedometer

## 📱 Testing on Physical Android Device

### Prerequisites
✅ Raspberry Pi Pico WH 2022 with MPU6500 sensor
✅ Power bank with micro-USB cable
✅ Android phone (Android 5.0+)
✅ USB cable (for initial firmware upload)

### Step 1: Upload Firmware to Pico WH

1. Connect Pico WH to computer via USB
2. Hold BOOTSEL button while connecting (appears as USB drive)
3. Copy these files to Pico:
   - `raspberry_pi_pico/main_bluetooth.py` → rename to `main.py`
   - `raspberry_pi_pico/mpu6050.py` (universal MPU library)
   - `raspberry_pi_pico/step_detector.py`
4. Disconnect USB and reconnect
5. Pico should start broadcasting "PicoW-Steps"

**Verify firmware is running:**
- LED should blink (if enabled in code)
- Or reconnect USB and check serial output in Thonny

### Step 2: Install Flutter App on Android

#### Option A: Install pre-built APK
```powershell
# APK already built at:
# Flutter-Steps-Tracker\build\app\outputs\flutter-apk\app-debug.apk

# Transfer to phone and install
# Or use ADB:
adb install build\app\outputs\flutter-apk\app-debug.apk
```

#### Option B: Build from source
```powershell
cd "c:\Users\SetupGame\Desktop\IOT\Flutter-Steps-Tracker"
flutter build apk --release
# APK at: build\app\outputs\flutter-apk\app-release.apk
```

### Step 3: Power Pico WH with Power Bank

1. Disconnect Pico from computer
2. Connect micro-USB cable from power bank to Pico WH
3. Turn on power bank
4. Wait 5 seconds for Pico to boot and start broadcasting

**Verification:**
- Power bank should show charging/power indicator
- Pico's LED may blink (depending on firmware)
- Device is now portable and battery-powered

### Step 4: Connect via Flutter App

1. **Launch App** on Android phone
   - First time: Complete onboarding form (name, age, weight, height, daily goal)
   - App will open to Main Dashboard

2. **Enable Bluetooth & Location**
   - Grant Bluetooth permissions when prompted
   - Enable Location (Android requirement for BLE scanning)

3. **Scan for Pico WH**
   - Tap **Bluetooth icon** in top-right corner
   - Tap **"Scan for Devices"** button
   - Wait for "PicoW-Steps" to appear in list

4. **Connect**
   - Tap **"Connect"** button next to "PicoW-Steps"
   - Wait for green "✓ Connecté au Pico WH" message
   - App will return to dashboard with live data

### Step 5: View Real-Time Data

**Main Dashboard shows:**
- 📊 Circular gauge: Steps / Daily goal (e.g., 5000/10000)
- 🏃 Speed card: Current speed in km/h
- 📏 Distance card: Total distance in km
- 🔥 Calories card: Calories burned
- 🎯 Progress card: Percentage of daily goal

**Sensor Monitor (advanced):**
- Tap **Sensor Monitor** icon (🔬)
- View detailed sensor data:
  - 🌡️ Temperature
  - 📈 Accelerometer X/Y/Z with history graph
  - 🧭 Gyroscope X/Y/Z with 3D orientation
  - ⚡ Connection status

### Step 6: Test Walking

1. Hold phone and carry Pico in pocket/backpack
2. Walk around (at least 20 steps)
3. Watch dashboard update every 500ms
4. Verify:
   - Steps increase
   - Speed shows current walking speed
   - Distance increases
   - Calories increase

## 🔧 Troubleshooting

### Problem: "PicoW-Steps" not found when scanning

**Solutions:**
- ✅ Ensure Pico is powered (check power bank LED)
- ✅ Restart Pico (disconnect/reconnect power)
- ✅ Enable Bluetooth on phone (Settings → Bluetooth)
- ✅ Grant Location permission (Android requirement)
- ✅ Try scanning again (10 second timeout)
- ✅ Check firmware is correctly uploaded (reconnect to PC and verify files)

### Problem: Connection fails or drops

**Solutions:**
- ✅ Reduce distance (stay within 5-10 meters)
- ✅ Remove obstacles (metal, walls can block BLE)
- ✅ Check power bank is charged
- ✅ Verify MPU6500 wiring (GPIO0=SDA, GPIO1=SCL)
- ✅ Restart both Pico and app

### Problem: Steps not increasing

**Solutions:**
- ✅ Walk at normal pace (not too slow)
- ✅ Hold Pico upright (sensor orientation matters)
- ✅ Check accelerometer in Sensor Monitor (should show movement)
- ✅ Verify MPU6500 is working (run test_mpu9250.py)
- ✅ Threshold may need adjustment in step_detector.py

### Problem: App crashes or freezes

**Solutions:**
- ✅ Clear app cache (Settings → Apps → Flutter Steps Tracker → Clear Cache)
- ✅ Reinstall app
- ✅ Check Android version (minimum: Android 5.0)
- ✅ Ensure sufficient RAM (close other apps)

## 📊 Expected Data Ranges

### When Standing Still
- Steps: No change
- Speed: 0.0 km/h
- Distance: No change
- Accel Z: ~1.0g (gravity)
- Accel X/Y: ~0.0g
- Gyro X/Y/Z: ~0-2°/s (sensor noise)
- Temperature: 35-40°C (warm due to electronics)

### When Walking (Normal Pace)
- Steps: +2-3 steps/second
- Speed: 3-6 km/h
- Distance: Increases gradually
- Calories: ~3-5 cal/minute
- Accel: Oscillating pattern with peaks at ~1.2-1.5g
- Gyro: Oscillating ±20-50°/s
- Temperature: May increase slightly

## 🎯 Testing Checklist

- [ ] Firmware uploaded to Pico WH
- [ ] Power bank charged and connected
- [ ] Flutter app installed on phone
- [ ] Bluetooth enabled on phone
- [ ] Location permission granted
- [ ] "PicoW-Steps" found when scanning
- [ ] Connection successful (green message)
- [ ] Dashboard shows live data
- [ ] Steps increase when walking
- [ ] Speed shows correct value
- [ ] Distance increases
- [ ] Calories increase
- [ ] Sensor Monitor shows accelerometer movement
- [ ] Connection remains stable for 5+ minutes
- [ ] Can disconnect and reconnect

## 🔋 Battery Life Estimates

### Raspberry Pi Pico WH
- **Active BLE + Sensors**: ~15-20 hours on 10000mAh power bank
- **Optimization**: Adjust update interval (500ms → 1000ms) for 2x battery life

### Android Phone
- **BLE Scanning**: Minimal impact (~1-2% per hour)
- **Connected**: ~5-10% per hour (depends on screen usage)

## 📝 Next Steps After Successful Test

1. **Implement Auto-Reconnection**
   - Save last device ID
   - Reconnect on app launch

2. **Add Data Persistence**
   - Save daily steps to SQLite
   - Show weekly/monthly statistics

3. **Battery Monitoring**
   - Display Pico battery level
   - Low battery warning

4. **Optimize Performance**
   - Reduce update interval when not moving
   - Implement sleep mode

## 🚀 Advanced Features (Future)

- 📊 Daily/weekly/monthly charts
- 🏆 Achievement system
- 👥 Social features (leaderboards)
- ☁️ Cloud sync
- 📤 Export data (CSV/JSON)
- 🎨 Custom themes
- 📍 GPS integration
- ⌚ Smartwatch support

---

**Need Help?**
Check `BLUETOOTH_MIGRATION.md` for detailed documentation.

**Status**: ✅ Ready for testing!
