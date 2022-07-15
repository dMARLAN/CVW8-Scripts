SAIPAN = AIRBASE.MarianaIslands.Saipan_Intl
TINIAN = AIRBASE.MarianaIslands.Tinian_Intl

local detectionGroup = SET_GROUP:New()
detectionGroup:FilterCoalitions("red")
detectionGroup:FilterPrefixes({ "EWR", "SAM" })
detectionGroup:FilterStart()

local dispatcher = AI_A2A_DISPATCHER:New(DETECTION_AREAS:New(detectionGroup, 37040))
-- dispatcher:SetTacticalDisplay(true) -- Uncomment for debug menu
dispatcher:SetBorderZone(ZONE_POLYGON:New("Red Border", GROUP:FindByName("Red Border")))
dispatcher:SetEngageRadius(111120) -- in Meters
dispatcher:SetGciRadius(148160) -- in Meters
dispatcher:SetDisengageRadius(185200) -- in Meters
dispatcher:SetDefaultFuelThreshold(0.20)
dispatcher:SetSquadron("MiG23CAP", SAIPAN, ("MiG23CAP"))
dispatcher:SetSquadron("MiG21CAP", TINIAN, ("MiG21CAP"))
dispatcher:SetDefaultOverhead(1)
dispatcher:SetDefaultGrouping(2)
dispatcher:SetDefaultTakeoffFromParkingCold()
dispatcher:SetDefaultLandingAtRunway()
dispatcher:SetDefaultCapRacetrack(27780, 46300, 090, 180) -- Distance in Meters

dispatcher:SetSquadronCap("MiG21CAP", ZONE:New("MiG21CAPZONE"), 4200, 8200, 600, 800, 1000, 1600, "BARO") -- Alt in Meters, Speed in KPH
dispatcher:SetSquadronCapInterval("MiG21CAP", 1, 600, 1800) -- Interval in seconds
-- 1 Knot (GS) = 1.852 KPH

dispatcher:SetSquadronCap("MiG23CAP", ZONE:New("MiG23CAPZONE"), 4200, 10000, 600, 800, 1000, 1600, "BARO") -- Alt in Meters, Speed in KPH
dispatcher:SetSquadronCapInterval("MiG23CAP", 1, 600, 1800) -- Interval in seconds
-- 1 Knot (GS) = 1.852 KPH

dispatcher:Start()