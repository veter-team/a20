#pragma once

#include <Ice/BuiltinSequences.ice>

// Interface definitions for different types of sensors


module Sensor
{
    // Common sensor type IDs definition.
    // Not using Enum here to keep it open and not prevent "unknown" 
    // sensor types
    const int text = 1;
    const int range = 2;
    const int bearing = 3;
    const int altitude = 4;
    const int longitude = 5;
    const int lattitude = 6;
    const int temperature = 7;
    const int pressure = 8;
    const int roll = 9;
    const int pitch = 10;
    const int yaw = 11;
    const int speed = 12;
    const int accelx = 13;
    const int accely = 14;
    const int accelz = 15;
    const int positionx = 16;
    const int positiony = 17;
    const int positionz = 18;
    const int brightness = 19;


    dictionary<int, Ice::StringSeq> TextData;
    dictionary<int, float> FloatData;
    dictionary<int, int> IntData;

    struct Frame
    {
        TextData txtvals;
        FloatData floatvals;
        IntData intvals;
    };

    // Callback interface for sensor observers
    interface SensorObserver
    {
        void newData(Frame data);
    };

    // Generic sensor interface
    interface Generic
    {
        // Returns free-text description of the module
        idempotent string getInfo();

        // Subscribe particular observer for update notifications
        void addObserver(SensorObserver *observer);
    };

};
