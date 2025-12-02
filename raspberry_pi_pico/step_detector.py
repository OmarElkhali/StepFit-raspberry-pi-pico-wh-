import time, math

class StepDetector:
    def __init__(self, step_length=0.7):
        self.prev_mag = 0
        self.step_count = 0
        self.step_times = []
        self.recent_deltas = []
        self.smoothed = 0
        self.step_length = step_length
        self.window = 20
        self.debounce_ms = 300
    
    def update(self, magnitude):
        now = time.ticks_ms()
        delta = abs(magnitude - self.prev_mag)
        
        # smooth
        self.smoothed = 0.3 * delta + 0.7 * self.smoothed
        
        # window for threshold
        self.recent_deltas.append(self.smoothed)
        if len(self.recent_deltas) > self.window:
            self.recent_deltas.pop(0)
        
        avg = sum(self.recent_deltas) / len(self.recent_deltas)
        threshold = max(0.2, avg * 1.5)
        
        step_detected = False
        if self.smoothed > threshold and time.ticks_diff(now, self._last_step()) > self.debounce_ms:
            self.step_count += 1
            self.step_times.append(now)
            step_detected = True
        
        self.prev_mag = magnitude  # Move this line here (was after return)
        return step_detected
    
    def _last_step(self):
        return self.step_times[-1] if self.step_times else 0
    
    def get_speed(self):
        if len(self.step_times) < 2:
            return 0.0
        
        times = self.step_times[-5:]
        duration = (times[-1] - times[0]) / 1000.0
        if duration <= 0:
            return 0.0
        
        steps = len(times) - 1
        return (steps / duration) * self.step_length