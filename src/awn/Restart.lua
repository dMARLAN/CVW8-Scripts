---
--- Attempts to restart the mission after restartTimeInSeconds seconds,
--- if clients are present it will not restart and reattempt every minute.
--- After maximumOverTimeInSeconds have elapsed, the mission will restart
--- regardless of the presence of clients.
--- @author Marlan
---

local reminderCount = 0

--- @return number
local function getNumPlayerUnits()
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
local function restartMission(maxOverTime)
    local reminderIntervalInMins = 60
    local repeatInterval = 300
    local numPlayerUnits = getNumPlayerUnits()
    if(numPlayerUnits == 0 or timer.getTime() >= maxOverTime) then
        env.info("Restarting mission.")
        trigger.action.setUserFlag("Restart",1) -- .miz requires Once -> Flag True ("Restart") -> Load Mission ("x.miz")
    else
        env.info("Cannot restart, " .. numPlayerUnits .. " player(s) present.")
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

--- Main Method
local function main()
    local restartTimeInHours = 1
    local maximumOverTimeInHours = 8
    local restartTimeInSeconds = restartTimeInHours * 3600
    local maximumOverTimeInSeconds = maximumOverTimeInHours * 3600
    local maxOverTime = timer.getTime() + restartTimeInSeconds
    local localMaximumOverTime = timer.getTime() + maximumOverTimeInSeconds
    timer.scheduleFunction(restartMission, localMaximumOverTime, maxOverTime)
end
main()
