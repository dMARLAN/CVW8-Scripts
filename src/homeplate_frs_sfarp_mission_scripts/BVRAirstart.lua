local HORNET_GROUP_NAME = "BVR (Airstart) Blue Hornets"
local TOMCAT_GROUP_NAME = "BVR (Airstart) Blue Tomcats"
local bvrAirstartMenu = {}
local menuHandler = {}
local spawn, reset, createGroupSpecificMenus

function spawn(groupNames)
    for _, groupName in pairs(groupNames) do
        mist.respawnGroup(groupName, true)
        trigger.action.outText(groupName .. " spawned.", 15)
    end
end

function reset()
end

function menuHandler:onEvent(event)
    if event.id == world.event.S_EVENT_BIRTH and event.initiator:getPlayerName() ~= nil then
        if (Group.getName(event.initiator:getGroup()) == HORNET_GROUP_NAME) or (Group.getName(event.initiator:getGroup()) == TOMCAT_GROUP_NAME) then
            local group = event.initiator:getGroup()
            local groupId = Group.getID(group)
            if bvrAirstartMenu[groupId] == nil then
                createGroupSpecificMenus(groupId)
            end
        end
    end
end

function createGroupSpecificMenus(groupId)

    bvrAirstartMenu[groupId] = missionCommands.addSubMenuForGroup(groupId,"BVR (Airstart) Spawn Menu")

    local singleGroupCommandName = "Spawn Single Group (SAR-2)"
    local singleGroupGroupsToSpawn = {"BVR (Airstart) Red Single"}
    missionCommands.addCommandForGroup(singleGroupCommandName,  bvrAirstartMenu[groupId], spawn, singleGroupGroupsToSpawn)

    local azimuthCommandName = "Spawn Azimuth (SAR-2)"
    local azimuthGroupsToSpawn = {"BVR (Airstart) Red Azimuth North", "BVR (Airstart) Red Azimuth South"}
    missionCommands.addCommandForGroup(azimuthCommandName,  bvrAirstartMenu[groupId], spawn, azimuthGroupsToSpawn)

    local rangeCommandName = "Spawn Range (SAR-2)"
    local rangeGroupsToSpawn = {"BVR (Airstart) Red Ladder Lead", "BVR (Airstart) Red Single"}
    missionCommands.addCommandForGroup(rangeCommandName,  bvrAirstartMenu[groupId], spawn, rangeGroupsToSpawn)

    local wallCommandName = "Spawn Wall (SAR-2)"
    local wallGroupsToSpawn = {"BVR (Airstart) Red Azimuth North", "BVR (Airstart) Red Azimuth South", "BVR (Airstart) Red Single"}
    missionCommands.addCommandForGroup(wallCommandName,  bvrAirstartMenu[groupId], spawn, wallGroupsToSpawn)

    local ladderCommandName = "Spawn Ladder (SAR-2)"
    local ladderGroupsToSpawn = {"BVR (Airstart) Red Ladder Lead", "BVR (Airstart) Red Single", "BVR (Airstart) Red Ladder Trail"}
    missionCommands.addCommandForGroup(ladderCommandName,  bvrAirstartMenu[groupId], spawn, ladderGroupsToSpawn)

    local vicCommandName = "Spawn Vic (SAR-2)"
    local vicGroupsToSpawn = {"BVR (Airstart) Red Ladder Lead", "BVR (Airstart) Red Azimuth North", "BVR (Airstart) Red Azimuth South"}
    missionCommands.addCommandForGroup(vicCommandName,  bvrAirstartMenu[groupId], spawn, vicGroupsToSpawn)

    local champagneCommandName = "Spawn Champagne (SAR-2)"
    local champagneGroupsToSpawn = {"BVR (Airstart) Red Ladder Trail", "BVR (Airstart) Red Azimuth North", "BVR (Airstart) Red Azimuth South"}
    missionCommands.addCommandForGroup(champagneCommandName,  bvrAirstartMenu[groupId], spawn, champagneGroupsToSpawn)

    local heavySarOneSingleGroupCommandName = "Spawn Single Group (Heavy, SAR-1)"
    local heavySarOneSingleGroupGroupsToSpawn = {"BVR (Airstart) Red Single SAR-1"}
    missionCommands.addCommandForGroup(heavySarOneSingleGroupCommandName,  bvrAirstartMenu[groupId], spawn, heavySarOneSingleGroupGroupsToSpawn)

    local resetCommandName = "Reset"
    missionCommands.addCommandForGroup(resetCommandName,  bvrAirstartMenu[groupId], reset)
end

local function main()
    world.addEventHandler(groupMenuHandler)
end
main()
