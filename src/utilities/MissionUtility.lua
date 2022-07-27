MissionUtility = {}

local invertMissionIdentifier

function MissionUtility.loadNextMission(mission)
    env.info("[CVW8Scripts-MissionUtility.lua]: Load Mission: " .. MISSION_FOLDER .. "\\" .. mission .. ".miz")
    trigger.action.outText("[CVW8Scripts-MissionUtility.lua]: Load Mission: " .. MISSION_FOLDER .. "\\" .. mission .. ".miz",10,false)
end

function MissionUtility.getNextMissionName()
    local missionName = CVW8ScriptsHook.MISSION_NAME
    if (string.match(string.sub(missionName,#missionName-1),"_%a")) then
        local invertedMissionIdentifier = invertMissionIdentifier(missionName)
        if (invertedMissionIdentifier ~= 0) then
            return string.sub(missionName,0,#missionName-1) .. invertedMissionIdentifier
        end
    end
    env.info("[CVW8Scripts-MissionUtility.lua]: Could not match mission identifier")
    return 0
end

function invertMissionIdentifier(missionName)
    if (string.sub(missionName,#missionName) == "A") then return "B" end
    if (string.sub(missionName,#missionName) == "B") then return "A" end
    return 0
end