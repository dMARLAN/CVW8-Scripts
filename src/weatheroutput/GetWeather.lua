---
--- Gets DCS Weather, formats into METAR format,
--- exports to a text file which will be read by DiscordWebHook.jar
--- and then is sent to a Discord Web Hook URL via HTTPPostRequest
--- Requires desanitized MissionScripting.lua
--- @author Marlan
---

local getWind, getDayAndTime24UTC, getVisibility
local getWeatherMods, getCloudCover, getPressureAltitude, getQnh
local getTempDew, outputToDiscord, getStationId, getNearestAirbasePoint
local writeAirbaseCoordinatesToFile

function getNearestAirbasePoint()
    local stationReferenceName = "StationReference"
    local stationReference = trigger.misc.getZone(stationReferenceName)

    local searchVolume = {
        id = world.VolumeType.SPHERE,
        params = {
            point = stationReference.point,
            radius = stationReference.radius
        }
    }

    local airbaseFound
    local located = function(located)
        airbaseFound = located:getPoint()
    end
    world.searchObjects(Object.Category.BASE, searchVolume, located)

    if airbaseFound then
        return airbaseFound
    end
    return stationReference.point
end

function getWind(referencePoint)
    local localReferencePoint = {}
    localReferencePoint.x = referencePoint.x
    localReferencePoint.y = (land.getHeight({localReferencePoint.x, localReferencePoint.z}) / CONVERSION.METERS_TO_FEET) + 10 -- Wind will return 0 within 10m of ground
    localReferencePoint.z = referencePoint.z

    local windVec = atmosphere.getWind(localReferencePoint)
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
    if windSpeed == 0 then
        windDirectionLeadingZeroes = "000"
    elseif windDirection < 10 then
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

function getDayAndTime24UTC()
    local theatre = env.mission.theatre
    local time = timer.getAbsTime()
    local day = os.date("%d")
    local hours = math.floor(time / 3600)
    local minutes = (time / 60) - (hours * 60)
    local timeChangeToZulu
    local timeChangeToZuluTbl = {}
    timeChangeToZuluTbl["Caucasus"] = -4
    timeChangeToZuluTbl["PersianGulf"] = -4
    timeChangeToZuluTbl["Nevada"] = 7
    timeChangeToZuluTbl["MarianaIslands"] = 2
    timeChangeToZuluTbl["Syria"] = -3
    timeChangeToZuluTbl["SouthAtlantic"] = -3

    if timeChangeToZuluTbl[theatre] then
        timeChangeToZulu = timeChangeToZuluTbl[theatre]
    else
        env.info("ERROR: No time change set on this theatre")
        timeChangeToZulu = 0
    end

    hours = hours + timeChangeToZulu
    if hours >= 24 then
        hours = hours % 24
        day = day + 1
    end

    if hours < 10 then
        hours = "0" .. hours
    end
    if minutes < 10 then
        minutes = "0" .. minutes
    end

    return os.date("%d") .. hours .. minutes .. "Z"
end

function getVisibility()
    local weather = env.mission.weather
    local visibility = env.mission.weather.visibility.distance

    if weather.enable_fog == true then
        local fog = weather.fog
        local fogVisibility = fog.visibility * CONVERSION.METERS_TO_FEET
        if fogVisibility < visibility then
            visibility = fogVisibility
        end
    end

    visibility = visibility * CONVERSION.FEET_TO_STATUTORY_MILES
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

function getWeatherMods()
    -- TODO: TS = Thunderstorm, DS = Dust Storm, -RA/RA/+RA
    local weatherMods = ""
    local weather = env.mission.weather

    if weather.enable_fog == true then
        local fog = weather.fog
        local fogVisibility = fog.visibility * CONVERSION.METERS_TO_FEET

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

function getCloudCover()
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
        return "CAVOK"
    end

    return cloudsPresetTbl[cloudsPreset]
end

function getPressureAltitude(referencePoint)
    local _, qfeHPA = atmosphere.getTemperatureAndPressure(referencePoint)
    local qfeMB = qfeHPA * CONVERSION.PASCAL_TO_MILLIBAR
    return 145366.45 * (1 - math.pow((qfeMB / CONVERSION.STD_PRESSURE_MILLIBAR), 0.190284))
end

function getQnh(referencePoint)
    local pressureAltitude = getPressureAltitude(referencePoint)
    local altitudeDifference = (referencePoint.y * CONVERSION.METERS_TO_FEET) - pressureAltitude
    local tempCorrectedQNHPasc = ((altitudeDifference / 27) * 100) + PRESSURE.STANDARD_PRESSURE_PASCAL
    local qnhInHg = tempCorrectedQNHPasc * CONVERSION.PASCALS_TO_INHG
    return "A" .. math.floor(qnhInHg + 0.5)
end

function getTempDew(referencePoint) -- TODO Improve Dew Calculation, not matching real world, maybe get from Data file instead?
    local localReferencePoint = {}
    localReferencePoint.x = referencePoint.x
    localReferencePoint.y = 0
    localReferencePoint.z = referencePoint.z
    local clouds = env.mission.weather.clouds
    local temperature, _ = atmosphere.getTemperatureAndPressure(localReferencePoint)
    temperature = temperature - CONVERSION.ZERO_CELCIUS_IN_KELVIN

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

function outputToDiscord(metar)
    JsonUtility.setFileJSONValue("metar", metar, DATA_FILE)
    JarUtility.executeJar("weather-output")
end

function getStationId()
    return JsonUtility.getFileJSONValue("icao", DATA_FILE)
end

function writeAirbaseCoordinatesToFile(referencePoint)
    local stationLatitude, stationLongitude, _ = coord.LOtoLL(referencePoint)
    JsonUtility.setFileJSONValue("station_latitude", stationLatitude, DATA_FILE)
    JsonUtility.setFileJSONValue("station_longitude", stationLongitude, DATA_FILE)
end

local function main()
    local referencePoint = getNearestAirbasePoint()
    writeAirbaseCoordinatesToFile(referencePoint)

    local metar = getStationId() .. " " ..
            getDayAndTime24UTC() .. " " ..
            getWind(referencePoint) .. " " ..
            getVisibility() .. " " ..
            getWeatherMods() .. " " ..
            getCloudCover() .. " " ..
            getTempDew(referencePoint) .. " " ..
            getQnh(referencePoint)

    outputToDiscord(metar)
    env.info("METAR: " .. metar)
end
main()