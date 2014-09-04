#pragma once

// Interfaces for typical locomotion systems
// See http://www.robot-electronics.co.uk/htm/md22tech.htm
// for more details about meaning of parameter values
module MotorControl
{

    // Module to control differential steering system
    interface DifferentialSteering
    {
        // Returns free-text description of the module
        idempotent string getInfo();

        // Sets rotation speed for each motor
        idempotent void setMotors(byte speed1, byte speed2);

        // Sets motor rotation to achieve required speed and turn rate
        idempotent void setMotorsWithTurn(byte speed, byte turn);
    };

};
