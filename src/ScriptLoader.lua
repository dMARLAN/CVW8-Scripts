require "lfs"

local args={...}
CURRENT_PHASE = args[1]
METOC_ACTIVE = args[2]
SCRIPTS_PATH = args[3]

local LIBRARIES_FOLDER = "libraries"
local CURRENT_PHASE_FOLDER = CURRENT_PHASE
local UTILITIES_FOLDER = "utilities"
WEATHER_OUTPUT_FOLDER = "weatheroutput"

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
