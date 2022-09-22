local GROUPS_WITH_MENU = { "UZI", "ENFIELD", "COLT", "PONTIAC", "SPRINGFIELD", "DODGE", "FORD", "CHEVY" }

local RED_SINGLE = "BVR Lab (PVE) Red Center"
local RED_NORTH = "BVR Lab (PVE) Red North"
local RED_SOUTH = "BVR Lab (PVE) Red South"
local RED_LEAD = "BVR Lab (PVE) Red Lead"
local RED_TRAIL = "BVR Lab (PVE) Red Trail"
local RED_SAR1 = "BVR Lab (PVE) Red SAR-1"
local ALL_RED_GROUPS = { RED_SINGLE, RED_NORTH, RED_SOUTH, RED_LEAD, RED_TRAIL, RED_SAR1 }

local bvrAirstartMenu = {}
local menuHandler = {}
local spawn, reset, createGroupSpecificMenus, matchAnyName

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
        if matchAnyName(Group.getName(event.initiator:getGroup()), GROUPS_WITH_MENU) then
            local group = event.initiator:getGroup()
            local groupId = Group.getID(group)
            if bvrAirstartMenu[groupId] == nil then
                createGroupSpecificMenus(groupId)
            end
        end
    end
end

function matchAnyName(groupNameToCheck, namesTable)
    for _, name in pairs(namesTable) do
        if string.match(groupNameToCheck,name) then
            return true
        end
    end
    return false
end

function createGroupSpecificMenus(groupId)

    bvrAirstartMenu[groupId] = missionCommands.addSubMenuForGroup(groupId, "BVR Lab (PVE) Spawn Menu")

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
