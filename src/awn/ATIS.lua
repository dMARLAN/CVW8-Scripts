-- ATIS Andersen Airport on 243.325 MHz AM.
local nellisAtis = ATIS:New(BASES.NELLIS_AFB.NAME, 266.000)
nellisAtis:SetRadioRelayUnitName("Nellis ATIS")
nellisAtis:Start()