local PRE_EVENT_TIME = DCSDynamicWeather.JSON.getValue("pre_event_time", DCSDynamicWeather.CONFIG_PATH)
local RECOVERY_DURATION = DCSDynamicWeather.JSON.getValue("recovery_duration", DCSDynamicWeather.CONFIG_PATH)

local SOUND_DIRECTORY = "Sounds/"
local START_UP_SOUND = SOUND_DIRECTORY ..  "SpoolCaseIStarts.ogg"
local SHOOT_EM_SOUND = SOUND_DIRECTORY .. "SpoolShootEm.ogg"
local LENS_ON_SOUND = SOUND_DIRECTORY .. "SpoolLensOn.ogg"
local RECOVERY_COMPLETE_SOUND = SOUND_DIRECTORY .. "SpoolRecoveryComplete.ogg"

local CARRIER_NAME = "USS Roosevelt" -- This should be automatically gotten eventually.

local function convertRadioFreqStringToInt(radioFreqStr)
    return tonumber(string.gsub(radioFreqStr, "%.", "") .. "000")
end

local function scheduleRadioSound(playTime, soundFileName)
    local currentTime = timer.getAbsTime()
    if currentTime > playTime then
        return
    end

    local playSoundFunction = function()
        trigger.action.outSound(soundFileName)
        trigger.action.radioTransmission(
                soundFileName,
                Unit.getByName(CARRIER_NAME):getPoint(),
                0,
                false,
                convertRadioFreqStringToInt(RADIOS.BTN_1),
                100
        )
    end

    timer.scheduleFunction(playSoundFunction, nil, playTime - currentTime)
end

local function getEventWindows()
    local firstEventAbsTimeSecs = DCSDynamicWeather.JSON.getValue("first_cyclic_time_in_secs", DCSDynamicWeather.CONFIG_PATH)
    local numCyclicWindows = DCSDynamicWeather.JSON.getValue("cyclic_windows", DCSDynamicWeather.CONFIG_PATH)
    local cyclicLength = DCSDynamicWeather.JSON.getValue("cyclic_length", DCSDynamicWeather.CONFIG_PATH)

    local eventWindows = {}
    for i = 0, numCyclicWindows - 1 do
        local eventWindowTimeAbsSeconds = firstEventAbsTimeSecs + (i * cyclicLength * 60)
        table.insert(eventWindows, eventWindowTimeAbsSeconds)
    end
    return eventWindows
end

local function main()
    local eventWindows = getEventWindows()
    for _, eventWindowTimeAbsSeconds in pairs(eventWindows) do
        scheduleRadioSound(eventWindowTimeAbsSeconds - PRE_EVENT_TIME + 180, START_UP_SOUND)
        scheduleRadioSound(eventWindowTimeAbsSeconds - 60, SHOOT_EM_SOUND)
        scheduleRadioSound(eventWindowTimeAbsSeconds - 15, LENS_ON_SOUND)
        scheduleRadioSound(eventWindowTimeAbsSeconds + RECOVERY_DURATION, RECOVERY_COMPLETE_SOUND)
    end
end

main()
