require "lfs"

local LIBRARIES_FOLDER = "libraries"
local CONSTANTS_FOLDER = "constants"
local MISSION_SCRIPTS_FOLDER = "mission_scripts"
CVW8Scripts.SCRIPTS_PATH = lfs.writedir() .. "Missions\\" .. CVW8Scripts.MISSION_FOLDER

local function loadAllLua(folder)
    local dir = CVW8Scripts.SCRIPTS_PATH .. "\\" .. folder
    for file in lfs.dir(dir) do
        if string.find(file, ".lua$") then
            dofile(dir .. "\\" .. file)
        end
    end
end

loadAllLua(LIBRARIES_FOLDER)
loadAllLua(CONSTANTS_FOLDER)
loadAllLua(MISSION_SCRIPTS_FOLDER)
