local unitDestroyedHandler = {}

local function addUnitToKillTrackerFile(destroyedUnitName)
    local killTrackerFile = io.open(CVW8Scripts.SCRIPTS_PATH .. "\\data\\" .. "kills_tracker.txt", "a")
    io.write(killTrackerFile, destroyedUnitName .. "\n")
    io.flush(killTrackerFile)
    io.close(killTrackerFile)
    trigger.action.outText("Added unit to kill tracker: " .. destroyedUnitName, 5)
end

function unitDestroyedHandler:onEvent(event)
    -- Gets hit event on any player
    if event.id == world.event.S_EVENT_DEAD and event.initiator:getGroup():getCoalition() == coalition.side.RED then
        local destroyedUnitName = event.initiator:getUnit():getName()
        addUnitToKillTrackerFile(destroyedUnitName)
    end
end

local function destroyAllTrackedUnits()
    local killTrackerFile = io.open(CVW8Scripts.SCRIPTS_PATH .. "\\data\\" .. "kills_tracker.txt", "r")
    if killTrackerFile ~= nil then
        for line in io.lines(CVW8Scripts.SCRIPTS_PATH .. "\\data\\" .. "kills_tracker.txt") do
            local unit = Unit.getByName(line)
            if unit ~= nil then
                unit:destroy()
                trigger.action.outText("Destroyed unit: " .. line, 5)
            end
        end
        io.close(killTrackerFile)
    end
end

local function main()
    world.addEventHandler(unitDestroyedHandler)
    destroyAllTrackedUnits()
end
main()