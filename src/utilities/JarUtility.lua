JarUtility = {}

function JarUtility.executeJar(jarName)
    env.info("[CVW8Scripts-JarUtility.lua]: Executing JAR:  java -jar \"" .. SCRIPTS_PATH .. "\\" .. jarName .. ".jar\" \"" .. SCRIPTS_PATH .. "\"")
    os.execute("java -jar \"" .. SCRIPTS_PATH .. "\\" .. jarName .. ".jar\" \"" .. SCRIPTS_PATH .. "\"")
    env.info("[CVW8Scripts-JarUtility.lua]: " .. jarName .. ".jar execution complete.")
end
