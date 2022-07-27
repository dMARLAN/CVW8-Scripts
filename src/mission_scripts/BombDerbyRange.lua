local bombTarget = { "BombDerbyCircle" }
local bombDerbyRange = RANGE:New("Bomb Derby Range")

_SETTINGS:SetA2G_LL_DMS()
_SETTINGS:SetLL_Accuracy(0)
_SETTINGS:SetImperial()
_SETTINGS:SetPlayerMenuOff()

bombDerbyRange:AddBombingTargets(bombTarget, 15)
bombDerbyRange:SetRangeRadius(2)
bombDerbyRange:SetAutosaveOn()
bombDerbyRange:SetDefaultPlayerSmokeBomb(false)
bombDerbyRange:Start()
