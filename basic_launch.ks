//hellolaunch

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

FUNCTION TILT {
  PARAMETER minAltitude.
  PARAMETER angle.

  WAIT UNTIL SHIP:ALTITUDE > minAltitude.
  LOCK STEERING TO HEADING(0, angle).
}

//Next, we'll lock our throttle to 100%.
SET throt to 1.0.
LOCK THROTTLE TO throt.   // 1.0 is the max, 0.0 is idle.

//This is our countdown loop, which cycles from 10 to 0
UPDATE "Counting down:".
FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    UPDATE "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

//This is a trigger that constantly checks to see if our thrust is zero.
//If it is, it will attempt to stage and then return to where the script
//left off. The PRESERVE keyword keeps the trigger active even after it
//has been triggered.

//This will be our main control loop for the ascent. It will
//cycle through continuously until our apoapsis is greater
//than 100km. Each cycle, it will check each of the IF
//statements inside and perform them if their conditions
//are met
UNTIL SHIP:APOAPSIS > 75000 {
  WHEN MAXTHRUST = 0 THEN {

      PRINT "Staging".
      STAGE.
      PRESERVE.

  }.

    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    IF SHIP:VELOCITY:SURFACE:MAG < 100 {
        //This sets our steering 90 degrees up and yawed to the compass
        //heading of 90 degrees (east)
        TILT(0, 80).

    //Once we pass 100m/s, we want to pitch down ten degrees
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 100 {
        TILT(5000, 70).
        TILT(10000, 60).
        TILT(15000, 55).
        TILT(20000, 50).
        TILT(30000, 40).


    }.


}.

SET throt to 0.

SET steer to SHIP:PROGRADE.

WAIT UNTIL ETA:APOAPSIS < 20.

TILT(0, 0). WAIT 5. LOCK THROTTLE to 1.

WAIT UNTIL PERIAPSIS > 70000.
LOCK THROTTLE TO 0.
