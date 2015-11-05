HUDTEXT("Beginning launch countdown: ", 2, 1, 12, green, false).
FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    DECLARE counter is "..." + countdown.
    HUDTEXT (counter, 2, 1, 12, green, false).
    WAIT 1. // pauses the script here for 1 second.
}
HUDTEXT("LIFTOFF!", 2, 1, 12, green, false).
