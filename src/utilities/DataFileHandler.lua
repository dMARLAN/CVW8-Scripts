cvw8utilities = {}

function cvw8utilities.setDataFile(key,value)
    local readFile = io.open(SCRIPTS_PATH .. "\\Data.txt", "rb")
    local fileContents = readFile:read("*all")
    readFile:close()

    fileContents = string.gsub(fileContents, "\""..key.."\":%s+\"(.[^\"]*)", "\""..key.."\": \"" .. value)
    local writeFile = io.open(SCRIPTS_PATH .. "\\Data.txt", "w")
    writeFile:write(fileContents)
    writeFile:close()
end