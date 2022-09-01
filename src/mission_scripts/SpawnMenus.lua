---
--- Generates Spawn Menus using String Flags from Mission Editor Group Names
--- Set " *S " to indicate a group is spawnable and will be added to a menu.
--- Set " #x " where x is a location to group spawnables together.
--- A location is not required and will groups will be placed in an undefined menu.
--- Requires MIST
--- @author Marlan
---

-- TODO: Lists are limited to 10 options, need to create "next page" or similar function to allow overflow.
-- TODO: Add a flag to group together units to spawn all together. " *G1 " maybe..
-- LIMITATION: as above, adding more than 10 options to a single menu will overflow the menu and not be displayed.

local getSpawnableGroups, getSpawnableStatics, getLocationsAndSortGroups, reinitializeSkynet, removeSymbols, getLocation, spawn, despawn, generateMenus, sort

--- Gets all groups in the mission that have a "*S" flag.
--- @return table
function getSpawnableGroups()
    local spawnableGroups = {}
    for _, side in pairs(coalition.side) do
        for _, group in pairs(coalition.getGroups(side)) do
            local matched = string.match(Group.getName(group), "%*S")
            if (matched) then
                table.insert(spawnableGroups, group)
            end
        end
    end
    return spawnableGroups
end

--- Gets all statics in the mission that have a "*S" flag.
--- @return table
function getSpawnableStatics()
    local spawnableStatics = {}
    for _, side in pairs(coalition.side) do
        for _, static in pairs(coalition.getStaticObjects(side)) do
            local matched = string.match(StaticObject.getName(static), "%*S")
            if (matched) then
                table.insert(spawnableStatics, static)
            end
        end
    end
    return spawnableStatics
end

--- Sorts flagged groups by #location flag, otherwise placed
--- into undefined table.
--- @return table,table
function getLocationsAndSortGroups()
    local spawnableGroups = getSpawnableGroups()
    local spawnableStatics = getSpawnableStatics()
    local locations = {}
    local groupsWithUndefinedLocation = {}
    for _, group in pairs(spawnableGroups) do
        local groupName = Group.getName(group)
        local locationTag = string.match(groupName, "%#([A-z0-9%s%p]+)")
        if (locationTag) then
            if (not locations[locationTag]) then
                locations[locationTag] = {}
            end -- if location doesn't exist yet, initialize table
            table.insert(locations[locationTag], groupName) -- add group at its location
        else
            table.insert(groupsWithUndefinedLocation, groupName)
        end
    end
    for _, static in pairs(spawnableStatics) do
        local staticName = StaticObject.getName(static)
        local matched = string.match(staticName, "%#([A-z0-9%s%p]+)")
        if (matched) then
            if (not locations[matched]) then
                locations[matched] = {}
            end -- if location doesn't exist yet, initialize table
            table.insert(locations[matched], staticName) -- add group at its location
        else
            table.insert(groupsWithUndefinedLocation, staticName)
        end
    end
    return locations, groupsWithUndefinedLocation
end

--- Reinitializes Skynet
--- @param groupName string
function reinitializeSkynet(groupName)
    if (redIADS) then
        redIADS:addSAMSite(groupName)
        redIADS:activate()
    end
end

--- @param s string
--- @return string
function removeSymbols(s)
    local str = s
    str = string.gsub(str, "%-", " ") -- replace dashes with spaces
    str = string.gsub(str, "%*(.*)", "") -- removes everything after *
    return str
end

--- @param groupName string
--- @return string is prefixed with "at"
function getLocation(groupName)
    local location = string.match(groupName, "%#([A-z0-9%s%p]+)")
    location = string.gsub(location, "%-", " ") -- replace dashes with spaces
    if (not location) then
        location = ""
    else
        location = " (" .. location .. ")"
    end
    return location
end

--- Spawns or respawns (if existing) group by name.
--- @param name string
function spawn(name)
    local ref = mist.DBs.groupsByName[name]
    local route
    if ref.category ~= "static" then
        route = true
    end
    mist.respawnGroup(name, route)
    if string.find(name, "SAM") then
        reinitializeSkynet(name)
    end
    trigger.action.outText(removeSymbols(name) .. getLocation(name) .. " spawned.", 15)
end

--- Deletes group by name.
--- @param name string
function despawn(name)
    local ref = mist.DBs.groupsByName[name]
    if ref.category == "static" then
        StaticObject.destroy(StaticObject.getByName(name))
    else
        if (Group.getByName(name)) then
            Group.destroy(Group.getByName(name))
        end
    end
    trigger.action.outText(removeSymbols(name) .. getLocation(name) .. " despawned.", 15)
end

--- @param locations table
--- @param groupsWithUndefinedLocation table
function generateMenus(locations, groupsWithUndefinedLocation)
    if (next(locations) ~= nil or next(groupsWithUndefinedLocation) ~= nil) then
        local mainMenu = missionCommands.addSubMenu("Spawning Menu")
        for _, location in pairs(locations) do
            local locationMenu = missionCommands.addSubMenu(removeSymbols(location.name), mainMenu)
            for _, group in pairs(location.groups) do
                local locationGroupMenu = missionCommands.addSubMenu(removeSymbols(group), locationMenu)
                missionCommands.addCommand("Spawn", locationGroupMenu, spawn, group)
                missionCommands.addCommand("Despawn", locationGroupMenu, despawn, group)
            end
        end
        if (#groupsWithUndefinedLocation > 0) then
            local undefinedLocationMenu = missionCommands.addSubMenu("Undefined", mainMenu)
            for i = 1, #groupsWithUndefinedLocation do
                local undefinedLocationGroupMenu = missionCommands.addSubMenu(removeSymbols(groupsWithUndefinedLocation[i]), undefinedLocationMenu)
                missionCommands.addCommand("Spawn", undefinedLocationGroupMenu, spawn, groupsWithUndefinedLocation[i])
                missionCommands.addCommand("Despawn", undefinedLocationGroupMenu, despawn, groupsWithUndefinedLocation[i])
            end
        end
    end
end

--- @param locations table
--- @return table
function sort(locations)
    local sortedLocations = {}
    local locationsNames = {}

    -- Sort location names
    for location, _ in pairs(locations) do
        table.insert(locationsNames, location)
    end
    table.sort(locationsNames)

    -- Sort groups and insert into sorted table
    for _, locationName in ipairs(locationsNames) do
        local sortedLocationAndGroups = {}
        sortedLocationAndGroups.name = locationName
        sortedLocationAndGroups.groups = {}

        local locationGroups = {}
        for _, group in pairs(locations[locationName]) do
            table.insert(locationGroups, group)
        end
        table.sort(locationGroups)

        for _, group in ipairs(locationGroups) do
            table.insert(sortedLocationAndGroups.groups, group)
        end

        table.insert(sortedLocations, sortedLocationAndGroups)
    end

    return sortedLocations
end

--- Main Method
local function main()
    local locations, groupsWithUndefinedLocation = getLocationsAndSortGroups()
    local sortedLocations = sort(locations)
    generateMenus(sortedLocations, groupsWithUndefinedLocation)
end
main()