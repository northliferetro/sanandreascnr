local mezar = {}

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
	if getElementData(source, "logged") then
		local x, y, z = getElementPosition(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)
		local mezarID = getAccountData(getPlayerAccount(source), "coffin") or 3471
		local plr_index = tonumber(getElementData(source, "id"))
		local sonsoz = getAccountData(getPlayerAccount(source), "sonsoz") or "San Andreas Hırsız Polis!"
		if isElement(mezar[plr_index]) then destroyElement(mezar[plr_index]) end
		mezar[plr_index] = createPickup(x, y, z, 3, tonumber(mezarID))
		setElementData(mezar[plr_index], "sonsoz", sonsoz)
		setElementInterior(mezar[plr_index], int)
		setElementDimension(mezar[plr_index], dim)
		setTimer(function(source)
		if getElementData(source, "sinifsec") then
		triggerEvent("resGameLoad", source)
		triggerClientEvent(source, "authC", source, true)
		spawnPlayer(source, 0, 0, 0)
		setElementInterior(source, 17)
		setElementPosition(source, 485.77271, -14.93627, 1000.67969)
		setPedRotation(source, -90)
		setCameraMatrix(source, 489.56476, -14.85263, 1000.67969, 485.77271, -14.93627, 1000.67969)
		setElementModel(source, 155)
		setElementDimension(source, #getElementsByType("player")+1)
		setPedAnimation(source, "dancing", "dance_loop")
		triggerClientEvent(source, "spawnClass", source)
		if isElement(mezar[plr_index]) then destroyElement(mezar[plr_index]) end
		else
		spawnPlayer(source, 0, 0, 0, 90, tonumber(getElementData(source, "skin")), 0, 0)
		exports.auth:sehirIsinla(source)
		if isElement(mezar[plr_index]) then destroyElement(mezar[plr_index]) end
		end
		end, 5000, 1, source)
	end
end)


addCommandHandler("sinifsec", function(plr, cmd)
	setElementData(plr, "sinifsec", true)
	outputChatBox("[-] #ffffffÖldükten sonra tekra sınıf seçme menüsü karşınıza gelecek.",plr,255,0,0,true)
end)


function onCmdDeregister ( playerSource, commandName, name)
	-- grab the account
		local sourceAccount = getAccount(name)
		removeAccount ( sourceAccount )
		outputChatBox ( "Account deregistered for " .. getAccountName(sourceAccount) )
end
 
addCommandHandler("deregister",onCmdDeregister)