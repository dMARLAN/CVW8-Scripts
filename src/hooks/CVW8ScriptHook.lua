net.log("[CVW8ScriptsHook]: Loading callbacks")

local cvw8ScriptsHook = {}

function cvw8ScriptsHook.onMissionLoadEnd()
    missionName = DCS.getMissionName()
    code = [[a_do_script("MISSION_NAME = \"]] .. missionName .. [[\"")]]
    net.dostring_in("mission", code)
    net.log("[CVW8ScriptsHook]: MISSION_NAME injected into Trigger Environment")
end

function cvw8ScriptsHook.onTriggerMessage(message, duration, clearView)
    if (string.match(message,"CVW8Scripts: Load Mission: ")) then
        local mission = string.match(message,"CVW8Scripts:%sLoad Mission:%s(.*)")
        net.log("[CVW8ScriptsHook]: Loading: " .. lfs.writedir() .. "Missions\\" .. mission .. ".miz")
        net.load_mission(lfs.writedir() .. "Missions\\" .. mission .. ".miz")
    end
end

DCS.setUserCallbacks(cvw8ScriptsHook)
net.log("[CVW8ScriptsHook]: Callbacks loaded")
