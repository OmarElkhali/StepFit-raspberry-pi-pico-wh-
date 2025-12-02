"""
Test MPU9250/MPU6500 avec Raspberry Pi Pico WH
Détecte automatiquement MPU6050, MPU6500 ou MPU9250
"""

from machine import Pin, I2C
import time

# Configuration I2C
i2c = I2C(0, scl=Pin(1), sda=Pin(0), freq=400000)

print("\n" + "="*50)
print("Test MPU9250/MPU6500 - Raspberry Pi Pico WH")
print("="*50 + "\n")

# Scanner les adresses I2C
print("[1] Scan des adresses I2C...")
devices = i2c.scan()

if not devices:
    print("❌ Aucun périphérique I2C détecté!")
    print("\nVérifiez le câblage:")
    print("  - SDA → GPIO 0 (Pin 1)")
    print("  - SCL → GPIO 1 (Pin 2)")
    print("  - VCC → 3.3V")
    print("  - GND → GND")
else:
    print(f"✓ {len(devices)} périphérique(s) détecté(s):")
    for addr in devices:
        print(f"  - Adresse: 0x{addr:02X}")
        
        # Identifier le type de capteur
        if addr == 0x68 or addr == 0x69:
            print(f"    → MPU6050/MPU6500/MPU9250 détecté !")
            
            # Lire le WHO_AM_I register
            try:
                who_am_i = i2c.readfrom_mem(addr, 0x75, 1)[0]
                print(f"    WHO_AM_I: 0x{who_am_i:02X}")
                
                if who_am_i == 0x68:
                    print("    Type: MPU6050")
                elif who_am_i == 0x70:
                    print("    Type: MPU6500")
                elif who_am_i == 0x71:
                    print("    Type: MPU9250")
                else:
                    print(f"    Type: Inconnu (WHO_AM_I = 0x{who_am_i:02X})")
            except Exception as e:
                print(f"    ⚠️  Erreur lecture WHO_AM_I: {e}")

print("\n[2] Test de communication avec le capteur...")

# Adresse par défaut MPU
MPU_ADDR = 0x68

try:
    # Réveiller le MPU (PWR_MGMT_1 = 0x6B)
    i2c.writeto_mem(MPU_ADDR, 0x6B, b'\x00')
    time.sleep(0.1)
    print("✓ Capteur réveillé")
    
    # Lire WHO_AM_I
    who_am_i = i2c.readfrom_mem(MPU_ADDR, 0x75, 1)[0]
    print(f"✓ WHO_AM_I: 0x{who_am_i:02X}")
    
    # Configuration pour MPU6500/MPU9250 (meilleure précision)
    if who_am_i in [0x70, 0x71]:
        print("\n[3] Configuration optimisée pour MPU6500/MPU9250...")
        
        # Gyroscope: ±250°/s (meilleur pour les pas)
        i2c.writeto_mem(MPU_ADDR, 0x1B, b'\x00')
        
        # Accéléromètre: ±2g (meilleur pour les pas)
        i2c.writeto_mem(MPU_ADDR, 0x1C, b'\x00')
        
        # Low Pass Filter: 20Hz (réduit le bruit)
        i2c.writeto_mem(MPU_ADDR, 0x1A, b'\x04')
        
        # Sample Rate: 100Hz (bon compromis)
        i2c.writeto_mem(MPU_ADDR, 0x19, b'\x09')
        
        print("✓ Configuration appliquée")
    
    # Test lecture accéléromètre
    print("\n[4] Test lecture accéléromètre...")
    for i in range(5):
        # Lire X, Y, Z
        raw_x = i2c.readfrom_mem(MPU_ADDR, 0x3B, 2)
        raw_y = i2c.readfrom_mem(MPU_ADDR, 0x3D, 2)
        raw_z = i2c.readfrom_mem(MPU_ADDR, 0x3F, 2)
        
        # Convertir
        x = (raw_x[0] << 8 | raw_x[1])
        y = (raw_y[0] << 8 | raw_y[1])
        z = (raw_z[0] << 8 | raw_z[1])
        
        # Signé
        if x > 32768: x -= 65536
        if y > 32768: y -= 65536
        if z > 32768: z -= 65536
        
        # Convertir en g
        x_g = x / 16384.0
        y_g = y / 16384.0
        z_g = z / 16384.0
        
        print(f"  Lecture {i+1}: X={x_g:6.3f}g  Y={y_g:6.3f}g  Z={z_g:6.3f}g")
        time.sleep(0.2)
    
    # Test gyroscope
    print("\n[5] Test lecture gyroscope...")
    for i in range(5):
        # Lire X, Y, Z
        raw_x = i2c.readfrom_mem(MPU_ADDR, 0x43, 2)
        raw_y = i2c.readfrom_mem(MPU_ADDR, 0x45, 2)
        raw_z = i2c.readfrom_mem(MPU_ADDR, 0x47, 2)
        
        # Convertir
        x = (raw_x[0] << 8 | raw_x[1])
        y = (raw_y[0] << 8 | raw_y[1])
        z = (raw_z[0] << 8 | raw_z[1])
        
        # Signé
        if x > 32768: x -= 65536
        if y > 32768: y -= 65536
        if z > 32768: z -= 65536
        
        # Convertir en °/s
        x_dps = x / 131.0
        y_dps = y / 131.0
        z_dps = z / 131.0
        
        print(f"  Lecture {i+1}: X={x_dps:7.2f}°/s  Y={y_dps:7.2f}°/s  Z={z_dps:7.2f}°/s")
        time.sleep(0.2)
    
    # Test température
    print("\n[6] Test lecture température...")
    for i in range(3):
        raw_temp = i2c.readfrom_mem(MPU_ADDR, 0x41, 2)
        temp_raw = (raw_temp[0] << 8 | raw_temp[1])
        if temp_raw > 32768:
            temp_raw -= 65536
        temp_c = (temp_raw / 340.0) + 36.53
        print(f"  Lecture {i+1}: {temp_c:.1f}°C")
        time.sleep(0.5)
    
    print("\n" + "="*50)
    print("✅ TOUS LES TESTS RÉUSSIS!")
    print("="*50)
    print("\nVotre capteur MPU6500/MPU9250 fonctionne correctement!")
    print("Vous pouvez maintenant utiliser main_bluetooth.py")
    
except OSError as e:
    print(f"\n❌ Erreur de communication I2C: {e}")
    print("\nVérifiez:")
    print("  1. Le câblage (SDA/SCL/VCC/GND)")
    print("  2. L'adresse I2C (0x68 ou 0x69)")
    print("  3. L'alimentation 3.3V (pas 5V !)")
    
except Exception as e:
    print(f"\n❌ Erreur: {e}")
