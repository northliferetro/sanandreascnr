local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted", "radar", "area_name"}
local panel = false

local songs = {

[1] = {singer = "Rockstar Games", song = "Vice City Theme"},
[2] = {singer = "Seryoga", song = "King Ring"},
[3] = {singer = "Offset & Metro Boomin", song = "Ric Flair Drip"},

}

addEventHandler("onClientResourceStart", resourceRoot, function()
	exports.anticheat:triggerSafeServerEvent("tea", "resGameLoad", 26, localPlayer, "resGameLoad")
	exports.anticheat:triggerSafeServerEvent("tea", "join", 19, localPlayer, "join")
end)


function authClientside(st)
	if not st then
	clearChatBox()
	showCursor(true)
	setTime(12, 0)
	setWeather(2)
	hudState(false)
	mbCheck()
	else
	hudState(false)
	clearChatBox()
	showChat(false)
	end
end
addEvent("authC", true)
addEventHandler("authC", root, authClientside)

function mbCheck()
	if isTransferBoxActive() then
		setTimer(mbCheck, 2000, 1)
	else
		exports.anticheat:triggerSafeServerEvent("tea", "loadGame", 23, localPlayer, "loadGame")
	end
end

function authPanel(name, s)
	local metin = ""
	if s == "Kayıt Ol" then 
	metin = "Kullanıcı adına ait bir hesap bulunamadı. Şifreni oluşturarak \nserüvene devam edebilirsin!" 
	else
	metin = "Kullanıcı adına ait bir hesap bulundu. Şifreni aşağı girerek\ngiriş yapabilirsin."
	end
	local deger = math.random(1,#songs)
	giris_sarki = playSound("SFX/"..deger..".mp3")
	exports.anticheat:triggerSafeServerEvent("tea", "si", 17, localPlayer, "si", localPlayer, songs[deger]["singer"], songs[deger]["song"])
	setSoundVolume(giris_sarki, 0.5)
    giris_window = guiCreateWindow(0.36, 0.39, 0.27, 0.22, "San Andreas Hırsız Polis", true)
    guiWindowSetMovable(giris_window, false)
    guiWindowSetSizable(giris_window, false)
    guiSetAlpha(giris_window, 1.00)
    giris_yazi = guiCreateLabel(0.03, 0.16, 0.94, 0.36, "Sunucuya hoş geldin "..name..",\n\n"..metin, true, giris_window)
    giris_sifre = guiCreateEdit(0.03, 0.57, 0.93, 0.15, "Şifrenizi Girin", true, giris_window)
    giris_buton = guiCreateButton(0.66, 0.78, 0.29, 0.12, s, true, giris_window)    
end
addEvent("authCPanel", true)
addEventHandler("authCPanel", root, authPanel)

function hudState(state)
	for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, state )
	end
end

addEvent("deactiveClient", true)
addEventHandler("deactiveClient", root, function()
	hudState(true)
	showChat(true)
	showCursor(false)
	if isElement(giris_window) then destroyElement(giris_window) end
	if isElement(giris_sarki) then destroyElement(giris_sarki) end
	setCameraTarget(localPlayer, localPlayer)
end)

addEvent("deactiveLogin", true)
addEventHandler("deactiveLogin", root, function()
	if isElement(giris_window) then destroyElement(giris_window) end
	showChat(false)
	if giris_sarki then destroyElement(giris_sarki) end
end)

addEventHandler("onClientGUIClick", root, function()
	if source == giris_sifre and guiGetText(giris_sifre) == "Şifrenizi Girin" then guiSetText(giris_sifre, "") end
	if source == giris_buton then 
	if guiGetText(giris_buton) == "Giriş Yap" then
	exports.anticheat:triggerSafeServerEvent("tea", "girisyap", 23, localPlayer, "girisyap", guiGetText(giris_sifre), "login")
	else
	exports.anticheat:triggerSafeServerEvent("tea", "girisyap", 23, localPlayer, "girisyap", guiGetText(giris_sifre), "register", getLanguageCode(getLocalization().code))
	end
	end
end)

local languageCodes = {
	['ar_SA'] = 'ar',
	['bg_BG'] = 'bg',
	['da_DK'] = 'da',
	['de_DE'] = 'de',
	['el_GR'] = 'el',
	['es_ES'] = 'es',
	['fr_FR'] = 'fr',
	['hr_HR'] = 'hr',
	['hu_HU'] = 'hu',
	['id_ID'] = 'id',
	['it_IT'] = 'it',
	['lt_LT'] = 'lt',
	['nb_NO'] = 'nb',
	['nl_NL'] = 'nl',
	['pl_PL'] = 'pl',
	['pt_PT'] = 'pt_BR',
	['ro_RO'] = 'ro',
	['ru_RU'] = 'ru',
	['sl_SL'] = 'sl',
	['sv_SE'] = 'sv',
	['tr_TR'] = 'tr',
	['uk_UA'] = 'uk',
	['vi_VN'] = 'vi',
}

function getLanguageCode(c)
	return languageCodes[c] or c
end

code = getLanguageCode(getLocalization().code)

 playSFX("spc_na", 32, 34)
local lastIndex = 0

function classCheck(index)
	gerekens = ""
	local data = {}
	local yildiz = "#990000★\n"
	if tonumber(index) then
		if config[tonumber(index)] ~= nil then
			local metin = config[tonumber(index)][9].."\n"
			local gereken, tur = config[tonumber(index)][2], config[tonumber(index)][3]
			for i=10, 18 do
				if config[tonumber(index)][i] ~= nil then
					yildiz = yildiz.."#990000★\n"
					metin = metin..config[tonumber(index)][i].."\n"
				end
			end
			local _, count = string.gsub(yildiz, "\n", "")
			local starI = 11 - count
			for i=1, starI do
			yildiz = yildiz.."\n"
			if i == starI then
			yildiz = yildiz.."#990000★"
			end
			end
			if config[tonumber(index)][3] == "skorpolis" then
			gerekens = "Polis"
			else
			gerekens = "Hırsız" 
			end
			setElementInterior(localPlayer, camera[tonumber(index)][1])
			exports.anticheat:triggerSafeServerEvent("tea", "triggerFunction", 30, localPlayer, "triggerFunction", "setElementPosition", localPlayer, camera[tonumber(index)][5], camera[tonumber(index)][6],camera[tonumber(index)][7])
			setPedRotation(localPlayer, camera[tonumber(index)][8])
			setPedAnimation(localPlayer, config[tonumber(index)][6], config[tonumber(index)][7])
			if config[tonumber(index)][8] ~= nil then
				if isElement(effect) then destroyElement(effect) end
				local effect = createEffect(config[tonumber(index)][8], camera[tonumber(index)][5], camera[tonumber(index)][6],camera[tonumber(index)][7], nil, nil, nil, nil, true)
			end
			if config[tonumber(index)][1] == "Paralı Asker" then
			--	triggerServerEvent("giveWep", localPlayer, 31, 2)
			else
			--	triggerServerEvent("giveWep", localPlayer)
			end
			setElementFrozen(localPlayer, true)
			setCameraMatrix(camera[tonumber(index)][2], camera[tonumber(index)][3], camera[tonumber(index)][4], camera[tonumber(index)][5], camera[tonumber(index)][6],camera[tonumber(index)][7])
			data = {alinan = config[tonumber(index)][3], taraf = config[tonumber(index)][4], isim = config[tonumber(index)][1], puan = gereken, puanturu = tur, yildizlar = yildiz, avantajlar = metin, skin = config[tonumber(index)][5]}
			currentlyClass = data
			local skin = config[tonumber(index)][5]
			setElementModel(localPlayer, tonumber(skin))
		end
	end
	return data
end



    function spawnHandler()
		lastIndex = 0
		local veri = currentlyClass
        dxDrawRectangle(506, 599, 344, 45, tocolor(0, 0, 0, 181), false)
		if isMouseInPosition(510, 603, 105, 37) then
			ge = 0
			il = 255
			sp = 255
		elseif isMouseInPosition(740, 603, 105, 37) then
			ge = 255
			il = 0
			sp = 255
		elseif isMouseInPosition(625, 603, 105, 37) then
			ge = 255
			il = 255
			sp = 0
		else
			ge = 255
			il = 255
			sp = 255
		end
        geri = dxDrawImage(510, 603, 105, 37, ":scoreboard/button.png", 0, 0, 0, tocolor(255, ge, ge, 255), false)
        ileri = dxDrawImage(740, 603, 105, 37, ":scoreboard/button.png", 0, 0, 0, tocolor(255, il, il, 255), false)
        spawn = dxDrawImage(625, 603, 105, 37, ":scoreboard/button.png", 0, 0, 0, tocolor(255, sp, sp, 255), false)
        dxDrawText("<<", 510, 602, 615, 640, tocolor(255, 255, 255, 255), 1.30, "arial", "center", "center", false, false, false, false, false)
        dxDrawText(">>", 625, 602, 730, 640, tocolor(255, 255, 255, 255), 1.30, "arial", "center", "center", false, false, false, false, false)
        dxDrawText("Spawn", 740, 602, 845, 640, tocolor(255, 255, 255, 255), 1.30, "arial", "center", "center", false, false, false, false, false)
        dxDrawRectangle(169, 261, 282, 30, tocolor(0, 0, 0, 254), false)
        dxDrawRectangle(169, 291, 282, 10, tocolor(254, 254, 254, 254), false)
        dxDrawRectangle(169, 301, 282, 283, tocolor(0, 0, 0, 196), false)
        dxDrawText("SINIF: "..veri.isim, 179, 265, 447, 287, tocolor(255, 255, 255, 255), 0.90, "bankgothic", "left", "center", false, false, false, false, false)
        dxDrawText(veri.yildizlar, 176, 307, 189, 579, tocolor(255, 255, 255, 255), 1.00, "clear", "left", "top", false, false, false, true, false)
        dxDrawText(veri.avantajlar, 199 - 1, 306 - 1, 441 - 1, 458 - 1, tocolor(0, 0, 0, 255), 0.50, "bankgothic", "left", "top", false, false, false, true, false)
        dxDrawText(veri.avantajlar, 199 + 1, 306 - 1, 441 + 1, 458 - 1, tocolor(0, 0, 0, 255), 0.50, "bankgothic", "left", "top", false, false, false, true, false)
        dxDrawText(veri.avantajlar, 199 - 1, 306 + 1, 441 - 1, 458 + 1, tocolor(0, 0, 0, 255), 0.50, "bankgothic", "left", "top", false, false, false, true, false)
        dxDrawText(veri.avantajlar, 199 + 1, 306 + 1, 441 + 1, 458 + 1, tocolor(0, 0, 0, 255), 0.50, "bankgothic", "left", "top", false, false, false, true, false)
        dxDrawText(veri.avantajlar, 199, 306, 441, 458, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, true, false)
		dxDrawText("GEREKEN: "..veri.puan.." "..gerekens.." Skoru", 189 - 1, 473 - 1, 431 - 1, 488 - 1, tocolor(0, 0, 0, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
        dxDrawText("GEREKEN: "..veri.puan.." "..gerekens.." Skoru", 189 + 1, 473 - 1, 431 + 1, 488 - 1, tocolor(0, 0, 0, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
        dxDrawText("GEREKEN: "..veri.puan.." "..gerekens.." Skoru", 189 - 1, 473 + 1, 431 - 1, 488 + 1, tocolor(0, 0, 0, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
        dxDrawText("GEREKEN: "..veri.puan.." "..gerekens.." Skoru", 189 + 1, 473 + 1, 431 + 1, 488 + 1, tocolor(0, 0, 0, 255), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
        dxDrawText("GEREKEN: "..veri.puan.." "..gerekens.." Skoru", 189, 473, 431, 488, tocolor(5, 46, 1, 254), 0.40, "bankgothic", "left", "top", false, false, false, false, false)
    end
	
	
	addEvent("spawnClass", true)
	addEventHandler("spawnClass", root, function()
		currentlyClass = classCheck(1)
		showCursor(true)
		indexID = 1
		panel = true
		addEventHandler("onClientRender", getRootElement(), spawnHandler)
	end)

local indexID = 1

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if panel then
    if currentlyClass then
        if button == "left" and state == "up" then
            if isMouseInPosition(510, 603, 105, 37) then -- geri
                indexID = indexID - 1
				playSFX("genrl", 53, 1, false)
                if indexID < 1 then
                    indexID = #config
					currentlyClass = classCheck(indexID)
                else
                currentlyClass = classCheck(indexID)
				end
                if not currentlyClass then
                    indexID = indexID + 1
                    currentlyClass = classCheck(indexID)
                end
            end
            if isMouseInPosition(740, 603, 105, 37) then -- spawn
				local secili_sinif = currentlyClass
				exports.anticheat:triggerSafeServerEvent("tea", "spawnServer", 26, localPlayer, "spawnServer", secili_sinif, indexID)
				-- s
            end
            if isMouseInPosition(625, 603, 105, 37) then -- ileri
                indexID = indexID + 1
				playSFX("genrl", 53, 7, false)
                if indexID > #config then
                    indexID = 1
					currentlyClass = classCheck(indexID)
                else
                currentlyClass = classCheck(indexID)
				end
                if not currentlyClass then
                    indexID = indexID - 1 
                    currentlyClass = classCheck(indexID)
					end
                end
            end
        end
    end
end)

addEvent("finishUp", true)
addEventHandler("finishUp", root, function()
	triggerEvent("deactiveClient", getRootElement())
	panel = false
	removeEventHandler("onClientRender", getRootElement(), spawnHandler)
end)

addEvent("playSF", true)
addEventHandler("playSF", root, function(part, one, two, loop)
	playSFX(part, tonumber(one), tonumber(two), loop)
end)


