local unitDestroyedHandler = {}
local trackedUnits = {}

local function addUnitToKillTrackerFile(destroyedUnitName)
    for _, unitName in pairs(trackedUnits) do
        if unitName == destroyedUnitName then
            return
        end
    end

    local dataPath = CVW8Scripts.SCRIPTS_PATH .. "\\data\\"
    local fileName = dataPath .. "kills_tracker.txt"

    if not lfs.attributes(dataPath) then
        lfs.mkdir(dataPath)
    end

    local killTrackerFile = io.open(fileName, "a")
    io.write(killTrackerFile, destroyedUnitName .. "\n")
    io.flush(killTrackerFile)
    io.close(killTrackerFile)
end

function unitDestroyedHandler:onEvent(event)
    if event.id == world.event.S_EVENT_DEAD then
        if event.initiator ~= nil and
                event.initiator:getCategory() == Object.Category.UNIT and
                event.initiator:getCoalition() == coalition.side.RED then
            local destroyedUnitName = event.initiator:getName()
            addUnitToKillTrackerFile(destroyedUnitName)
        end
    end
end

local function destroyAllTrackedUnits()
    local killTrackerFile = io.open(CVW8Scripts.SCRIPTS_PATH .. "\\data\\" .. "kills_tracker.txt", "r")
    if killTrackerFile ~= nil then
        for line in killTrackerFile:lines() do
            local unit = Unit.getByName(line)
            if unit ~= nil then
                trackedUnits[#trackedUnits + 1] = unit
                unit:destroy()
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