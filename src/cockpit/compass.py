#!/usr/bin/env python3

import pygame
from pygame.locals import *

from collections import deque

from baseview import BaseView

import Sensor


class Compass(BaseView):
    "Display log output in scrolling window"

    font_size = 8
    font_color = (0, 255, 0)
    border_width = 1 # 0 - no border
    border_color = (0, 0, 255) # blue
    color = (0, 255, 0)
    x_offset = 5
    y_offset = 3
    line_dist = 3

    
    def __init__(self, display_surf, viewport):
        super(Compass, self).__init__()
        
        self.display_surf = display_surf
        self.viewport = viewport
        self.font = pygame.font.Font('vera.ttf', self.font_size)

        # Determine font height
        self.caption_surf = self.font.render('Compass', True, (255, 255, 0))
        self.caption_rect = self.caption_surf.get_rect()
        self.caption_rect.move_ip(viewport.left + self.x_offset, 
                                  viewport.top + self.border_width + self.y_offset)

        self.dir_labels = []
        for d in range(0, 360, 10):
            s = self.font.render('{0}'.format(d), True, self.color)
            self.dir_labels.append(s)

        self.line_y1 = self.caption_rect.bottom + \
                       self.dir_labels[0].get_rect().height + 2 * self.y_offset

        self.marker_lines = [
            ((viewport.center[0], self.line_y1 + 10 + 1), 
             (viewport.center[0] - 5, self.line_y1 + 10 + 1 + 5)),

            ((viewport.center[0], self.line_y1 + 10 + 1), 
             (viewport.center[0] + 5, self.line_y1 + 10 + 1 + 5)),

            ((viewport.center[0] - 5, self.line_y1 + 10 + 1 + 5), 
             (viewport.center[0] + 5, self.line_y1 + 10 + 1 + 5))
        ]

        self.curr_dir = 18

    
    def update_visuals(self):
        # Outer rectangle
        if self.border_width > 0:
            pygame.draw.rect(self.display_surf,
                             self.border_color,
                             self.viewport,
                             self.border_width)

        self.display_surf.blit(self.caption_surf, self.caption_rect)

        scala_range = int((self.viewport.width - 2 * self.x_offset) / 2 / self.line_dist)

        for x1 in range(self.curr_dir - scala_range, self.curr_dir + scala_range):
            if x1 % 10 == 0:
                h = 10

                if x1 >= 0:
                    idx = int(x1 / 10)
                else:
                    idx = int((360 + x1) / 10)

                r = self.dir_labels[idx].get_rect()
                r.move_ip(self.viewport.center[0] + (x1 - self.curr_dir) * self.line_dist - int(r.width / 2), 
                          self.line_y1 - r.height - 1)
                self.display_surf.blit(self.dir_labels[idx], r)
                                       
            else:
                h = 5

            pygame.draw.line(self.display_surf, 
                             self.color, 
                             (self.viewport.center[0] + (x1 - self.curr_dir) * self.line_dist, self.line_y1), 
                             (self.viewport.center[0] + (x1 - self.curr_dir) * self.line_dist, self.line_y1 + h))

            for line_begin, line_end in self.marker_lines:
                pygame.draw.line(self.display_surf,
                                 self.color,
                                 line_begin, line_end)


    def get_supported_sensor_types(self):
        return [Sensor.bearing]
