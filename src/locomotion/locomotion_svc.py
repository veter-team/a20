#!/usr/bin/env python

import sys, traceback, Ice

Ice.loadSlice('--all -I' + Ice.getSliceDir() + ' -I../interfaces/' + ' ../interfaces/motorcontrol.ice')
Ice.updateModules()
import MotorControl


class DifferentialSteeringI(MotorControl.DifferentialSteering):
    def __init__(self, logger):
        self.logger = logger


    def getInfo(self, current=None):
        return 'MD22 motor controller'


    def setMotors(self, speed, turn, current=None):
        self.logger.trace('Info', 'Setting motor: speed={0} turn={1}'.format(speed, turn))


class LocomotionServer(Ice.Application):
    def run(self, args):
        if len(args) > 1:
            print(self.appName() + ': too many arguments')
            return 1

        logger = self.communicator().getLogger()

        adapter = self.communicator().createObjectAdapter('locomotion')
        diff_steering = DifferentialSteeringI(logger)
        adapter.add(diff_steering, 
                    self.communicator().stringToIdentity('diffsteering'))
        adapter.activate()
        logger.trace('Info', '{0} - initialized'.format(diff_steering.getInfo()))
        self.communicator().waitForShutdown()
        logger.trace('Info', 'Shutting down...')
        return 0


app = LocomotionServer()
app.main(sys.argv, 'locomotion_server.config')
