require "lfs"

local LIBRARIES_FOLDER = "libraries"
local CONSTANTS_FOLDER = "constants"
local MISSION_SCRIPTS_FOLDER = "mission_scripts"
local MODULE_NAME = "CVW8-Scripts"
local THIS_FILE = MODULE_NAME .. ".ScriptLoader"

local function loadAllLua(folder)
    local dir = DCSWeather.SCRIPTS_PATH .. "\\" .. folder
    for file in lfs.dir(dir) do
        if string.find(file, ".lua$") then
            dofile(dir .. "\\" .. file)
            DCSWeather.Logger.Info(THIS_FILE, "Loaded: " .. folder .. "\\" .. file)
        end
    end
end

loadAllLua(LIBRARIES_FOLDER)
loadAllLua(CONSTANTS_FOLDER)
loadAllLua(MISSION_SCRIPTS_FOLDER)
