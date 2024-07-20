function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if not acc or isGuestAccount(acc) then
        return false
    end
    return getAccountPlayer(acc)
end

function loadItemsDB()
		for k, tablo in pairs(itemler) do
		for k, tablos in pairs(silahlar) do
		local acc = getPlayerAccount(source)
		if getAccountData(acc, ""..tablo.itemid.."") then
		local value = getAccountData(acc, ""..tablo.itemid.."")
		setElementData(source, ""..tablo.itemid.."", value)
		if getAccountData(acc, "silah:"..tablos.silahid.."") then
		local mermi = getAccountData(acc, "silah:"..tablos.silahid.."")
		setElementData(source, "silah:"..tablos.silahid.."", mermi)
		end
		end
		end
		end
	end
addEventHandler("onPlayerLogin", root, loadItemsDB)

function silahlarYukle()
	for k, player in ipairs(getElementsByType("player")) do
	for k, tablos in pairs(silahlar) do
	local acc = getPlayerAccount(player)
	if getAccountData(acc, "silah:"..tablos.silahid.."") then
	local mermi = getAccountData(acc, "silah:"..tablos.silahid.."")
	if getElementData(player, "silahaktif:"..tablos.silahid.."")==true then
	giveWeapon(player, tablos.silahid)
	setWeaponAmmo(player, tablos.silahid, mermi)
	end
	end
end
end
end
addEventHandler("onResourceStart", root, silahlarYukle)




addCommandHandler("openTheFuckingInventory", function(source, cmd)
	local acc = getPlayerAccount(source)
	local klan = getAccountData(acc, "klan") or "Sivil/Yok"
	local rutbe = getAccountData(acc, "rutbe") or " "
	setElementData(source, "klan", klan)
	setElementData(source, "rutbe", rutbe)
	setElementData(source, "envpanel:acik", true)
	triggerClientEvent(source, "envanter", source)
end)

function giveGun(plr,cmd,target,id,ammo)
   local hesapismi = getAccountName(getPlayerAccount(plr)) 
    if  isObjectInACLGroup("user." ..hesapismi, aclGetGroup("Console")) then
	if not target or not id or not ammo then
		outputChatBox("[!] #ffffff/"..cmd.." [Oyuncu] [Silah ID] [Mermi Miktarı]",plr,255,0,0,true)
	else
	if tonumber(ammo) then
		local targets = exports.globals:findPlayerByPartialNick(target)
		local targetsacc = getPlayerAccount(targets)
		local wepname = getPedWeapon(targets)
		local wepmodel = getWeaponNameFromID(id)
		outputChatBox("[!] #ffffff["..getPlayerName(targets).." adlı oyuncuya] "..wepmodel.." adlı silahı "..ammo.." mermi miktarıyla verdiniz.",plr,255,0,0,true)
		setElementData(targets, "silah:"..id.."", ammo)
		setAccountData(targetsacc, "silah:"..id.."", ammo)
		setElementData(targets, "silahaktif:"..id.."", false)
		end
	end
	end
end
addCommandHandler("makegun", giveGun)

function takeGun(plr,cmd,target,id)
   local hesapismi = getAccountName(getPlayerAccount(plr)) 
    if  isObjectInACLGroup("user." ..hesapismi, aclGetGroup("Console")) then
	if not target or not id then
		outputChatBox("[!] #ffffff/"..cmd.." [Oyuncu] [Silah ID]",plr,255,0,0,true)
	else
	local targets = exports.globals:findPlayerByPartialNick(target)
	local have = getPedWeapon(targets)
	if tonumber(id) then
		local targets = exports.globals:findPlayerByPartialNick(target)
		local wepname = getPedWeapon(targets)
		local targetsacc = getPlayerAccount(targets)
		local wepmodel = getWeaponNameFromID(id)
		local cws = takeWeapon(plr, id)
		outputChatBox("[!] #ffffff["..getPlayerName(targets).." adlı oyuncunun] "..wepmodel.." adlı silahını başarıyla sildiniz.",plr,255,0,0,true)
		setTimer(function(plr)
		setElementData(targets, "silah:"..id.."", ammo)
		setAccountData(targetsacc, "silah:"..id.."", ammo)
		end, 500, 1, targets)
		end
		end
	end
end
addCommandHandler("takegun", takeGun)



addCommandHandler("itemver", function(plr,cmd,target,itemid,value)
	local accountname = getAccountName(getPlayerAccount(plr))
	if not isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Console" ) ) then outputChatBox("[!] #ffffffYetkiniz yok.",plr,255,0,0,true) return end
	if not target or not itemid or not value then outputChatBox("[!] #ffffff/itemver [Oyuncu] [Item ID] [Miktar]",plr,255,0,0,true) return end
	for k, tablo in pairs(itemler) do
	if (itemid==""..tablo.itemid.."") then 
		local targetn = exports.globals:findPlayerByPartialNick(target)
		local ownerplr = getPlayerAccount(targetn)
		outputChatBox("[!] #ffffffBaşarıyla "..tablo.itemname.." adlı ürünü "..value.." miktarıyla "..getPlayerName(targetn).."'e/a verdiniz.",plr,255,0,0,true) 
		if getElementData(targetn, ""..tablo.itemid.."") then
			local item_mevcut = getElementData(targetn, ""..tablo.itemid.."")
			setAccountData(ownerplr, ""..tablo.itemid.."", item_mevcut+value)
			setElementData(targetn, ""..tablo.itemid.."", item_mevcut+value)
		else
		setAccountData(ownerplr, ""..tablo.itemid.."", value)
		setElementData(targetn, ""..tablo.itemid.."", value)		
		end
	end
	end
end)

function checkItem(target, itemid)
	if getElementType(target) == "player" and tonumber(itemid) then
		for k, tablo in pairs(itemler) do
			if (itemid==tonumber(tablo.itemid)) then
				local ownerplr = getPlayerAccount(target)
				if getElementData(target, ""..tablo.itemid.."") then
					local item_mevcut = getElementData(target, ""..tablo.itemid.."")
					return tonumber(item_mevcut)
				else	
				return false
				end
			end
		end
	end	
end	

function takeItem(target, itemid, amount)
	if getElementType(target) == "player" and tonumber(itemid) and tonumber(amount) then
		for k, tablo in pairs(itemler) do
			if (itemid==tonumber(tablo.itemid)) then
				local ownerplr = getPlayerAccount(target)
				if getElementData(target, ""..tablo.itemid.."") then
					local item_mevcut = getElementData(target, ""..tablo.itemid.."")
					if tonumber(item_mevcut) >= amount then
					setAccountData(ownerplr, ""..itemid.."", item_mevcut-amount)
					setElementData(target, ""..tablo.itemid.."", item_mevcut-amount)
					local yeni = getElementData(target, ""..tablo.itemid.."")
					if tonumber(yeni) == 0 then
					setAccountData(ownerplr, ""..itemid.."", false)
					setElementData(target, ""..tablo.itemid.."", false)
					end
					else
					return false
					end
				else	
				return false
				end
			end
		end
	end	
end	

function giveItem(target, itemid, amount)
    if getElementType(target) == "player" and tonumber(itemid) and tonumber(amount) then
        for k, tablo in pairs(itemler) do
            if tonumber(itemid) == tonumber(tablo.itemid) then
                local ownerplr = getPlayerAccount(target)
                local item_mevcut = getElementData(target, tostring(tablo.itemid)) or false

                if not item_mevcut then
                    setAccountData(ownerplr, tostring(itemid), amount)
                    setElementData(target, tostring(tablo.itemid), amount)
                    return true
                else
                    if tonumber(item_mevcut) > 0 then
                        setAccountData(ownerplr, tostring(itemid), item_mevcut + amount)
                        setElementData(target, tostring(tablo.itemid), item_mevcut + amount)
                        return true
                    else
                        return false
                    end
                end
            end
        end
        return false
    else
        return false
    end
end




addCommandHandler("itemsil", function(plr,cmd,target,itemid)
	local accountname = getAccountName(getPlayerAccount(plr))
	if not isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Console" ) ) then outputChatBox("[!] #ffffffYetkiniz yok.",plr,255,0,0,true) return end
	if not target or not itemid then outputChatBox("[!] #ffffff/itemsil [Oyuncu] [Item ID]",plr,255,0,0,true) return end
	local targetn = exports.globals:findPlayerByPartialNick(target)
	for k, tablo in pairs(itemler) do
	if (itemid==""..tablo.itemid.."") then 
		local ownerplr = getPlayerAccount(targetn)
		local owner = getAccountName(ownerplr)
		if getElementData(targetn, ""..itemid.."") then
		local acc = getPlayerAccount(targetn)
		local islem = setAccountData(acc, ""..itemid.."", false)
		setElementData(targetn, ""..tablo.itemid.."", false)
		if islem then 
		outputChatBox("[!] #ffffffBaşarıyla "..tablo.itemname.." adlı ürünü "..getPlayerName(targetn).."'den/dan sildiniz.",plr,255,0,0,true) 
		end
		end
	end
	end
end)

function showItemList(plr,cmd)
	local accountname = getAccountName(getPlayerAccount(plr))
	if not isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Console" ) ) then outputChatBox("[!] #ffffffYetkiniz yok.",plr,255,0,0,true) return end
	triggerClientEvent(plr, "showAdminItemList", plr)
end
addCommandHandler("itemlist", showItemList)

addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),
function ()
for index, player in pairs(getElementsByType("player")) do
bindKey(player,"J","down","openTheFuckingInventory")
  end
end)

addEventHandler("onPlayerJoin",getRootElement(),
function ()
bindKey(source,"J","down","openTheFuckingInventory")
end)

function envanterParaTransfer(oyuncu_adi, miktar)
	local miktartl = tonumber(miktar)
	local para = getPlayerMoney(source)
	local target = getPlayerFromName(oyuncu_adi)
	local targetpara = getPlayerMoney(target)
	if not miktartl then outputChatBox("[!] #ffffffMiktar Girin adlı kutucuğa vereceğiniz miktarı girin.",source,255,0,0,true) return end
	if oyuncu_adi=="" then outputChatBox("[!] #ffffffPara vermek istediğiniz oyuncuyu seçin.",source,255,0,0,true) return end
	if not (getPlayerMoney(source)>=miktartl) then outputChatBox("[!] #ffffffYeterli miktarda paranız bulunmamakta.",source,255,0,0,true) return end
	if (target==source) then outputChatBox("[!] #ffffffKendi kendinize para iletemezsiniz. Bug tespit edildi, yöneticiye bildiriliyor.",source,255,0,0,true) return end
	takePlayerMoney(source, miktartl)
	setPlayerMoney(target, targetpara+miktartl)
	outputChatBox("[!] #ffffffBaşarıyla "..oyuncu_adi.." isimli oyuncuya "..miktar.."TL para verdiniz.",source,0,255,0,true)
	outputChatBox("[!] #ffffff"..getPlayerName(source).." adlı kişi size "..miktar.."TL para verdi.",target,0,255,0,true)
end
addEvent("envanter:para:ver", true)
addEventHandler("envanter:para:ver", root, envanterParaTransfer)

function envanterKimlikGoster(oyuncu_adi)
	local target = getPlayerFromName(oyuncu_adi)
	local acc = getPlayerAccount(source)
	local cinsiyet = getAccountData(acc, "cinsiyet") or "Diğer"
	local klan = getAccountData(acc, "klan") or "Yok"
	local rutbe = getAccountData(acc, "rutbe") or "Bulunmuyor"
	local isim = getPlayerName(source)
	if oyuncu_adi=="" then outputChatBox("[!] #ffffffKimlik göstermek istediğiniz oyuncuyu seçin.",source,255,0,0,true) return end
	outputChatBox("[!] #ffffff"..getPlayerName(target).." isimli oyuncuya kimliğinizi gösterdiniz.",source,255,0,0,true)
	outputChatBox("#CC6600[ #ffffffTürkiye Cumhuriyeti Kimlik Kartı #CC6600]",target,255,0,0,true)
	outputChatBox("#CC6600[ #ffffffCinsiyet: "..cinsiyet.." - İsim: "..isim.."]",target,255,0,0,true)
	outputChatBox("#CC6600[ #ffffffBulunduğu Hizmet: "..klan.." - Hizmet Kıdemi: "..rutbe.." #CC6600]",target,255,0,0,true)
	outputChatBox("#CC6600[ #ffffffVatandaşlık Numarası: "..getPlayerSerial(source).." #CC6600]",target,255,0,0,true)
end
addEvent("envanter:kimlik:ver", true)
addEventHandler("envanter:kimlik:ver", root, envanterKimlikGoster)


cases = {}

for i,v in ipairs(getElementsByType("player"))do
setElementData(v, "bcase", 0)
end

foods = {}

function eatFood(itemtype)
	if itemtype == "Yemek" then
	for index, tablo in pairs(yemekler) do
	for index, tablos in pairs(itemler) do
	if(getElementData(source, "yemek:"..tablo.itemid.."") ~= 1)then
        setElementData(source, "yemek:"..tablo.itemid.."", 1)
		outputChatBox("[!] #ffffff"..tablos.itemname.." isimli yemeği yiyorsunuz.",source,0,255,0,true)
		setPedAnimation(source, "FOOD", "EAT_Pizza", false, false, false, false)
		setTimer(function(source)
		setPedAnimation(source)
		setElementData(source, "yemek:"..tablo.itemid.."", false)
		outputChatBox("[!] #ffffff"..tablos.itemname.." isimli yemeği yediniz ve sağlığınız yükseldi.",source,255,0,0,true)
		local sourceacc = getPlayerAccount(source)
		local yemek_miktar = getAccountData(sourceacc, ""..tablo.itemid.."")
		local yemek_miktar_data = getElementData(source, ""..tablo.itemid.."")
		
		setElementData(source, "envpanel:acik", false)
		if tonumber(yemek_miktar)>1 then
		setElementHealth(source, getElementHealth(source)+30)
		setAccountData(sourceacc, ""..tablo.itemid.."", yemek_miktar-1)
		setElementData(source, ""..tablo.itemid.."", yemek_miktar_data-1)
		else
		setElementHealth(source, getElementHealth(source)+30)
		setAccountData(sourceacc, ""..tablo.itemid.."", false)
		setElementData(source, ""..tablo.itemid.."", false)
		end
		end, 3000, 1, source)
		end
		end
		end
	end
end
addEvent("eat", true)
addEventHandler("eat", root, eatFood)

function bombIn(itemtype, isim)
	takeWeapon(source, 16)
	if isim == "Yanıcı Bomba" then
		setElementData(source, "bomb", "flame")
		outputChatBox("[!] #ffffffElinizde yanıcı bomba aldınız.",source,255,0,0,true)
		exports.envanter:takeItem(source, 10, 1)
		giveWeapon(source, 16, 1)
	elseif isim == "Flaş Bombası" then
		setElementData(source, "bomb", "flashbang")
		outputChatBox("[!] #ffffffElinizde flaş bombası aldınız.",source,255,0,0,true)
		exports.envanter:takeItem(source, 9, 1)
		giveWeapon(source, 16, 1)
	elseif isim == "Mayın" then
		triggerEvent("mayinSERVER", source)
	else
		setElementData(source, "bomb", false)
	end
end
addEvent("bomb", true)
addEventHandler("bomb", root, bombIn)

function esyaVerServer(itemname, oyuncu, adet)
	if itemname ~= "" and oyuncu ~= "" and tonumber(adet) then
		local target = exports.globals:findPlayerByPartialNick(oyuncu)
		if not target then outputChatBox("[-] #ffffffBelirttiğiniz oyuncu bulunamadı.",source,255,0,0,true) return end
		local itemid = getItemIDFromName(itemname)
		local oyuncu_item_miktar = checkItem(source, itemid)
		if tonumber(oyuncu_item_miktar) < tonumber(adet) then outputChatBox("[-] #ffffffBelirttiğiniz miktarda eşyaya sahip değilsiniz.",source,255,0,0,true) return end
		if target == source then outputChatBox("[-] #ffffffKendinize eşyayı geri veremezsiniz.",source,255,0,0,true) return end
		local x, y, z = getElementPosition(source)
		local tx, ty, tz = getElementPosition(target)
		local mesafe = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
		if tonumber(mesafe) > 5 then outputChatBox("[-] #ffffffBelirtilen oyuncu size 5 metreden yakın olmalı.",source,255,0,0,true) return end
		outputChatBox("[-] #ffffff"..getPlayerName(target).." adlı oyuncuya eşya verme talebini gönderdiniz.",source,0,255,0,true)
		local esyaTablo = {item = itemid, itemadet = adet, gonderen = source}
		setElementData(target, "itemIstek", esyaTablo)
		outputChatBox("[-] #ffffff"..getPlayerName(source).." kişisi size "..itemname.." ürününden "..adet.." adet vermek istiyor.",target,255,0,0,true)
		outputChatBox("[-] #ffffffEğer eşyayı envanterinize almak istiyorsanız /esyakabul komutunu kullanın.",target,255,0,0,true)
		setElementData(source, "esyaTalep", getPlayerName(target))
	else
	outputChatBox("[-] #ffffffEşya vermek için alanları doğru doldurun.",source,255,0,0,true)
	return end
end	
addEvent("esyaVer", true)
addEventHandler("esyaVer", root, esyaVerServer)

addCommandHandler("esyakabul", function(plr, cmd)
	local esya = getElementData(plr, "itemIstek") or false
	if esya then
		local sahip = esya["gonderen"]
		local itemid = esya["item"]
		local itemadet = esya["itemadet"]
		local x, y, z = getElementPosition(plr)
		local tx, ty, tz = getElementPosition(sahip)
		local mesafe = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
		if tonumber(mesafe) > 5 then outputChatBox("[-] #ffffffOyuncuya 5 metreden yakın olmalısınız.",plr,255,0,0,true) return end
		takeItem(sahip, tonumber(itemid), tonumber(itemadet))
		print(giveItem(plr, tonumber(itemid), tonumber(itemadet)))
		outputChatBox("[-] #ffffffBaşarıyla verilen eşyayı aldınız, envanterinize eklendi.",plr,255,0,0,true)
		outputChatBox("[-] #ffffffOyuncu isteğinizi kabul etti, eşyayı verdiniz.",sahip,255,0,0,true)
		setElementData(plr, "itemIstek", false)
		setElementData(sahip, "esyaTalep", false)
	else
		outputChatBox("[-] #ffffffHerhangi eşya size verilmek üzere istek gönderilmemiş.",plr,255,0,0,true)
	return end
end)

function ckDeleteItems()
	for k, tablo in pairs(itemler) do 
	local acc = getPlayerAccount(source)
	setAccountData(acc, ""..tablo.itemid.."", false)
	end
end
addEvent("sifirla:item", true)
addEventHandler("sifirla:item", root, ckDeleteItems)

function getItemIDFromName(name)
	if name then
		for k, v in pairs(itemler) do
			if v.itemname == name then
				return tonumber(v.itemid)
			end
		end
	end
end

worldItems = {}

function itemDropFunction(item, amount, state)
	if item then
		local itemID = getItemIDFromName(item)
		local mevcut = checkItem(source, tonumber(itemID))
		local x, y, z = getElementPosition(source)
		local int, dim = getElementInterior(source), getElementDimension(source)
		if state then
			if tonumber(amount) then
				if tonumber(mevcut) < tonumber(amount) then outputChatBox("[-] #ffffffBelirttiğiniz miktarda eşyaya sahip değilsiniz.",source,255,0,0,true) return end
				local loot = createObject(1575, x, y, z-(0.9+0.01))
				local loot_serial = #worldItems + 1
				worldItems[loot_serial] = {serial = loot_serial, by = getPlayerName(source), item = itemID, count = amount, itemname = item, element = loot}
				setElementData(loot, "content", worldItems[loot_serial])
				setElementInterior(loot, int)
				setElementDimension(loot, dim)
				setElementData(loot, "serial", loot_serial)
				outputChatBox("[-] #ffffff"..item.." ürününden "..amount.." adet yere bıraktınız.",source,255,0,0,true)
				takeItem(source, tonumber(itemID), tonumber(amount))
			else
				outputChatBox("[-] #ffffffGeçerli bir miktar değeri girmelisiniz.",source,255,0,0,true)
			return end
		else
			local loot = createObject(1575, x, y, z-(0.9+0.01))
			local loot_serial = #worldItems + 1
			worldItems[loot_serial] = {serial = loot_serial, by = getPlayerName(source), item = itemID, count = mevcut, itemname = item, element = loot}
			setElementData(loot, "content", worldItems[loot_serial])
			setElementInterior(loot, int)
			setElementDimension(loot, dim)
			setElementData(loot, "serial", loot_serial)
			outputChatBox("[-] #ffffff"..item.." ürününün tamamını yere bıraktınız.",source,255,0,0,true)
			takeItem(source, tonumber(itemID), tonumber(mevcut))
		end
	end
end
addEvent("itemDrop", true)
addEventHandler("itemDrop", root, itemDropFunction)

--DÜZENLENMELİ
--[[function briefcase( itemtype, itemname)
	if itemtype == "Aksesuar" then
	for index, tablo in pairs(aksesuarlar) do
	if(getElementData(source, "aks:"..tablo.itemid.."") ~= 1) and getElementData(source, ""..tablos.itemid.."") then
        setElementData(source, "aks:"..tablo.itemid.."", 1)
		outputChatBox("[!] #ffffff"..itemname.." isimli aksesuarı kullandınız.",source,0,255,0,true)
		end
		for index, tablos in pairs(aksesuarlar) do
          case = createObject(""..tablos.objeid.."",0,0,0)
           exports.bone_attach:attachElementToBone(case,source,tablo.arg1,tablo.arg2,tablo.arg3,tablo.arg4,tablo.arg5,tablo.arg6,tablo.arg7)
			cases[source] = case
          elseif(getElementData(source, "aks:"..tablo.itemid.."") == 1)then
          setElementData(source, "aks:"..tablo.itemid.."", 0)
		outputChatBox("[!] #ffffff"..itemname.." isimli aksesuarı çıkarttınız.",source,255,0,0,true)
        exports.bone_attach:detachElementFromBone(cases[source])
		destroyElement(cases[source])
		break
		end
		end
	end
end
addEvent("bcase", true)
addEventHandler("bcase", root, briefcase)
]]--

function takeGunInventory(silah, mermi)
	local silah_db = getWeaponIDFromName(silah)
	local mermimiktar = tonumber(mermi)
	local pedSlot = getPedWeaponSlot ( source )
	local pedGun = getPedWeapon(source)
	local pedAmmo = getPedTotalAmmo(source)
	if getElementData(source, "silah:"..silah_db.."") then
	if getElementData(source, "silahaktif:"..silah_db.."")==false then 
	local mermi_s = tonumber(mermi)
	if (mermi_s==0) then outputChatBox("[!] #ffffff"..silah.." isimli silahınızın mermisi yok.",source,255,0,0,true) return end
	if silah_db == 1 or silah_db == 2 or silah_db == 3 or silah_db == 4 or silah_db == 5 or silah_db == 6 or silah_db == 7 or silah_db == 8 or silah_db == 9 then
	if getElementData(source, "silahaktif:1")==true or getElementData(source, "silahaktif:2")==true or getElementData(source, "silahaktif:3")==true or getElementData(source, "silahaktif:4")==true or getElementData(source, "silahaktif:5")==true or getElementData(source, "silahaktif:6")==true or getElementData(source, "silahaktif:7")==true or getElementData(source, "silahaktif:8")==true or getElementData(source, "silahaktif:9")==true then
	outputChatBox("[!] #ffffffYakın dövüş bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end -- ÜST KISIM YAKIN DÖVÜŞ İÇİN
	elseif silah_db == 23 or silah_db == 22 or silah_db == 24 then -- TABANCALAR KARIŞTIRMAMA
	if getElementData(source, "silahaktif:22")==true or getElementData(source, "silahaktif:23")==true or getElementData(source, "silahaktif:24")==true then
	outputChatBox("[!] #ffffffTabanca model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	elseif silah_db == 25 or silah_db == 26 or silah_db == 27 then -- POMPALI TÜFEKLER KARIŞTIRMAMA
	if getElementData(source, "silahaktif:25")==true or getElementData(source, "silahaktif:26")==true or getElementData(source, "silahaktif:27")==true then
	outputChatBox("[!] #ffffffTüfek model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	elseif silah_db == 30 or silah_db == 31 then -- TAARUZ TÜFEKLERİ KARIŞTIRMAMA
	if getElementData(source, "silahaktif:30")==true or getElementData(source, "silahaktif:31")==true then
	outputChatBox("[!] #ffffffTaaruz Tüfeği model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	elseif silah_db == 28 or silah_db == 29 or silah_db == 32 then -- HAFİF MAKİNELİ KARIŞTIRMAMA
	if getElementData(source, "silahaktif:28")==true or getElementData(source, "silahaktif:29")==true or getElementData(source, "silahaktif:32")==true then
	outputChatBox("[!] #ffffffHafif Makineli model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	elseif silah_db == 33 or silah_db == 34 then -- UZUN NAMLU TÜFEKLER KARIŞTIRMAMA (SNIPER; RIFLE)
	if getElementData(source, "silahaktif:33")==true or getElementData(source, "silahaktif:34")==true then
	outputChatBox("[!] #ffffffUzun Namlu Tüfek model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	elseif silah_db == 35 or silah_db == 36 or silah_db == 37 or silah_db == 38 then -- AĞIR SİLAHLAR KARIŞTIRMAMA
	if getElementData(source, "silahaktif:35")==true or getElementData(source, "silahaktif:36")==true or getElementData(source, "silahaktif:37")==true or getElementData(source, "silahaktif:38")==true then
	outputChatBox("[!] #ffffffAğır Makineli model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	elseif silah_db == 16 or silah_db == 17 or silah_db == 18 or silah_db == 39 then -- BOMBALAR KARIŞTIRMAMA
	if getElementData(source, "silahaktif:16")==true or getElementData(source, "silahaktif:17")==true or getElementData(source, "silahaktif:18")==true or getElementData(source, "silahaktif:39")==true then
	outputChatBox("[!] #ffffffBomba model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	elseif silah_db == 44 or silah_db == 45 or silah_db == 46 then -- ÖZEL ALETLER KARIŞTIRMAMA
	if getElementData(source, "silahaktif:44")==true or getElementData(source, "silahaktif:45")==true or getElementData(source, "silahaktif:46")==true then
	outputChatBox("[!] #ffffffOpsiyonel Teçhizat model bir diğer silahınız zaten aktif, öncelikle onu saklayın.",source,255,0,0,true)
	return end
	end
	setElementData(source, "silahaktif:"..silah_db.."", true)	
	outputChatBox("[!] #ffffff"..silah.." isimli silahınızı elinize aldınız. Mevcut Mermi: "..mermi.."",source,0,255,0,true)
	giveWeapon(source, silah_db, mermi)
	
	setElementData(source, "envpanel:acik", false)
	elseif getElementData(source, "silahaktif:"..silah_db.."")==true then
	if (pedSlot == 0) then outputChatBox("[!] #ffffffEnvanterinize koymak istediğiniz silahı elinize alın.",source,255,0,0,true) return end
	if (pedGun ~= silah_db) then outputChatBox("[!] #ffffff"..silah.." model silahınızı saklamak için elinize alın.",source,255,0,0,true) return end
	takeWeapon(source, silah_db)
	setAccountData(getPlayerAccount(source), "silah:"..silah_db.."", pedAmmo)
	setElementData(source, "silahaktif:"..silah_db.."", false)
	setElementData(source, "silah:"..silah_db.."", pedAmmo)
	outputChatBox("[!] #ffffff"..silah.." isimli silahınızı envanterinize sakladınız. Görüntülemek için 'J'",source,0,255,0,true)
	
	setElementData(source, "envpanel:acik", false)
	end
	end
end
addEvent("weapon:function", true)
addEventHandler("weapon:function", root, takeGunInventory)

addEventHandler ("onPlayerWeaponFire", root, 
   function (weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
	local mermi_sayisi = getPedTotalAmmo(source)
	setElementData(source, "silah:"..weapon.."", mermi_sayisi-1)
	setAccountData(getPlayerAccount(source), "silah:"..weapon.."", mermi_sayisi-1)
	if (mermi_sayisi==1) then
	setAccountData(getPlayerAccount(source), "silah:"..weapon.."", 0)
	setElementData(source, "silahaktif:"..weapon.."", false)
	setElementData(source, "silah:"..weapon.."", 0)
	outputChatBox("[!] #ffffff"..getWeaponNameFromID(weapon).." isimli silahınızın mermisi bitti ve envanterinize düştü. 'I'",source,0,255,0,true)
   end
   end
)

function yaraliSilah()
	for i, weapon in pairs(silahlar) do
	setElementData(source, "silahaktif:"..weapon.silahid.."", false)
	end
end
addEvent("silah:sakla", true)
addEventHandler("silah:sakla", root, yaraliSilah)

function lootAlFunction(lootid, amount, toplu)
		if not amount and not toplu then
			local cloot = worldItems[tonumber(lootid)]
			if cloot == nil then outputChatBox("[-] #ffffffSeçtiğiniz eşya artık bulunmuyor.",source,255,0,0,true) return end
			local itemid, itemname, itemcount, element = cloot["item"], cloot["itemname"], cloot["count"], cloot["element"]
			outputChatBox("[-] #ffffffSeçili eşyayı başarıyla aldınız.",source,255,0,0,true)
			giveItem(source, tonumber(itemid), tonumber(itemcount))
			worldItems[tonumber(lootid)] = nil
			destroyElement(element)
		elseif amount and not toplu then
			if tonumber(amount) then
			local cloot = worldItems[tonumber(lootid)]
			if cloot == nil then outputChatBox("[-] #ffffffSeçtiğiniz eşya artık bulunmuyor.",source,255,0,0,true) return end
			local itemid, itemname, itemcount, element = cloot["item"], cloot["itemname"], cloot["count"], cloot["element"]
			if tonumber(amount) > tonumber(itemcount) then outputChatBox("[-] #ffffffGirdiğiniz miktar kadar eşya yer almıyor.",source,255,0,0,true) return end
			outputChatBox("[-] #ffffffSeçili eşyayı başarıyla aldınız.",source,255,0,0,true)
			giveItem(source, tonumber(itemid), tonumber(amount))
			if (itemcount-amount) > 0 then
			worldItems[tonumber(lootid)]["count"] = itemcount - amount 
			setElementData(element, "content", worldItems[tonumber(lootid)])
			else
			worldItems[tonumber(lootid)] = nil
			destroyElement(element)
			end
			else
			outputChatBox("[-] #ffffffLütfen geçerli bir miktar girin.",source,255,0,0,true)
			return end
		elseif not amount and toplu then
			outputChatBox("[-] #ffffffSeçili eşyayı başarıyla aldınız.",source,255,0,0,true)
			for k, v in pairs(toplu) do
			local serial = v.serial
			local cloot = worldItems[tonumber(serial)]
			local itemid, itemname, itemcount, element = cloot["item"], cloot["itemname"], cloot["count"], cloot["element"]
			giveItem(source, tonumber(itemid), tonumber(itemcount))
			worldItems[tonumber(serial)] = nil
			destroyElement(element)
		end
	end
end
addEvent("lootAl", true)
addEventHandler("lootAl", root, lootAlFunction)