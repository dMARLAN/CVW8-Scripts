---
--- Requires Mist
--- @author Marlan
---

local SPAWNING_AREA = {}
SPAWNING_AREA[1] = { "Saipan",
					 "SAM-SA2-Saipan",
					 "SAM-SA3-Saipan",
					 "Armored-Targets-Saipan" }
SPAWNING_AREA[2] = { "Tinian",
					 "AAA-Tinian",
					 "SAM-SA8-Tinian",
					 "SAM-SA6-Tinian",
					 "SCUDS-Tinian" }
SPAWNING_AREA[3] = { "Rota",
					 "Armored-Targets-Rota",
					 "Soft-Targets-Rota",
					 "Moving-Targets-Rota",
					 "Bunkers-Rota",
					 "Sam-SA2-Rota",
					 "Sam-SA3-Rota",
					 "Sam-SA6-Rota",
					 "Sam-SA11-Rota" }
SPAWNING_AREA[4] = { "BVR Lab",
					 "MIG29-North-SAR2-BVRLab",
					 "MIG29-South-SAR2-BVRLab",
					 "MIG29-North-SAR1-BVRLab",
					 "MIG29-South-SAR1-BVRLab" }
SPAWNING_AREA[5] = { "Guam",
					 "Targets-GuamRange"}
SPAWNING_AREA[6] = { "FDM Range",
					 "TODO" }

local function reinitializeSkynet(groupName)
	redIADS:addSAMSite(groupName)
	redIADS:activate()
end

local function removeDashes(str)
	return str:gsub("%-", " ")
end

local function removeLocation(str)
	return str:gsub("[-][^-]*$","")
end

local function spawnGroup(groupName)
    mist.respawnGroup(groupName, true)
    if groupName:find("SAM") then reinitializeSkynet(groupName) end
    trigger.action.outText(removeDashes(groupName) .. " spawned.", 15)
end

local function despawnGroup(groupName)
    Group.destroy(Group.getByName(groupName))
    trigger.action.outText(removeDashes(groupName) .. " despawned.", 15)
end

local function main()
	-- Spawning Menu, sets first item in area[][] as title for first sub menu. All other items are added as choices with spawn/despawn commands.
	local mainMenu = missionCommands.addSubMenu("Spawning Menu")
	for i = 1, #SPAWNING_AREA do
		local subMenu1 = missionCommands.addSubMenu(removeDashes(SPAWNING_AREA[i][1]), mainMenu)
		for j = 2, #SPAWNING_AREA[i] do
			local subMenu2 = missionCommands.addSubMenu((removeDashes(removeLocation(SPAWNING_AREA[i][j]))), subMenu1)
			missionCommands.addCommand("Spawn", subMenu2, spawnGroup, SPAWNING_AREA[i][j])
			missionCommands.addCommand("Despawn", subMenu2, despawnGroup, SPAWNING_AREA[i][j])
		end
	end
end
main()