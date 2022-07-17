# cvw8-scripts

phase = "awn"
metocActive = true
path = lfs.writedir() .. "Missions\\" .. phase .. "\\"
loadfile(path.."ScriptLoader.lua")(phase,metocActive,path)
 
