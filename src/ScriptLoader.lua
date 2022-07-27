require "lfs"

SCRIPTS_PATH = lfs.writedir() .. "Missions\\" .. MISSION_FOLDER
DATA_FILE = "dao.json"

local LIBRARIES_FOLDER = "libraries"
local MISSION_SCRIPTS_FOLDER = "mission_scripts"
local UTILITIES_FOLDER = "utilities"
local MODEL_FOLDER = "model"
local WEATHER_OUTPUT_FOLDER = "weatheroutput"

local function loadAllLua(dir)
    for file in lfs.dir(dir) do
        if string.find(file, ".lua$") then
            dofile(dir .. "\\" .. file)
        end
    end
end

loadAllLua(SCRIPTS_PATH .. "\\" .. LIBRARIES_FOLDER)
loadAllLua(SCRIPTS_PATH .. "\\" .. UTILITIES_FOLDER)
loadAllLua(SCRIPTS_PATH .. "\\" .. MODEL_FOLDER)
loadAllLua(SCRIPTS_PATH .. "\\" .. MISSION_SCRIPTS_FOLDER)
loadAllLua(SCRIPTS_PATH .. "\\" .. WEATHER_OUTPUT_FOLDER)
