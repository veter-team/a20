#!/usr/bin/env python3

import pygame
from pygame.locals import *

import sys, traceback, Ice
import MotorControl
import Sensor

from baseview import BaseView


class MotorControl(BaseView):
    "Display target and current wheel rotation speed. \
Send motor control commands."

    NEUTRAL = 0
    FASTER = 1
    SLOWER = 2
    LEFT = 3
    RIGHT = 4

    font_size = 10
    font_color = (255, 255, 0)
    border_width = 1 # 0 - no border
    border_color = (0, 0, 255) # blue
    speed_max = 127
    turn_max = 127
    inc_speed = 8
    inc_direction = 8

    
    def __init__(self, display_surf, viewport):
        super(MotorControl, self).__init__()
        
        self.display_surf = display_surf
        self.viewport = viewport
        self.font = pygame.font.Font('vera.ttf', self.font_size)

        self.title_surf = self.font.render('Motors target and actual speed', 
                                           True, 
                                           self.font_color)
        self.title_rect = self.title_surf.get_rect()
        self.title_rect.move_ip(viewport.left + 3, viewport.top + self.border_width + 3)

        self.hint_surf = self.font.render('Use awsd or arrow keys', 
                                           True, 
                                           self.font_color)
        self.hint_rect = self.hint_surf.get_rect()
        self.hint_rect.left = self.title_rect.left
        self.hint_rect.top = viewport.bottom - self.hint_rect.height - self.border_width

        self.direction_ctl = self.NEUTRAL
        self.speed_ctl = self.NEUTRAL
        self.speed = [0, 0, 0, 0]
        self.calculated_speed = [0, 0, 0, 0]
        self.turn_factor = 0
        self.v_scale = (viewport.height - 2 * (self.title_rect.bottom - viewport.top) - 2 * self.border_width) / 2 / self.speed_max


    def update_visuals(self):
        # Outer rectangle
        if self.border_width > 0:
            pygame.draw.rect(self.display_surf,
                             self.border_color,
                             self.viewport,
                             self.border_width)

        # Draw title and hint
        self.display_surf.blit(self.title_surf, self.title_rect)
        self.display_surf.blit(self.hint_surf, self.hint_rect)

        if self.speed_ctl == self.FASTER:
            self.speed[0] += self.inc_speed
            if self.speed[0] > self.speed_max:
                self.speed[0] = self.speed_max

            self.speed[2] += self.inc_speed
            if self.speed[2] > self.speed_max:
                self.speed[2] = self.speed_max

        elif self.speed_ctl == self.SLOWER:
            self.speed[0] -= self.inc_speed
            if self.speed[0] < -self.speed_max:
                self.speed[0] = -self.speed_max

            self.speed[2] -= self.inc_speed
            if self.speed[2] < -self.speed_max:
                self.speed[2] = -self.speed_max

        if self.direction_ctl == self.RIGHT:
            self.turn_factor -= self.inc_direction
            if self.turn_factor < -self.turn_max:
                self.turn_factor = -self.turn_max
        elif self.direction_ctl == self.LEFT:
            self.turn_factor += self.inc_direction
            if self.turn_factor > self.turn_max:
                self.turn_factor = self.turn_max

        # Update speed to achieve requested turn factor
        self.calculated_speed[0] = self.speed[0] - self.turn_factor
        self.calculated_speed[2] = self.speed[2] + self.turn_factor

        if self.calculated_speed[0] > self.speed_max:
            d = self.calculated_speed[0] - self.speed_max
            self.calculated_speed[0] = self.speed_max
            self.calculated_speed[2] -= d
        elif self.calculated_speed[0] < -self.speed_max:
            d = -(self.calculated_speed[0] + self.speed_max)
            self.calculated_speed[0] = -self.speed_max
            self.calculated_speed[2] += d

        if self.calculated_speed[2] > self.speed_max:
            d = self.calculated_speed[2] - self.speed_max
            self.calculated_speed[2] = self.speed_max
            self.calculated_speed[0] -= d
        elif self.calculated_speed[2] < -self.speed_max:
            d = -(self.calculated_speed[2] + self.speed_max)
            self.calculated_speed[2] = -self.speed_max
            self.calculated_speed[0] += d

        x = self.title_rect.left
        spacing = 5
        bar_w = (self.viewport.width - 2 * (x - self.viewport.left)) / len(self.calculated_speed) - spacing
        y = self.viewport.top + self.viewport.height / 2
        for h in self.calculated_speed:
            h *= self.v_scale
            if h >= 0:
                pygame.draw.rect(self.display_surf,
                                 (0, 128, 0),
                                 (x, y-h, bar_w, h),
                                 0)
            else:
                pygame.draw.rect(self.display_surf,
                                 (0, 128, 0),
                                 (x, y, bar_w, -h),
                                 0)
            x += bar_w + spacing

            
    def process_events(self, new_events):
        for event in new_events:
            if event.type == QUIT:
                pass
            elif event.type == KEYDOWN:
                if event.key == K_LEFT or event.key == K_a:
                    self.direction_ctl = self.LEFT
                elif event.key == K_RIGHT or event.key == K_d:
                    self.direction_ctl = self.RIGHT
                elif event.key == K_UP or event.key == K_w:
                    self.speed_ctl = self.FASTER
                elif event.key == K_DOWN or event.key == K_s:
                    self.speed_ctl = self.SLOWER
            elif event.type == KEYUP:
                if event.key == K_LEFT or event.key == K_a or event.key == K_RIGHT or event.key == K_d:
                    self.direction_ctl = self.NEUTRAL
                elif event.key == K_UP or event.key == K_w or event.key == K_DOWN or event.key == K_s:
                    self.speed_ctl = self.NEUTRAL


    def get_supported_sensor_types(self):
        return [Sensor.speed, Sensor.accelx, Sensor.accely]
