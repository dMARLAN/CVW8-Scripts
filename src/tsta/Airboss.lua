--------------------
--- Rescue Helo ----
--------------------

--- Rescue Helo
local rescueHelo = RESCUEHELO:New("USS Roosevelt", "Rescue Helo")
rescueHelo:SetTakeoffAir()
rescueHelo:SetAltitude(100)
rescueHelo:SetOffsetX(-1335)
rescueHelo:SetOffsetZ(1402)
rescueHelo:SetModex(612)
rescueHelo:__Start(5)

--------------------
--- Tanker Track ---
--------------------

--- TEXACO 11
local TO11 = RECOVERYTANKER:New("Tanker Track", "TO11")
local TO11_alt = 22000
TO11:SetCallsign(CALLSIGN.Tanker.Texaco, 1)
TO11:SetTakeoffAir()
TO11:SetAltitude(TO11_alt)
TO11:SetRadio(TANKERS.TO11.BTN)
TO11:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TO11_alt))
TO11:SetTACAN(TANKERS.TO11.TCN_FREQ,TANKERS.TO11.TCN_ID)
TO11:SetRacetrackDistances(15, 0)
TO11:__Start(15)

--- TEXACO 21
local TO21 = RECOVERYTANKER:New("Tanker Track", "TO21")
local TO21_alt = 24000
TO21:SetCallsign(CALLSIGN.Tanker.Texaco, 2)
TO21:SetTakeoffAir()
TO21:SetAltitude(TO21_alt)
TO21:SetRadio(TANKERS.TO21.BTN)
TO21:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TO21_alt))
TO21:SetTACAN(TANKERS.TO21.TCN_FREQ,TANKERS.TO21.TCN_ID)
TO21:SetRacetrackDistances(15, 0)
TO21:__Start(5)

------------------------
--- Recovery Tankers ---
------------------------

--- SHELL 71
local SL71 = RECOVERYTANKER:New("USS Roosevelt", "SL71")
local SL71_alt = 6000
SL71:SetCallsign(CALLSIGN.Tanker.Shell, 7)
SL71:SetTakeoffAir()
SL71:SetAltitude(SL71_alt)
SL71:SetRadio(TANKERS.SL71.BTN)
SL71:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, SL71_alt))
SL71:SetTACAN(TANKERS.SL71.TCN_FREQ,TANKERS.SL71.TCN_ID)
SL71:SetModex(701)
SL71:SetLowFuelThreshold(.1)
SL71:__Start(5)

--- SHELL 81
local SL81 = RECOVERYTANKER:New("USS Roosevelt", "SL81") -- TODO Fix Unit Name
local SL81_alt = 6000
SL81:SetCallsign(CALLSIGN.Tanker.Shell, 8)
SL81:SetTakeoffAir()
SL81:SetAltitude(SL81_alt)
SL71:SetRadio(TANKERS.SL81.BTN)
SL71:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, SL81_alt))
SL71:SetTACAN(TANKERS.SL81.TCN_FREQ,TANKERS.SL81.TCN_ID)
SL81:SetModex(702)
SL81:SetLowFuelThreshold(.1)
SL81:__Start(15)

--------------------
--- AWACS Track ----
--------------------

--- DARKSTAR
local ODR1 = RECOVERYTANKER:New("AWACS Track", "ODR1") -- TODO Fix Unit Name
local ODR1_alt = 26000
ODR1:SetCallsign(CALLSIGN.AWACS.Darkstar, 1)
ODR1:SetAWACS()
ODR1:SetTakeoffAir()
ODR1:SetAltitude(ODR1_alt)
ODR1:SetRadio(RADIOS.BTN_9)
ODR1:SetSpeed(UTILS.KnotsToAltKIAS(AWACS.SPEED, ODR1_alt))
ODR1:SetRacetrackDistances(45, 0)
ODR1:__Start(5)

--- WIZARD
local OWD1 = RECOVERYTANKER:New("AWACS Track", "OWD1") -- TODO Fix Unit Name
local OWD1_alt = 28000
OWD1:SetCallsign(CALLSIGN.AWACS.Wizard, 1)
OWD1:SetAWACS()
OWD1:SetTakeoffAir()
OWD1:SetAltitude(OWD1_alt)
OWD1:SetRadio(RADIOS.BTN_10)
OWD1:SetSpeed(UTILS.KnotsToAltKIAS(AWACS.SPEED, OWD1_alt))
OWD1:SetRacetrackDistances(45, 0)
OWD1:__Start(120)

--------------------
----- Airboss ------
--------------------

--- CVN71
local CVN71 = AIRBOSS:New("USS Roosevelt")
CVN71:SetTACAN(71, "X", "TR")
CVN71:SetICLS(1, "TR")
CVN71:SetMenuRecovery(60, 30, true)
CVN71:SetPatrolAdInfinitum(true)
CVN71:SetAirbossNiceGuy(true)
CVN71:SetRecoveryTurnTime(120)
CVN71:SetMaxSectionSize(4)
CVN71:SetDefaultPlayerSkill("TOPGUN Graduate")
CVN71:SetMenuSingleCarrier(true)
CVN71:SetDespawnOnEngineShutdown(true)
CVN71:SetWelcomePlayers(false)
CVN71:SetRecoveryTanker(SL71)
CVN71:SetRecoveryTanker(SL81)
CVN71:SetAWACS(ODR1)
CVN71:SetAWACS(OWD1)
CVN71:SetRecoveryTanker(TO11)
CVN71:SetRecoveryTanker(TO21)

--- Event Windows
local numOfEvents = 9
local durOfEventsInMins = 75
local timeOfFirstEventCumMins = (timer.getAbsTime() + 1800)/60 -- Always set to 30 minutes after mission start
local durOfRecoveryInMins = 30
local windows = {}
local function MinsToClock(time)
    local hours = math.floor(time / 60 )
    local minutes = time - hours * 60
    return string.format("%d:%d",hours,minutes)
end
for i = 1, numOfEvents do
    local startOfEvent = timeOfFirstEventCumMins + ((i-1) * durOfEventsInMins) - 5
    local endOfEvent = startOfEvent + durOfRecoveryInMins + 5
    local startOfEventInClock = MinsToClock(startOfEvent)
    local endOfEventInClock = MinsToClock(endOfEvent)
    windows[i] = CVN71:AddRecoveryWindow(startOfEventInClock, endOfEventInClock, 1, nil, true, 30)
end

CVN71:Start()