local pickups = {

[3471] = "Heykel I",
[1313] = "Kurukafalar",
[1608] = "Köpekbalığı",
[3528] = "Aslan Kafası",

}

local sehirler = {

["LS"] = "Los Santos",
["SF"] = "San Fierro", 
["LV"] = "Las Venturas",

["Los Santos"] = "LS",
["San Fierro"] = "SF", 
["Las Venturas"] = "LV",

}


function openProfile(plr, cmd)
	if getElementData(plr, "logged") then
		local acc = getPlayerAccount(plr)
		local data = {}
		local sehir = getAccountData(acc, "city") or "LS"
		local mezar  = getAccountData(acc, "coffin") or 3471
		local sonsoz = getAccountData(acc, "sonsoz") or "San Andreas Hırsız Polis"
		local istatistik = getAccountData(acc, "istatistik") or false
		local otologin = getAccountData(acc, "otologin") or false
		local discord = getAccountData(acc, "discordid") or false 
		local hasarses = getAccountData(acc, "hasarses") or "Varsayılan"
		local hasarverses = getAccountData(acc, "hasarverses") or "Varsayılan"
		local headshotses = getAccountData(acc, "headshotses") or "Varsayılan"
		data = {headshotses = headshotses, hasarverses = hasarverses, hasarses = hasarses, discord = discord, sehir = {yer = sehirler[sehir], konum = sehir}, mezarlik = mezar, sonsoz = sonsoz, istatistik = istatistik, otologin = otologin}
		triggerClientEvent(plr, "profileClient", plr, data)
	end
end
addCommandHandler("profil", openProfile)

	
addEvent("olummetin", true)
addEventHandler("olummetin", root, function(text, yerbir, yeriki)
	if not text or text == "" then 
	setAccountData(getPlayerAccount(source), "sonsoz", "San Andreas Hırsız Polis") 
	outputChatBox("[-] #ffffffBaşarıyla son sözünüz varsayılan olarak ayarlandı.",source,255,0,0,true)
	triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, "Varsayılan")
	else
	if string.len(text) > 10 and string.len(text) < 32 then
	setAccountData(getPlayerAccount(source), "sonsoz", text)
	outputChatBox("[-] #ffffffBaşarıyla mezar taşındaki metniniz değiştirildi.",source,255,0,0,true)
	triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, text)
	else
	outputChatBox("[-] #ffffffMezar taşı metni minimum 10, maksimum 32 harf olmalıdır.",plr,255,0,0,true)
	end
	end
end)

addEvent("yerDegis", true)
addEventHandler("yerDegis", root, function(yer)
	if yer then
		setAccountData(getPlayerAccount(source), "city", sehirler[yer]) 
		outputChatBox("[-] #ffffffBaşarıyla yeni spawn noktanız "..yer.." olarak değiştirildi.",source,255,0,0,true)
	end
end)

addEvent("hasarSesDegis", true)
addEventHandler("hasarSesDegis", root, function(secili, yerbir, yeriki)
	setAccountData(getPlayerAccount(source), "hasarses", secili)
	triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, secili)
end)

addEvent("headshotSesDegis", true)
addEventHandler("hasarSesDegis", root, function(secili, yerbir, yeriki)
	setAccountData(getPlayerAccount(source), "headshotses", secili)
	triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, secili)
end)

addEvent("hasarVerSesDegis", true)
addEventHandler("hasarVerSesDegis", root, function(secili, yerbir, yeriki)
	setAccountData(getPlayerAccount(source), "hasarverses", secili)
	triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, secili)
end)



addEvent("olummezar", true)
addEventHandler("olummezar", root, function(id, yerbir, yeriki)
	if id == "" then 
	setAccountData(getPlayerAccount(source), "coffin", 3471) 
	outputChatBox("[-] #ffffffBaşarıyla mezar taşınız varsayılan olarak değiştirildi.",source,255,0,0,true)
	triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, pickups[3471])
	return end
	if not tonumber(id) then outputChatBox("[-] #ffffffGeçerli bir ID girin.",plr,255,0,0,true) 
	for k, v in pairs(pickups) do
	outputChatBox("[-] #ffffff"..k..": "..v,source,255,0,0,true)
	end
	else
	if pickups[tonumber(id)] ~= nil then 
	setAccountData(getPlayerAccount(source), "coffin", id) 
	outputChatBox("[-] #ffffffBaşarıyla mezar taşınız değiştirildi.",source,255,0,0,true)
	triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, pickups[tonumber(id)])
	end
	end
end)

local newPassword = {}

function sifreDegistir(pass, _, _, asama)
	local acc = getPlayerAccount(source)
	if pass and tonumber(asama) == 1 then
		local accCheck = getAccount(getAccountName(acc), pass)
		if not accCheck then outputChatBox("[-] #ffffffGirdiğiniz şifre hesabınızın mevcut şifresiyle eşleşmedi.",source,255,0,0,true) return end
		triggerClientEvent(source, "ayarPanel", source, "edit", nil, "Hesabınızın yeni şifresini girin.", {6,2}, "sifredegis", 2)
	elseif pass and tonumber(asama) == 2 then
		if (string.len(pass)>=5) and (string.len(pass)<32) then
		newPassword[source] = pass
		triggerClientEvent(source, "ayarPanel", source, "edit", nil, "Hesabınızın yeni şifresini tekrar girin. (Doğrulama)", {6,2}, "sifredegis", 3)
		else
		outputChatBox("[-] #ffffffŞifreniz minimum 5, maksimum 32 haneli olmak zorundadır.",source,255,0,0,true)
		return end
	elseif pass and tonumber(asama) == 3 then
		if newPassword[source] ~= nil then
		if pass ~= newPassword[source] then outputChatBox("[-] #ffffffŞifre tekrar doğrulaması başarısız, tekrar deneyin.",source,255,0,0,true) newPassword[source] = nil return end
		newPassword[source] = nil
		setAccountPassword(acc,pass)
		outputChatBox("[-] #ffffffHesap şifreniz başarıyla değiştirildi, bu kısmı ekran görüntüsü almanız tavsiye edilir.",source,255,0,0,true)
		outputChatBox("#ffae00[Hesap Adı: "..getAccountName(acc).."] - [Şifre: "..pass.."]",source,255,0,0,true)
		setAccountData(getPlayerAccount(source), "password", encodeString("base64", pass, {key = getPlayerName(source)}))
		if getAccountData(getPlayerAccount(source), "otologin") then
			updateXMLValue(getAccountName(acc)..":"..getPlayerSerial(source), encodeString("base64", pass, {key = getPlayerName(source)}))
		end
		else
		outputChatBox("[-] #ffffffŞifre doğrulamada bir hata oluştu, daha sonra tekrar deneyin.",source,255,0,0,true)
		return end
	end
end
addEvent("sifredegis", true)
addEventHandler("sifredegis", root, sifreDegistir)

function changeSituation(state, yerbir, yeriki)
	if state then
		local currently = getElementData(source, state) or false
		if currently then
		setElementData(source, state, false)
		triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, "AÇIK", 0, 255, 0)
		else
		setElementData(source, state, true)
		triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, "KAPALI", 255, 0, 0)
		end
	end
end
addEvent("changeState", true)
addEventHandler("changeState", root, changeSituation)

function changeSituationAcc(state, yerbir, yeriki)
	if state then
		local acc = getPlayerAccount(source)
		local currently = getAccountData(acc, state) or false
		if currently then
		local text = "AÇIK"
		local r, g, b = 0, 255, 0
		setAccountData(acc, state, false)
		if state == "otologin" then text = "KAPALI" r, g, b = 255, 0, 0 autamaticLogin(false, getPlayerName(source), getPlayerSerial(source)) end
		triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, text, r, g, b)
		else
		local text = "KAPALI"
		local r, g, b = 252, 0, 0
		local option = true
		if state == "otologin" then text = "AÇIK" r, g, b = 0, 255, 0 local option = getPlayerSerial(source) autamaticLogin(true, getPlayerName(source), getPlayerSerial(source)) end
		setAccountData(acc, state, option)
		triggerClientEvent(source, "panelGuncelle", source, yerbir, yeriki, text, r, g, b)
		end
	end
end
addEvent("changeStateAcc", true)
addEventHandler("changeStateAcc", root, changeSituationAcc)

local kod = {}

function discordCheck(userid)
	if userid then
		if kod[source] ~= nil then outputChatBox("[-] #ffffffYakın zamanda kod almışsınız, lütfen discord-dogrulama kanalını kontrol edin.",source,255,0,0,true) return end
		local check = checkUserExists(userid)
		if not check then
		local code = generateString(10)
		kod[source] = code
		triggerEvent("sendDiscordMessage", source, "discordcheck", "<@"..userid..">, doğrulama kodunuz: ```"..code.."```")
		triggerClientEvent(source, "ayarPanel", source, "edit", nil, "discord-kod kısmındaki doğrulama kodunu girin.", {11,2}, "checkcode", userid)
		setTimer(function(source)
		kod[source] = nil
		end, 60000, 1, source)		
		else
		local acc = getPlayerAccount(source)
		if not getAccountData(acc, "discordid") then
		outputChatBox("[-] #ffffffBir başka hesapta discord hesabınız kayıtlı.",source,255,0,0,true)
		end
		return end
	end
end
addEvent("discordKontrol", true)
addEventHandler("discordKontrol", root, discordCheck)

function discordCodeCheck(realcode, yerbir, yeriki, userid)
	if userid then
		if kod[source] ~= nil then
			if kod[source] == realcode then
				local acc = getPlayerAccount(source)
				setAccountData(acc, "discordid", userid)
				discordXML(userid)
			end
		end
	end
end
addEvent("checkcode", true)
addEventHandler("checkcode", root, discordCodeCheck)


function discordXML(userid)
    local xmlFile = xmlLoadFile("discord.xml")
    if not xmlFile then
        xmlFile = xmlCreateFile("discord.xml", "users")
    end

    local exists = checkUserExists(userid)
    if not exists then
        local newUserNode = xmlCreateChild(xmlFile, "user")
        xmlNodeSetAttribute(newUserNode, "id", userid)
		xmlNodeSetAttribute(newUserNode, "account", getPlayerName(source))
		xmlNodeSetValue(newUserNode, 0)
        xmlSaveFile(xmlFile)
        xmlUnloadFile(xmlFile)
		outputChatBox("[-] #ffffffDiscord hesabınız başarıyla oyun sunucusuyla eşleştirildi.", source, 255, 0, 0, true)
		local allAcc = ""
		local accs = getAccountsBySerial(getPlayerSerial(source))
		for k, v in pairs(accs) do
		allAcc = allAcc..", "..getAccountName(v)
		end
		local pllog = "```Kullanıcı Adı: "..getPlayerName(source).."\nSerial: "..getPlayerSerial(source).."\nIP Adresi: "..getPlayerIP(source).."\nDiğer hesaplar: "..allAcc.."```"
		triggerEvent("sendDiscordMessage", source, "checklog", "```"..getPlayerName(source).." adlı oyuncu discord hesabını iliştirdi.\nDiscord Kullanıcı ID: "..userid.." /``` <@"..userid..">".."\n\n||"..pllog.."||")
		triggerClientEvent(source, "panelGuncelle", source, 12, 2, "Bağlanıldı", 0, 255, 0)
        return true
    else
        outputChatBox("[-] #ffffffBu discord hesabı zaten oyun hesabıyla eşleştirilmiş.", source, 255, 0, 0, true)
        xmlUnloadFile(xmlFile)
        return false
    end
end

function cancelDiscord(input, yerbir, yeriki, userid)
	if (userid) then
		if input == "Onaylıyorum." then
		deleteUserFromXML(userid)
		setAccountData(getPlayerAccount(source), "discordid", nil)
		triggerClientEvent(source, "panelGuncelle", source, 12, 2, "Bağlı Değil", 255, 0, 0)
		triggerClientEvent(source, "cancelDC", source)
		local allAcc = ""
		local accs = getAccountsBySerial(getPlayerSerial(source))
		for k, v in pairs(accs) do
		allAcc = allAcc..", "..getAccountName(v)
		end
		local pllog = "```Kullanıcı Adı: "..getPlayerName(source).."\nSerial: "..getPlayerSerial(source).."\nIP Adresi: "..getPlayerIP(source).."\nDiğer hesaplar: "..allAcc.."```"
		triggerEvent("sendDiscordMessage", source, "checklog", "```"..getPlayerName(source).." adlı oyuncu discord hesabının bağlantısını kaldırdı.\nDiscord Kullanıcı ID: "..userid.." /``` <@"..userid..">".."\n\n||"..pllog.."||")
		end
	end
end
addEvent("cancelDiscord", true)
addEventHandler("cancelDiscord", root, cancelDiscord)

function checkUserExists(userid)
    local xmlFile = xmlLoadFile("discord.xml")
    if not xmlFile then
        xmlFile = xmlCreateFile("discord.xml", "users")
    end
    
    local userNode = xmlFindChild(xmlFile, "user", 0)
    while userNode do
        local id = xmlNodeGetAttribute(userNode, "id")
        if id == userid then
            xmlUnloadFile(xmlFile)
            return true
        end
        userNode = xmlFindChild(xmlFile, "user", userNode + 1)
    end
    
    xmlUnloadFile(xmlFile)
    return false
end

function autamaticLogin(st, acc, serial)
    local xmlFile = xmlLoadFile("logins.xml")
    if not xmlFile then 
        xmlFile = xmlCreateFile("logins.xml", "root")
    end
    
    if st then
        local node = xmlCreateChild(xmlFile, "entry")
        xmlNodeSetAttribute(node, "key", acc..":"..serial)
        xmlNodeSetValue(node, tostring(getAccountData(getPlayerAccount(source), "password")))
    else
        local keyToRemove = acc..":"..serial
        local entries = xmlNodeGetChildren(xmlFile)
        for _, node in ipairs(entries) do
            local key = xmlNodeGetAttribute(node, "key")
            if key == keyToRemove then
                xmlDestroyNode(node)
                break
            end
        end
    end

    xmlSaveFile(xmlFile)
    xmlUnloadFile(xmlFile)
end


local allowed = { { 97, 122 } } 

function generateString(len)
    if tonumber(len) then
        math.randomseed(getTickCount())

        local str = ""
        for i = 1, len do
            local charlist = allowed[1]
            str = str .. string.char(math.random(charlist[1], charlist[2]))
        end

        return str
    end
    
    return false
end

function deleteUserFromXML(userid)
    local xmlFile = xmlLoadFile("discord.xml")
    if not xmlFile then
        return false, "discord.xml dosyası yüklenemedi."
    end
    
    local userNode = xmlFindChild(xmlFile, "user", 0)
    while userNode do
        local id = xmlNodeGetAttribute(userNode, "id")
        if id == userid then
            xmlDestroyNode(userNode)
            xmlSaveFile(xmlFile)
            xmlUnloadFile(xmlFile)
            return true
        end
        userNode = xmlFindChild(xmlFile, "user", userNode + 1)
    end
    
    xmlUnloadFile(xmlFile)
    return false, "Kullanıcı bulunamadı."
end

addEvent("kickPlayerServer", true)
addEventHandler("kickPlayerServer", root, function(reason)
	if reason then
		kickPlayer(source, reason)
	end
end)

