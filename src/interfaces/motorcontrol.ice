#pragma once

// Interfaces for typical locomotion systems
module MotorControl
{

    // Module to control differential steering system
    interface DifferentialSteering
    {
        // Returns free-text description of the module
        idempotent string getInfo();
        // Sets motor rotation to achieve required speed and turn rate
        idempotent void setMotors(byte speed, byte turn);
    };

};
