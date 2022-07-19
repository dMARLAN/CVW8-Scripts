---
--- Gets DCS Weather, formats into METAR format,
--- exports to a text file which will be read by DiscordWebHook.jar
--- and then is sent to a Discord Web Hook URL via HTTPPostRequest
--- Requires desanitized MissionScripting.lua
--- @author Marlan
---

--- Selects a location based on currentPhase or if no phase,
--- then selects a location based on the env.theatre.
--- @return table, string
local function getWeatherReferencePointAndStationId()
    local theatre = env.mission.theatre
    local location
    local stationId
    -- currentPhase is global var from ScriptLoader.lua
    -- Select location based on currentPhase
    if string.find(CURRENT_PHASE, PHASE.TSTA) or string.find(CURRENT_PHASE, PHASE.DEPLOY) or CURRENT_PHASE == PHASE.C2X then
        -- currentPhase uses a Carrier
        location = BASES.CARRIER.NAME
        stationId = BASES.CARRIER.CODE
    elseif CURRENT_PHASE == PHASE.FRS or string.find(CURRENT_PHASE, PHASE.SFARP) then
        -- currentPhase uses a field in Guam
        location = BASES.ANDERSEN_AFB.NAME
        stationId = BASES.ANDERSEN_AFB.CODE
    elseif string.find(CURRENT_PHASE, PHASE.AWN) then
        -- currentPhase uses a field in Nevada
        location = BASES.NELLIS_AFB.NAME
        stationId = BASES.NELLIS_AFB.CODE
    else
        -- Otherwise pick current theatre
        -- WWII Theatres not included
        if theatre == THEATRE.CAUCASUS then
            location = BASES.BATUMI.NAME
            stationId = BASES.BATUMI.CODE
        elseif theatre == THEATRE.NEVADA then
            location = BASES.NELLIS_AFB.NAME
            stationId = BASES.NELLIS_AFB.CODE
        elseif theatre == THEATRE.PERSIAN_GULF then
            location = BASES.AL_DHAFRA_AFB.NAME
            stationId = BASES.AL_DHAFRA_AFB.CODE
        elseif theatre == THEATRE.MARIANA_ISLANDS then
            location = BASES.ANDERSEN_AFB.NAME
            stationId = BASES.ANDERSEN_AFB.CODE
        elseif theatre == THEATRE.SYRIA then
            location = BASES.INCIRLIK.NAME
            stationId = BASES.INCIRLIK.CODE
        elseif location == nil then
            env.info("ERROR: Theatre not supported")
            return nil, nil
        end
        env.info("WARNING: Phase unknown.")
    end
    return Airbase.getByName(location):getPoint(), stationId
end

--- Gets Wind from DCS Weather in METAR format e.g. 180030KT
--- @param weatherReferencePoint table point to read weather from
--- @return string windDirecton .. windSpeed .. "KT"
local function getWind(weatherReferencePoint)
    local referencePoint = deepCopy(weatherReferencePoint)
    referencePoint.y = referencePoint.y + 15 -- Values less than 10 meters will always return 0

    local windVec = atmosphere.getWind(referencePoint)
    local windSpeed = math.sqrt((windVec.z) ^ 2 + (windVec.x) ^ 2)
    windSpeed = windSpeed * CONVERSION.METERS_TO_KNOTS -- Meters to Knots

    local windDirection = math.deg(math.atan2(windVec.z, windVec.x))

    -- Clamp wind direction between 0 and 360
    if windDirection < 0 then
        windDirection = windDirection + 360
    end
    if windDirection > 180 then
        windDirection = windDirection - 180
    else
        windDirection = windDirection + 180
    end

    windDirection = math.floor(windDirection + 0.5)
    windSpeed = math.floor(windSpeed + 0.5)

    -- Add leading zeroes
    local windDirectionLeadingZeroes
    if windDirection < 10 then
        windDirectionLeadingZeroes = "00" .. windDirection
    elseif windDirection < 100 then
        windDirectionLeadingZeroes = "0" .. windDirection
    else
        windDirectionLeadingZeroes = windDirection
    end

    local windSpeedLeadingZeroes
    if windSpeed < 10 then
        windSpeedLeadingZeroes = "0" .. windSpeed
    else
        windSpeedLeadingZeroes = windSpeed
    end

    return windDirectionLeadingZeroes .. windSpeedLeadingZeroes .. "KT"
end

--- Gets 24 Hour ZULU Time from DCS based on selected theatre.
--- Adds leading zeroes as appropriate.
--- e.g. 271230Z
--- @return string day .. hours .. minutes .. "Z"
local function getDayAndTime24UTC()
    local theatre = env.mission.theatre
    local time = timer.getAbsTime()
    local hours = math.floor(time / 3600)
    local minutes = (time / 60) - (hours * 60)
    local timeChange
    local timeChangeTbl = {}
    timeChangeTbl["Caucasus"] = 4
    timeChangeTbl["PersianGulf"] = 4
    timeChangeTbl["Nevada"] = -7
    timeChangeTbl["MarianaIslands"] = -2
    timeChangeTbl["Syria"] = 3
    timeChangeTbl["SouthAtlantic"] = 3

    if timeChangeTbl[theatre] then
        timeChange = timeChangeTbl[theatre]
    else
        env.info("ERROR: No time change set on this theatre")
        timeChange = 0
    end

    -- Time clamped to 24 hours
    if hours + timeChange > 0 then
        hours = (hours + timeChange)
    else
        hours = (hours + timeChange) + 24
    end

    -- Add leading zeroes
    if hours < 10 then
        hours = "0" .. hours
    end
    if minutes < 10 then
        minutes = "0" .. minutes
    end

    return os.date("%d") .. hours .. minutes .. "Z"
end

--- Gets visibility from DCS weather in METAR format.
--- Compares to fog and chooses minimum.
--- e.g. "3/4SM"
--- @return string
local function getVisibility()
    local weather = env.mission.weather
    local visibility = env.mission.weather.visibility.distance

    if weather.enable_fog == true then
        local fog = weather.fog
        local fogVisibility = fog.visibility * CONVERSION.METERS_TO_FEET -- Meters to Feet
        if fogVisibility < visibility then
            visibility = fogVisibility
        end
    end

    visibility = visibility * CONVERSION.FEET_TO_STATUTORY_MILES -- Feet To Miles
    if visibility < 0.25 then
        return "1/4SM"
    elseif visibility < 0.50 then
        return "1/2SM"
    elseif visibility < 1 then
        return "3/4SM"
    elseif visibility < 10 then
        return math.floor(visibility + 0.5) .. "SM"
    else
        return "10SM"
    end
end

--- Gets weather modifications from DCS weather in METAR format.
--- Thunderstorm & Dust Storm not yet implemented.
--- Rain is currently handled in getCloudCover()
--- until ED/DCS improves current weather implementation
--- @return string
local function getWeatherMods()
    -- TODO: TS = Thunderstorm, DS = Dust Storm, -RA/RA/+RA
    local weatherMods = ""
    local weather = env.mission.weather

    if weather.enable_fog == true then
        local fog = weather.fog
        local fogVisibility = fog.visibility * CONVERSION.METERS_TO_FEET -- Meters to Feet

        if fogVisibility < 3300 then
            if fogVisibility < 1300 then
                weatherMods = "+"
            end
            weatherMods = weatherMods .. "FG"
        else
            weatherMods = "BR"
        end
    end

    return weatherMods
end

--- Gets Cloud Preset from DCS weather in METAR format.
--- If Cloud Preset is nil, returns "CAVOK"
--- Currently no other handling for a nil Cloud Preset.
--- @return string
local function getCloudCover()
    local cloudsPreset = env.mission.weather.clouds.preset
    local cloudsPresetTbl = {}

    cloudsPresetTbl["Preset1"] = "FEW070"
    cloudsPresetTbl["Preset2"] = "FEW080 SCT230"
    cloudsPresetTbl["Preset3"] = "SCT080 FEW210"
    cloudsPresetTbl["Preset4"] = "SCT080 FEW240"
    cloudsPresetTbl["Preset5"] = "SCT080 FEW240"
    cloudsPresetTbl["Preset6"] = "SCT080 FEW400"
    cloudsPresetTbl["Preset7"] = "BKN075 SCT210 SCT400"
    cloudsPresetTbl["Preset8"] = "SCT180 FEW360 FEW400"
    cloudsPresetTbl["Preset9"] = "BKN075 SCT200 FEW410"
    cloudsPresetTbl["Preset10"] = "SCT180 FEW360 FEW400"
    cloudsPresetTbl["Preset11"] = "BKN180 BKN320 FEW410"
    cloudsPresetTbl["Preset12"] = "BKN120 SCT220 FEW410"
    cloudsPresetTbl["Preset13"] = "BKN120 BKN260 FEW410"
    cloudsPresetTbl["Preset14"] = "BKN070 FEW410"
    cloudsPresetTbl["Preset15"] = "BKN140 BKN240 FEW400"
    cloudsPresetTbl["Preset16"] = "BKN140 BKN280 FEW400"
    cloudsPresetTbl["Preset17"] = "BKN070 BKN200 BKN320"
    cloudsPresetTbl["Preset18"] = "BKN130 BKN250 BKN380"
    cloudsPresetTbl["Preset19"] = "OVC090 BKN230 BKN310"
    cloudsPresetTbl["Preset20"] = "BKN130 BKN280 FEW380"
    cloudsPresetTbl["Preset21"] = "BKN070 OVC170"
    cloudsPresetTbl["Preset22"] = "BKN070 OVC170"
    cloudsPresetTbl["Preset23"] = "BKN110 OVC180 SCT320"
    cloudsPresetTbl["Preset24"] = "BKN030 OVC170 BKN340"
    cloudsPresetTbl["Preset25"] = "OVC120 OVC220 OVC400"
    cloudsPresetTbl["Preset26"] = "OVC090 BKN230 SCT320"
    cloudsPresetTbl["Preset27"] = "OVC080 BKN250 BKN340"
    cloudsPresetTbl["RainyPreset1"] = "RA OVC030 OVC280 FEW400"
    cloudsPresetTbl["RainyPreset2"] = "RA OVC030 SCT180 FEW400"
    cloudsPresetTbl["RainyPreset3"] = "RA OVC060 OVC190 SCT340"

    if cloudsPreset == nil or cloudsPresetTbl[cloudsPreset] == nil then
        env.info("WARNING: Preset not detected")
        return "CAVOK"
    end

    return cloudsPresetTbl[cloudsPreset]
end

--- Calculates Pressure Altitude in feet at weatherReferencePoint elevation.
--- https://en.wikipedia.org/wiki/Pressure_altitude -> Pressure Altitude
--- @param weatherReferencePoint table point to read weather from
--- @return number
local function getPressureAltitude(weatherReferencePoint)
    local referencePoint = deepCopy(weatherReferencePoint)
    local _, QFEPasc = atmosphere.getTemperatureAndPressure(referencePoint)
    local QFEMilliBar = QFEPasc * CONVERSION.PASCAL_TO_MILLIBAR
    local pressureAltitudeInFeet = 145366.45 * (1 - math.pow((QFEMilliBar / CONVERSION.STD_PRESSURE_MILLIBAR), 0.190284))
    return pressureAltitudeInFeet
end

--- Calculates QNH from DCS Weather and returns in METAR format.
--- Corrects for temperature
--- https://en.wikipedia.org/wiki/Pressure_altitude -> QNE
--- e.g. A2992
--- @param weatherReferencePoint table point to read weather from
--- @return string
local function getQNHAltimeter(weatherReferencePoint)
    local referencePoint = deepCopy(weatherReferencePoint)
    local fieldElevInMeters = referencePoint.y
    local pressureAltitude = getPressureAltitude(referencePoint)
    local altitudeDifference = (fieldElevInMeters * CONVERSION.METERS_TO_FEET) - pressureAltitude
    referencePoint.y = 0
    local tempCorrectedQNHPasc = ((altitudeDifference / 27) * 100) + PRESSURE.STANDARD_PRESSURE_PASCAL
    local QNHInHg = tempCorrectedQNHPasc * CONVERSION.PASCALS_TO_INHG
    return "A" .. math.floor(QNHInHg + 0.5)
end

--- Calculates Temperature and Dew Point from DCS Weather
--- and returns in METAR format.
--- e.g. 30/11
--- See: https://www.flymac.co.uk/how-to-estimate-cloud-bases-and-heights/
--- Thanks to Snake122 & Bailey's Conversation
--- @param weatherReferencePoint table point to read weather from
--- @return string temperature .. "/" .. dew
local function getTempDew(weatherReferencePoint)
    local referencePoint = deepCopy(weatherReferencePoint)
    local clouds = env.mission.weather.clouds
    referencePoint.y = 0 -- Set Reference Point to Sea Level
    local temperature, _ = atmosphere.getTemperatureAndPressure(referencePoint)
    temperature = temperature - CONVERSION.ZERO_CELCIUS_IN_KELVIN -- Convert to Celcius

    -- Calculate Dew Point
    local cloudBase = clouds.base * CONVERSION.METERS_TO_FEET
    local dew = temperature - ((cloudBase / 1000) * 2.5)
    dew = math.floor(dew + 0.5)

    -- Absolute Values but prefix M per METAR formatting.
    temperature = math.floor(temperature + 0.5)
    if temperature < 0 then
        temperature = math.abs(temperature)
        temperature = "M" .. temperature
    end
    if dew < 0 then
        dew = math.abs(dew)
        dew = "M" .. dew
    end
    return temperature .. "/" .. dew
end

--- Writes (overwrites) file to DCS Root and executes DiscordWebHook.jar
--- which will read the file and delete it afterwards.
--- @param metar table formatted full METAR for data transfer
local function outputToDiscord(metar, stationId)
    cvw8utilities.setDataFile("icao",stationId)
    cvw8utilities.setDataFile("metar", metar)
    env.info("[TEST!]: Executing JAR:  java -jar \"" .. SCRIPTS_PATH .. "\\weather-output.jar\" " .. "\"" .. SCRIPTS_PATH .. "\"")
    os.execute("java -jar \"" .. SCRIPTS_PATH .. "\\weather-output.jar\" ".. "\"" .. SCRIPTS_PATH .. "\"")
end

--- @author Grimes
--- from mist.utils, thanks Grimes
--- @param object table object to be cloned
--- @return table cloned object
function deepCopy(object)
    local lookup_table = {}
    local function _copy(_object)
        if type(_object) ~= "table" then
            return _object
        elseif lookup_table[_object] then
            return lookup_table[_object]
        end
        local new_table = {}
        lookup_table[_object] = new_table
        for index, value in pairs(_object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(_object))
    end
    return _copy(object)
end

--- Main function; builds METOC and sends to DiscordWebHook.jar
local function main()
    local weatherReferencePoint, stationId = getWeatherReferencePointAndStationId()
    if weatherReferencePoint == nil or stationId == nil then
        return -- EXPAND ON THIS ???
    end

    local metar = stationId .. " " ..
            getDayAndTime24UTC() .. " " ..
            getWind(weatherReferencePoint) .. " " ..
            getVisibility() .. " " ..
            getWeatherMods() .. " " ..
            getCloudCover() .. " " ..
            getTempDew(weatherReferencePoint) .. " " ..
            getQNHAltimeter(weatherReferencePoint)

    outputToDiscord(metar, stationId) -- Pass METOC to DiscordWebHook.java so it can POST because Lua sucks
    env.info("METAR: " .. metar)
    timer.scheduleFunction(main, nil, timer.getTime() + 3600)
end

-- Checks metocActive flag set inside Mission File triggers is true else do not run.
if METOC_ACTIVE then
    main()
end