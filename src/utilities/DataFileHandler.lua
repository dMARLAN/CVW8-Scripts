function utilities.setFileJSONValue(key, value, fileName)
    local readFile = io.open(SCRIPTS_PATH .. "\\" .. fileName, "rb")
    local fileContents = readFile:read("*all")
    readFile:close()

    fileContents = string.gsub(fileContents, "\""..key.."\":%s+\"(.[^\"]*)", "\""..key.."\": \"" .. value)
    local writeFile = io.open(SCRIPTS_PATH .. "\\" .. DATA_FILE, "w")
    writeFile:write(fileContents)
    writeFile:close()
end

function utilities.getFileJSONValue(key, fileName)
    local readFile = io.open(SCRIPTS_PATH .. "\\" .. fileName, "rb")
    local fileContents = readFile:read("*all")
    readFile:close()
    return string.match(fileContents, "\""..key.."\": \"(.[^\"]*)")
end