require "lfs"

CURRENT_PHASE = "awn" -- TODO: Get this from the data file
METOC_ACTIVE = true --  TODO: Get this from the data file
SCRIPTS_PATH = lfs.writedir() .. "Missions\\" .. CURRENT_PHASE

local LIBRARIES_FOLDER = "libraries"
local CURRENT_PHASE_FOLDER = CURRENT_PHASE
local UTILITIES_FOLDER = "utilities"
local WEATHER_OUTPUT_FOLDER = "weatheroutput"

local function loadAll(dir)
    for file in lfs.dir(dir) do
        if string.find(file, ".lua$") then
            dofile(dir .. "\\" .. file)
        end
    end
end

loadAll(SCRIPTS_PATH .. "\\" .. LIBRARIES_FOLDER)
loadAll(SCRIPTS_PATH .. "\\" .. UTILITIES_FOLDER)
loadAll(SCRIPTS_PATH .. "\\" .. CURRENT_PHASE_FOLDER)
loadAll(SCRIPTS_PATH .. "\\" .. WEATHER_OUTPUT_FOLDER)
