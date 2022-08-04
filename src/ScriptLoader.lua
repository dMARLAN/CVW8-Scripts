require "lfs"

local LIBRARIES = "libraries"
local MISSION_SCRIPTS = "mission_scripts"

local function loadAllLua(folder)
    local dir = DCSWeather.SCRIPTS_PATH .. "\\" .. folder
    for file in lfs.dir(dir) do
        if string.find(file, ".lua$") then
            dofile(dir .. "\\" .. file)
            DCSWeather.Logger.Info(THIS_FILE, "Loaded: " .. folder .. "\\" .. file)
        end
    end
end

loadAllLua(LIBRARIES)
loadAllLua(MISSION_SCRIPTS)
