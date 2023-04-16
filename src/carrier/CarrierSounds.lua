--- Depends on SimpleRadioStandalone STTS module

local PATH_TO_SOUNDS = "C:\\Program Files\\DCS-SimpleRadio-Standalone\\Sounds\\"
local FREQS = RADIOS.BTN_1 .. "," .. RADIOS.BTN_8
local MODULATION = "AM,AM"

local START_UP_SOUND = "SpoolCaseIStarts.ogg"
local SHOOT_EM_SOUND = "SpoolShootEm.ogg"
local LENS_ON_SOUND = "SpoolLensOn.ogg"
local RECOVERY_COMPLETE_SOUND = "SpoolRecoveryComplete.ogg"

local PRE_EVENT_TIME = DCSDynamicWeather.JSON.getValue("pre_event_time", DCSDynamicWeather.CONFIG_PATH)
local RECOVERY_DURATION = DCSDynamicWeather.JSON.getValue("recovery_duration", DCSDynamicWeather.CONFIG_PATH)

local function scheduleRadioSound(playTime, soundFileName)
    local currentTime = timer.getAbsTime()
    if currentTime > playTime then
        return
    end

    local playSoundFunction = function()
        STTS.PlayMP3(
                PATH_TO_SOUNDS .. soundFileName,
                FREQS,
                MODULATION,
                "1",
                "Airboss",
                2
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
