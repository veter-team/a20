#!/usr/bin/env python

import sys, traceback, platform, time
import Ice, IceStorm

Ice.loadSlice('--all -I' + Ice.getSliceDir() + ' -I../interfaces/' + ' ../interfaces/sensor.ice')
Ice.updateModules()
import Sensor


class SyslogSensorI(Sensor.Generic):

    def __init__(self, logger, topic):
        self.logger = logger
        self.topic = topic
        

    def setOperationMode(self, mode):
        if mode != self.operation_mode:
            self.operation_mode = mode
            self.bus.write_byte_data(self.address, 0, mode)


    def getInfo(self, current=None):
        return 'Monitor syslog file @ {0}'.format(platform.node())


    def addObserver(self, observer, current=None):
        qos = IceStorm.QoS()
        topic.subscribeAndGetPublisher(qos, observer)


class LocomotionServer(Ice.Application):
    def run(self, args):
        if len(args) > 1:
            print(self.appName() + ': too many arguments')
            return 1

        logger = self.communicator().getLogger()

        try:

            obj = self.communicator().propertyToProxy('sensorstorm.Proxy')
            topic_manager = IceStorm.TopicManagerPrx.checkedCast(obj)
            
            node_name = platform.node()
            retr = 0
            node_topic = None
            while node_topic is None and retr < 3:
                try:
                    node_topic = topic_manager.retrieve(node_name)
                except IceStorm.NoSuchTopic as ex:
                    try:
                        node_topic = topic_manager.create(node_name)
                    except IceStorm.TopicExists as ex:
                        time.sleep(2)
                retr += 1

            if node_topic is None:
                log.error('Can not create {0} topic after {1} attempts'.format(node_name, retr))
                return 2

            retr = 0
            sensor_topic = None
            while sensor_topic is None and retr < 3:
                try:
                    sensor_topic = topic_manager.retrieve('syslog')
                except IceStorm.NoSuchTopic as ex:
                    try:
                        sensor_topic = topic_manager.create('syslog')
                    except IceStorm.TopicExists as ex:
                        time.sleep(2)
                retr += 1

            if sensor_topic is None:
                log.error('Can not create syslog topic after {0} attempts'.format(retr))
                return 2

            # Make sensor events available through node topic
            try:
                sensor_topic.link(node_topic, 0)
            except IceStorm.LinkExists as ex:
                # Link already exists. Cool.
                pass


            pub = sensor_topic.getPublisher().ice_oneway()
            #pub = topic.getPublisher().ice_datagram() # Use UDP
            observer = Sensor.SensorObserverPrx.uncheckedCast(pub);

            adapter = self.communicator().createObjectAdapter('sensor')
            sensor = SyslogSensorI(logger, sensor_topic)
            adapter.add(sensor, 
                        self.communicator().stringToIdentity('syslog'))
            adapter.activate()
            logger.trace('Info', '{0} - initialized'.format(sensor.getInfo()))

            # Read syslog and update observers until shutdown
            with open('/var/log/syslog', mode='r') as syslog:
                while not self.communicator().isShutdown():
                    where = syslog.tell()
                    line = syslog.readline()
                    if not line:
                        time.sleep(1)
                        syslog.seek(where)
                    else:
                        frame = Sensor.Frame(txtvals = {})
                        frame.txtvals[Sensor.text] = [line]
                        observer.newData(frame)
                
        except EnvironmentError as (errno, errorstring):
            logger.error('Error {0}: {1}'.format(errno, errorstring))
            if not self.communicator().isShutdown():
                self.communicator.shutdown()
        except Ice.Exception as ex:
            logger.error('Got Ice exception {0}'.format(ex))
        
        logger.trace('Info', 'Shutting down...')
        return 0


app = LocomotionServer()
app.main(sys.argv, 'syslog_sensor_server.config')
