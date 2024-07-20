local unvan = { 

[5] = "#ffae00Kral",
[10] = "#FF6699Gizemli"

}

local tag = "#b1c7dc[SA-HP] #ffffff"
local allP = getElementsByType("player")

function RemoveHEXColorCode( s ) 
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s 
end 

addEvent("join", true)
addEventHandler("join", root, function()
	addEventHandler("onPlayerChat", source, engel)
	addEventHandler("onPlayerCommand", source, engel)
	addEventHandler("onPlayerChangeNick", source, engel)
	setElementInterior(source, 0)
	showChat(source, true)
	toggleControl(source, "chatbox", false)
	setCameraMatrix(source, 1072.76904, -1982.84094, 89.06690, 836.85303, -1919.35181, 80.44060)
	setElementData(source, "logged", false)
	triggerClientEvent(source, "authC", source)
end)

function songinfo(element, singer, song)
	if getElementType(element) == "player" and singer and song then
	outputChatBox("#b1c7dc["..getTime().."] #669933Şu an oynatılıyor: "..singer.." - "..song.."",element,135,157,183,true)
	end
end
addEvent("si", true)
addEventHandler("si", root, songinfo)

addEvent("loadGame", true)
addEventHandler("loadGame", root, function()
	outputChatBox("#b1c7dc["..getTime().."] #fffff9MTA-SA #bbc4c21.6F #fffff9Başlatıldı",source,135,157,183,true)
	outputChatBox("#b1c7dc["..getTime().."] Bağlanılıyor: "..getServerConfigSetting("serverip").." ...",source,135,157,183,true)
	setTimer(function(source)
	outputChatBox("#b1c7dc["..getTime().."] Bağlanıldı. Oyuna giriş yapılıyor...",source,135,157,183,true)
	end, 2000, 1, source)
	setTimer(function(source)
	outputChatBox("#b1c7dc["..getTime().."] Bağlanıldı: #bbc4c2"..getServerName(),source,135,157,183,true)
	end, 6000, 1, source)
	setTimer(function(source)
	local allplayers = getElementsByType("player")
	outputChatBox("#b1c7dc["..getTime().."] #ffffff"..RemoveHEXColorCode(getPlayerName(source)).."("..getElementData(source, "id")..") sunucuya giriş yaptı! #bbc4c2("..#allplayers.."/30)",allplayers,0,0,0,true)
	clearChatBox(source)
	outputChatBox("#b1c7dc["..getTime().."] #FFCC99San Andreas #660000Hırsız #006699Polis #ffffffsunucusuna hoş geldiniz. İyi eğlenceler!",source,135,157,183,true)
	local kad = RemoveHEXColorCode(getPlayerName(source))
	local hesap = getAccount(kad) or false
	local state = ""
	if not hesap then state = "Kayıt Ol" end
	if hesap then
	local checkAutoLogin = checkXMLValue(getPlayerName(source)..":"..getPlayerSerial(source), source)
	if checkAutoLogin then
	logIn(source, hesap, decodeString("base64", checkAutoLogin, {key = getPlayerName(source)}))
	triggerClientEvent(source, "deactiveLogin", source)
	--triggerEvent("loadData", source, getPlayerAccount(source))
	setElementInterior(source, 17)
	setElementPosition(source, 485.77271, -14.93627, 1000.67969)
	setPedRotation(source, -90)
	setCameraMatrix(source, 489.56476, -14.85263, 1000.67969, 485.77271, -14.93627, 1000.67969)
	setElementModel(source, 155)
	setElementDimension(source, getElementData(source, "id"))
	setPedAnimation(source, "dancing", "dance_loop")
	triggerClientEvent(source, "spawnClass", source)
	triggerClientEvent(source, "infobox", source, "Bilgi", "Otomatik olarak hesaba giriş yaptınız.",true)
	triggerClientEvent(source, "exportSafeServerEvent", source, "tea", "loadData", 23, source, "loadData", getPlayerAccount(source))
	else
	state = "Giriş Yap" 
	end
	end
	if state ~= "" then
	kalan = 5
	triggerClientEvent(source, "authCPanel", source, kad, state)
	end
	end, 7000, 1, source)
end)

function getTime()
    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
	return string.format("%02d:%02d:%02d",  hours, minutes, seconds)
end

function engel()
	if not getElementData(source, "logged") then cancelEvent() outputChatBox(tag.."Giriş ekranında bu işlemi yapamazsınız!",source,0,0,0,true) return end
end

function spawnServer(sinif, indexID)
	local sinif_exp = sinif.puan
	local plr_exp = 0
	plr_exp = getElementData(source, sinif.puanturu) or 0
	local plr_city = getAccountData(getPlayerAccount(source), "city") or "LS"
	local place = math.random(1, #spawnPoints[plr_city])
	if plr_exp < sinif_exp then triggerClientEvent(source, "playSF", source, "genrl", 53, 3, false) return end
	if sinif.taraf == "Polis" and getElementData(source, "aranma") then
	triggerClientEvent(source, "infobox", source, "Uyarı", "Aranma seviyeniz bulunuyorken polis olamazsınız.",true)
	triggerClientEvent(source, "playSF", source, "genrl", 53, 3, false)
	else
	if sinif.taraf == "Polis" then
	if plr_city == "LS" then
	spawnPlayer(source, 1575.40320, -1634.03052, 13.55649, 90, tonumber(sinif.skin), 0, 0)
	elseif plr_city == "SF" then
	spawnPlayer(source, -1623.07495, 686.16565, 7.18750, 90, tonumber(sinif.skin), 0, 0)
	elseif plr_city == "LV" then
	spawnPlayer(source, 2290.59033, 2430.32422, 10.82031, 90, tonumber(sinif.skin), 0, 0)	
	end
	toggleControl(source, "chatbox", true)
	else
	spawnPlayer(source, spawnPoints[plr_city][place][1], spawnPoints[plr_city][place][2], spawnPoints[plr_city][place][3], 90, tonumber(sinif.skin), 0, 0)
	toggleControl(source, "chatbox", true)
	end
	local etype = ""
	if config[tonumber(indexID)][4] == "Polis" then etype = "skorpolis" else etype = "skorhirsiz" end
	local plrSKOR = getElementData(source, etype) or 0
	local up = findNextLevelIndex(config, plrSKOR, config[tonumber(indexID)][4], source)
	if not up then return end
	triggerClientEvent(source, "playSF", source, "script", 95, 2, false)
	local maxExp = findNextLevelIndex(config, plrSKOR, config[tonumber(indexID)][4], source)
	setElementData(source, "tarafskor", etype)
	setElementData(source, "maxexp", maxExp)
	triggerClientEvent(source, "finishUp", source)
	setElementData(source, "taraf", sinif.taraf)
	setElementData(source, "meslek", sinif.isim)
	setElementData(source, "skin", sinif.skin)
	tagKontrol(sinif.isim)
	setElementData(source, "sinifsec", false)
	setPedAnimation(source)
	setElementFrozen(source, false)
	setElementData(source, "meslekindex", indexID)
	toggleControl(source, "chatbox", true)
	setElementData(source, "gerek", sinif.alinan)
	setElementData(source, "gerekenexp", sinif_exp)
	setElementData(source, "logged", true)
	triggerClientEvent(source, "discordEvent", source)
	end
end
addEvent("spawnServer", true)
addEventHandler("spawnServer", root, spawnServer)

function removeJob(source)
	setElementData(source, "tarafskor", false)
	setElementData(source, "maxexp", false)
	setElementData(source, "taraf", false)
	setElementData(source, "meslek", false)
	setElementData(source, "skin", false)
	setElementData(source, "meslekindex", false)
	setElementData(source, "gerek", false)
	setElementData(source, "gerekenexp", false)
end

addEvent("giveWep", true)
addEventHandler("giveWep", root, function(wep, ammo)
	if wep and ammo then
		giveWeapon(source, wep, ammo)
		setPedWeaponSlot(source, 7)
	else
		setPedWeaponSlot(source, 0)
	end
end)

function tagKontrol(isim)
	if isim == "SAPD" or isim == "SWAT" then
		triggerClientEvent(source, "exportSafeServerEvent", source, "tea", "scoreboardTag", 28, source, "scoreboardTag", source, "#0066FF")
	else
		if getElementData(source, "aranma") and tonumber(getElementData(source, "aranma")) > 5 then
			triggerClientEvent(source, "exportSafeServerEvent", source, "tea", "scoreboardTag", 28, source, "scoreboardTag", source, "#CC6633")
		else
			triggerClientEvent(source, "exportSafeServerEvent", source, "tea", "scoreboardTag", 28, source, "scoreboardTag", source, "#FFFFFF")
		end
	end
end	

function girisEvent(sifre, state, ulke)
	local kad = RemoveHEXColorCode(getPlayerName(source))
	if state == "register" then
		if sifre == "Şifrenizi Girin" then outputChatBox(tag.."Lütfen belirtilen kutucuğa geçerli bir şifre girin.",source,0,0,0,true) return end
		if #sifre < 8 then outputChatBox(tag.."Belirtilen şifre 8 haneden az olamaz.",source,0,0,0,true) return end
		local hesap = addAccount(kad, sifre) or false
		if hesap then 
		logIn(source, hesap, sifre)
		triggerClientEvent(source, "deactiveLogin", source)
		--triggerEvent("loadData", source, getPlayerAccount(source))
		setElementInterior(source, 17)
		setElementPosition(source, 485.77271, -14.93627, 1000.67969)
		setPedRotation(source, -90)
		setCameraMatrix(source, 489.56476, -14.85263, 1000.67969, 485.77271, -14.93627, 1000.67969)
		setElementModel(source, 155)
		setElementDimension(source, getElementData(source, "id"))
		setPedAnimation(source, "dancing", "dance_loop")
		triggerClientEvent(source, "spawnClass", source)
		setAccountData(getPlayerAccount(source), "password", encodeString("base64", sifre, {key = getPlayerName(source)}))
		local allAcc = ""
		local accs = getAccountsBySerial(getPlayerSerial(source))
		for k, v in pairs(accs) do
		if getAccountName(v) ~= kad then
		allAcc = allAcc..", "..getAccountName(v)
		end
		end
		local pllog = "```Yeni kayıtlı kullanıcı\nKullanıcı Adı: "..kad.."\nSerial: "..getPlayerSerial(source).."\nÜlke: "..ulke.."\nIP Adresi: "..getPlayerIP(source).."\nDiğer hesaplar: "..allAcc.."```"
		triggerEvent("sendDiscordMessage", source, "kayit", pllog)
		else
		outputChatBox(tag.."anlaşılmayan bir hata meydana geldi. Lütfen yöneticilerle iletişime geçin.",source,0,0,0,true)
		end
	else
		if sifre == "Şifrenizi Girin" then outputChatBox(tag.."Lütfen belirtilen kutucuğa geçerli bir şifre girin.",source,0,0,0,true) return end
		local hesap = getAccount(kad, sifre)
		if hesap then
			logIn(source, hesap, sifre)
			triggerClientEvent(source, "deactiveLogin", source)
			--triggerEvent("loadData", source, getPlayerAccount(source))
			setElementInterior(source, 17)
			setElementPosition(source, 485.77271, -14.93627, 1000.67969)
			setPedRotation(source, -90)
			setCameraMatrix(source, 489.56476, -14.85263, 1000.67969, 485.77271, -14.93627, 1000.67969)
			setElementModel(source, 155)
			setElementDimension(source, getElementData(source, "id"))
			setPedAnimation(source, "dancing", "dance_loop")
			triggerClientEvent(source, "exportSafeServerEvent", source, "tea", "loadData", 23, source, "loadData", getPlayerAccount(source))
			triggerClientEvent(source, "spawnClass", source)
		else
			if (kalan-1)==0 then kickPlayer(source, "Şifrenizi beş kez hatalı girdiniz.") return end
			kalan = kalan - 1
			outputChatBox(tag.."Şifre veya kullanıcı adı yanlış. (Kalan: "..kalan..")",source,0,0,0,true)
		end
	end
end
addEvent("girisyap", true)
addEventHandler("girisyap", root, girisEvent)

addEvent("seviyeAtlama", true)
addEventHandler("seviyeAtlama", root, function()
	local name = RemoveHEXColorCode(getPlayerName(source))
	local seviye = getElementData(source, "level")
	if unvan[tonumber(getElementData(source, "level"))] ~= nil then
	outputChatBox(tag.."#ffae00SEVIYE >> "..name.." adlı oyuncu "..getElementData(source, "level")..". seviyeye ulaşarak "..unvan[tonumber(getElementData(source, "level"))].." ünvanını kazandı!",allP,0,0,0,true)
	end
end)

function manageExp(plr, cmd, id, state, value)
	if not id or not state or not tonumber(value) then outputChatBox(tag.."Kullanım: /aexp [Oyuncu/ID] [ver/al] [değer]",plr,0,0,0,true) return end
	local opposite_p = exports.globals:findPlayerByPartialNick(id)
	if not opposite_p then outputChatBox(tag.."Aradığınız oyuncu bulunamadı.",plr,0,0,0,true) return end
	local opposite_p_exp = getElementData(opposite_p, "exp") or 0
	if state == "ver" then
		if tonumber(value) == 0 then outputChatBox(tag.."Belirtilen exp sıfırdan küçük olamaz.",plr,0,0,0,true) return end
		local ilk = opposite_p_exp
		setElementData(opposite_p, "exp", opposite_p_exp + value)
		outputChatBox(tag.."EXP >> "..getPlayerName(plr).." adlı yönetici size "..value.." EXP verdi!",opposite_p,0,0,0,true)
		outputChatBox(tag.."EXP >> "..getPlayerName(opposite_p).." adlı oyuncuya "..value.." EXP verdiniz.",plr,0,0,0,true)
		triggerClientEvent(opposite_p, "giveExp", opposite_p, opposite_p, true, ilk, value)
	elseif state == "al" then
		if opposite_p_exp > 0 and opposite_p_exp - value >= 0 then
		local ilk = opposite_p_exp
		setElementData(opposite_p, "exp", opposite_p_exp - value)
		outputChatBox(tag.."EXP >> "..getPlayerName(plr).." adlı yönetici sizden "..value.." EXP aldı!",opposite_p,0,0,0,true)
		outputChatBox(tag.."EXP >> "..getPlayerName(opposite_p).." adlı oyuncudan "..value.." EXP aldınız.",plr,0,0,0,true)
		triggerClientEvent(opposite_p, "giveExp", opposite_p, opposite_p, false, ilk, value)
		else outputChatBox(tag.."Belirttiğiniz oyuncu "..opposite_p_exp.." EXP'ye sahip, işlem yapılamadı.",plr,0,0,0,true) return end
	end
end
addCommandHandler("aexp", manageExp)

function manageScore(plr, cmd, id, state, taraf, value)
	if not id or not state or not taraf or not tonumber(value) then outputChatBox(tag.."Kullanım: /askor [Oyuncu/ID] [ver/al] [hirsiz/polis] [değer]",plr,0,0,0,true) return end
	local opposite_p = exports.globals:findPlayerByPartialNick(id)
	if not opposite_p then outputChatBox(tag.."Aradığınız oyuncu bulunamadı.",plr,0,0,0,true) return end
	local opposite_p_skor = 0
	local event = ""
	if taraf == "hirsiz" then
	opposite_p_skor = getElementData(opposite_p, "skorhirsiz") or 0
	event = "skorhirsiz"
	elseif taraf == "polis" then
	event = "skorpolis"
	opposite_p_skor = getElementData(opposite_p, "skorpolis") or 0
	end
	if state == "ver" then
		if tonumber(value) == 0 then outputChatBox(tag.."Belirtilen skor sıfırdan küçük olamaz.",plr,0,0,0,true) return end
		local ilk = opposite_p_skor
		setElementData(opposite_p, event, opposite_p_skor + value)
		outputChatBox(tag.."SKOR >> "..getPlayerName(plr).." adlı yönetici size "..value.." "..taraf.." skor verdi!",opposite_p,0,0,0,true)
		outputChatBox(tag.."SKOR >> "..getPlayerName(opposite_p).." adlı oyuncuya "..value.." "..taraf.." skor verdiniz.",plr,0,0,0,true)
	elseif state == "al" then
		if opposite_p_skor > 0 and opposite_p_skor - value >= 0 then
		local ilk = opposite_p_skor
		setElementData(opposite_p, event, opposite_p_skor - value)
		outputChatBox(tag.."SKOR >> "..getPlayerName(plr).." adlı yönetici sizden "..taraf.." skor aldı!",opposite_p,0,0,0,true)
		outputChatBox(tag.."SKOR >> "..getPlayerName(opposite_p).." adlı oyuncudan "..taraf.." skor aldınız.",plr,0,0,0,true)
		else outputChatBox(tag.."Belirttiğiniz oyuncu "..opposite_p_skor.." "..taraf.." skora sahip, işlem yapılamadı.",plr,0,0,0,true) return end
	end
end
addCommandHandler("askor", manageScore)

function manageLevel(plr, cmd, id, level)
	if not id or not tonumber(level) then outputChatBox(tag.."Kullanım: /alevel [Oyuncu/ID] [değer]",plr,0,0,0,true) return end
	if tonumber(level) < 1 then outputChatBox(tag.."Belirtilen seviye sıfırdan küçük olamaz.",plr,0,0,0,true) return end
	local opposite_p = exports.globals:findPlayerByPartialNick(id)
	if not opposite_p then outputChatBox(tag.."Aradığınız oyuncu bulunamadı.",plr,0,0,0,true) return end
	setElementData(opposite_p, "maxexp", level*1000)
	setElementData(opposite_p, "exp", 0)
	setElementData(opposite_p, "level", level)
	outputChatBox(tag.."LEVEL >> "..getPlayerName(plr).." adlı yönetici seviyenizi "..level.." yaptı.",opposite_p,0,0,0,true)
	outputChatBox(tag.."LEVEL >> "..getPlayerName(opposite_p).." adlı oyuncunun seviyesini "..level.." yaptınız.",plr,0,0,0,true)
end
addCommandHandler("alevel", manageLevel)

function setXP(player, state, value)
	if player and tonumber(value) then
		local player_xp = getElementData(player, "exp") or 0
		if state then
			setElementData(player, "exp", player_xp+value)
			return true
		else
			if (player_xp-value) > 0 then
				setElementData(player, "exp", player_xp-value)
				return true
			else
				return false
			end
		end
	end
end

function setLevel(player, value)
	if player and tonumber(value) then
		local player_level = getElementData(player, "level") or 1
		setElementData(player, "maxexp", value*1000)
		setElementData(player, "exp", value)
		return true
	end
end

function sehirIsinla(source)
	local acc = getPlayerAccount(source)
	local taraf = getElementData(source, "taraf") or "Hırsız"
	if taraf == "Hırsız" then
	local sehir = getAccountData(acc, "city") or "LS"
	local place = math.random(1, #spawnPoints[sehir])
	setElementDimension(source, 0)
	setElementInterior(source, 0)
	setElementPosition(source, spawnPoints[sehir][place][1], spawnPoints[sehir][place][2], spawnPoints[sehir][place][3])
	elseif taraf == "Polis" then
	setElementDimension(source, 0)
	setElementInterior(source, 0)
	setElementPosition(source, 1575.40320, -1634.03052, 13.55649)
	end
end



addEventHandler("onElementDataChange", root, function(key, old, new)
	 if (getElementType(source) == "player") then
		if key == "skorhirsiz" or key == "skorpolis" then
			local class = getElementData(source, "meslek") or "Sivil"
			local class_id = getElementData(source, "meslekindex") or false
			if class_id then
				if getElementData(source, "gerek") == key then
					if tonumber(new) < tonumber(getElementData(source, "gerekenexp")) then
						setElementData(source, "sinifsec", true)
						killPed(source)
						outputChatBox("[-] #ffffff"..class.." için yeterli skoru karşılamıyorsunuz, yeni sınıf seçin.",source,255,0,0,true)
						removeJob(source)
					end
				end
				local side = ""
				if key == "skorhirsiz" then side = "Hırsız" else side = "Polis" end 
				local up = findNextLevelIndex(config, tonumber(new), side, source)
				if not up then return end
				local upgrade = config[tonumber(findNextLevelIndex(config, tonumber(new), side, source))][2]
				local currently = config[getElementData(source, "meslekindex")][2]
				if tonumber(new) >= currently then
					local new_max = tonumber(findNextLevelIndex(config, tonumber(new), side, source))
					setElementData(source, "maxexp", new_max)
				elseif tonumber(new) < currently then
					local new_max = tonumber(findNextLevelIndex(config, tonumber(new), side, source))
					setElementData(source, "maxexp", new_max)
				end
			end	
		end
		if key == "aranma" then
			if new then 
				if tonumber(new) > 5 then
					triggerEvent("scoreboardTag", source, source, "#CC6633")
				end
			else
				triggerEvent("scoreboardTag", source, source, "#FFFFFF")
			end
		end
	 end
end)


function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function findNextLevelIndex(config, currentScore, types, element)
	local meslek = getElementData(element, "meslek") or false
    local nextLevelIndex = nil
    local smallestHigherDifference = math.huge  

    for i, v in pairs(config) do
        if types == v[4] and v[2] > currentScore then	
            local difference = v[2] - currentScore
            if difference < smallestHigherDifference then
                smallestHigherDifference = difference
                nextLevelIndex = i
            end
        end
    end
    if nextLevelIndex == nil then
        local lastHighestScoreIndex = nil
        for i, v in pairs(config) do
            if types == v[4] then
                if lastHighestScoreIndex == nil or v[2] > config[lastHighestScoreIndex][2] then
                    lastHighestScoreIndex = i
                end
            end
        end
        return lastHighestScoreIndex
    else
        return nextLevelIndex
    end
end
