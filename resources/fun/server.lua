local event = {
    ["ise"] = {},
    ["gaz"] = {},
    ["te"] = {},
    ["kus"] = {},
}

local timer = {
    ["ise"] = {},
    ["gaz"] = {},
    ["te"] = {},
    ["kus"] = {},
}

local move = {}
local currently = {}

function getNearestElement(player, type, distance)
    local result = false
    local dist = nil
    if player and isElement(player) then
        local elements = getElementsWithinRange(Vector3(getElementPosition(player)), distance, type, getElementInterior(player), getElementDimension(player))
        for i = 1, #elements do
            local element = elements[i]
            if not dist then
                result = element
                dist = getDistanceBetweenPoints3D(Vector3(getElementPosition(player)), Vector3(getElementPosition(element)))
            else
                local newDist = getDistanceBetweenPoints3D(Vector3(getElementPosition(player)), Vector3(getElementPosition(element)))
                if newDist <= dist then
                    result = element
                    dist = newDist
                end
            end
        end
    end
    return result
end

function moveCheck(plr)
    if currently[plr] == nil then
        return true
    else
        return false
    end
end

function isPlayerNearby(plr)
    local target = getNearestElement(plr, "player", 1)
    if target ~= plr then
        return target
    end
end

function eventCheck(plr, cmd)
    if event[cmd][plr] == nil then
        return true
    else
        return false
    end
end

function timeOut(plr, cmd, sec)
	local n_sec = sec * 1000
    setTimer(function(plr)
        executeCommandHandler("stopeffect", plr, cmd)
    end, n_sec, 1, plr)
end

function timeCheck(plr, cmd)
    if not eventCheck(plr, cmd) then 
		if isTimer(timer[cmd][plr]) then
        local kalan = getTimerDetails(timer[cmd][plr]) 
        local sure = math.floor(kalan / 1000) 
        outputChatBox("[-] #ffffffYakın zamanda bu aktiviteyi gerçekleştirmişsiniz. "..sure.." saniye daha bekleyin.", plr, 255, 0, 0, true) 
        return false
		end
    else
        return true
    end
end

function ise(plr, cmd)
	if not isPedOnGround(plr) then outputChatBox("[-] #ffffffİşlemi gerçekleştirmek için araçtan inin veya zıplamayın.",plr,255,0,0,true) return end
	if not timeCheck(plr, cmd) then return end
	if not moveCheck(plr) then return end
	if eventCheck(plr, cmd) then
	setElementData(plr, cmd, true)
	move[plr] = cmd
    event[cmd][plr] = true
	currently[plr] = true
	triggerClientEvent(plr, "playSF", plr, "script", 61, 0, false)
    local nearby = isPlayerNearby(plr)
    if nearby and not isPedDead(nearby) then 
	outputChatBox("#ffae00[İŞEME] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'n üzerine işedi!",getElementsByType("player"), 255, 0, 0, true)
	elseif nearby and isPedDead(nearby) then
	outputChatBox("#ffae00[İŞEME] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'n ölüsünün üzerine işedi!",getElementsByType("player"), 255, 0, 0, true)
	end
	triggerClientEvent(root, "createEffect", plr, "coke_trail")
    setElementFrozen(plr, true)
    toggleAllControls(plr, false)
    toggleControl(plr, "chatbox", true)
    setPedAnimation(plr, "paulnmac", "piss_loop", nil, false, nil, false)
    end
    timeOut(plr, cmd, 10)
	timer[cmd][plr] = setTimer(function(plr)
    event[cmd][plr] = nil
	timer[cmd][plr] = nil
	setElementData(plr, cmd, false)
	move[plr] = nil
    end, 60000, 1, plr)
end
addCommandHandler("ise", ise)

function kus(plr, cmd)
	if not isPedOnGround(plr) then outputChatBox("[-] #ffffffİşlemi gerçekleştirmek için araçtan inin veya zıplamayın.",plr,255,0,0,true) return end
	if not timeCheck(plr, cmd) then return end
	if not moveCheck(plr) then return end
	if eventCheck(plr, cmd) then
	setElementData(plr, cmd, true)
	move[plr] = cmd
    event[cmd][plr] = true
	currently[plr] = true
    local nearby = isPlayerNearby(plr)
	if nearby and not isPedDead(nearby) then 
	outputChatBox("#ffae00[KUSMA] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'n üzerine kustu!",getElementsByType("player"), 255, 0, 0, true)
	elseif nearby and isPedDead(nearby) then
	outputChatBox("#ffae00[KUSMA] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'n ölüsünün üzerine kustu!",getElementsByType("player"), 255, 0, 0, true)
	end
    setElementFrozen(plr, true)
    toggleAllControls(plr, false)
    toggleControl(plr, "chatbox", true)
	setPedRotation(plr, 180)
    setPedAnimation(plr, "FOOD", "EAT_Vomit_P", -1, true, true, false, false)
    setTimer(triggerEvent, 500, 1, "onVomitEffect", plr)
    end
    timeOut(plr, cmd, 8)
	timer[cmd][plr] = setTimer(function(plr)
    event[cmd][plr] = nil
	timer[cmd][plr] = nil
	setElementData(plr, cmd, false)
	move[plr] = nil
    end, 60000, 1, plr)
end
addCommandHandler("kus", kus)

function gaz(plr, cmd)
	if not isPedOnGround(plr) then outputChatBox("[-] #ffffffİşlemi gerçekleştirmek için araçtan inin veya zıplamayın.",plr,255,0,0,true) return end
	if not timeCheck(plr, cmd) then return end
	if not moveCheck(plr) then return end
	if eventCheck(plr, cmd) then
	setElementData(plr, cmd, true)
	move[plr] = cmd
    event[cmd][plr] = true
	currently[plr] = true
    local nearby = isPlayerNearby(plr)
	if nearby and not isPedDead(nearby) then 
	outputChatBox("#ffae00[GAZ] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'n üzerine gaz çıkardı!",getElementsByType("player"), 255, 0, 0, true)
	elseif nearby and isPedDead(nearby) then
	outputChatBox("#ffae00[GAZ] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'n ölüsünün üzerine gaz çıkardı!",getElementsByType("player"), 255, 0, 0, true)
	end
    setElementFrozen(plr, true)
    toggleAllControls(plr, false)
    toggleControl(plr, "chatbox", true)
	setPedRotation(plr, 180)
    setPedAnimation(plr, "PLAYIDLES", "shldr", -1, true, true, false, false)
    setTimer(triggerEvent, 100, 1, "onFartEffect", plr)
    end
    timeOut(plr, cmd, 2)
	timer[cmd][plr] = setTimer(function(plr)
    event[cmd][plr] = nil
	timer[cmd][plr] = nil
	setElementData(plr, cmd, false)
	move[plr] = nil
    end, 60000, 1, plr)
end
addCommandHandler("gaz", gaz)

function te(plr, cmd)
	if not isPedOnGround(plr) then outputChatBox("[-] #ffffffİşlemi gerçekleştirmek için araçtan inin veya zıplamayın.",plr,255,0,0,true) return end
	if not timeCheck(plr, cmd) then return end
	if not moveCheck(plr) then return end
	if eventCheck(plr, cmd) then
	local nearby = isPlayerNearby(plr)
	if not nearby then outputChatBox("[-] #ffffffYakınınızda bir oyuncu yok.",plr,255,0,0,true) return end
	setElementData(plr, cmd, true)
	move[plr] = cmd
    event[cmd][plr] = true
	currently[plr] = true
	if nearby and not isPedDead(nearby) then 
	outputChatBox("#ffae00[TECAVÜZ] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'e tecavüz etti!",getElementsByType("player"), 255, 0, 0, true)
	elseif nearby and isPedDead(nearby) then
	outputChatBox("#ffae00[TECAVÜZ] #ffffff"..getPlayerName(plr).." adlı oyuncu "..getPlayerName(nearby).."'n ölüsüne tecavüz etti!",getElementsByType("player"), 255, 0, 0, true)
	end
    end
	timer[cmd][plr] = setTimer(function(plr)
    event[cmd][plr] = nil
	timer[cmd][plr] = nil
	setElementData(plr, cmd, false)
	move[plr] = nil
    end, 60000, 1, plr)
end
addCommandHandler("te", te)


function stopEvent(plr, cmd)
	if moveCheck(plr) then return end
    if not eventCheck(plr, move[plr]) then
        toggleAllControls(plr, true)
        setPedAnimation(plr, anim)
        triggerClientEvent(plr, "deleteEffect", plr)
        setElementFrozen(plr, false)
		currently[plr] = nil
    end
end
addCommandHandler("stopeffect", stopEvent)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for index, player in pairs(getElementsByType("player")) do
        bindKey(player, "F", "down", "stopeffect")
    end
end)

addEventHandler("onPlayerJoin", getRootElement(), function()
    bindKey(source, "F", "down", "stopeffect")
end)

function triggerVomitEffect()
    triggerClientEvent(source, "onVomitEffect", source)
end
addEvent("onVomitEffect", true)
addEventHandler("onVomitEffect", root, triggerVomitEffect)

function triggerFartEffect()
    triggerClientEvent(source, "onFartEffect", source)
end
addEvent("onFartEffect", true)
addEventHandler("onFartEffect", root, triggerFartEffect)
