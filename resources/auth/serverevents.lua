local damageSounds = {

["Varsayılan"]  = {"script", 79, 2, false},
["Pinyata"] = {"script", 118, 1, false},
["Bıçak Yarası"] = {"script", 152, 2, false},
["Acı Çekme I"] = {"pain_a", 2, 13, false},
["Acı Çekme II"] = {"pain_a", 2, 14, false},
["Yumruk"] = {"genrl", 136, 35, false}

}

addEventHandler("onPlayerDamage", root, function(attacker, dmg, bodypart)
	local acc = getPlayerAccount(source)
	if (attacker) and getElementType(attacker) == "player" then
	local target_acc = getPlayerAccount(attacker)
	local target_secili = getAccountData(acc, "hasarverses") or "Varsayılan"
	local target_secili_head = getAccountData(acc, "headshotses") or "Varsayılan"
	end
	local secili = getAccountData(acc, "hasarses") or "Varsayılan"
	local baslik, bir, iki, loop = damageSounds[secili][1], tonumber(damageSounds[secili][2]), tonumber(damageSounds[secili][3]), false
	triggerClientEvent(source, "playSF", source, baslik, bir, iki, loop)
	if (attacker) and getElementType(attacker) == "player" then
	if tonumber(bodypart) == 9 then
		local t_baslik, t_bir, t_iki, t_loop = damageSounds[target_secili_head][1], tonumber(damageSounds[target_secili_head][2]), tonumber(damageSounds[target_secili_head][3]), false
		triggerClientEvent(attacker, "playSF", attacker, t_baslik, t_bir, t_iki, t_loop)
	else
		local t_baslik, t_bir, t_iki, t_loop = damageSounds[target_secili][1], tonumber(damageSounds[target_secili][2]), tonumber(damageSounds[target_secili][3]), false
		triggerClientEvent(attacker, "playSF", attacker, t_baslik, t_bir, t_iki, t_loop)
	end
	end
end)