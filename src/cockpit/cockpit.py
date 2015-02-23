#!/usr/bin/env python3

import pygame
from pygame.locals import *


FPS = 30 # frames per second to update the screen
window_dim = (1024, 768) # default width and height of the program's window


def load_components(display_surf, window_dim):
    window_w, window_h = window_dim
    component_list = []

    import motorcontrol
    viewport = pygame.Rect(0, 0, window_w / 5, window_h / 4)
    component_list.append(motorcontrol.MotorControl(display_surf, viewport))

    import logview
    viewport = pygame.Rect((0, window_h / 3 * 2, window_w, window_h / 3))
    component_list.append(logview.LogView(display_surf, viewport))

    return component_list


def main():
    pygame.init()

    # Adjust window size depending on screen resolution
    #infoObject = pygame.display.Info()
    #window_dim = (int(infoObject.current_w / 5 * 4),
    #              int(infoObject.current_h / 5 * 4))

    main_clock = pygame.time.Clock()
    display_surf = pygame.display.set_mode(window_dim)
    pygame.display.set_caption('A20 cockpit')    

    component_list = load_components(display_surf, window_dim)
    
    # Run the main UI loop
    return main_loop(component_list, display_surf, main_clock)


def main_loop(component_list, display_surf, main_clock):
    
    while True: # main game loop
        new_events = pygame.event.get() # Retrieve new events
                    
        display_surf.fill((0, 0, 0)) # black background

        # Let each component update visual representation
        for c in component_list:
            c.process_events(new_events)
            c.update_visuals()
        
        pygame.display.update()
        
        # Check if we should quit
        for event in new_events:
            if event.type == QUIT:
                pygame.quit()
                return 0

        main_clock.tick(FPS)


if __name__ == '__main__':
    main()
