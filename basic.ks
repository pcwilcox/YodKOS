//hellolaunch

//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

//Next, we'll lock our throttle to 100%.
SET throt to 1.0.
LOCK THROTTLE TO throt.   // 1.0 is the max, 0.0 is idle.

//This is our countdown loop, which cycles from 10 to 0
PRINT "Counting down:".
FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

//This is a trigger that constantly checks to see if our thrust is zero.
//If it is, it will attempt to stage and then return to where the script
//left off. The PRESERVE keyword keeps the trigger active even after it
//has been triggered.
WHEN MAXTHRUST = 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE.
}.

//This will be our main control loop for the ascent. It will
//cycle through continuously until our apoapsis is greater
//than 100km. Each cycle, it will check each of the IF
//statements inside and perform them if their conditions
//are met
UNTIL SHIP:VELOCITY:SURFACE:MAG > 310 AND SHIP:ALTITUDE > 16000 {
    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    IF SHIP:VELOCITY:SURFACE:MAG < 100 {
        //This sets our steering 90 degrees up and yawed to the compass
        //heading of 90 degrees (east)
        LOCK STEERING TO HEADING(90,90).

    //Once we pass 100m/s, we want to pitch down ten degrees
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 100 {
        LOCK STEERING TO HEADING(90,80).
        PRINT "Pitching to 80 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).
    }.

    WHEN SHIP:VELOCITY:SURFACE:MAG > 400 THEN {
      SET throt to throt - 0.1.
      PRESERVE.
    }.

    WHEN SHIP:VELOCITY:SURFACE:MAG < 350 THEN {
      SET throt to throt + 0.1.
      PRESERVE.
    }.
  }.

          SET throt to 0.
      WAIT 1.
      STAGE.
      WAIT 1.
      LOCK STEERING to SHIP:SRFREROGRADE.
      WAIT 1.
      STAGE.
    
