require "lfs"

MISSION_SCRIPTS_FOLDER = "awn" -- TODO: Get this from the data file
SCRIPTS_PATH = lfs.writedir() .. "Missions\\" .. MISSION_SCRIPTS_FOLDER

local LIBRARIES_FOLDER = "libraries"
local CURRENT_PHASE_FOLDER = MISSION_SCRIPTS_FOLDER
local UTILITIES_FOLDER = "utilities"
local MODEL_FOLDER = "model"
local WEATHER_OUTPUT_FOLDER = "weatheroutput"

local function loadAll(dir)
    for file in lfs.dir(dir) do
        if string.find(file, ".lua$") then
            dofile(dir .. "\\" .. file)
        end
    end
end

utilities = {}
loadAll(SCRIPTS_PATH .. "\\" .. LIBRARIES_FOLDER)
loadAll(SCRIPTS_PATH .. "\\" .. UTILITIES_FOLDER)
loadAll(SCRIPTS_PATH .. "\\" .. MODEL_FOLDER)
loadAll(SCRIPTS_PATH .. "\\" .. CURRENT_PHASE_FOLDER)
loadAll(SCRIPTS_PATH .. "\\" .. WEATHER_OUTPUT_FOLDER)
