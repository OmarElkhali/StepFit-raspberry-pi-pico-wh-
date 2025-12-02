"""
Détecteur de pas avancé avec algorithmes améliorés
Utilise Zero-Crossing + Peak Detection + Frequency Analysis
"""
import time
import math

class AdvancedStepDetector:
    def __init__(self, step_length=0.7, user_weight=70):
        # Configuration utilisateur
        self.step_length = step_length  # mètres
        self.user_weight = user_weight  # kg
        
        # État de détection
        self.step_count = 0
        self.step_times = []
        
        # Historique pour analyse de fréquence
        self.accel_history = []
        self.history_max = 50
        
        # Variables pour Zero-Crossing
        self.prev_accel = 1.0
        self.last_zero_crossing = 0
        
        # Variables pour Peak Detection
        self.last_peak = 0
        self.peak_threshold = 0.3
        
        # Debounce pour éviter double comptage
        self.debounce_ms = 250  # ms entre chaque pas
        
        # Calories tracking
        self.start_time = time.ticks_ms()
        self.total_calories = 0.0
        
    def update(self, magnitude):
        """
        Detecte un pas en utilisant plusieurs techniques combinees
        
        Args:
            magnitude: Magnitude de l acceleration (sqrt(x^2 + y^2 + z^2))
            
        Returns:
            bool: True si un pas est detecte
        """
        now = time.ticks_ms()
        
        # Normaliser (enlever gravité ~1g)
        normalized = magnitude - 1.0
        
        # Ajouter à l'historique
        self.accel_history.append(normalized)
        if len(self.accel_history) > self.history_max:
            self.accel_history.pop(0)
        
        step_detected = False
        
        # Technique 1 : Zero-Crossing Detection
        # Détecte quand l'accélération passe de positif à négatif
        if self._detect_zero_crossing(normalized, now):
            # Technique 2 : Peak Validation
            # Vérifie que c'était un vrai pic (pas du bruit)
            if self._validate_peak(normalized, now):
                # Technique 3 : Frequency Check
                # Vérifie que la fréquence est dans la plage de marche (1.5-2.5 Hz)
                if self._check_frequency():
                    self.step_count += 1
                    self.step_times.append(now)
                    step_detected = True
                    
                    # Mettre à jour les calories
                    self._update_calories()
        
        self.prev_accel = normalized
        return step_detected
    
    def _detect_zero_crossing(self, accel, now):
        """Détecte le passage par zéro (positif → négatif)"""
        if self.prev_accel > 0 and accel <= 0:
            if time.ticks_diff(now, self.last_zero_crossing) > self.debounce_ms:
                self.last_zero_crossing = now
                return True
        return False
    
    def _validate_peak(self, accel, now):
        """Valide que c'était un vrai pic significatif"""
        if len(self.accel_history) < 5:
            return False
        
        # Calculer le seuil adaptatif basé sur l'historique récent
        recent = self.accel_history[-10:]
        avg = sum(abs(x) for x in recent) / len(recent)
        std = math.sqrt(sum((abs(x) - avg) ** 2 for x in recent) / len(recent))
        
        threshold = max(self.peak_threshold, avg + std)
        
        # Vérifier que le pic était assez grand
        max_recent = max(abs(x) for x in recent)
        return max_recent > threshold
    
    def _check_frequency(self):
        """Vérifie que la fréquence des pas est réaliste (1.5-2.5 Hz)"""
        if len(self.step_times) < 3:
            return True  # Pas assez de données, accepter
        
        # Analyser les 5 derniers pas
        recent_steps = self.step_times[-5:]
        if len(recent_steps) < 2:
            return True
        
        # Calculer la fréquence moyenne
        duration_ms = recent_steps[-1] - recent_steps[0]
        if duration_ms <= 0:
            return True
        
        frequency = (len(recent_steps) - 1) / (duration_ms / 1000.0)
        
        # Fréquence de marche normale : 1.5-2.5 Hz
        # Course : 2.5-4 Hz
        return 1.0 <= frequency <= 4.0
    
    def _update_calories(self):
        """Met à jour le calcul des calories basé sur le MET"""
        speed_kmh = self.get_speed() * 3.6  # m/s → km/h
        
        # Déterminer le MET (Metabolic Equivalent)
        if speed_kmh < 3.2:
            MET = 2.0  # Marche très lente
        elif speed_kmh < 4.8:
            MET = 3.5  # Marche normale
        elif speed_kmh < 6.4:
            MET = 5.0  # Marche rapide
        else:
            MET = 8.0  # Course
        
        # Temps écoulé depuis le dernier pas (en heures)
        if len(self.step_times) >= 2:
            duration_h = (self.step_times[-1] - self.step_times[-2]) / (1000.0 * 3600.0)
            # Calories = MET × poids × durée
            calories_increment = MET * self.user_weight * duration_h
            self.total_calories += calories_increment
    
    def get_speed(self):
        """
        Calcule la vitesse en m/s basée sur les derniers pas
        Plus précis que la version simple
        """
        if len(self.step_times) < 2:
            return 0.0
        
        # Utiliser une fenêtre glissante de 5 pas
        window_size = min(5, len(self.step_times))
        recent_times = self.step_times[-window_size:]
        
        if len(recent_times) < 2:
            return 0.0
        
        # Durée en secondes
        duration_s = (recent_times[-1] - recent_times[0]) / 1000.0
        
        if duration_s <= 0:
            return 0.0
        
        # Nombre de pas dans la fenêtre
        steps = len(recent_times) - 1
        
        # Distance = pas × longueur_pas
        distance = steps * self.step_length
        
        # Vitesse = distance / temps
        speed = distance / duration_s
        
        # Appliquer un facteur de correction basé sur la cadence
        cadence = steps / duration_s  # pas/seconde
        
        # Correction : les gens font des pas plus longs quand ils vont vite
        if cadence > 2.5:  # Course
            speed *= 1.15
        elif cadence < 1.5:  # Marche lente
            speed *= 0.95
        
        return speed
    
    def get_distance(self):
        """Calcule la distance totale en mètres"""
        return self.step_count * self.step_length
    
    def get_calories(self):
        """Retourne les calories brûlées"""
        return self.total_calories
    
    def reset(self):
        """Réinitialise tous les compteurs"""
        self.step_count = 0
        self.step_times = []
        self.accel_history = []
        self.total_calories = 0.0
        self.start_time = time.ticks_ms()
    
    def get_activity_type(self):
        """Détermine le type d'activité en cours"""
        speed_kmh = self.get_speed() * 3.6
        
        if speed_kmh < 0.5:
            return "Immobile"
        elif speed_kmh < 3.2:
            return "Marche lente"
        elif speed_kmh < 4.8:
            return "Marche"
        elif speed_kmh < 6.4:
            return "Marche rapide"
        else:
            return "Course"
    
    def get_cadence(self):
        """Retourne la cadence (pas/minute)"""
        if len(self.step_times) < 2:
            return 0.0
        
        recent = self.step_times[-5:]
        if len(recent) < 2:
            return 0.0
        
        duration_min = (recent[-1] - recent[0]) / (1000.0 * 60.0)
        if duration_min <= 0:
            return 0.0
        
        steps = len(recent) - 1
        return steps / duration_min
