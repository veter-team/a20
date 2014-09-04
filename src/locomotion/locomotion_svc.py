#!/usr/bin/env python

import sys, traceback
import Ice
import platform
import smbus

Ice.loadSlice('--all -I' + Ice.getSliceDir() + ' -I../interfaces/' + ' ../interfaces/motorcontrol.ice')
Ice.updateModules()
import MotorControl

# See http://www.robot-electronics.co.uk/htm/md22tech.htm
# for more details about controller and i2c interface
class DifferentialSteeringI(MotorControl.DifferentialSteering):

    def __init__(self, logger, bus, addr):
        self.logger = logger
        self.bus = bus
        self.address = addr
        self.operation_mode = 0 # default mode
        

    def setOperationMode(self, mode):
        if mode != self.operation_mode:
            self.operation_mode = mode
            self.bus.write_byte_data(self.address, 0, mode)


    def getInfo(self, current=None):
        # Ger firmware revision version from register 7
        version = self.bus.read_byte_data(self.address, 7)
        return 'MD22 @ {0}. Firmware: {1}'.format(platform.node(), version)


    def setMotors(self, speed1, speed2, current=None):
        #self.logger.trace('Info', 'Setting motor: speed1={0} speed2={1}'.format(speed1, speed2))
        self.setOperationMode(0)
        self.bus.write_byte_data(self.address, 1, speed1)
        self.bus.write_byte_data(self.address, 2, speed2)
        #self.bus.write_word_data(self.address, 1, (speed1 << 8) + speed2)


    def setMotorsWithTurn(self, speed, turn, current=None):
        #self.logger.trace('Info', 'Setting motor: speed={0} turn={1}'.format(speed, turn))
        self.setOperationMode(4)
        self.bus.write_byte_data(self.address, 1, speed)
        self.bus.write_byte_data(self.address, 2, turn)
        #self.bus.write_word_data(self.address, 1, (speed << 8) + turn)


class LocomotionServer(Ice.Application):
    def run(self, args):
        if len(args) > 1:
            print(self.appName() + ': too many arguments')
            return 1

        logger = self.communicator().getLogger()

        try:

            adapter = self.communicator().createObjectAdapter('locomotion')
            bus = smbus.SMBus(0)
            diff_steering = DifferentialSteeringI(logger, bus, 0xB0)
            adapter.add(diff_steering, 
                        self.communicator().stringToIdentity('diffsteering'))
            adapter.activate()
            logger.trace('Info', '{0} - initialized'.format(diff_steering.getInfo()))
            self.communicator().waitForShutdown()

        except EnvironmentError as (errno, errorstring):
            logger.error('Error {0}: {1}'.format(errno, errorstring))
        except Ice.Exception as ex:
            logger.error(ex)

        logger.trace('Info', 'Shutting down...')
        return 0


app = LocomotionServer()
app.main(sys.argv, 'locomotion_server.config')
