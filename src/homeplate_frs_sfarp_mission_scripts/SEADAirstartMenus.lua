local HORNET_GROUP_NAME = "SEAD (Airstart) Blue Hornets"
local GROUPS_WITH_MENU = { HORNET_GROUP_NAME }

local RED_SA2 = "SEAD-SAM (Airstart) SA2"
local RED_SA3 = "SEAD-SAM (Airstart) SA3"
local RED_SA6 = "SEAD-SAM (Airstart) SA6"
local RED_SA10 = "SEAD-SAM (Airstart) SA10"
local RED_SA11 = "SEAD-SAM (Airstart) SA11"
local RED_SA15 = "SEAD-SAM (Airstart) SA15"
local RED_EWR = "SEAD-EWR (Airstart) EWR"
local ALL_RED_GROUPS = { RED_SA2, RED_SA3, RED_SA6, RED_SA10, RED_SA11, RED_SA15, RED_EWR }

local seadAirstartMenu = {}
local menuHandler = {}
local spawn, reset, createGroupSpecificMenus, matchAnyName, reinitializeSkynet

function spawn(groupNames)
    for _, groupName in pairs(groupNames) do
        mist.respawnGroup(groupName, true)
        reinitializeSkynet(groupName)
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

function reinitializeSkynet(groupName)
    if (seadAirstartIADS) then
        seadAirstartIADS:addSAMSite(groupName)
        seadAirstartIADS:activate()
    end
end

function menuHandler:onEvent(event)
    if event.id == world.event.S_EVENT_BIRTH and event.initiator:getPlayerName() ~= nil then
        if matchAnyName(Group.getName(event.initiator:getGroup()), GROUPS_WITH_MENU)  then
            local group = event.initiator:getGroup()
            local groupId = Group.getID(group)
            if seadAirstartMenu[groupId] == nil then
                createGroupSpecificMenus(groupId)
            end
        end
    end
end

function matchAnyName(groupNameToCheck, namesTable)
    for _, name in pairs(namesTable) do
        if groupNameToCheck == name then
            return true
        end
    end
    return false
end

function createGroupSpecificMenus(groupId)

    seadAirstartMenu[groupId] = missionCommands.addSubMenuForGroup(groupId, "SEAD (Airstart) Spawn Menu")

    local sa2CommandName = "Spawn SA-2"
    local sa2GroupsToSpawn = { RED_SA2, RED_EWR }
    missionCommands.addCommandForGroup(groupId, sa2CommandName, seadAirstartMenu[groupId], spawn, sa2GroupsToSpawn)

    local sa3CommandName = "Spawn SA-3"
    local sa3GroupsToSpawn = { RED_SA3, RED_EWR }
    missionCommands.addCommandForGroup(groupId, sa3CommandName, seadAirstartMenu[groupId], spawn, sa3GroupsToSpawn)

    local sa6CommandName = "Spawn SA-6"
    local sa6GroupsToSpawn = { RED_SA6, RED_EWR }
    missionCommands.addCommandForGroup(groupId, sa6CommandName, seadAirstartMenu[groupId], spawn, sa6GroupsToSpawn)

    local sa10CommandName = "Spawn SA-10"
    local sa10GroupsToSpawn = { RED_SA10, RED_EWR }
    missionCommands.addCommandForGroup(groupId, sa10CommandName, seadAirstartMenu[groupId], spawn, sa10GroupsToSpawn)

    local sa11CommandName = "Spawn SA-11"
    local sa11GroupsToSpawn = { RED_SA11, RED_EWR }
    missionCommands.addCommandForGroup(groupId, sa11CommandName, seadAirstartMenu[groupId], spawn, sa11GroupsToSpawn)

    local sa15CommandName = "Spawn SA-15"
    local sa15GroupsToSpawn = { RED_SA15, RED_EWR }
    missionCommands.addCommandForGroup(groupId, sa15CommandName, seadAirstartMenu[groupId], spawn, sa15GroupsToSpawn)

    local resetCommandName = "Reset"
    missionCommands.addCommandForGroup(groupId, resetCommandName, seadAirstartMenu[groupId], reset)
end

local function main()
    world.addEventHandler(menuHandler)
end
main()
