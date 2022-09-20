local HORNET_GROUP_NAME = "BVR (Airstart) Blue Hornets"
local TOMCAT_GROUP_NAME = "BVR (Airstart) Blue Tomcats"

local RED_SINGLE = "BVR (Airstart) Red Center"
local RED_NORTH = "BVR (Airstart) Red North"
local RED_SOUTH = "BVR (Airstart) Red South"
local RED_LEAD = "BVR (Airstart) Red Lead"
local RED_TRAIL = "BVR (Airstart) Red Trail"
local RED_SAR1 = "BVR (Airstart) Red SAR-1"
local ALL_RED_GROUPS = { RED_SINGLE, RED_NORTH, RED_SOUTH, RED_LEAD, RED_TRAIL, RED_SAR1 }

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
    for _, groupName in pairs(ALL_RED_GROUPS) do
        if (Group.getByName(groupName)) then
            Group.destroy(Group.getByName(groupName))
        end
    end
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

    bvrAirstartMenu[groupId] = missionCommands.addSubMenuForGroup(groupId, "BVR (Airstart) Spawn Menu")

    local singleGroupCommandName = "Spawn Single Group (SAR-2)"
    local singleGroupGroupsToSpawn = { RED_SINGLE }
    missionCommands.addCommandForGroup(groupId, singleGroupCommandName, bvrAirstartMenu[groupId], spawn, singleGroupGroupsToSpawn)

    local azimuthCommandName = "Spawn Azimuth (SAR-2)"
    local azimuthGroupsToSpawn = { RED_NORTH, RED_SOUTH }
    missionCommands.addCommandForGroup(groupId, azimuthCommandName, bvrAirstartMenu[groupId], spawn, azimuthGroupsToSpawn)

    local rangeCommandName = "Spawn Range (SAR-2)"
    local rangeGroupsToSpawn = { RED_LEAD, RED_SINGLE }
    missionCommands.addCommandForGroup(groupId, rangeCommandName, bvrAirstartMenu[groupId], spawn, rangeGroupsToSpawn)

    local wallCommandName = "Spawn Wall (SAR-2)"
    local wallGroupsToSpawn = { RED_NORTH, RED_SOUTH, RED_SINGLE }
    missionCommands.addCommandForGroup(groupId, wallCommandName, bvrAirstartMenu[groupId], spawn, wallGroupsToSpawn)

    local ladderCommandName = "Spawn Ladder (SAR-2)"
    local ladderGroupsToSpawn = { RED_LEAD, RED_SINGLE, RED_TRAIL }
    missionCommands.addCommandForGroup(groupId, ladderCommandName, bvrAirstartMenu[groupId], spawn, ladderGroupsToSpawn)

    local vicCommandName = "Spawn Vic (SAR-2)"
    local vicGroupsToSpawn = { RED_LEAD, RED_NORTH, RED_SOUTH }
    missionCommands.addCommandForGroup(groupId, vicCommandName, bvrAirstartMenu[groupId], spawn, vicGroupsToSpawn)

    local champagneCommandName = "Spawn Champagne (SAR-2)"
    local champagneGroupsToSpawn = { RED_TRAIL, RED_NORTH, RED_SOUTH }
    missionCommands.addCommandForGroup(groupId, champagneCommandName, bvrAirstartMenu[groupId], spawn, champagneGroupsToSpawn)

    local heavySarOneSingleGroupCommandName = "Spawn Single Group (Heavy, SAR-1)"
    local heavySarOneSingleGroupGroupsToSpawn = { RED_SAR1 }
    missionCommands.addCommandForGroup(groupId, heavySarOneSingleGroupCommandName, bvrAirstartMenu[groupId], spawn, heavySarOneSingleGroupGroupsToSpawn)

    local resetCommandName = "Reset"
    missionCommands.addCommandForGroup(groupId, resetCommandName, bvrAirstartMenu[groupId], reset)
end

local function main()
    world.addEventHandler(menuHandler)
end
main()
