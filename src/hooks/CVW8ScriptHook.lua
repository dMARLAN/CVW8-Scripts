net.log("[CVW8Scripts-ScriptHook.lua]: Loading callbacks")

local CVW8ScriptsHook = {}
local doStringInUtility

function CVW8ScriptsHook.onMissionLoadEnd()
    local missionName = DCS.getMissionName()

    doStringInUtility("CVW8ScriptsHook = {}")

    local code = [[a_do_script("CVW8ScriptsHook.MISSION_NAME = \"]] .. missionName .. [[\"")]]
    net.dostring_in("mission", code)
    net.log("[CVW8ScriptsHook-ScriptHook.lua]: CVW8ScriptsHook.MISSION_NAME injected into Trigger Environment")
end

function CVW8ScriptsHook.onTriggerMessage(message, duration, clearView)
    if (string.match(message,"[CVW8Scripts-MissionUtility.lua]: Load Mission: ")) then
        local mission = string.match(message,"[CVW8Scripts-MissionUtility.lua]:%sLoad Mission:%s(.*)")
        net.log("[CVW8ScriptsHook]: Loading: " .. lfs.writedir() .. "Missions\\" .. mission .. ".miz")
        net.load_mission(lfs.writedir() .. "Missions\\" .. mission .. ".miz")
    end
end

function doStringInUtility(code)
    local input = "a_do_script(\"" .. code .. "\")"
    net.dostring_in("mission", input)
end

DCS.setUserCallbacks(CVW8ScriptsHook)
net.log("[CVW8ScriptsHook-ScriptHook.lua]: Callbacks loaded")
