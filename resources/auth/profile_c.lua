local pickups = {

[3471] = "Heykel I",
[1313] = "Kurukafalar",
[1608] = "Köpekbalığı",
[3528] = "Aslan Kafası",

}

local damageSounds = {

["Varsayılan"]  = {"script", 79, 2, false},
["Pinyata"] = {"script", 118, 1, false},
["Bıçak Yarası"] = {"script", 152, 2, false},
["Acı Çekme I"] = {"pain_a", 2, 13, false},
["Acı Çekme II"] = {"pain_a", 2, 14, false},
["Yumruk"] = {"genrl", 136, 35, false}

}

local advice = ""
local dc = nil
local discord = ""

local lang = {

[true] = {"KAPALI", 255, 0, 0},
[false] = {"AÇIK", 0, 255, 0}

}


    function profilAc(data)
		advice = "******************************"
		dc = data.discord
		if isElement(profil) then destroyElement(profil) showCursor(false) end
		if isElement(ayarlar_ayarpanel) then destroyElement(ayarlar_ayarpanel) return end
		showCursor(true)
		local screenW, screenH = guiGetScreenSize()
        profil = guiCreateWindow((screenW - 507) / 2, (screenH - 396) / 2, 507, 396, "SA:HP - Profil", false)
        guiWindowSetMovable(profil, false)
        guiWindowSetSizable(profil, false)

        profil_ayarlartab = guiCreateTabPanel(9, 22, 488, 364, false, profil)

        profilayar = guiCreateTab("Ayarlar", profil_ayarlartab)

        ayarlarGrid = guiCreateGridList(6, 4, 472, 325, false, profilayar)
        opt = guiGridListAddColumn(ayarlarGrid, "İşlem", 0.3)
        guiGridListAddColumn(ayarlarGrid, "Değer", 0.5)
        for i = 1, 17 do
            guiGridListAddRow(ayarlarGrid)
        end
        guiGridListSetItemText(ayarlarGrid, 0, 2, "", false, false)
        kapat = guiGridListSetItemText(ayarlarGrid, 0, 1, ">> Paneli Kapat", false, false)
        guiGridListSetItemColor(ayarlarGrid, 0, 1, 255, 0, 0, 255)
        guiGridListSetItemText(ayarlarGrid, 1, 1, ">> Şifre Değiştir", false, false)
        guiGridListSetItemText(ayarlarGrid, 1, 2, "******", false, false)
        guiGridListSetItemText(ayarlarGrid, 2, 1, ">> Hesap Serial", false, false)
        guiGridListSetItemText(ayarlarGrid, 2, 2, advice, false, false)
        guiGridListSetItemText(ayarlarGrid, 3, 2, "", false, false)
        guiGridListSetItemText(ayarlarGrid, 5, 1, ">> Şehir Değiştir", false, false)
        guiGridListSetItemText(ayarlarGrid, 5, 2, data.sehir["yer"], false, false)
        guiGridListSetItemText(ayarlarGrid, 6, 1, ">> Mezar Değiştir", false, false)
        guiGridListSetItemText(ayarlarGrid, 6, 2, pickups[tonumber(data.mezarlik)], false, false)
        guiGridListSetItemText(ayarlarGrid, 7, 1, ">> Son Söz Değiştir", false, false)
        guiGridListSetItemText(ayarlarGrid, 7, 2, data.sonsoz, false, false)  
        guiGridListSetItemText(ayarlarGrid, 8, 1, ">> Topluluk Davetleri", false, false)
        guiGridListSetItemText(ayarlarGrid, 8, 2, lang[getElementData(localPlayer, "davet")][1], false, false)    		
		guiGridListSetItemColor(ayarlarGrid, 8, 2, lang[getElementData(localPlayer, "davet")][2], lang[getElementData(localPlayer, "davet")][3], lang[getElementData(localPlayer, "davet")][4], 255)
		guiGridListSetItemText(ayarlarGrid, 9, 1, ">> Özel Mesajlar", false, false)
        guiGridListSetItemText(ayarlarGrid, 9, 2, lang[getElementData(localPlayer, "pm")][1], false, false)    		
		guiGridListSetItemColor(ayarlarGrid, 9, 2, lang[getElementData(localPlayer, "pm")][2], lang[getElementData(localPlayer, "pm")][3], lang[getElementData(localPlayer, "pm")][4], 255)
		guiGridListSetItemText(ayarlarGrid, 10, 1, ">> İstatistik Gösterimi", false, false)
        guiGridListSetItemText(ayarlarGrid, 10, 2, lang[data.istatistik][1], false, false)    		
		guiGridListSetItemColor(ayarlarGrid, 10, 2, lang[data.istatistik][2], lang[data.istatistik][3], lang[data.istatistik][4], 255)
		guiGridListSetItemText(ayarlarGrid, 11, 1, ">> Otomatik Giriş", false, false)
        guiGridListSetItemText(ayarlarGrid, 11, 2, lang[not data.otologin][1], false, false)    		
		guiGridListSetItemColor(ayarlarGrid, 11, 2, lang[not data.otologin][2], lang[not data.otologin][3], lang[not data.otologin][4], 255)
		guiGridListSetItemText(ayarlarGrid, 12, 1, ">> Discord Hesabı", false, false)
		guiGridListSetItemText(ayarlarGrid, 13, 1, ">> Hasar Alma Sesi", false, false)
        guiGridListSetItemText(ayarlarGrid, 13, 2, data.hasarses, false, false)
		guiGridListSetItemText(ayarlarGrid, 14, 1, ">> Hasar Verme Sesi", false, false)
        guiGridListSetItemText(ayarlarGrid, 14, 2, data.hasarverses, false, false)
		guiGridListSetItemText(ayarlarGrid, 15, 1, ">> Headshot Sesi", false, false)
        guiGridListSetItemText(ayarlarGrid, 15, 2, data.headshotses, false, false)
		if data.discord then
		discord = "Bağlanıldı"
		else
		discord = "Bağlı Değil"
		end
        guiGridListSetItemText(ayarlarGrid, 12, 2, discord, false, false)    		
		guiGridListSetItemColor(ayarlarGrid, 12, 2, lang[not data.discord][2], lang[not data.discord][3], lang[not data.discord][4], 255)
		guiGridListSetSortingEnabled(ayarlarGrid, false)
    end
	addEvent("profileClient", true)
	addEventHandler("profileClient", root, profilAc)

	local active = ""
	local g_yer = {}
	local g_event = ""

    function ayarPanel(state, veri, info, yer, event, eventdata)
		active = state
		g_yer = yer
		g_event = event
		g_eventdata = eventdata or false
		if isElement(profil) then guiSetVisible(profil, false) end
		if isElement(ayarlar_ayarpanel) then destroyElement(ayarlar_ayarpanel) end
		local screenW, screenH = guiGetScreenSize()
        ayarlar_ayarpanel = guiCreateWindow((screenW - 347) / 2, (screenH - 122) / 2, 347, 122, "SA:HP - Profil Ayar", false)
        guiWindowSetMovable(ayarlar_ayarpanel, false)
        guiWindowSetSizable(ayarlar_ayarpanel, false)
        buton_kaydet = guiCreateButton(11, 77, 85, 35, "Kaydet", false, ayarlar_ayarpanel)
        buton_iptal = guiCreateButton(252, 77, 85, 35, "İptal", false, ayarlar_ayarpanel)
		if state == "combobox" then
        ayarlar_combobox = guiCreateComboBox(106, 20, 136, 92, "", false, ayarlar_ayarpanel)
		if veri then
		for k, v in pairs(veri) do
        guiComboBoxAddItem(ayarlar_combobox, v)
		end
		guiComboBoxSetSelected(ayarlar_combobox, 0)
		end
		end		
		if state == "edit" then
        ayarlar_edit = guiCreateEdit(13, 46, 324, 26, "", false, ayarlar_ayarpanel)
		if info then
        ayarlar_infotext = guiCreateLabel(14, 19, 323, 18, info, false, ayarlar_ayarpanel)
        guiLabelSetVerticalAlign(ayarlar_infotext, "center")  		
		end
		end
    end
	

	addEventHandler("onClientGUIDoubleClick", root, function()
		if isElement(ayarlarGrid) then
			local option = guiGridListGetItemText ( ayarlarGrid, guiGridListGetSelectedItem ( ayarlarGrid ), 1 )
			if option == ">> Paneli Kapat" then
			destroyElement(profil)
			showCursor(false)
			elseif option == ">> Hesap Serial" then
			if advice == getPlayerSerial(localPlayer) then
			advice = "******************************"
			else
			advice = getPlayerSerial(localPlayer)
			end
			guiGridListSetItemText(ayarlarGrid, 2, 2, advice, false, false)
			elseif option == ">> Şehir Değiştir" then
			ayarPanel("combobox", {"Los Santos", "San Fierro", "Las Venturas"}, nil, {5,2}, "yerDegis")
			elseif option == ">> Mezar Değiştir" then
			ayarPanel("edit", nil, "Kullanılabilir bir Mezar ID girin. Varsayılan için boş.", {6,2}, "olummezar")
			elseif option == ">> Son Söz Değiştir" then
			ayarPanel("edit", nil, "Öldüğünüzde üzerinizde beliren mesaj. Varsayılan için boş.", {7,2}, "olummetin")
			elseif option == ">> Şifre Değiştir" then
			ayarPanel("edit", nil, "Doğrulama için mevcut şifrenizi girin.", {7,2}, "sifredegis", 1)
			elseif option == ">> Topluluk Davetleri"  then
				triggerServerEvent("changeState", localPlayer, "davet", 8, 2)
			elseif option == ">> Özel Mesajlar" then
				triggerServerEvent("changeState", localPlayer, "pm", 9, 2)
			elseif option == ">> İstatistik Gösterimi" then
				triggerServerEvent("changeStateAcc", localPlayer, "istatistik", 10, 2)
			elseif option == ">> Otomatik Giriş" then
				triggerServerEvent("changeStateAcc", localPlayer, "otologin", 11, 2)
			elseif option == ">> Discord Hesabı" then
				if not dc then
				if isDiscordRichPresenceConnected() then
				local id = getDiscordRichPresenceUserID() 
				if id == "" then outputChatBox("[-] #ffffffDiscord programında sunucuda oynadığınız tespit edilemedi.",255,0,0,true) return end
				triggerServerEvent("discordKontrol", localPlayer, id)
				else
				outputChatBox("[-] #ffffffDiscord programında sunucuda oynadığınız tespit edilemedi.",255,0,0,true)
				return end
				else
				ayarPanel("edit", nil, "Discord bağlantısını kesmek için 'Onaylıyorum.' yazın.", {11,2}, "cancelDiscord", dc)
				end
			elseif option == ">> Hasar Alma Sesi" then
				ayarPanel("combobox", {"Varsayılan", "Pinyata", "Bıçak Yarası", "Acı Çekme I", "Acı Çekme II", "Yumruk"}, nil, {13,2}, "hasarSesDegis")
			elseif option == ">> Hasar Verme Sesi" then
				ayarPanel("combobox", {"Varsayılan", "Pinyata", "Bıçak Yarası", "Acı Çekme I", "Acı Çekme II", "Yumruk"}, nil, {14,2}, "hasarVerSesDegis")
			elseif option == ">> Headshot Sesi" then
				ayarPanel("combobox", {"Varsayılan", "Pinyata", "Bıçak Yarası", "Acı Çekme I", "Acı Çekme II", "Yumruk"}, nil, {15,2}, "headshotSesDegis")
			end
		end
	end)
	
	
	function manuelAyar(atype,data,info,place,event,eventdata)
		ayarPanel(atype,data,info,place,event,eventdata)
	end
	addEvent("ayarPanel", true)
	addEventHandler("ayarPanel", root, manuelAyar)
	
	local selected = ""
	
	addEventHandler("onClientGUIClick", root, function()
		if source == buton_iptal then 
			if isElement(ayarlar_ayarpanel) then destroyElement(ayarlar_ayarpanel) end
			guiSetVisible(profil, true)
		elseif source == buton_kaydet then
			if active == "combobox" then
				selected = guiComboBoxGetItemText(ayarlar_combobox, guiComboBoxGetSelected(ayarlar_combobox))
				guiGridListSetItemText(ayarlarGrid, g_yer[1], g_yer[2], selected, false, false)
				if g_event then triggerServerEvent(g_event, localPlayer, selected, g_eventdata) end
			elseif active == "edit" then
				selected = guiGetText(ayarlar_edit) or ""
				if g_event then triggerServerEvent(g_event, localPlayer, selected, g_yer[1], g_yer[2], g_eventdata) end
			end
			if isElement(ayarlar_ayarpanel) then destroyElement(ayarlar_ayarpanel) end
			guiSetVisible(profil, true)
		end
	end)
	
	addEvent("panelGuncelle", true)
	addEventHandler("panelGuncelle", root, function(bir, iki, text, r, g,b)
		if not r and not g and not b then
		if bir and iki then
		guiGridListSetItemText(ayarlarGrid, tonumber(bir), tonumber(iki), text, false, false)
		end
		else
		guiGridListSetItemText(ayarlarGrid, tonumber(bir), tonumber(iki), text, false, false)
		guiGridListSetItemColor(ayarlarGrid, bir, iki, r, g, b, 255)
		end
	end)
	
	addEvent("cancelDC", true)
	addEventHandler("cancelDC", root, function()
		dc = nil
	end)