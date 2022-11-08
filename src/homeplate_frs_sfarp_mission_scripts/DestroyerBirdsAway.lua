local shipNames = {}
local shotHandler = {}
local addShip, isASpecifiedShip, getBullseye, getImpact, buildMessage, getBearingFromTwoPoints, getDistanceFromTwoPoints, getMagneticDeclination, integerToEnglish, bearingToSingleDigits
local freqs = { "255", "262", "259", "268" }

function addShip(shipGroupName, shipCallsign)
    shipNames[shipGroupName] = shipCallsign
end

function isASpecifiedShip(shipToCheck)
    if (not shipToCheck) then
        return false
    end
    local shipNameToCheck = Unit.getName(shipToCheck)
    for shipName, _ in pairs(shipNames) do
        if (shipNameToCheck == shipName) then
            return true
        end
    end
    return false
end

function getBullseye(target)
    local bullsLO = coalition.getMainRefPoint(coalition.side.BLUE)
    local distanceNm = math.floor(getDistanceFromTwoPoints(bullsLO, target:getPoint()) / 1852)

    if (distanceNm < 5) then
        return ", AT BULLSEYE "
    end

    local distanceNmEnglish = integerToEnglish(distanceNm)
    local bearing = math.floor(getBearingFromTwoPoints(bullsLO, target:getPoint()) - getMagneticDeclination() * 2)
    local bearingString = bearingToSingleDigits(bearing)

    return "BULLSEYE, " .. bearingString .. " , " .. distanceNmEnglish .. ", "
end

function bearingToSingleDigits(bearing)
    local bearingString = ""
    for i = 1, string.len(bearing) do
        bearingString = bearingString .. string.sub(bearing, i, i) .. " "
    end
    return bearingString
end

local belowTen = {"ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN"}
local belowTwenty = {"ELEVEN", "TWELVE", "THIRTEEN", "FOURTEEN", "FIFTEEN", "SIXTEEN", "SEVENTEEN", "EIGHTEEN", "NINETEEN"};
local belowHundred = {"", "TWENTY", "THIRTY", "FORTY", "FIFTY", "SIXTY", "SEVENTY", "EIGHTY", "NINETY"};

local function integerToEnglishHelper(num)
    if (num == 0) then
        return " "
    end
    if (num < 11) then
        return belowTen[num]
    end

    if (num < 20) then
        return belowTwenty[num - 10]
    end

    if (num < 100) then
        return belowHundred[math.floor(num/10)] .. " " .. integerToEnglishHelper(num % 10)
    else
        local middleWord = " HUNDRED AND "
        if (num % 100 == 0) then
            middleWord = " HUNDRED "
        end
        return integerToEnglishHelper(math.floor(num / 100)) .. middleWord .. integerToEnglishHelper(num % 100)
    end
end

function integerToEnglish(distance)
    return integerToEnglishHelper(distance)
end


function getDistanceFromTwoPoints(p1, p2)
    return math.sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.z - p1.z, 2))
end

function getBearingFromTwoPoints(p1, p2)
    local p1Lat, p1Lon, _ = coord.LOtoLL(p1)
    local p2Lat, p2Lon, _ = coord.LOtoLL(p2)
    local lat1 = math.rad(p1Lat)
    local lon1 = math.rad(p1Lon)
    local lat2 = math.rad(p2Lat)
    local lon2 = math.rad(p2Lon)

    local dLon = lon2 - lon1
    local y = math.sin(dLon) * math.cos(lat2)
    local x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon)
    return (math.deg(math.atan2(y, x)) + 360) % 360
end

function getMagneticDeclination()
    local theatre = env.mission.theatre
    if theatre == "Caucasus" then
        return 6
    end
    if theatre == "Nevada" then
        return 12
    end
    if theatre == "Normandy" or theatre == "TheChannel" then
        return -10
    end
    if theatre == "PersianGulf" then
        return 2
    end
    if theatre == "Syria" then
        return 5
    end
    if theatre == "MarianaIslands" then
        return 2
    end
    return 0
end


function getImpact(target)
    local bullsLO = coalition.getMainRefPoint(coalition.side.BLUE)
    local distanceNm = math.floor(getDistanceFromTwoPoints(bullsLO, target:getPoint()) / 1852)

    return " IMPACT, ONE PLUS FIFTEEN"
end

function buildMessage(shipCallsign, bullseye, impact)
    local msg = {}
    msg[#msg + 1] = shipCallsign
    msg[#msg + 1] = ", BIRDS AWAY, TARGETED, " .. bullseye .. impact
    return table.concat(msg)
end

function shotHandler:onEvent(event)
    if event.id == world.event.S_EVENT_SHOT and event.weapon:getTarget() and isASpecifiedShip(event.initiator) then
        local target = event.weapon:getTarget()
        local shipCallsign = shipNames[Unit.getName(event.initiator)]
        local bullseye = getBullseye(target)
        local impact = getImpact(event.initiator, target)
        local message = buildMessage(shipCallsign, bullseye, impact)
        for _, freq in pairs(freqs) do
            STTS.TextToSpeech(message, freq, "AM", "1.0", shipCallsign, 2, null, 2, "male", "en-GB")
        end
    end
end

local function main()
    addShip("CSGAD1", "KILO") -- GROUPNAME, CALLSIGN
    addShip("CSGAD2", "LIMA") -- GROUPNAME, CALLSIGN
    world.addEventHandler(shotHandler)
end
main()


