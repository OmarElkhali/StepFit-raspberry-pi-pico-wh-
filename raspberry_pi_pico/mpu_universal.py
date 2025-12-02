"""
Bibliothèque MPU universelle
Supporte MPU6050, MPU6500 et MPU9250
Compatible Raspberry Pi Pico WH
"""

from machine import I2C
import time

class MPU:
    """Classe universelle pour MPU6050/MPU6500/MPU9250"""
    
    # Registres communs
    PWR_MGMT_1 = 0x6B
    GYRO_CONFIG = 0x1B
    ACCEL_CONFIG = 0x1C
    CONFIG = 0x1A
    SMPLRT_DIV = 0x19
    WHO_AM_I = 0x75
    
    # Registres de données
    ACCEL_XOUT_H = 0x3B
    GYRO_XOUT_H = 0x43
    TEMP_OUT_H = 0x41
    
    def __init__(self, i2c, addr=0x68):
        self.i2c = i2c
        self.addr = addr
        self.mpu_type = "Unknown"
        
        # Détecter le type de MPU
        self._detect_mpu()
        
        # Réveiller le MPU
        self.i2c.writeto_mem(self.addr, self.PWR_MGMT_1, b'\x00')
        time.sleep(0.1)
        
        # Configuration optimisée
        self._configure()
    
    def _detect_mpu(self):
        """Détecte le type de MPU connecté"""
        try:
            who_am_i = self.i2c.readfrom_mem(self.addr, self.WHO_AM_I, 1)[0]
            
            if who_am_i == 0x68:
                self.mpu_type = "MPU6050"
            elif who_am_i == 0x70:
                self.mpu_type = "MPU6500"
            elif who_am_i == 0x71:
                self.mpu_type = "MPU9250"
            else:
                self.mpu_type = f"Unknown (0x{who_am_i:02X})"
            
            print(f"[MPU] Type détecté: {self.mpu_type}")
        except Exception as e:
            print(f"[MPU] Erreur détection: {e}")
    
    def _configure(self):
        """Configure le MPU avec des paramètres optimisés"""
        try:
            # Gyroscope: ±250°/s (meilleur pour détection de pas)
            self.i2c.writeto_mem(self.addr, self.GYRO_CONFIG, b'\x00')
            
            # Accéléromètre: ±2g (meilleur pour détection de pas)
            self.i2c.writeto_mem(self.addr, self.ACCEL_CONFIG, b'\x00')
            
            # Low Pass Filter: 20Hz (réduit le bruit)
            # Important pour MPU6500/MPU9250
            self.i2c.writeto_mem(self.addr, self.CONFIG, b'\x04')
            
            # Sample Rate Divider: 100Hz (1kHz / (1 + 9) = 100Hz)
            self.i2c.writeto_mem(self.addr, self.SMPLRT_DIV, b'\x09')
            
            print(f"[MPU] Configuration appliquée pour {self.mpu_type}")
        except Exception as e:
            print(f"[MPU] Erreur configuration: {e}")
    
    def read_raw_data(self, reg):
        """Lit 2 bytes et les convertit en valeur signée"""
        high = self.i2c.readfrom_mem(self.addr, reg, 1)
        low = self.i2c.readfrom_mem(self.addr, reg+1, 1)
        value = (high[0] << 8) | low[0]
        if value > 32768:
            value = value - 65536
        return value
    
    def get_accel_data(self):
        """Lit les données de l'accéléromètre (en g)"""
        acc_x = self.read_raw_data(self.ACCEL_XOUT_H) / 16384.0
        acc_y = self.read_raw_data(self.ACCEL_XOUT_H + 2) / 16384.0
        acc_z = self.read_raw_data(self.ACCEL_XOUT_H + 4) / 16384.0
        return {'x': acc_x, 'y': acc_y, 'z': acc_z}
    
    def get_gyro_data(self):
        """Lit les données du gyroscope (en °/s)"""
        gyro_x = self.read_raw_data(self.GYRO_XOUT_H) / 131.0
        gyro_y = self.read_raw_data(self.GYRO_XOUT_H + 2) / 131.0
        gyro_z = self.read_raw_data(self.GYRO_XOUT_H + 4) / 131.0
        return {'x': gyro_x, 'y': gyro_y, 'z': gyro_z}
    
    def get_temp(self):
        """Lit la température du capteur (en °C)"""
        temp_raw = self.read_raw_data(self.TEMP_OUT_H)
        temp_c = (temp_raw / 340.0) + 36.53
        return temp_c
    
    def get_all_data(self):
        """Lit toutes les données en une fois (optimisé)"""
        return {
            'accel': self.get_accel_data(),
            'gyro': self.get_gyro_data(),
            'temp': self.get_temp()
        }


# Alias pour compatibilité avec le code existant
class MPU6050(MPU):
    """Alias MPU6050 pour compatibilité"""
    pass

class MPU6500(MPU):
    """Alias MPU6500"""
    pass

class MPU9250(MPU):
    """Alias MPU9250"""
    pass
