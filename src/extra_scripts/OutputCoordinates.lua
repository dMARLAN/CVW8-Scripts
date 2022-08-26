local createUnitCoordinatesList, convertLL, printToFile

function createUnitCoordinatesList(unitCoordinatesList)
    for _, side in pairs(coalition.side) do
        for _, group in pairs(coalition.getGroups(side)) do
            local firstUnitInGroup = true
            for _, unit in pairs(Group.getUnits(group)) do
                if (Unit.inAir(unit) == false) then
                    if (firstUnitInGroup) then
                        unitCoordinatesList = unitCoordinatesList .. "\n--- GROUP: " .. Group.getName(group) .. "\n"
                        firstUnitInGroup = false
                    end
                    local unitName = Unit.getName(unit)
                    local unitPoint = Unit.getPoint(unit)
                    local latInDegDec, lonInDegDec, altInMeters = coord.LOtoLL(unitPoint)
                    local altInFeet = math.floor(altInMeters * 3.28084)
                    local latDDMMmmm, lonDDMMmmm = convertLL(latInDegDec, lonInDegDec, "DDMMmmm")
                    local latDDMMSSss, lonDDMMSSss = convertLL(latInDegDec, lonInDegDec, "DDMMSSss")
                    unitCoordinatesList = unitCoordinatesList
                            .. "------ UNIT: " .. unitName .. "\n"
                            .. "------ DDMMmmm: " .. latDDMMmmm .. "  " .. lonDDMMmmm .. "  " .. altInFeet .. "\'\n"
                            .. "------ DDMMSSss: " .. latDDMMSSss .. "  " .. lonDDMMSSss .. "  " .. altInFeet .. "\'\n\n"
                end
            end
        end
    end
    return unitCoordinatesList
end

function printToFile(unitCoordinatesList)
    local file = io.open("unitcoordinates.txt", "w")
    file:write(unitCoordinatesList)
    io.close(file)
end

function convertLL(lat, lon, conversionType)
    local latCardinal
    local lonCardinal
    local degreesSymbol = "°"

    if (lat >= 0) then
        latCardinal = "N"
    else
        lat = math.abs(lat)
        latCardinal = "S"
    end

    if (lon >= 0) then
        lonCardinal = "E"
    else
        lon = math.abs(lon)
        lonCardinal = "W"
    end

    if (conversionType == "DDMMmmm") then
        local latMM = ((lat % 1) * 60)
        local lonMM = ((lon % 1) * 60)
        local latDDMMmmm = latCardinal .. " " .. math.floor(lat) .. degreesSymbol .. math.floor(latMM * 1000) / 1000 .. "\'"
        local lonDDMMmmm = lonCardinal .. " " .. math.floor(lon) .. degreesSymbol .. math.floor(lonMM * 1000) / 1000 .. "\'"
        return latDDMMmmm, lonDDMMmmm
    end

    if (conversionType == "DDMMSSss") then
        local latMM = ((lat % 1) * 60)
        local lonMM = ((lon % 1) * 60)
        local latSSss = ((latMM % 1) * 60)
        local lonSSss = ((lonMM % 1) * 60)
        local latDDMMmmm = latCardinal .. " " .. math.floor(lat) .. degreesSymbol .. math.floor(latMM) .. "\'" .. math.floor(latSSss * 100) / 100 .. "\""
        local lonDDMMmmm = lonCardinal .. " " .. math.floor(lon) .. degreesSymbol .. math.floor(lonMM) .. "\'" .. math.floor(lonSSss * 100) / 100 .. "\""
        return latDDMMmmm, lonDDMMmmm
    end
    return 0, 0
end

local function main()
    local unitCoordinatesList = ""
    unitCoordinatesList = createUnitCoordinatesList(unitCoordinatesList)
    printToFile(unitCoordinatesList)
end
main()