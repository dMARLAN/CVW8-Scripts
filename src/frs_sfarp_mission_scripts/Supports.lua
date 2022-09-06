--------------------
--- Tanker Track ---
--------------------

local TO_TRACK = "ROCKHOPPER Track"
local AO_TRACK = "PINTAIL Track"
local AGR_AO_TRACK = "GENTOO Track"

--- TEXACO 11
local TO11 = RECOVERYTANKER:New(TO_TRACK, "TO11")
TO11:SetCallsign(CALLSIGN.Tanker.Texaco, 1)
TO11:SetTakeoffAir()
TO11:SetAltitude(TANKERS.TO11.ALT)
TO11:SetRadio(TANKERS.TO11.BTN)
TO11:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TANKERS.TO11.ALT))
TO11:SetTACAN(TANKERS.TO11.TCN_FREQ, TANKERS.TO11.TCN_ID)
TO11:SetRacetrackDistances(15, 0)
TO11:__Start(5)

--- TEXACO 21
local TO21 = RECOVERYTANKER:New(TO_TRACK, "TO21")
TO21:SetCallsign(CALLSIGN.Tanker.Texaco, 2)
TO21:SetTakeoffAir()
TO21:SetAltitude(TANKERS.TO21.ALT)
TO21:SetRadio(TANKERS.TO21.BTN)
TO21:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TANKERS.TO21.ALT))
TO21:SetTACAN(TANKERS.TO21.TCN_FREQ, TANKERS.TO21.TCN_ID)
TO21:SetRacetrackDistances(15, 0)
TO21:__Start(30)

--- ARCO 31
local AO31 = RECOVERYTANKER:New(AO_TRACK, "AO31")
AO31:SetCallsign(CALLSIGN.Tanker.Arco, 3)
AO31:SetTakeoffAir()
AO31:SetAltitude(TANKERS.AO31.ALT)
AO31:SetRadio(TANKERS.AO31.BTN)
AO31:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TANKERS.AO31.ALT))
AO31:SetTACAN(TANKERS.AO31.TCN_FREQ, TANKERS.AO31.TCN_ID)
AO31:SetRacetrackDistances(15, 0)
AO31:__Start(5)

--- ARCO 41
local AO41 = RECOVERYTANKER:New(AO_TRACK, "AO41")
AO41:SetCallsign(CALLSIGN.Tanker.Arco, 4)
AO41:SetTakeoffAir()
AO41:SetAltitude(TANKERS.AO41.ALT)
AO41:SetRadio(TANKERS.AO41.BTN)
AO41:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TANKERS.AO41.ALT))
AO41:SetTACAN(TANKERS.AO41.TCN_FREQ, TANKERS.AO41.TCN_ID)
AO41:SetRacetrackDistances(15, 0)
AO41:__Start(30)

--- ARCO 42
local AO42 = RECOVERYTANKER:New(AGR_AO_TRACK, "AO42")
AO42:SetCallsign(CALLSIGN.Tanker.Arco, 4)
AO42:SetTakeoffAir()
AO42:SetAltitude(TANKERS.AO42.ALT)
AO42:SetRadio(TANKERS.AO42.BTN)
AO42:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TANKERS.AO42.ALT))
AO42:SetRacetrackDistances(15, 0)
AO42:__Start(30)

--------------------
--- AWACS Track ----
--------------------

--- DARKSTAR
local ODR1 = RECOVERYTANKER:New("TYRANT Track", "ODR1")
local ODR1_alt = 27000
ODR1:SetCallsign(CALLSIGN.AWACS.Darkstar, 1)
ODR1:SetAWACS()
ODR1:SetTakeoffAir()
ODR1:SetAltitude(ODR1_alt)
ODR1:SetRadio(RADIOS.BTN_9)
ODR1:SetSpeed(UTILS.KnotsToAltKIAS(AWACS.SPEED, ODR1_alt))
ODR1:SetRacetrackDistances(30, 0)
ODR1:__Start(5)

--- FOCUS
local OFS1 = RECOVERYTANKER:New("TYRANT Track", "OFS1")
local OFS1_alt = 23000
OFS1:SetCallsign(CALLSIGN.AWACS.Focus, 1)
OFS1:SetAWACS()
OFS1:SetTakeoffAir()
OFS1:SetAltitude(OFS1_alt)
OFS1:SetRadio(RADIOS.BTN_10)
OFS1:SetSpeed(UTILS.KnotsToAltKIAS(AWACS.SPEED, OFS1_alt))
OFS1:SetRacetrackDistances(30, 0)
OFS1:__Start(60)

--- WIZARD (Red Human AWACS)
local OWD1 = RECOVERYTANKER:New("CARACARA Track", "OWD1")
local OWD1_alt = 25000
OWD1:SetCallsign(CALLSIGN.AWACS.Wizard, 1)
OWD1:SetAWACS()
OWD1:SetTakeoffAir()
OWD1:SetAltitude(OWD1_alt)
OWD1:SetRadio(255.1)
OWD1:SetSpeed(UTILS.KnotsToAltKIAS(AWACS.SPEED, OWD1_alt))
OWD1:SetRacetrackDistances(30, 0)
OWD1:__Start(5)

--- OVERLORD (Red AI AWACS)
local OOD1 = RECOVERYTANKER:New("VULTURE Track", "OOD1")
local OOD1_alt = 23000
OOD1:SetCallsign(CALLSIGN.AWACS.Overlord, 1)
OOD1:SetAWACS()
OOD1:SetTakeoffAir()
OOD1:SetAltitude(OOD1_alt)
OOD1:SetRadio(RADIOS.BTN_12)
OOD1:SetSpeed(UTILS.KnotsToAltKIAS(AWACS.SPEED, OOD1_alt))
OOD1:SetRacetrackDistances(30, 0)
OOD1:__Start(10)