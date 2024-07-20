-- Scoreboard üzerinden birinin seçilmesi durumundaki callback

addEvent("scoreboardClick", true)
addEventHandler("scoreboardClick", root, function(selected, id)
	if getElementType(selected) == "player" and tonumber(id) then
		local acc = getPlayerAccount(selected) or false
		if selected ~= source then
		if acc then
			if getAccountData(acc, "istatistik") then outputChatBox("[-] #ffffffBu kişi istatistiklerinin görünümünü kapatmış.",source,255,0,0,true) return end
			showInfo(source, selected)
		end
		else
		showInfo(source,source)
		end
	end
end)

function showInfo(plr, element)
	outputChatBox(getPlayerName(element), plr)
end
  
function hex2rgb(hex) 
  hex = hex:gsub("#","") 
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) 
end 

function setPlayerColor(plr, color)
	local pattern = "^#%x%x%x%x%x%x$"
	if color then
	if string.match(color, pattern) then
        if getElementType(plr) == "player" then
			setElementData(plr, "tagcolor", color)
			setPlayerNametagColor(plr, hex2rgb(color))
			return true
		end
	else
		return false
    end
	else
	return false
	end
end
addEvent("scoreboardTag", true)
addEventHandler("scoreboardTag", root, setPlayerColor)

