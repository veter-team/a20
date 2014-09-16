#!/usr/bin/env python

import sys, traceback, platform
import Ice, IceStorm

Ice.loadSlice('--all -I' + Ice.getSliceDir() + ' -I../interfaces/' + ' ../interfaces/sensor.ice')
Ice.updateModules()
import Sensor

# Known sensor names
sensor_type = {
    Sensor.text : 'TEXT',
    Sensor.range : 'RANGE',
    Sensor.bearing : 'BEARING',
    Sensor.altitude : 'ALTITUDE',
    Sensor.longitude : 'LONGITUDE',
    Sensor.lattitude : 'LATTITUDE',
    Sensor.temperature : 'TEMPERATURE',
    Sensor.pressure : 'PRESURE',
    Sensor.roll : 'ROLL',
    Sensor.pitch : 'PITCH',
    Sensor.yaw : 'YAW',
    Sensor.speed : 'SPEED',
    Sensor.accelx : 'ACCELX',
    Sensor.accely : 'ACCELY',
    Sensor.accelz : 'ACCELZ',
    Sensor.positionx : 'POSITIONX',
    Sensor.positiony : 'POSITIONY',
    Sensor.positionz : 'POSITIONZ',
    Sensor.brightness : 'BRIGHTNESS'
    Sensor.video : 'VIDEO'
}



class SensorObserverI(Sensor.SensorObserver):

    def newData(self, data, current = None):
        possible_vals = [data.txtvals, data.floatvals, data.intvals]
        for val in possible_vals:
            for k, v in val.items():
                print('{0}: {1}'.format(sensor_type[k], ' '.join(v)))


class Subscriber(Ice.Application):

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

        # Add a servant for the Ice object.
        # Id is not directly altered since it is used below to detect
        # whether subscribeAndGetPublisher can raise AlreadySubscribed.
        subId = Ice.Identity()
        subId.name = Ice.generateUUID()
        subscriber = adapter.add(SensorObserverI(), subId)

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
        self.communicator().waitForShutdown()

        # Unsubscribe all subscribed objects.
        topic.unsubscribe(subscriber)

        return 0


app = Subscriber()
sys.exit(app.main(sys.argv, "syslog_sensor_client.config"))
