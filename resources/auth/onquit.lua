function gameLoad()
	if getElementData(source, "logged") then
		local acc = getPlayerAccount(source)
		if acc then
		local details = getDetail(source)
		local sx, sy, sz = getElementPosition(source)
		local sint, sdim = getElementInterior(source), getElementDimension(source)
		local kordinat = {x = sx, y = sy, z = sz, int = sint, dim = sdim}
		local fullData = {p_detail = details, p_co = kordinat}
		local json_k = toJSON(fullData)
		setAccountData(acc, "data", json_k)
		end
	end
end
addEventHandler("onPlayerQuit", root, gameLoad)
addEvent("resGameLoad", true)
addEventHandler("resGameLoad", root, gameLoad)

function getWeapons(e)
	local t = {}
     for i=0, 12 do
        local weapon = getPedWeapon(e, i)
        local ammo = getPedTotalAmmo(e, i)
        table.insert(t, {wep = weapon, bullet = ammo})
     end
	 return t
end

function getDetail(e)
	local aranma = getElementData(e, "aranma") or false
	local epskor = getElementData(e, "skorpolis") or 0
	local ehskor = getElementData(e, "skorhirsiz") or 0
	local elevel = getElementData(e, "level") or 1
	local emaxexp = getElementData(e, "maxexp") or 1000
	local eexp = getElementData(e, "exp") or 0
	local emoney = getPlayerMoney(e)
	local ehp = getElementHealth(e)
	local earmor = getPedArmor(e)
	local eskin = getElementModel(e)
	local t = {aranma = aranma, money = emoney, hp = ehp, armor = earmor, skin = eskin, exp = eexp, maxexp = emaxexp, level = elevel, polis = epskor, hirsiz = ehskor}
	return t
end