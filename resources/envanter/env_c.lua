
GUIEditor = {
    gridlist = {},
    window = {},
	button = {}
}

		function showList()
		showCursor(true)
		local screenW, screenH = guiGetScreenSize()
        GUIEditor.window[1] = guiCreateWindow((screenW - 834) / 2, (screenH - 564) / 2, 834, 564, "SA:HP- Item System v0.1", false)
        guiWindowSetMovable(GUIEditor.window[1], false)
        guiWindowSetSizable(GUIEditor.window[1], false)
        guiSetAlpha(GUIEditor.window[1], 1.00)
		

        GUIEditor.gridlist[1] = guiCreateGridList(9, 20, 815, 530, false, GUIEditor.window[1])
		GUIEditor.button[1] = guiCreateButton(754, 6, 51, 17, "X", false, GUIEditor.gridlist[1]) 
		colID = guiGridListAddColumn(GUIEditor.gridlist[1], "ID", 0.2)
        colName = guiGridListAddColumn(GUIEditor.gridlist[1], "Item Name", 0.2)
        colDesc = guiGridListAddColumn(GUIEditor.gridlist[1], "Item Desc", 0.2)
        colType = guiGridListAddColumn(GUIEditor.gridlist[1], "Item Type", 0.2)
        for i = 1, 7 do
            guiGridListAddRow(GUIEditor.gridlist[1])
        end
		for k, tablo in pairs(itemler) do		
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		guiGridListSetItemText(GUIEditor.gridlist[1], row, colID, tablo.itemid, false, true)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, colName, tablo.itemname, false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, colDesc, tablo.desc, false, false)
		guiGridListSetItemText(GUIEditor.gridlist[1], row, colType, tablo.type, false, false)
		end
		end
		addEvent("showAdminItemList", true)
		addEventHandler("showAdminItemList", root, showList)
    
function checkNearbyLoots(element)
	local loots = {}
	if isElement(element) then
		local x, y, z = getElementPosition(element)
		for k, v in pairs(getElementsByType("object")) do
			if getElementModel(v) == 1575 and getElementData(v, "content") then
				local lx, ly, lz = getElementPosition(v)
				local mtwithloot = getDistanceBetweenPoints3D(x, y, z, lx, ly, lz)
				if tonumber(mtwithloot) < 2 then
					local loot_content = getElementData(v, "content")
					local loot_serial = getElementData(v, "serial")
					loots[#loots+1] = {serial = loot_serial, content = loot_content}
				end
			end
		end
	end
	return loots
end


function click()
	if source == GUIEditor.button[1] then
	guiSetVisible(GUIEditor.window[1], false)
	showCursor(false)
end
end
addEventHandler("onClientGUIClick", root, click)

function removeHex (s)
    if type (s) == "string" then
        while (s ~= s:gsub ("#%x%x%x%x%x%x", "")) do
            s = s:gsub ("#%x%x%x%x%x%x", "")
        end
    end
    return s or false
end


GUIEditor = {
    tab = {},
    tabpanel = {},
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {}
}

    function envanter()
	if isElement(mainWindow) then 
	closeAll()
	return end
	addEventHandler("onClientGUITabSwitched", getRootElement(), OnChange)
	showCursor(true)
	local screenW, screenH = guiGetScreenSize()
        mainWindow = guiCreateWindow((screenW - 524) / 2, (screenH - 336) / 2, 524, 336, "SA:HP - Envanter Paneli", false)
        guiWindowSetSizable(mainWindow, false)
		guiWindowSetMovable(mainWindow, false)
        guiSetAlpha(mainWindow, 1.00)

        GUIEditor.tabpanel[1] = guiCreateTabPanel(9, 21, 505, 305, false, mainWindow)

        GUIEditor.tab[1] = guiCreateTab("Envanter", GUIEditor.tabpanel[1])

        GUIEditor.gridlist[1] = guiCreateGridList(8, 8, 487, 263, false, GUIEditor.tab[1])
		esyaCol = guiGridListAddColumn(GUIEditor.gridlist[1], "Eşya", 0.3)
        miktarCol = guiGridListAddColumn(GUIEditor.gridlist[1], "Miktar", 0.3)
        turCol = guiGridListAddColumn(GUIEditor.gridlist[1], "Tür", 0.3)
		for k, item in pairs(itemler) do
		local row = guiGridListAddRow(GUIEditor.gridlist[1])
		if getElementData(localPlayer, ""..item.itemid.."") then
		local itemmiktar = getElementData(localPlayer, ""..item.itemid.."")
        guiGridListSetItemText(GUIEditor.gridlist[1], row, esyaCol, item.itemname, false, false)
        guiGridListSetItemText(GUIEditor.gridlist[1], row, miktarCol, itemmiktar, false, false)
        guiGridListSetItemText(GUIEditor.gridlist[1], row, turCol, item.type, false, false)
		end
		end
        GUIEditor.tab[2] = guiCreateTab("Cüzdan", GUIEditor.tabpanel[1])

        GUIEditor.gridlist[2] = guiCreateGridList(5, 6, 490, 265, false, GUIEditor.tab[2])
        guiGridListAddColumn(GUIEditor.gridlist[2], "Evrak", 0.3)
        guiGridListAddColumn(GUIEditor.gridlist[2], "Değer", 0.3)
        guiGridListAddColumn(GUIEditor.gridlist[2], "Bilgi", 0.3)
        guiGridListAddRow(GUIEditor.gridlist[2])
		guiGridListAddRow(GUIEditor.gridlist[2])
		guiGridListAddRow(GUIEditor.gridlist[2])
		guiGridListAddRow(GUIEditor.gridlist[2])
		guiGridListAddRow(GUIEditor.gridlist[2])
        guiGridListSetItemText(GUIEditor.gridlist[2], 0, 1, "Kimlik", false, false)
        guiGridListSetItemText(GUIEditor.gridlist[2], 0, 2, ""..getPlayerSerial(localPlayer).."", false, false)
        guiGridListSetItemText(GUIEditor.gridlist[2], 0, 3, "Mesleğin", false, false)
		guiGridListSetItemText(GUIEditor.gridlist[2], 1, 1, "Para Miktarı", false, false)
        guiGridListSetItemText(GUIEditor.gridlist[2], 1, 2, ""..getPlayerMoney(localPlayer).." Türk Lirası", false, false)
		guiGridListSetItemText(GUIEditor.gridlist[2], 2, 1, "Bulunduğun Klan", false, false)
		guiGridListSetItemText(GUIEditor.gridlist[2], 2, 2, ""..getElementData(localPlayer, "klan").."", false, false)
		guiGridListSetItemText(GUIEditor.gridlist[2], 2, 3, ""..getElementData(localPlayer, "rutbe").."", false, false)
        GUIEditor.tab[3] = guiCreateTab("İşlemler", GUIEditor.tabpanel[1])
	

        GUIEditor.gridlist[3] = guiCreateGridList(17, 11, 198, 260, false, GUIEditor.tab[3])
		nearCol = guiGridListAddColumn(GUIEditor.gridlist[3], "Yakındaki Oyuncular", 0.9)
		local row = guiGridListAddRow(GUIEditor.gridlist[3])
		 local posX1, posY1, posZ1 = getElementPosition(localPlayer)
        for id, player in ipairs(getElementsByType("player")) do
           local posX2, posY2, posZ2 = getElementPosition(player)
		   local playert = getPlayerName(player)
         if getDistanceBetweenPoints3D(posX1, posY1, posZ1, posX2, posY2, posZ2) <= 2 then
		 local players = removeHex(playert)
		guiGridListSetItemText(GUIEditor.gridlist[3], row, nearCol, players, false, false)
		end
		end
        GUIEditor.edit[1] = guiCreateEdit(233, 25, 236, 38, "Miktar Girin", false, GUIEditor.tab[3])
        GUIEditor.button[3] = guiCreateButton(241, 73, 218, 32, "Para Ver", false, GUIEditor.tab[3])
        GUIEditor.label[1] = guiCreateLabel(235, 161, 224, 40, "Diğer İşlemler", false, GUIEditor.tab[3])
        guiSetFont(GUIEditor.label[1], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        GUIEditor.button[2] = guiCreateButton(241, 205, 218, 32, "Seçili Oyuncuya Kimlik Göster", false, GUIEditor.tab[3]) 
		GUIEditor.tab[4] = guiCreateTab("Silahlar", GUIEditor.tabpanel[1])		
		GUIEditor.gridlist[4] = guiCreateGridList(5, 6, 490, 265, false, GUIEditor.tab[4])
		weaponesyaCol = guiGridListAddColumn(GUIEditor.gridlist[4], "Silah Bilgisi", 0.3)
        weaponmiktarCol = guiGridListAddColumn(GUIEditor.gridlist[4], "Mevcut Mermi", 0.3)
        weaponturCol = guiGridListAddColumn(GUIEditor.gridlist[4], "Durum", 0.3)
		for k, items in pairs(silahlar) do
		local rowgun = guiGridListAddRow(GUIEditor.gridlist[4])
		if getElementData(localPlayer, "silah:"..items.silahid.."") then
		local mermimiktar = getElementData(localPlayer, "silah:"..items.silahid.."") or 0
		if getElementData(source, "silahaktif:"..items.silahid.."")==false then
		gunstate = "Envanterinizde"
		else
		gunstate = "Elinizde"
		end
		guiGridListSetItemText(GUIEditor.gridlist[4], rowgun, weaponesyaCol, getWeaponNameFromID(items.silahid), false, false)
        guiGridListSetItemText(GUIEditor.gridlist[4], rowgun, weaponmiktarCol, mermimiktar, false, false)
        guiGridListSetItemText(GUIEditor.gridlist[4], rowgun, weaponturCol, gunstate, false, false)
		end
	end	
	local loot = checkNearbyLoots(localPlayer)
	if #loot > 0 then
	GUIEditor.tab[5] = guiCreateTab("Yerdeki Eşyalar", GUIEditor.tabpanel[1])
	GUIEditor.gridlist[10] = guiCreateGridList(0.03, 0.04, 0.50, 0.93, true, GUIEditor.tab[5])
		nearItems_lid = guiGridListAddColumn(GUIEditor.gridlist[10], "Loot ID", 0.2)
		nearItems_item = guiGridListAddColumn(GUIEditor.gridlist[10], "Eşya", 0.4)
		nearItems_itemcount = guiGridListAddColumn(GUIEditor.gridlist[10], "Eşya Adet", 0.3)
		for k, itm in pairs(loot) do
		local content = itm.content
		local itemname, amount, itemid = content["itemname"], content["count"], content["item"]
		local rowx = guiGridListAddRow(GUIEditor.gridlist[10])
		guiGridListSetItemText(GUIEditor.gridlist[10], rowx, nearItems_lid, itm.serial, false, false)
		guiGridListSetItemText(GUIEditor.gridlist[10], rowx, nearItems_item, itemname, false, false)
		guiGridListSetItemText(GUIEditor.gridlist[10], rowx, nearItems_itemcount, amount, false, false)
		end
		GUIEditor.button[10] = guiCreateButton(275, 233, 220, 38, "Yakındakilerin Tümünü Al", false, GUIEditor.tab[5])
        GUIEditor.button[20] = guiCreateButton(275, 185, 220, 38, "Seçili Olanı Al", false, GUIEditor.tab[5])
        GUIEditor.button[30] = guiCreateButton(275, 62, 220, 38, "Seçili Olandan Miktarla Al", false, GUIEditor.tab[5])
        GUIEditor.edit[10] = guiCreateEdit(277, 34, 218, 23, "Miktar Girin", false, GUIEditor.tab[5])    
	end
	end
	addEvent("envanter", true)
	addEventHandler("envanter", root, envanter)


function click () 
		if source == GUIEditor.button[3] then
		local miktar = guiGetText(GUIEditor.edit[1])
       local playerName = guiGridListGetItemText ( GUIEditor.gridlist[3], guiGridListGetSelectedItem ( GUIEditor.gridlist[3] ), 1 )
       triggerServerEvent("envanter:para:ver", localPlayer, playerName, miktar)
	   elseif source == GUIEditor.button[2] then
	    local playerName = guiGridListGetItemText ( GUIEditor.gridlist[3], guiGridListGetSelectedItem ( GUIEditor.gridlist[3] ), 1 )
       triggerServerEvent("envanter:kimlik:ver", localPlayer, playerName)
	 end
	 if source == option_use then
		if not silah then
		if itemname ~= "" and itemtype ~= "" then
			triggerServerEvent("bomb", localPlayer,itemtype, itemname)
			triggerServerEvent("eat", localPlayer, itemtype, itemname)
		end
		else
			if weapon_name ~= "" and weapon_ammo ~= "" then
			triggerServerEvent("weapon:function", localPlayer, weapon_name, tonumber(weapon_ammo))
			end
		end
		closeAll()
	elseif source == option_give then
		if not silah then
		if isElement(optionwindow) then destroyElement(optionwindow) end
		givewindow = guiCreateWindow(0.23, 0.28, 0.07, 0.14, itemname, true)
        guiWindowSetMovable(givewindow, false)
        guiWindowSetSizable(givewindow, false)
        guiSetAlpha(givewindow, 1.00)
        give_plr = guiCreateEdit(0.09, 0.21, 0.80, 0.21, "Oyuncu/ID", true, givewindow)
        give_count = guiCreateEdit(0.09, 0.47, 0.80, 0.21, "Miktar", true, givewindow)
        give_accept = guiCreateButton(0.09, 0.71, 0.80, 0.21, "Onayla", true, givewindow)   
		end
	elseif source == option_drop then
		if not silah then
		if isElement(optionwindow) then destroyElement(optionwindow) end
        dropwindow = guiCreateWindow(0.23, 0.28, 0.07, 0.14, itemname, true)
        guiWindowSetMovable(dropwindow, false)
        guiWindowSetSizable(dropwindow, false)
        guiSetAlpha(dropwindow, 1.00)
        drop_amount = guiCreateEdit(0.09, 0.21, 0.80, 0.21, "Miktar", true, dropwindow)
        drop_drop = guiCreateButton(0.09, 0.47, 0.80, 0.21, "Miktarla Bırak", true, dropwindow)
        drop_drop_all = guiCreateButton(0.09, 0.71, 0.80, 0.21, "Hepsini Bırak", true, dropwindow)  
		end
	 end
	 if source == give_accept then
		local targetPlayer = guiGetText(give_plr)
		local targetCount = guiGetText(give_count)
		triggerServerEvent("esyaVer", localPlayer, itemname, targetPlayer, targetCount)
		if isElement(givewindow) then destroyElement(givewindow) end
	 end
	 if source == give_count and guiGetText(give_count) == "Miktar" then guiSetText(give_count, "") end
	 if source == give_plr and guiGetText(give_plr) == "Oyuncu/ID" then guiSetText(give_plr, "") end
	 if source == drop_drop then
		local amount = guiGetText(drop_amount)
		triggerServerEvent("itemDrop", localPlayer, itemname, amount, true)
		if isElement(dropwindow) then destroyElement(dropwindow) showCursor(false) end
		closeAll()
	 elseif source == drop_drop_all then
		triggerServerEvent("itemDrop", localPlayer, itemname, false, false)
		closeAll()
	 end
	 if source == drop_amount and guiGetText(drop_amount) == "Miktar" then guiSetText(drop_amount, "") end
	 if source == GUIEditor.edit[10] and guiGetText(GUIEditor.edit[10]) == "Miktar Girin" then guiSetText(GUIEditor.edit[10], "") end
	 if source == GUIEditor.button[20] then
		local lootID = guiGridListGetItemText ( GUIEditor.gridlist[10], guiGridListGetSelectedItem ( GUIEditor.gridlist[10] ), 1 )
		if lootID ~= "" then
			closeAll()
			triggerServerEvent("lootAl", localPlayer, lootID, false, false)
		end
	elseif source == GUIEditor.button[30] then
		local edit_count = guiGetText(GUIEditor.edit[10])
		local lootID = guiGridListGetItemText ( GUIEditor.gridlist[10], guiGridListGetSelectedItem ( GUIEditor.gridlist[10] ), 1 )
		if lootID ~= "" then
			closeAll()
			triggerServerEvent("lootAl", localPlayer, lootID, edit_count, false)
		end
	elseif source == GUIEditor.button[10] then
		local allLoots = checkNearbyLoots(localPlayer)
		triggerServerEvent("lootAl", localPlayer, false, false, allLoots)
		closeAll()
	 end
end
addEventHandler ( "onClientGUIClick", root, click )

function closeAll()
	if isElement(mainWindow) then destroyElement(mainWindow) showCursor(false)  end
	removeEventHandler("onClientGUITabSwitched", getRootElement(), OnChange)
	if isElement(givewindow) then destroyElement(givewindow) end
	if isElement(optionwindow) then destroyElement(optionwindow) end
	if isElement(dropwindow) then destroyElement(dropwindow) end
end

function aksesuar()
	if source == GUIEditor.gridlist[1] then
		itemtype = guiGridListGetItemText ( GUIEditor.gridlist[1], guiGridListGetSelectedItem ( GUIEditor.gridlist[1] ), turCol )
		itemname = guiGridListGetItemText ( GUIEditor.gridlist[1], guiGridListGetSelectedItem ( GUIEditor.gridlist[1] ), esyaCol )
		if itemname ~= "" and itemtype ~= "" then
		if isElement(optionwindow) then destroyElement(optionwindow) 
		if isElement(givewindow) then destroyElement(givewindow) end
		if isElement(dropwindow) then destroyElement(dropwindow) end
		return end
		silah = false
        optionwindow = guiCreateWindow(0.23, 0.28, 0.07, 0.14, itemname, true)
        guiWindowSetMovable(optionwindow, false)
        guiWindowSetSizable(optionwindow, false)
        guiSetAlpha(optionwindow, 1.00)
        option_use = guiCreateButton(0.09, 0.21, 0.80, 0.21, "Kullan", true, optionwindow)
        option_drop = guiCreateButton(0.09, 0.47, 0.80, 0.21, "Yere Bırak", true, optionwindow)
        option_give = guiCreateButton(0.09, 0.71, 0.80, 0.21, "Ver", true, optionwindow)    
		end
		elseif source == GUIEditor.gridlist[4] then
	    weapon_name = guiGridListGetItemText ( GUIEditor.gridlist[4], guiGridListGetSelectedItem ( GUIEditor.gridlist[4] ), weaponesyaCol )
		weapon_ammo = guiGridListGetItemText ( GUIEditor.gridlist[4], guiGridListGetSelectedItem ( GUIEditor.gridlist[4] ), weaponmiktarCol )
		if isElement(optionwindow) then destroyElement(optionwindow) 
		if isElement(givewindow) then destroyElement(givewindow) end
		if isElement(dropwindow) then destroyElement(dropwindow) end
		return end
		silah = true
		optionwindow = guiCreateWindow(0.23, 0.28, 0.07, 0.14, weapon_name.." ("..weapon_ammo..")", true)
        guiWindowSetMovable(optionwindow, false)
        guiWindowSetSizable(optionwindow, false)
        guiSetAlpha(optionwindow, 1.00) 
        option_use = guiCreateButton(0.09, 0.21, 0.80, 0.21, "Kullan", true, optionwindow)
        option_drop = guiCreateButton(0.09, 0.47, 0.80, 0.21, "Yere Bırak", true, optionwindow)
        option_give = guiCreateButton(0.09, 0.71, 0.80, 0.21, "Ver", true, optionwindow)  
      -- triggerServerEvent("weapon:function", localPlayer, weapon_name, weapon_ammo)
	 end
end
addEventHandler( "onClientGUIDoubleClick", root, aksesuar)



function OnChange(selectedTab)
	if selectedTab ~= nil then 
		if isElement(optionwindow) then destroyElement(optionwindow) end
		if isElement(givewindow) then destroyElement(givewindow) end
		if isElement(dropwindow) then destroyElement(dropwindow) end
	end	
end
