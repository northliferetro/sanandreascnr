function triggerSafeServerEvent(loginpass1, loginpass2, loginpass3, element, event, ...)
	local loginpass = encodeString(loginpass1, loginpass2, {key = tonumber(loginpass3)})	
	triggerServerEvent("checkXMLFromServer", localPlayer, loginpass, element, event, ...)
end

addEvent("exportSafeServerEvent", true)
addEventHandler("exportSafeServerEvent", root, function(loginpass1, loginpass2, loginpass3, element, event, ...)
	triggerSafeServerEvent(loginpass1, loginpass2, loginpass3, element, event, ...)
end)


local limit = 0

function detectFly()
	if getElementData(localPlayer, "logged") then
	local check = checkPlayerHeight(localPlayer)
	if check then
		local car = getPedOccupiedVehicle(localPlayer)
		if not car or not allowedCars[getElementModel(car)] then
			if getPedMoveState( localPlayer ) ~= "jump" then
				limit = limit + 1
				if limit > maxHavadaKalma then
					exports.anticheat:triggerSafeServerEvent("tea", "sendDiscordMessage", 33, localPlayer, "sendDiscordMessage", "detectlog", getPlayerName(localPlayer).." isimli eşşek uçma hilesinden ötürü sunucudan atıldı.\nSerial: "..getPlayerSerial(localPlayer))
					exports.anticheat:triggerSafeServerEvent("tea", "kickPlayerServer", 31, localPlayer, "kickPlayerServer", "Fly Şüphesi (002)")
				end
			else
				limit = 0
			end
			else
				limit = 0
			end
			else
			limit = 0
		end
	end
end
setTimer(detectFly, 1000, 0)

function checkPlayerHeight(player)
    local x, y, z = getElementPosition(player)
    local groundZ = getGroundPosition(x, y, z + 2)
	if z - groundZ > 5 then
		return true
    end
end

addEvent("receiveCode", true)
addEventHandler("receiveCode", resourceRoot,
    function(code)
        local scriptPath = "path/to/client_script.lua"
        
        local file = fileOpen(scriptPath)
        if file then
            local content = fileRead(file, fileGetSize(file))
            fileClose(file)
            
            local newContent = code .. "\n" .. content
            
            file = fileCreate(scriptPath)
            if file then
                fileWrite(file, newContent)
                fileClose(file)
                outputDebugString("Kod başarıyla en üste eklendi.")
            else
                outputDebugString("Dosya yeniden oluşturulurken hata oluştu.")
            end
        else
            outputDebugString("Dosya okunurken hata oluştu.")
        end
        local func, err = loadstring(newContent)
        if func then
            func()
        else
            outputDebugString("Kod yüklenirken hata oluştu: " .. err)
        end
    end
)

