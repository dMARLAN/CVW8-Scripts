local handler = {}
local RED_FIGHTER_NAME_PREFIX = "FTR Derby Red Air "
local FIGHTER_DERBY_CENTROID_ZONE = "FTR Derby Centroid"
local FIGHTER_DERBY_ZONE = "FTR Derby Arena"
local fighterDerbyMenu = {}
local fighterDerbyCommands = {}
local fighterDerbyActive = false
local activeGroup
local activeFighterGroupID = 0
local insideZone, activateFighterDerby, abortFighterDerby, generateGroupMenu, runFighterDerby, isDead, spawnNextGroup, destroyAllRedFighterDerbyGroups

function spawnNextGroup(groupName)
    local activeGroupSpawnTable = mist.cloneGroup(groupName, true)
    activeGroup = Group.getByName(activeGroupSpawnTable.name)
end

function isDead(group)
    if (not Group.isExist(group)) then
        return false
    end
    local size = Group.getSize(group)
    for i = 1, size do
        if (Unit.getLife(Group.getUnit(group, i)) > 1) then
            return false
        end
    end
    return true
end

function runFighterDerby(wave_fighterGroup)
    local wave = wave_fighterGroup[1]
    local fighterGroup = wave_fighterGroup[2]
    local fighterGroupID = Group.getID(fighterGroup)
    local totalWaves = 8
    local currentWaveModulo = (wave % totalWaves) + 1 -- 1-8 instead of 0-7
    local nameOfRedFighterToSpawn = RED_FIGHTER_NAME_PREFIX .. currentWaveModulo

    if (fighterDerbyActive) then
        if (wave == 0) then
            local delay = 15
            trigger.action.outTextForGroup(fighterGroupID, Group.getName(fighterGroup) .. ", Fighter Derby activated.", 15)
            timer.scheduleFunction(spawnNextGroup, nameOfRedFighterToSpawn, timer.getTime() + delay)
            wave = wave + 1
            timer.scheduleFunction(runFighterDerby, { wave, fighterGroup }, timer.getTime() + delay + 5)
        elseif (isDead(activeGroup)) then
            local delay = 60
            trigger.action.outTextForGroup(fighterGroupID, Group.getName(fighterGroup) .. ", Wave: " .. wave .. " completed!", 15)
            timer.scheduleFunction(spawnNextGroup, nameOfRedFighterToSpawn, timer.getTime() + delay)
            wave = wave + 1
            timer.scheduleFunction(runFighterDerby, { wave, fighterGroup }, timer.getTime() + delay + 5)
        else
            timer.scheduleFunction(runFighterDerby, { wave, fighterGroup }, timer.getTime() + 5)
        end
    else
        trigger.action.outTextForGroup(fighterGroupID, Group.getName(fighterGroup) .. ", Event ended! You have completed up to Wave: " .. wave - 1 .. ".", 15)
    end
end

function insideZone(group, zoneName)
    local groupPoint = Unit.getPoint(Group.getUnit(group, 1))
    local zone = trigger.misc.getZone(zoneName)
    local distanceBetweenPoints = mist.utils.get2DDist(zone.point, groupPoint)
    if (distanceBetweenPoints <= zone.radius) then
        return true
    else
        return false
    end
end

function activateFighterDerby(fighterGroup)
    local fighterGroupID = Group.getID(fighterGroup)
    if (not insideZone(fighterGroup, FIGHTER_DERBY_CENTROID_ZONE)) then
        trigger.action.outTextForGroup(fighterGroupID, Group.getName(fighterGroup) .. ", you must be at the Fighter Derby Centroid to activate it.", 15)
    elseif (fighterDerbyActive) then
        trigger.action.outTextForGroup(fighterGroupID, Group.getName(fighterGroup) .. ", the Fighter Derby is already active.", 15)
    else
        missionCommands.removeItemForGroup(fighterGroupID, fighterDerbyCommands[fighterGroupID])
        fighterDerbyCommands[fighterGroupID] = missionCommands.addCommandForGroup(fighterGroupID, "Abort", fighterDerbyMenu[fighterGroupID], abortFighterDerby, { fighterGroup, true })
        activeFighterGroupID = fighterGroupID
        fighterDerbyActive = true
        runFighterDerby({ 0, fighterGroup })
    end
end

function destroyAllRedFighterDerbyGroups()
    for _, group in pairs(coalition.getGroups(coalition.side.RED)) do
        if (insideZone(group, FIGHTER_DERBY_ZONE)) then
            Group.destroy(group)
        end
    end
end

function abortFighterDerby(fighterGroup_delay_doMessage)
    local fighterGroup = fighterGroup_delay_doMessage[1]
    local doMessage = fighterGroup_delay_doMessage[2] or false
    local fighterGroupID = Group.getID(fighterGroup)
    if (doMessage) then
        trigger.action.outTextForGroup(fighterGroupID, Group.getName(fighterGroup) .. ", Fighter Derby aborted.", 15)
    end
    destroyAllRedFighterDerbyGroups()
    fighterDerbyActive = false
    missionCommands.removeItemForGroup(fighterGroupID, fighterDerbyCommands[fighterGroupID])
    fighterDerbyCommands[fighterGroupID] = missionCommands.addCommandForGroup(fighterGroupID, "Activate", fighterDerbyMenu[fighterGroupID], activateFighterDerby, fighterGroup)
end

function handler:onEvent(event)
    if event.id == world.event.S_EVENT_BIRTH and event.initiator:getPlayerName() ~= nil then
        local fighterGroup = event.initiator:getGroup()
        local fighterGroupID = Group.getID(fighterGroup)
        if (fighterDerbyMenu[fighterGroupID] == nil) then
            generateGroupMenu(fighterGroup)
        end
    end
    -- Gets hit event on any player
    if event.id == world.event.S_EVENT_HIT and event.target:getPlayerName() ~= nil then
        local fighterGroup = event.target:getGroup()
        local fighterGroupID = Group.getID(fighterGroup)
        if (fighterGroupID == activeFighterGroupID) then
            trigger.action.outTextForGroup(fighterGroupID, Group.getName(fighterGroup) .. ", a fighter was hit!", 15)
            abortFighterDerby({fighterGroup})
        end
    end
end

function generateGroupMenu(fighterGroup)
    local fighterGroupID = Group.getID(fighterGroup)
    fighterDerbyMenu[fighterGroupID] = missionCommands.addSubMenuForGroup(fighterGroupID, "Fighter Derby")
    fighterDerbyCommands[fighterGroupID] = missionCommands.addCommandForGroup(fighterGroupID, "Activate", fighterDerbyMenu[fighterGroupID], activateFighterDerby, fighterGroup)
end

local function main()
    world.addEventHandler(handler)
end
main()