---
--- Attempts to restart the mission after restartTimeInSeconds seconds,
--- if clients are present it will not restart and reattempt every minute.
--- After maximumOverTimeInSeconds have elapsed, the mission will restart
--- regardless of the presence of clients.
--- @author Marlan
---

local getNumPlayerUnits, restartMission, getNextMissionName, invertMissionIdentifier, executeWeatherUpdate, loadNextMission
local reminderCount = 0

--- @return number
function getNumPlayerUnits()
    local numPlayerUnits = 0
    for _, side in pairs(coalition.side) do
        for _,_ in pairs(coalition.getPlayers(side)) do
            numPlayerUnits = numPlayerUnits + 1
        end
    end
    return numPlayerUnits
end

--- @param maxOverTime number maximum overtime until restart regardless of clients
--- @return number returns interval for next attempt if cannot restart this attempt
function restartMission(maxOverTime)
    local reminderIntervalInMins = 60
    local repeatInterval = 300
    local numPlayerUnits = getNumPlayerUnits()
    if(numPlayerUnits == 0 or timer.getTime() >= maxOverTime) then
        env.info("Restarting mission.")
        local nextMissionToLoad = getNextMissionName()
        if (nextMissionToLoad ~= 0) then
            cvw8utilities.setDataFile("mission",nextMissionToLoad .. ".miz")
            executeWeatherUpdate()
            loadNextMission(nextMissionToLoad)
        end
    else
        env.info("Restart.lua: Cannot restart, " .. numPlayerUnits .. " player(s) present.")
        local timeRemaining = maxOverTime - timer.getTime()
        local timeRemainingInMinutes = timeRemaining / 60
        local flooredTimeRemainingInMinutes = math.floor(timeRemainingInMinutes)
        local message = "Overtime: Server will restart in " .. flooredTimeRemainingInMinutes .. " minutes."
        if(reminderCount == reminderIntervalInMins) then
            trigger.action.outText(message , 10)
            reminderCount = 0
        elseif (flooredTimeRemainingInMinutes <= 5) then
            trigger.action.outText(message , 10)
        else
            reminderCount = reminderCount + 1
        end
        return timer.getTime() + repeatInterval -- Schedules next attempt to restart in repeatInterval seconds
    end
end

function loadNextMission(mission)
    env.info("[TEST!]: CVW8Scripts: Load Mission: " .. phase .. "\\" .. mission)
    trigger.action.outText("CVW8Scripts: Load Mission: " .. phase .. "\\" .. mission,10,false)
end

function getNextMissionName()
    if (string.match(string.sub(MISSION_NAME,#MISSION_NAME-1),"_%a")) then
        local invertedMissionIdentifier = invertMissionIdentifier(MISSION_NAME)
        if (invertedMissionIdentifier ~= 0) then
            return string.sub(MISSION_NAME,0,#MISSION_NAME-1) .. invertedMissionIdentifier
        end
    end
    env.info("Restart.lua: Could not match mission identifier")
    return 0
end

function invertMissionIdentifier(missionName)
    if (string.sub(missionName,#missionName) == "A") then return "B" end
    if (string.sub(missionName,#missionName) == "B") then return "A" end
    return 0
end

function executeWeatherUpdate()
    env.info("[TEST!]: Executing JAR:  java -jar \"" .. SCRIPTS_PATH .. "\\weather-update.jar\" " .. "\"" .. SCRIPTS_PATH .. "\"")
    os.execute("java -jar \"" .. SCRIPTS_PATH .. "\\weather-update.jar\" " .. "\"" .. SCRIPTS_PATH .. "\"")
end

--- Main Method
local function main()
    local restartTimeInHours = 1
    local maximumOverTimeInHours = 8
    local restartTimeInSeconds = restartTimeInHours * 3600
    local maximumOverTimeInSeconds = maximumOverTimeInHours * 3600
    local relativeRestartTimeInSeconds = timer.getTime() + restartTimeInSeconds
    local relativeMaximumOverTimeInSeconds = timer.getTime() + maximumOverTimeInSeconds
    timer.scheduleFunction(restartMission, relativeMaximumOverTimeInSeconds, relativeRestartTimeInSeconds)
end
main()
