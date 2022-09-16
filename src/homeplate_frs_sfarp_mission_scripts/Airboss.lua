local carrierName = "CVN71"

--- SHELL 51
local SL51 = RECOVERYTANKER:New(carrierName, "SL51")
SL51:SetCallsign(CALLSIGN.Tanker.Shell, 5)
SL51:SetTakeoffAir()
SL51:SetAltitude(TANKERS.SL51.ALT)
SL51:SetRadio(TANKERS.SL51.BTN)
SL51:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TANKERS.SL51.ALT))
SL51:SetTACAN(TANKERS.SL51.TCN_FREQ, TANKERS.SL51.TCN_ID)
SL51:SetRacetrackDistances(TANKERS.RACETRACK_DISTANCE, 0)
SL51:__Start(5)

--- SHELL 51
local SL61 = RECOVERYTANKER:New(carrierName, "SL61")
SL61:SetCallsign(CALLSIGN.Tanker.Shell, 6)
SL61:SetTakeoffAir()
SL61:SetAltitude(TANKERS.SL61.ALT)
SL61:SetRadio(TANKERS.SL61.BTN)
SL61:SetSpeed(UTILS.KnotsToAltKIAS(TANKERS.SPEED, TANKERS.SL61.ALT))
SL61:SetTACAN(TANKERS.SL61.TCN_FREQ, TANKERS.SL61.TCN_ID)
SL61:SetRacetrackDistances(TANKERS.RACETRACK_DISTANCE, 0)
SL61:__Start(5)

local CVN71Airboss = AIRBOSS:New(carrierName)
CVN71Airboss:SetTACAN(71, "X", "TR")
CVN71Airboss:SetICLS(1, "TR")
CVN71Airboss:SetMenuRecovery(60, 30, true)
CVN71Airboss:SetPatrolAdInfinitum(true)
CVN71Airboss:SetRecoveryTurnTime(120)
CVN71Airboss:SetDefaultPlayerSkill("TOPGUN Graduate")
CVN71Airboss:SetMenuSingleCarrier(true)
CVN71Airboss:SetWelcomePlayers(false)

-- Create Windows
--local windows = {}
--windows[1] = airbossCVN71:AddRecoveryWindow("09:35", "10:05", 1, nil, true, 30)
--windows[2] = airbossCVN71:AddRecoveryWindow("11:45", "12:45", 1, nil, true, 30)

CVN71Airboss:Start()