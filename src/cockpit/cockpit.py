#!/usr/bin/env python3

import sys, platform
import pygame
from pygame.locals import *

import Ice, IceStorm

Ice.loadSlice('--all -I' + Ice.getSliceDir() + ' -I../interfaces/' + ' ../interfaces/motorcontrol.ice')
Ice.loadSlice('--all -I' + Ice.getSliceDir() + ' -I../interfaces/' + ' ../interfaces/sensor.ice')
Ice.updateModules()
import Sensor

FPS = 30 # frames per second to update the screen
window_dim = (1024, 768) # default width and height of the program's window

# Known sensor names
#sensor_type = {
#    Sensor.text : 'TEXT',
#    Sensor.range : 'RANGE',
#    Sensor.bearing : 'BEARING',
#    Sensor.altitude : 'ALTITUDE',
#    Sensor.longitude : 'LONGITUDE',
#    Sensor.lattitude : 'LATTITUDE',
#    Sensor.temperature : 'TEMPERATURE',
#    Sensor.pressure : 'PRESURE',
#    Sensor.roll : 'ROLL',
#    Sensor.pitch : 'PITCH',
#    Sensor.yaw : 'YAW',
#    Sensor.speed : 'SPEED',
#    Sensor.accelx : 'ACCELX',
#    Sensor.accely : 'ACCELY',
#    Sensor.accelz : 'ACCELZ',
#    Sensor.positionx : 'POSITIONX',
#    Sensor.positiony : 'POSITIONY',
#    Sensor.positionz : 'POSITIONZ',
#    Sensor.brightness : 'BRIGHTNESS',
#    Sensor.video : 'VIDEO'
#}


class SensorObserverI(Sensor.SensorObserver):

    def __init__(self, observer_interest_dict):
        self.observer_interest_dict = observer_interest_dict


    def newData(self, data, current = None):
        possible_vals = [data.txtvals, data.floatvals, data.intvals]
        for val in possible_vals:
            for k, v in val.items():
                #print('{0}: {1}'.format(sensor_type[k], ' '.join(v)))
                for view in self.observer_interest_dict[k]:
                    view.new_data(k, v)


class Subscriber(Ice.Application):

    def __init__(self, component_list, display_surf, main_clock):
        self.component_list = component_list
        self.display_surf = display_surf
        self.main_clock = main_clock
        

    def run(self, args):
        if len(args) > 1:
            print(self.appName() + ": too many arguments")
            return 1

        manager = IceStorm.TopicManagerPrx.checkedCast(self.communicator().propertyToProxy('TopicManager.Proxy'))
        if not manager:
            print('Invalid topic manager proxy')
            return 1

        print('Topic list:')
        topic_dict = manager.retrieveAll()
        for topic_name, topic_prx in topic_dict.items():
            print(topic_name)
            link_info_seq = topic_prx.getLinkInfoSeq()
            print('  linked topics:')
            for link_info in link_info_seq:
                print('    {0} cost {1}'.format(link_info.name, link_info.cost))
            

        # Retrieve the topic.
        topic_name = platform.node()
        try:
            topic = manager.retrieve(topic_name)
        except IceStorm.NoSuchTopic as e:
            print('Topic {0} not found'.format(topic_name))
            return 1

        adapter = self.communicator().createObjectAdapter("Syslog.Subscriber")

        observer_interest_dict = {}
        for c in self.component_list:
            interest_list = c.get_supported_sensor_types()
            for interest in interest_list:
                if interest in observer_interest_dict:
                    observer_interest_dict[t].append(c)
                else:
                    observer_interest_dict[interest] = [c]

        sensor_observer = SensorObserverI(observer_interest_dict)

        # Add a servant for the Ice object.
        # Id is not directly altered since it is used below to detect
        # whether subscribeAndGetPublisher can raise AlreadySubscribed.
        subId = Ice.Identity()
        subId.name = Ice.generateUUID()
        subscriber = adapter.add(sensor_observer, subId)

        # Activate the object adapter before subscribing.
        adapter.activate()

        qos = {}
        #qos["retryCount"] = retryCount

        # Set up the proxy.
        #if option == "Datagram":
        #    if batch:
        #        subscriber = subscriber.ice_batchDatagram()
        #    else:
        #        subscriber = subscriber.ice_datagram()
        #elif option == "Twoway":
        #    # Do nothing to the subscriber proxy. Its already twoway.
        #     pass
        #elif option == "Ordered":
        #    # Do nothing to the subscriber proxy. Its already twoway.
        #    qos["reliability"] = "ordered"
        #elif option == "Oneway" or option == "None":
        #    if batch:
        #        subscriber = subscriber.ice_batchOneway()
        #    else:
        #        subscriber = subscriber.ice_oneway()
        subscriber = subscriber.ice_batchDatagram()

        try:
            topic.subscribeAndGetPublisher(qos, subscriber)
        except IceStorm.AlreadySubscribed as ex:
            raise

        self.shutdownOnInterrupt()

        while True: # main game loop
            try:

                new_events = pygame.event.get() # Retrieve new events
                    
                self.display_surf.fill((0, 0, 0)) # black background

                # Let each component update visual representation
                for c in self.component_list:
                    c.process_events(new_events)
                    c.update_visuals()
        
                pygame.display.update()
        
                # Check if we should quit
                for event in new_events:
                    if event.type == QUIT:
                        pygame.quit()
                        return 0

                self.main_clock.tick(FPS)

            except Ice.Exception as ex:
                print(ex)
                break

        # Unsubscribe all subscribed objects.
        topic.unsubscribe(subscriber)

        return 0


def load_components(display_surf, window_dim):
    window_w, window_h = window_dim
    component_list = []

    import motorctl
    viewport = pygame.Rect(0, 0, window_w / 5, window_h / 4)
    component_list.append(motorctl.MotorView(display_surf, viewport))

    import logview
    viewport = pygame.Rect((0, window_h / 3 * 2, window_w, window_h / 3))
    component_list.append(logview.LogView(display_surf, viewport))

    import compass
    viewport = pygame.Rect(window_w / 5, 0, window_w / 5, window_h / 4)
    component_list.append(compass.Compass(display_surf, viewport))

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
    
    app = Subscriber(component_list, display_surf, main_clock)
    # Run the main loop
    return app.main(sys.argv, "../config/syslog_sensor_client.config")



if __name__ == '__main__':
    main()
