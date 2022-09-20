local DEVIL_GROUP_NAME = "DEVIL (R-FIELD-F18)"
local SNAKE_GROUP_NAME = "SNAKE (R-FIELD-F18)"
local FORD_F14_GROUP_NAME = "FORD (R-FIELD-F14)"
local FORD_F5_GROUP_NAME = "FORD (R-FIELD-F5)"
local VIPER_GROUP_NAME = "VIPER (R-FIELD-F16)"
local GROUPS_WITH_MENU = { DEVIL_GROUP_NAME, SNAKE_GROUP_NAME, FORD_F14_GROUP_NAME, FORD_F5_GROUP_NAME, VIPER_GROUP_NAME }

local RED_FLIP = "EGYP Red Flip"
local BLUE_FLIP = "EGYP Blue Flip"

local aggressorFlipMenu = {}
local menuHandler = {}
local flip, createGroupSpecificMenus, matchAnyName

function flip(groupName)
    if groupName == RED_FLIP then
        mist.respawnGroup(RED_FLIP, true)
        trigger.action.outText(RED_FLIP, 15)
        if (Group.getByName(BLUE_FLIP)) then
            Group.destroy(Group.getByName(BLUE_FLIP))
        end
    else
        mist.respawnGroup(BLUE_FLIP, true)
        trigger.action.outText(BLUE_FLIP, 15)
        if (Group.getByName(RED_FLIP)) then
            Group.destroy(Group.getByName(RED_FLIP))
        end
    end
end

function menuHandler:onEvent(event)
    if event.id == world.event.S_EVENT_BIRTH and event.initiator:getPlayerName() ~= nil then
        if matchAnyName(Group.getName(event.initiator:getGroup()), GROUPS_WITH_MENU)  then
            local group = event.initiator:getGroup()
            local groupId = Group.getID(group)
            if aggressorFlipMenu[groupId] == nil then
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

    aggressorFlipMenu[groupId] = missionCommands.addSubMenuForGroup(groupId, "EGYP Flip Menu")

    local redFlipCommandName = "Flip EGYP: Red"
    missionCommands.addCommandForGroup(groupId, redFlipCommandName, aggressorFlipMenu[groupId], flip, RED_FLIP)

    local blueFlipCommandName = "Flip EGYP: Blue"
    missionCommands.addCommandForGroup(groupId, blueFlipCommandName, aggressorFlipMenu[groupId], flip, BLUE_FLIP)

end

local function main()
    world.addEventHandler(menuHandler)
end
main()
