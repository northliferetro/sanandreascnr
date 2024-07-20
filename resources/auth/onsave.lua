addEvent("loadData", true)
addEventHandler("loadData", root, function()
	local acc = getPlayerAccount(source)
	setElementData(source, "logged", true)
	local data = getAccountData(acc, "data")
	if data then
	local datas = fromJSON(data)
	serverLoadDetails(datas)
	else
	spawnPlayer(source, 0, 0, 0)
	setPlayerMoney(source, 1000)
	setElementHealth(source, 100)
	setPedArmor(source, 0)
	setElementModel(source, 7)
	end
end)

function serverSpawn(data)
	local kordinat = data["p_co"]
	spawnPlayer(source, kordinat["x"], kordinat["y"], kordinat["z"])
	setElementInterior(source, kordinat["int"])
	setElementDimension(source, kordinat["dim"])
end

function serverLoadDetails(data)
	local detail = data["p_detail"]
	setPlayerMoney(source, detail["money"])
	setElementHealth(source, 100)
	setPedArmor(source, detail["armor"])
--	setElementModel(source, detail["skin"])
	setElementData(source, "exp", detail["exp"])
	setElementData(source, "maxexp", detail["maxexp"])
	setElementData(source, "level", detail["level"])
	setElementData(source, "skorpolis", detail["polis"])
	setElementData(source, "skorhirsiz", detail["hirsiz"])
	setElementData(source, "aranma", detail["aranma"])
end


function servrLoadWeapons(data)
	local detail = data["p_weapon"]
	if detail and #detail > 1 then
		for i, v in pairs(detail) do
			if v.wep > 0 then
				giveWeapon(source, tonumber(v.wep), tonumber(v.bullet), true)
			end
		end
	end
end