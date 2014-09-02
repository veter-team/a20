#!/usr/bin/env python

import sys, traceback, Ice

Ice.loadSlice('--all -I' + Ice.getSliceDir() + ' -I../interfaces/' + ' ../interfaces/motorcontrol.ice')
Ice.updateModules()
import MotorControl



class Client(Ice.Application):

    def run(self, args):
        if len(args) > 1:
            print(self.appName() + ": too many arguments")
            return 1

        diffdrive = MotorControl.DifferentialSteeringPrx.checkedCast(\
            self.communicator().propertyToProxy('diffsteering.Proxy').ice_twoway().ice_timeout(-1).ice_secure(False))
        if not diffdrive:
            print(args[0] + ": invalid proxy")
            return 1

        print('Connected to {0}'.format(diffdrive.getInfo()))

        print('Enter speed and turn separated by space or empty string to exit')
        c = None
        while c != '':
            try:
                sys.stdout.write("$ ")
                sys.stdout.flush()
                c = sys.stdin.readline().strip()
                lst = map(int, c.split())
                if c != '' and len(lst) != 2:
                    print('Parsing error')
                else:
                    diffdrive.setMotors(lst[0], lst[1])

            except KeyboardInterrupt:
                break
            except EOFError:
                break
            except Ice.Exception as ex:
                print(ex)

        return 0

app = Client()
sys.exit(app.main(sys.argv, "locomotion_client.config"))
