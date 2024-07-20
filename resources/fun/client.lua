local effect = {}

function createEff()
    local x, y, z = getElementPosition(localPlayer)
    local _, _, playerRotation = getElementRotation(localPlayer)
    local offsetDistance = 0.5  
    local offsetX = x + offsetDistance * math.cos(math.rad(playerRotation))
    local offsetY = y + offsetDistance * math.sin(math.rad(playerRotation))
    effect[localPlayer] = createEffect("coke_trail", offsetX, offsetY, z)
	local _, _, zr = getElementRotation(effect[localPlayer])
	setElementPosition(localPlayer, offsetX, offsetY, z)
	setPedRotation(localPlayer, -90)
end
addEvent("createEffect", true)
addEventHandler("createEffect", root, createEff)

addEvent("deleteEffect", true)
addEventHandler("deleteEffect", root, function()
	if isElement(effect[localPlayer]) then destroyElement(effect[localPlayer]) end
end)


function createVomitEffect()
	setTimer(function()
	if getElementData(localPlayer, "kus") then
	local x, y, z = getElementPosition(localPlayer)
    local vomitEffect = createEffect("puke", x-0.5, y-0.1, z-0.1)
	local sound = playSound3D("puke.mp3", x, y, z)
	setElementRotation(vomitEffect, -90, 0, 0)
	end
	end, 3700, 1)
    if isElement(vomitEffect) then setTimer(destroyElement, 3000, 1, vomitEffect) end
end
addEvent("onVomitEffect", true)
addEventHandler("onVomitEffect", root, createVomitEffect)

function createFartEffect()
	local x, y, z = getElementPosition(localPlayer)
    local fartEffect = createEffect("spraycan", x, y, z)
	setElementRotation(fartEffect, 90, 0, 0)
	local sound = playSound3D("fart.mp3", x, y, z)
    if isElement(fartEffect) then setTimer(destroyElement, 1500, 1, fartEffect) end
end
addEvent("onFartEffect", true)
addEventHandler("onFartEffect", root, createFartEffect)