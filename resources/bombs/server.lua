local bombalar = {

[1] = "flashbang",
[2] = "flame",

}

addEvent("explode", true)
addEventHandler("explode", getRootElement(), function(attacker, x, y, z)
	for k, v in pairs(getElementsByType("player")) do
	local px, py, pz = getElementPosition(v)
	local mesafe = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
	if getElementData(attacker, "bomb") == "flashbang" then
		flashPlanted(v, x, y, z, mesafe)
	elseif getElementData(attacker, "bomb") == "flame" then
		flamePlanted(v, x, y, z, mesafe)
		checkMines(x, y, z)
	else
		checkMines(x, y, z)
	end
	end
end)

function checkMines(gx, gy, gz)
	for k, v in pairs(getElementsByType("object")) do
		if getElementModel(v) == 1853 then
			if getElementData(v, "mayin") then
				local sahip = getPlayerFromName(getElementData(v, "mayin"))
				local x, y, z = getElementData(mayinDetect[sahip], "x"), getElementData(mayinDetect[sahip], "y"), getElementData(mayinDetect[sahip], "z")
				local mesafe = getDistanceBetweenPoints3D(x, y, z, gx, gy, gz)
				if tonumber(mesafe) < 15 then
				createExplosion(x, y, z, 1)
				createExplosion(x, y, z, 1)
				createExplosion(x, y, z, 1)
				destroyElement(mayin[sahip])
				destroyElement(mayinDetect[sahip])
				destroyElement(mayinAlan[sahip])
				destroyElement(mayinInfo[sahip])
				mayin[sahip] = nil
				outputChatBox("[MAYIN] #ffffffMayınınızın dayanıklılığı yetmediğinden ötürü patladı.",sahip,255,0,0,true)
				end
			end
		end
	end
end

function flashPlanted(v, x, y, z, mesafe)
	triggerClientEvent(v, "effectClient", v, "coke_puff", x, y, z)
	if tonumber(mesafe) < 10 and not getElementData(v, "flashbang") then
		setElementData(v, "flashbang", true)
		flashbangEffect(v)
		fadeCamera ( v, false, 0.5, 255, 255, 255 )         
		setTimer ( fadeCameraDelayed, 5000, 1, source )
	end
end

function flamePlanted(v, x, y, z, mesafe)
	triggerClientEvent(v, "effectClient", v, "explosion_molotov", x, y, z, true)
	createExplosion(x, y, z, 1)
	createExplosion(x, y, z, 1)
	createExplosion(x, y, z, 1)
end

function flashbangEffect(element)
	if isElement(element) then
		triggerClientEvent(element, "sound", element, "SFX/flash.mp3")
		toggleAllControls(element, false)
		toggleControl(element, "chatbox", true)
		setTimer(function(element)
		setPedAnimation(element, "ped", "walk_drunk", 10000, true)
		end, 700, 1, element)
		setTimer(function(element)
		toggleAllControls(element, true)
		setPedAnimation(element)
		setElementData(element, "flashbang", false)
		end, 10000, 1, element)
	end	
end

function fadeCameraDelayed(player)
      if (isElement(player)) then
            fadeCamera(player, true, 5.0)
      end
end

function bombaAyarla(p, c, state)
	if not state then
		outputChatBox("/bomba [Bomba ID]",p)
		outputChatBox("0 - El Bombası",p)
		outputChatBox("1 - Flaş Bombası",p)
		outputChatBox("2 - Yanıcı Bomba",p)
	return end
	if tonumber(state) == 0 then setElementData(p, "bomb", false) outputChatBox("Bomba güncellendi!",p)
	else
	if bombalar[tonumber(state)] ~= nil then
		setElementData(p, "bomb", bombalar[tonumber(state)])
		outputChatBox("Bomba güncellendi!",p)
	end
	end
end
addCommandHandler("bomba", bombaAyarla)

mayin = {}
mayinDetect = {}
mayinAlan = {}
mayinInfo = {}

function mayinKur(p, c)
	local mine = exports.envanter:checkItem(p, 8)
	if not mine then outputChatBox("[!] #ffffffHiç mayına sahip değilsiniz.",p,255,0,0,true) return end
	if isPedOnGround(p) then
		if mayin[p] ~= nil then outputChatBox("[!] #ffffffZaten bir mayın yerleştirmişsiniz.",p,255,0,0,true) return end
		exports.envanter:takeItem(p, 8, 1)
		local x, y, z = getElementPosition(p)
		local int, dim = getElementInterior(p), getElementDimension(p)
		setPedAnimation(p, "bomber", "bom_plant_2idle", 2500, false)
		toggleAllControls(p, false)
		setTimer(function(p)
		triggerClientEvent(p, "sound", p, "SFX/atdrop.mp3")
		end, 500, 1, p)
		setTimer(function(p)
		setPedAnimation(p)
		toggleAllControls(p, true)
		outputChatBox("[!] #ffffffMayın başarıyla oluştu!",p,255,0,0,true)
		mayin[p] = createObject(1853, x, y, z-(0.9+0.01))
		mayinInfo[p] = createMarker(x, y, z+1, "arrow", 0.8, 255, 0, 0)
		mayinAlan[p] = createColSphere(x, y, z, 5)
		setElementData(mayinAlan[p], "mayin", getPlayerName(p))
		mayinDetect[p] = createMarker(x, y, z-0.5, "cylinder", 0.8, 255, 0, 0)
		setElementData(mayinDetect[p], "mayin", getPlayerName(p))
		setElementData(mayin[p], "mayin", getPlayerName(p))
		setElementData(mayinDetect[p], "x", x)
		setElementData(mayinDetect[p], "y", y)
		setElementData(mayinDetect[p], "z", z)
		setElementVisibleTo(mayinDetect[p], root, false)
		setElementVisibleTo(mayinInfo[p], root, false)
		setElementVisibleTo(mayinInfo[p], p, true)
		setElementInterior(mayin[p], int)
		setElementDimension(mayin[p], dim)
		setElementFrozen(mayin[p], true)
		setElementData(mayin[p], "physical", true)
		setElementCollisionsEnabled(mayin[p], true)
		end, 3000, 1, p)
	else
	outputChatBox("[!] #ffffffMayın yerleştirmek için uygun bir alanda olmalısınız.",p,255,0,0,true)
	return end
end
addCommandHandler("mayinkur", mayinKur)

function mayinKurEvent()
	local mine = exports.envanter:checkItem(source, 8)
	if not mine then outputChatBox("[!] #ffffffHiç mayına sahip değilsiniz.",source,255,0,0,true) return end
	if isPedOnGround(source) then
		if mayin[source] ~= nil then outputChatBox("[!] #ffffffZaten bir mayın yerleştirmişsiniz.",source,255,0,0,true) return end
		exports.envanter:takeItem(source, 8, 1)
		local x, y, z = getElementPosition(source)
		local int, dim = getElementInterior(source), getElementDimension(source)
		setPedAnimation(source, "bomber", "bom_plant_2idle", 2500, false)
		toggleAllControls(source, false)
		setTimer(function(source)
		triggerClientEvent(source, "sound", source, "SFX/atdrop.mp3")
		end, 500, 1, source)
		setTimer(function(source)
		setPedAnimation(source)
		toggleAllControls(source, true)
		outputChatBox("[!] #ffffffMayın başarıyla oluştu!",source,255,0,0,true)
		mayin[source] = createObject(1853, x, y, z-(0.9+0.01))
		mayinInfo[source] = createMarker(x, y, z+1, "arrow", 0.8, 255, 0, 0)
		mayinAlan[source] = createColSphere(x, y, z, 5)
		setElementData(mayinAlan[source], "mayin", getPlayerName(source))
		mayinDetect[source] = createMarker(x, y, z-0.5, "cylinder", 0.8, 255, 0, 0)
		setElementData(mayinDetect[source], "mayin", getPlayerName(source))
		setElementData(mayin[source], "mayin", getPlayerName(source))
		setElementData(mayinDetect[source], "x", x)
		setElementData(mayinDetect[source], "y", y)
		setElementData(mayinDetect[source], "z", z)
		setElementVisibleTo(mayinDetect[source], root, false)
		setElementVisibleTo(mayinInfo[source], root, false)
		setElementVisibleTo(mayinInfo[source], source, true)
		setElementInterior(mayin[source], int)
		setElementDimension(mayin[source], dim)
		setElementFrozen(mayin[source], true)
		setElementData(mayin[source], "physical", true)
		setElementCollisionsEnabled(mayin[source], true)
		end, 3000, 1, source)
	else
	outputChatBox("[!] #ffffffMayın yerleştirmek için uygun bir alanda olmalısınız.",source,255,0,0,true)
	return end
end
addEvent("mayinSERVER", true)
addEventHandler("mayinSERVER", root, mayinKurEvent)

function mayinkaldir(p, c)
	if isElement(mayin[p]) then
		destroyElement(mayin[p])
		destroyElement(mayinDetect[p])
		destroyElement(mayinAlan[p])
		destroyElement(mayinInfo[p])
		mayin[p] = nil
		outputChatBox("[MAYIN] #fffffDaha önceden kurduğun mayın kaldırıldı.",p,255,0,0,true)
	end
end
addCommandHandler("mayinkaldir", mayinkaldir)

addEventHandler("onPlayerQuit", root, function()
	if isElement(mayin[source]) then
		destroyElement(mayin[source])
		destroyElement(mayinDetect[source])
		destroyElement(mayinAlan[source])
		destroyElement(mayinInfo[source])
	end
end)

addEventHandler("onColShapeHit", root, function(plr)
	if getElementData(source, "mayin") then
		if getPlayerName(plr) ~= getElementData(source, "mayin") then
		outputChatBox("[!] #ffffffYakınlarda mayın olduğunu sezdin, dikkatli ol.",plr,255,0,0,true)
		end
	end
end)

addEventHandler("onPlayerMarkerHit", root, function(marker)
	if getElementData(marker, "mayin") then
		if getPlayerName(source) ~= getElementData(marker, "mayin") then
			triggerClientEvent(source, "sound", source, "SFX/landmine.mp3")
			local attckr = getPlayerFromName(getElementData(marker, "mayin"))
			outputChatBox("[MAYIN] #ffffff"..getPlayerName(source).." adlı oyuncu mayınınıza takıldı.",attckr,255,0,0,true)
			outputChatBox("[-] #ffffffMayına bastığınız için sistemsel olarak durduruldunuz, hareket ettiğinizde devreye girecek.",source,255,0,0,true)
			toggleAllControls(source, false)
			setElementFrozen(source, true)
			setElementData(source, "mined", true)
			setPedAnimation(source)
			local x, y, z = getElementData(marker, "x"), getElementData(marker, "y"), getElementData(marker, "z")
			setElementPosition(source, x, y, z)
			setTimer(function(source)
			setElementFrozen(source, false)
			toggleAllControls(source, true)
			end, 2000, 1, source)
		end
	end
end)

addEvent("blowMine", true)
addEventHandler("blowMine", root, function(mine)
	if isElement(mine) then
		local sahip = getPlayerFromName(getElementData(mine, "mayin"))
		local x, y, z = getElementData(mayinDetect[sahip], "x"), getElementData(mayinDetect[sahip], "y"), getElementData(mayinDetect[sahip], "z")
		createExplosion(x, y, z, 1)
		createExplosion(x, y, z, 1)
		createExplosion(x, y, z, 1)
		destroyElement(mayin[sahip])
		destroyElement(mayinDetect[sahip])
		destroyElement(mayinAlan[sahip])
		destroyElement(mayinInfo[sahip])
		mayin[sahip] = nil
		outputChatBox("[MAYIN] #ffffffMayınınızın dayanıklılığı yetmediğinden ötürü patladı.",sahip,255,0,0,true)
	end
end)

addEventHandler("onPlayerMarkerLeave", root, function(marker)
	if getElementData(marker, "mayin") then
		if getPlayerName(source) ~= getElementData(marker, "mayin") then
			triggerClientEvent(source, "sound", source, "SFX/landmine.mp3")
			if getElementData(source, "mined") then
				local x, y, z = getElementPosition(source)
				createExplosion(x, y, z, 1)
				createExplosion(x, y, z, 1)
				createExplosion(x, y, z, 1)
				killPlayer(source)
				local sahip = getPlayerFromName(getElementData(marker, "mayin"))
				destroyElement(mayin[sahip])
				destroyElement(mayinDetect[sahip])
				destroyElement(mayinAlan[sahip])
				destroyElement(mayinInfo[sahip])
				mayin[sahip] = nil
				outputChatBox("[MAYIN] #ffffff"..getPlayerName(source).." adlı oyuncu mayınınıza takılarak öldü.",sahip,255,0,0,true)
			end
		end
	end
end)


