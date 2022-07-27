local setWeather, createMenus

function setWeather(weatherType)
    JsonUtility.setFileJSONValue("weather_type", weatherType, DATA_FILE)

    local nextMissionToLoad = MissionUtility.getNextMissionName()
    if (nextMissionToLoad ~= 0) then
        trigger.action.outText("Loading: " .. weatherType .. "\\" .. nextMissionToLoad .. "...", 10)
        JsonUtility.setFileJSONValue("mission",nextMissionToLoad .. ".miz", DATA_FILE)
        JarUtility.executeJar("weather-update")
        MissionUtility.loadNextMission(nextMissionToLoad)
    end
end

function createMenus()
    local setWeatherMenu = missionCommands.addSubMenu("Set Weather")

    local clearDayConfirm = missionCommands.addSubMenu("Clear Day", setWeatherMenu)
    missionCommands.addCommand("Confirm", clearDayConfirm, setWeather, "clearDay")

    local clearNightConfirm = missionCommands.addSubMenu("Clear Night", setWeatherMenu)
    missionCommands.addCommand("Confirm", clearNightConfirm, setWeather, "clearNight")
end

local function main()
    createMenus()
end
main()
