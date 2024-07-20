function onClientExplosion(x, y, z, theType)
	if tonumber(theType) == 0 then
	if getElementData(source, "bomb") then
	cancelEvent()
	triggerServerEvent("explode", getRootElement(), source, x, y, z)
	end
	end
end
addEventHandler("onClientExplosion", root, onClientExplosion)

function effect(name, x, y, z, sound)
	effect = createEffect(name, x, y, z, 0, 0, 0, nil, sound)
	setTimer(function(effect)
	destroyElement(effect)
	end, 1000, 1, effect)
end
addEvent("effectClient", true)
addEventHandler("effectClient", getRootElement(), effect)

function createSound(sound)
	local sound = playSound(sound)
	setSoundVolume(sound, 0.5)
end
addEvent("sound", true)
addEventHandler("sound", root, createSound)

addEventHandler("onClientRender", getRootElement(), function()
	for k, v in pairs(getElementsByType("object")) do
		local model = getElementModel(v)
		if tonumber(model) == 1853 then 
			if getElementData(v, "mayin") then
				local health = math.floor(getElementHealth(v))
				local yuzde = (health / 1000) * 100
				if getElementData(v, "mayin") == getPlayerName(localPlayer) then
				dxDrawTextOnElement(v, "Mayın Dayanıklılığı: %"..yuzde, 1, 15, 255, 255, 255, 255, 1, "pricedown")
				end
			end
		end
		if tonumber(model) == 1575 then
			if getElementData(v, "content") then
				local c_t = getElementData(v, "content")
				local name, count = c_t["itemname"], c_t["count"]
				if name and count then
				dxDrawTextOnElement(v, "Loot ID:"..getElementData(v, "serial").."\n"..name.."("..count..")", 0.5, 5, 255, 255, 255, 255, 2, "arial")
				end
			end
		end
	end
end)

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end

function outputLoss(loss)
    local oldHealth = getElementHealth(source)
	local model = getElementModel(source)
	if tonumber(model) == 1853 and getElementData(source, "mayin") then
		local new_health = oldHealth - loss
		if tonumber(new_health) < 20 then
			triggerServerEvent("blowMine", getRootElement(), source)
		end
	end
end
addEventHandler("onClientObjectDamage", root, outputLoss)