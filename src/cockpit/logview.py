#!/usr/bin/env python

import pygame
from collections import deque


class LogView:
    "Display log output in scrolling window"

    fontsize = 10
    border_width = 1
    x_offset = 5
    y_offset = 3
    
    def __init__(self, display_surf, viewport):
        self.display_surf = display_surf
        self.viewport = viewport
        self.font = pygame.font.Font('vera.ttf', self.fontsize)
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
        pygame.draw.rect(self.display_surf, (0, 0, 255), self.viewport, 1)

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
            text_surf = self.font.render(s, True, (0, 255, 0))
            text_rect = text_surf.get_rect()
            text_rect.topleft = (self.x_offset, y)
            text_rect.width = self.viewport.width
            self.display_surf.blit(text_surf, text_rect,
                area = (0, 0,
                        text_rect.width if text_rect.width < self.viewport.width - self.x_offset - self.border_width * 2 else self.viewport.width - self.x_offset - self.border_width * 2, text_rect.height))
            y += self.line_height
            
            
