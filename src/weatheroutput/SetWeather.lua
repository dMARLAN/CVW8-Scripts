local setWeather, createMenus

function setWeather(weatherType)
    utilities.setFileJSONValue("weather_type", weatherType, "Data.txt")

    local nextMissionToLoad = getNextMissionName()
    if (nextMissionToLoad ~= 0) then
        utilities.setFileJSONValue("mission",nextMissionToLoad .. ".miz", "Data.txt")
        executeWeatherUpdate()
        loadNextMission(nextMissionToLoad)
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