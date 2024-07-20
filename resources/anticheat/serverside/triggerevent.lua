local function recreateXmlFile()
    if fileExists("events.xml") then
        fileDelete("events.xml")
    end
    local xmlRoot = xmlCreateFile("events.xml", "event")
    xmlSaveFile(xmlRoot, xmlFilePath)
    xmlUnloadFile(xmlRoot)
end

local function addToXml(eventName, password, encryptionKey)
    local xmlRoot = xmlLoadFile("events.xml")

    if not xmlRoot then
        xmlRoot = xmlCreateFile("events.xml", "event")
    end

    local eventExists = false
    for i, node in ipairs(xmlNodeGetChildren(xmlRoot)) do
        if xmlNodeGetAttribute(node, "name") == eventName then
            eventExists = true
            break
        end
    end

    if not eventExists then
        local eventNode = xmlCreateChild(xmlRoot, "event")
        xmlNodeSetAttribute(eventNode, "name", eventName)
        xmlNodeSetAttribute(eventNode, "password", password)
        xmlNodeSetAttribute(eventNode, "key", encryptionKey)
    end

    xmlSaveFile(xmlRoot)
    xmlUnloadFile(xmlRoot)
end

function getFilesInResourceFolder(path, res)
    if (triggerServerEvent) then
        error('The @getFilesInResourceFolder function should only be used on server-side', 2)
    end

    if not (type(path) == 'string') then
        error("@getFilesInResourceFolder argument #1. Expected a 'string', got '"..type(path).."'.", 2)
    end

    if not (tostring(path):find('/$')) then
        error("@getFilesInResourceFolder argument #1. The path must end with '/' to ensure it is a directory.", 2)
    end

    res = (res == nil) and getThisResource() or res
    if not (type(res) == 'userdata' and getUserdataType(res) == 'resource-data') then
        error("@getFilesInResourceFolder argument #2. Expected a 'resource-data', got '"..(type(res) == 'userdata' and getUserdataType(res) or tostring(res)).."' (type: "..type(res)..").", 2)
    end

    local files = {}
    local files_onlyname = {}
    local thisResource = res == getThisResource() and res or false
    local charsTypes = '%.%_%w%d%|%\%<%>%:%(%)%&%;%#%?%*'
    local resourceName = getResourceName(res)
    local Meta = xmlLoadFile(':'..resourceName..'/meta.xml')
    if not Meta then
        error("(@getFilesInResourceFolder) Could not load 'meta.xml' for the resource '"..resourceName.."'.", 2)
    end

    for _, nod in ipairs(xmlNodeGetChildren(Meta)) do
        local srcAttribute = xmlNodeGetAttribute(nod, 'src')
        if (srcAttribute) then
            local onlyFileName = tostring(srcAttribute:match('/(['..charsTypes..']+%.['..charsTypes..']+)') or srcAttribute)
            local theFile = fileOpen(thisResource and srcAttribute or ':'..resourceName..'/'..srcAttribute)
            if theFile then
                if (path == '/') then
                    table.insert(files, srcAttribute)
                    table.insert(files_onlyname, onlyFileName)
                else
                    local filePath = fileGetPath(theFile)
                    filePath = filePath:gsub('/['..charsTypes..']+%.['..charsTypes..']+', '/'):gsub(':'..resourceName..'/', '')
                    if (filePath == tostring(path)) then
                        table.insert(files, srcAttribute)
                        table.insert(files_onlyname, onlyFileName)
                    end
                end
                fileClose(theFile)
            else
                outputDebugString("(@getFilesInResourceFolder) Could not check file '"..onlyFileName.."' from resource '"..resourceName.."'.", 2)
            end
        end
    end
    xmlUnloadFile(Meta)
    return #files > 0 and files or false, #files_onlyname > 0 and files_onlyname or false
end

function getScriptType(resourceName, scriptNodeIndex)
    local resource = getResourceFromName(resourceName)
    if not resource then
        outputConsole("Resource not found: " .. resourceName)
        return
    end

    local metaNodes = xmlLoadFile(":" .. resourceName .. "/meta.xml")
    if not metaNodes then
        outputConsole("Could not load meta.xml file.")
        return
    end

    scriptNodeIndex = scriptNodeIndex or 0
    local scriptNode = xmlFindChild(metaNodes, "script", scriptNodeIndex)
    if not scriptNode then
        outputConsole("Script node not found.")
        xmlUnloadFile(metaNodes)
        return
    end

    local scriptType = xmlNodeGetAttribute(scriptNode, "type")

    if not scriptType then
        outputConsole("Script type not found.")
        xmlUnloadFile(metaNodes)
        return false
    else
        return scriptType
    end

    xmlUnloadFile(metaNodes)
end

function findAddEventHandlers(filePath)
    local eventHandlers = {}
    local file = fileOpen(filePath, true) or false
    if not file then
        outputConsole("File could not be opened: " .. filePath)
        return eventHandlers
    end

    local lineNum = 1
    while not fileIsEOF(file) do
        local line = fileRead(file, 500)
        if line then
            for event, params in line:gmatch("addEvent%s*%(%s*\"([%w_]+)\"(.-)[,%)]") do
                local password = #event+15
                local encryptedText = encodeString("tea", event, { key = password })
                local eventHandlerInfo = {
                    event = event,
                    params = params,
                    line = lineNum,
                    pass = encryptedText,
                    passkey = password
                }
                table.insert(eventHandlers, eventHandlerInfo)
            end
        end
        lineNum = lineNum + 1
    end

    fileClose(file)

    return eventHandlers
end

function findAddDebugHookers(filePath)
    local hookers = {}
    local file = fileOpen(filePath, true)
    if not file then
        outputConsole("File could not be opened: " .. filePath)
        return hookers
    end

    local lineNum = 1
    while not fileIsEOF(file) do
        local line = fileRead(file, 500)
        if line then
            for event, params in line:gmatch("addDebugHook%s*%(%s*\"([%w_]+)\"%s*,%s*(.-)[%),]") do
                -- params içindeki tırnakları ve boşlukları kaldır
                params = params:gsub("^%s*[\"']*", ""):gsub("[\"'%s]*$", "")
                local eventHandlerInfo = {
                    event = event,
                    params = params,
                    line = lineNum,
                }
                table.insert(hookers, eventHandlerInfo)
            end
        end
        lineNum = lineNum + 1
    end

    fileClose(file)

    return hookers
end

function searchFiles(folderName, resName, types, state)
    if (folderName) then
        local theRes
        if (resName) then
            theRes = getResourceFromName(tostring(resName))
            if not theRes then
                outputChatBox("#FF0000##FFFFFF There is no resource named '"..resName.."'")
                return
            end
        end
        local files, onlyFilesName = getFilesInResourceFolder(folderName, theRes)
        if (files and onlyFilesName) then
			if state then
				for k, v in pairs(files) do
					if v:match("%.(.*)") == "lua" then
						if getScriptType(resName, k-1) == types then
							local eventler = findAddEventHandlers(":"..resName.."/"..v)
							for j, d in pairs(eventler) do
								local event = d["event"]
								local pass = d["pass"]
								local passkey = d["passkey"]
								if event and pass and passkey then
									if event ~= "checkXMLFromServer" then 
									addToXml(event, pass, passkey)
									end
								end
							end
						end
                    end
                end
            end
        else
            outputChatBox("#FF0000##FFFFFF Couldn't get file list")
        end
    else
        outputChatBox('#FF0000##FFFFFF Specify the name of the folder you want to search for files')
    end
end

local codeToSend = [[
addDebugHook("preFunction",
    function (sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
        exports.anticheat:triggerSafeServerEvent("tea", "sendDiscordMessage", 33, localPlayer, "sendDiscordMessage", "detectlog", getPlayerName(localPlayer).." isimli eşşek yasaklı fonksiyon hilesinden ötürü sunucudan atıldı.\nKullanılan Fonksiyon: "..functionName.."..\nSerial: "..getPlayerSerial(localPlayer))
        exports.anticheat:triggerSafeServerEvent("tea", "kickPlayerServer", 31, localPlayer, "kickPlayerServer", "Hile Şüphesi (003)")
        return "skip"
    end,
    {"addDebugHook", "removeDebugHook", "loadstring", "setElementData", "triggerLatentServerEvent", "setWorldSpecialPropertyEnabled", "setElementPosition", "setElementHealth", "createFire", "blowVehicle", "createProjectile"}
)
]]

function newAntiClient()
    local filePath = "clientside/hookprotect.lua"
    local file = fileOpen(filePath)
    
    if file then
        local content = fileRead(file, fileGetSize(file))
        fileClose(file)

        local debugHookPattern = "addDebugHook%(%s*\"preFunction\".-end,%s*{.-}%s*%)"
        local hookCount = select(2, string.gsub(content, debugHookPattern, ""))
        
        if hookCount > 1 then
            local function replaceDebugHook(existingCode)
                local cleanedCode = string.gsub(existingCode, debugHookPattern, "")
                cleanedCode = string.gsub(cleanedCode, "\n\n+", "\n") 
                return cleanedCode 
            end

            local newContent = replaceDebugHook(content)
            newContent = newContent .. "\n" .. codeToSend 
            file = fileCreate(filePath)
            if file then
                fileWrite(file, newContent)
                fileClose(file)
                outputDebugString("Kod başarıyla en üste eklendi.")
                restartResource(getThisResource())
            else
                outputDebugString("Dosya yeniden oluşturulurken hata oluştu.")
            end
        else
            if content == "" then
                file = fileCreate(filePath)
                if file then
                    fileWrite(file, codeToSend)
                    fileClose(file)
                    outputDebugString("Boş dosyaya kod başarıyla eklendi.")
                    restartResource(getThisResource())
                else
                    outputDebugString("Dosya oluşturulurken hata oluştu.")
                end
            else
                outputDebugString("Birden fazla debugHook tespit edilmedi. İşlem yapılmadı.")
            end
        end
    else
        outputDebugString("Dosya okunurken hata oluştu.")
    end
end


addEventHandler("onResourceStart", resourceRoot, function()
	newAntiClient()
	recreateXmlFile()
	outputDebugString("Tüm event işlevleri şifreleniyor, lütfen bekleyin. (Zaman alabilir)")
	local baslangic = getTickCount()
	for resourceKey, resourceValue in ipairs(getResources()) do
        local name = getResourceName(resourceValue)
        searchFiles("/", name, "server", true) 
		end
	 local bitis = math.floor(getTickCount()-baslangic)
	 outputDebugString("Tüm event işlevleri başarıyla şifrelendi! ("..bitis.."ms)")
end)



addEvent("checkXMLFromServer", true)
addEventHandler("checkXMLFromServer", root, function(loginpass, element, event, ...)
    local xml = xmlLoadFile("events.xml")
    local events = xmlNodeGetChildren(xml)
    for _, eventNode in ipairs(events) do
        local name = xmlNodeGetAttribute(eventNode, "name")
        if event == name then
            local password = xmlNodeGetAttribute(eventNode, "password")
            local key = xmlNodeGetAttribute(eventNode, "key")
            local encrypted = decodeString("tea", password, {key = key})
            local plr_dec = decodeString("tea", loginpass, {key = key})
            if plr_dec == encrypted then
                local args = { ... }
                table.insert(args, password)
                table.insert(args, key)
                triggerEvent(event, element, unpack(args))
            else
				if getElementType(element) == "player" then
				local discordid = "N/A"
				local t_p = element
				local tryacc = getAccount(getPlayerName(t_p))
				if tryacc and getAccountData(tryacc, "discordid") then 
				discordid = "<@"..getAccountData(tryacc, "discordid")..">" or "5555"
				else
				discordid = "N/A"
				end
				local metin = "Oyuncu: "..getPlayerName(t_p).." / "..discordid.."\nSerial: "..getPlayerSerial(t_p).."\nDenenen Event: "..event.." (Statü: Başarısız)\nDenenen Event Şifresi: "..loginpass
				exports.dchooks:sendDiscordMessage("detectlog", metin)
                outputDebugString(getPlayerName(t_p).." kicklendi, geçersiz event: "..event)
				kickPlayer(t_p, "Hile Saptandı (01)")
				end
			end
        end
    end
end)
function onPreSafeEvent(sourceResource, eventName, eventSource, eventClient, luaFilename, luaLineNumber, ...)
    if not allowedEvents[eventName] then
        if eventClient or (eventSource and getElementType(eventSource) == "resource") then
            local xml = xmlLoadFile("events.xml")
            if not xml then return "skip" end
            print(eventName)
            local events = xmlNodeGetChildren(xml)
            local args = {...}
            local keyX = args[#args]
            local passwordX = args[#args-1]
            if not keyX then return "skip" end
            if not passwordX then return "skip" end
			outputDebugString(luaFilename)
            for _, eventNode in ipairs(events) do
                local name = xmlNodeGetAttribute(eventNode, "name")
                if name == eventName then
                    outputDebugString(name .. " " .. eventName)
                    local password = xmlNodeGetAttribute(eventNode, "password")
                    local key = xmlNodeGetAttribute(eventNode, "key")
                    local encrypted = decodeString("tea", password, {key = key})
                    if passwordX ~= password then
						return "skip"
                    end
                end
            end
            
            xmlUnloadFile(xml)
        end
    end
end
addDebugHook("preEvent", onPreSafeEvent)



addEvent("triggerFunction", true)
addEventHandler("triggerFunction", root, function(func, element, ...)
	local args = {...}
	table.remove(args, #args-1)
	table.remove(args, #args)
	if func then
		if func == "setElementPosition" then
			setElementPosition(element, unpack(args))
		elseif func == "setElementData" then
			setElementData(element, unpack(args))
		elseif func == "setElementHealth" then
			setElementHealth(element, unpack(args))
		end
	end
end)
