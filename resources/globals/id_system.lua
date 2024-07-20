local players = {}

addEventHandler("onPlayerJoin", root, function()
	for i=1, #getElementsByType("player")+1 do
		if players[i] == nil then
			local newID = i
			players[newID] = source 
			setElementData(source, "id", newID)
			break
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	local id = getElementData(source, "id")
	table.remove(players, tonumber(id))
end)

function findPlayerByName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function findIDByPlayer(player)
	if player then
		local player = exports.globals:findPlayerByName(player)
		local theid
		players = getElementsByType("player")
		theid = getElementData(player, "id") or 0
		return theid
	else return false end
end

function findPlayerByID(theID)
	if theID then
		theID = tonumber(theID)
		local theplayer
		players = getElementsByType("player")
		for id,p in ipairs(players) do
			local ids = getElementData(p, "id") or 0
			if tonumber(ids) == tonumber(theID) then
				theplayer = p
			end
		end
		return theplayer
	else return false end
end

function findPlayerByPartialNick(element)
	local target
	if tonumber(element) then
	local target = exports.globals:findPlayerByID(element)
	return target
	elseif element then
	local target = findPlayerByName(element)
	return target
end
end

