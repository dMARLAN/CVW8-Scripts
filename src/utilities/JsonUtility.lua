JsonUtility = {}

function JsonUtility.setFileJSONValue(key, value, fileName)
    local readFile = io.open(SCRIPTS_PATH .. "\\" .. fileName, "rb")
    local fileContents = readFile:read("*all")
    readFile:close()

    fileContents = string.gsub(fileContents, "\""..key.."\":%s+\"(.[^\"]*)", "\""..key.."\": \"" .. value)
    local writeFile = io.open(SCRIPTS_PATH .. "\\" .. DATA_FILE, "w")
    writeFile:write(fileContents)
    writeFile:close()
    env.info("[CVW8Scripts-JsonUtility.lua]: " .. key .. " set to " .. value .. " in " .. fileName)
end

function JsonUtility.getFileJSONValue(key, fileName)
    local readFile = io.open(SCRIPTS_PATH .. "\\" .. fileName, "rb")
    local fileContents = readFile:read("*all")
    readFile:close()
    env.info("[CVW8Scripts-JsonUtility.lua]: " .. key .. " retrieved from " .. fileName)
    return string.match(fileContents, "\""..key.."\": \"(.[^\"]*)")
end