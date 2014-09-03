#!/usr/bin/env python

# Required python-networkmanager package:
# https://pypi.python.org/pypi/python-networkmanager
# or apt-get install python-networkmanager

"""Listen to StateChanged signal from NetworkManager an
(re)start/stop the application"""

import dbus.mainloop.glib; dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
from gi.repository import GObject
import NetworkManager
import subprocess


# List of programms to execute if/when network connection is changed
commands = ( ['restart', 'locomotion'], 
)


# Starts processes after network connection changes
def on_changed():
    for p in commands:
        try:
            proc = subprocess.Popen(p)
            #print('Started "{0}" . PID: {1}'.format(' '.join(p), proc.pid))
        except OSError as err:
            print('Could not start "{0}". Error: {1}'.format(' '.join(p), err))


# State handlers table
state_handlers = { NetworkManager.NM_STATE_DISCONNECTED : on_changed,
                   NetworkManager.NM_STATE_DISCONNECTING : None,
                   NetworkManager.NM_STATE_ASLEEP : None,
                   NetworkManager.NM_STATE_CONNECTING : None,
                   NetworkManager.NM_STATE_CONNECTED_GLOBAL : on_changed
}


# Table to map state id to corresponding text string
state_text = { NetworkManager.NM_STATE_DISCONNECTED : 'disconnected',
               NetworkManager.NM_STATE_DISCONNECTING : 'disconnecting...',
               NetworkManager.NM_STATE_ASLEEP : 'asleep',
               NetworkManager.NM_STATE_CONNECTING : 'connecting...',
               NetworkManager.NM_STATE_CONNECTED_GLOBAL : 'connected'
}


def on_state_changed(newstate):
    #print('Network: {0}'.format(state_text[newstate]))
    # Invoke particular state handler (if not None)
    try:
        handler = state_handlers[newstate]
        if handler is not None:
            handler()
    except KeyError:
        print('No handler for state {0}'.format(state_text[newstate]))


def main():
    # Handle current state
    #on_state_changed(NetworkManager.NetworkManager.State)

    # Register StateChange signal callback
    NetworkManager.NetworkManager.connect_to_signal('StateChanged', on_state_changed)

    # Listen for changes
    loop = GObject.MainLoop()
    try:
        loop.run()
    except KeyboardInterrupt:
        print('Shutting down...')

    # Shut down the application
    #on_state_changed(NetworkManager.NM_STATE_DISCONNECTED)


if __name__ == '__main__':
    main()
