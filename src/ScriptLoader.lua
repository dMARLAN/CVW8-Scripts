require "lfs"

local args={...}
CURRENT_PHASE = args[1]
METOC_ACTIVE = args[2]
SCRIPTS_PATH = args[3]

local LIBRARIES_FOLDER_NAME = "libraries"
WEATHER_OUTPUT_FOLDER_NAME = "weatheroutput"

local function loadAll(dir)
    for file in lfs.dir(dir) do
        if string.find(file, ".lua$") then
            dofile(dir .. "\\" .. file)
        end
    end
end

loadAll(SCRIPTS_PATH .. "\\" .. LIBRARIES_FOLDER_NAME)
loadAll(SCRIPTS_PATH .. "\\" .. CURRENT_PHASE)
loadAll(SCRIPTS_PATH .. "\\" .. WEATHER_OUTPUT_FOLDER_NAME)