local strafePit = { "Guam NS Strafe Pit" }
local bombTargets = { "Guam NS Centroid" }
local guamRange = RANGE:New("Guam Class A Range")

_SETTINGS:SetA2G_LL_DMS()
_SETTINGS:SetLL_Accuracy(0)
_SETTINGS:SetImperial()
_SETTINGS:SetPlayerMenuOff()

guamRange:AddStrafePit(strafePit, 3000, 300, nil, true, 20, 500) -- units??
guamRange:AddBombingTargets(bombTargets, 50)
guamRange:SetRangeControl(338, "Range Control")
guamRange:SetRangeRadius(2)
guamRange:Start()
