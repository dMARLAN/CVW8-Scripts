local unitDestroyedHandler = {}
local trackedUnits = {}

local DATA_PATH = CVW8Scripts.SCRIPTS_PATH .. "\\data\\"
local FILE_NAME = "kills_tracker.txt"

local function addUnitToKillTrackerFile(destroyedUnitName)
    for _, unitName in pairs(trackedUnits) do
        if unitName == destroyedUnitName then
            return
        end
    end

    local killTrackerFile = io.open(DATA_PATH .. FILE_NAME, "a")
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
    local killTrackerFile = io.open(DATA_PATH .. FILE_NAME, "r")
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

local function createDataFolderIfNotExist()
    if not lfs.attributes(DATA_PATH) then
        lfs.mkdir(DATA_PATH)
    end
end

local function main()
    world.addEventHandler(unitDestroyedHandler)
    createDataFolderIfNotExist()
    destroyAllTrackedUnits()
end
main()