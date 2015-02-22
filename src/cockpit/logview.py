#!/usr/bin/env python3

import pygame
from pygame.locals import *

from collections import deque

from baseview import BaseView


class LogView(BaseView):
    "Display log output in scrolling window"

    font_size = 10
    font_color = (0, 255, 0)
    border_width = 1 # 0 - no border
    border_color = (0, 0, 64) # dark blue
    x_offset = 5
    y_offset = 3
    
    def __init__(self, display_surf, viewport):
        super(LogView, self).__init__()
        
        self.display_surf = display_surf
        self.viewport = viewport
        self.font = pygame.font.Font('vera.ttf', self.font_size)
        self.text_buf = deque()
        self.text_buf.append('Log output')

        # Determine font height
        text_surf = self.font.render('Log', True, (0, 255, 0))
        text_rect = text_surf.get_rect()
        self.line_height = text_rect.height + 2
        self.max_line_cnt = int(
            (viewport.height - self.border_width * 2 - self.y_offset)
            / self.line_height)
        
        self.syslog = open('/var/log/syslog', mode='r')
        self.where = self.syslog.tell()
    
    def update_visuals(self):
        # Outer rectangle
        if self.border_width > 0:
            pygame.draw.rect(self.display_surf,
                             self.border_color,
                             self.viewport,
                             self.border_width)

        if self.syslog is None:
            return
        
        where = self.syslog.tell()
        line = self.syslog.readline()
        if not line:
            self.syslog.seek(where)
        else:
            self.text_buf.append(line[:-1])
            if len(self.text_buf) > self.max_line_cnt:
                self.text_buf.popleft()

        y = self.y_offset + self.viewport.top
        for s in self.text_buf:
            text_surf = self.font.render(s, True, self.font_color)
            text_rect = text_surf.get_rect()
            text_rect.topleft = (self.x_offset, y)
            text_rect.width = self.viewport.width
            self.display_surf.blit(text_surf, text_rect,
                area = (0, 0,
                        text_rect.width if text_rect.width < self.viewport.width - self.x_offset - self.border_width * 2 else self.viewport.width - self.x_offset - self.border_width * 2, text_rect.height))
            y += self.line_height
            
    def process_events(self, new_events):
        for event in new_events:
            if event.type == QUIT:
                self.syslog.close()
                self.syslog = None
            
