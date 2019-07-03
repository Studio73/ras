import time
import logging

import RPi.GPIO as GPIO

_logger = logging.getLogger(__name__)


class Button:
    def __init__(self, pins):

        GPIO.setmode(GPIO.BOARD)  # Sets GPIO pins to Board GPIO numbering
        self.pin_signal = pins[0]
        self.pin_power = pins[1]
        self.active = True
        GPIO.setup(self.pin_signal, GPIO.IN, pull_up_down=GPIO.PUD_UP)
        GPIO.setup(self.pin_power, GPIO.OUT)
        GPIO.output(self.pin_power, 0)
        self.pressed = False
        GPIO.add_event_detect(
            self.pin_signal,
            GPIO.BOTH,
            callback=self.scanning,
        )
        _logger.debug("Button Class Initialized")

    def scanning(self, channel):
        if self.active and GPIO.input(self.pin_signal):
            self.pressed = True
            _logger.debug("Button Pressed")
            time.sleep(0.02)

    def poweroff(self):
        self.active = False
        GPIO.output(self.pin_power, 0)
        _logger.debug("Button Power off")

    def poweron(self):
        self.active = True
        GPIO.output(self.pin_power, 1)
        _logger.debug("Button Power on")
