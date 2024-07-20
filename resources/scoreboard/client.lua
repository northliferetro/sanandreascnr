debugMode = true -- (true = normal scoreboard, false = deneme amaçlı 300 plr)

local screenW, screenH = guiGetScreenSize()
local originalW = 1366
local originalH = 768
local scaleW = screenW / originalW
local scaleH = screenH / originalH

local serverName = "Default MTA Server"
local playersPerPage = 19
local currentPage = 1
local selectedPlayer = nil
local egplr = {}
local totalPages = 0

-- kırmızı çizelge şeysi
local rectangleX = 1007
local rectangleY = 160 -- 510 max
local rectangleWidth = 13
local rectangleHeight = 83
local rectangleColor = tocolor(195, 0, 0, 96)

addEventHandler("onClientRender", root,
    function()
        if scoreboard then
  
		dxDrawRectangle((screenW - 679 * scaleW) / 2, (screenH - 468 * scaleH) / 2, 679 * scaleW, 468 * scaleH, tocolor(0, 0, 0, 175), false)

		dxDrawRectangle((screenW - 679 * scaleW) / 2, (screenH - 468 * scaleH) / 2, 679 * scaleW, 468 * scaleH, tocolor(0, 0, 0, 175), false)

		dxDrawRectangle(338 * scaleW, 103 * scaleH, 690 * scaleW, 54 * scaleH, tocolor(0, 0, 0, 120), false)

		dxDrawRectangle(348 * scaleW, 155 * scaleH, 652 * scaleW, 19 * scaleH, tocolor(150, 5, 9, 0), false)
		dxDrawImage(336 * scaleW, 142 * scaleH, 697 * scaleW, 483 * scaleH, ":scoreboard/rounded.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)

		dxDrawText(serverName, (396 - 1) * scaleW, (104 - 1) * scaleH, (869 - 1) * scaleW, (121 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText(serverName, (396 + 1) * scaleW, (104 - 1) * scaleH, (869 + 1) * scaleW, (121 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText(serverName, (396 - 1) * scaleW, (104 + 1) * scaleH, (869 - 1) * scaleW, (121 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText(serverName, (396 + 1) * scaleW, (104 + 1) * scaleH, (869 + 1) * scaleW, (121 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText(serverName, 396 * scaleW, 104 * scaleH, (396 * scaleW) + 473 * scaleW, (104 * scaleH) + 17 * scaleH, tocolor(144, 143, 143, 254), 1.00, "default", "left", "bottom", false, false, false, false, false)

		dxDrawText("Players: ", (949 - 1) * scaleW, (104 - 1) * scaleH, (1013 - 1) * scaleW, (121 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText("Players: "..#getElementsByType("player"), (949 + 1) * scaleW, (104 - 1) * scaleH, (1013 + 1) * scaleW, (121 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText("Players: "..#getElementsByType("player"), (949 - 1) * scaleW, (104 + 1) * scaleH, (1013 - 1) * scaleW, (121 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText("Players: "..#getElementsByType("player"), (949 + 1) * scaleW, (104 + 1) * scaleH, (1013 + 1) * scaleW, (121 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "bottom", false, false, false, false, false)
		dxDrawText("Players: "..#getElementsByType("player"), 949 * scaleW, 104 * scaleH, (949 * scaleW) + 64 * scaleW, (104 * scaleH) + 17 * scaleH, tocolor(144, 143, 143, 254), 1.00, "default", "left", "bottom", false, false, false, false, false)

		dxDrawText("id", (354 - 1) * scaleW, (131 - 1) * scaleH, (381 - 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("id", (354 + 1) * scaleW, (131 - 1) * scaleH, (381 + 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("id", (354 - 1) * scaleW, (131 + 1) * scaleH, (381 - 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("id", (354 + 1) * scaleW, (131 + 1) * scaleH, (381 + 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("id", 354 * scaleW, 131 * scaleH, (354 * scaleW) + 27 * scaleW, (131 * scaleH) + 19 * scaleH, tocolor(149, 166, 190, 254), 1.00, "default", "center", "top", false, false, false, false, false)

		dxDrawText("name", (418 - 1) * scaleW, (131 - 1) * scaleH, (692 - 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
		dxDrawText("name", (418 + 1) * scaleW, (131 - 1) * scaleH, (692 + 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
		dxDrawText("name", (418 - 1) * scaleW, (131 + 1) * scaleH, (692 - 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
		dxDrawText("name", (418 + 1) * scaleW, (131 + 1) * scaleH, (692 + 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
		dxDrawText("name", 418 * scaleW, 131 * scaleH, (418 * scaleW) + 274 * scaleW, (131 * scaleH) + 19 * scaleH, tocolor(149, 166, 190, 254), 1.00, "default", "left", "top", false, false, false, false, false)

		dxDrawText("score", (702 - 1) * scaleW, (131 - 1) * scaleH, (771 - 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("score", (702 + 1) * scaleW, (131 - 1) * scaleH, (771 + 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("score", (702 - 1) * scaleW, (131 + 1) * scaleH, (771 - 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("score", (702 + 1) * scaleW, (131 + 1) * scaleH, (771 + 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("score", 702 * scaleW, 131 * scaleH, (702 * scaleW) + 69 * scaleW, (131 * scaleH) + 19 * scaleH, tocolor(149, 166, 190, 254), 1.00, "default", "center", "top", false, false, false, false, false)

		dxDrawText("ping", (873 - 1) * scaleW, (131 - 1) * scaleH, (896 - 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("ping", (873 + 1) * scaleW, (131 - 1) * scaleH, (896 + 1) * scaleW, (150 - 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("ping", (873 - 1) * scaleW, (131 + 1) * scaleH, (896 - 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("ping", (873 + 1) * scaleW, (131 + 1) * scaleH, (896 + 1) * scaleW, (150 + 1) * scaleH, tocolor(0, 0, 0, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawText("ping", 873 * scaleW, 131 * scaleH, 896 * scaleW, 150 * scaleH, tocolor(149, 166, 190, 254), 1.00, "default", "center", "top", false, false, false, false, false)
		dxDrawRoundedRectangle(rectangleX * scaleW, rectangleY * scaleH, rectangleWidth * scaleW, rectangleHeight * scaleH, 5, rectangleColor, true) --çizgi
        local startY = 155 * scaleH
        local yOffset = 24 * scaleH
        local totalPlayers = #egplr
        local startIndex = (currentPage - 1) * playersPerPage + 1
        local endIndex = math.min(startIndex + playersPerPage - 1, totalPlayers)

        for i = startIndex, endIndex do
            local playerData = egplr[i]
            if playerData then
                local yStart = startY + (i - startIndex) * yOffset
                local alpha = (selectedPlayer == playerData) and 255 or 0

                dxDrawRectangle(348 * scaleW, yStart, 647 * scaleW, 19 * scaleH, tocolor(150, 5, 9, alpha), false)
                dxDrawText(playerData.tag..playerData.id, 354 * scaleW, yStart, 381 * scaleW, yStart + 19 * scaleH, tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, false, false, true, true)
                dxDrawText(playerData.tag..getPlayerName(playerData.plr), 418 * scaleW, yStart, 692 * scaleW, yStart + 19 * scaleH, tocolor(255, 254, 254, 254), 1.20, "default-bold", "left", "center", false, false, false, true, true)
                dxDrawText(playerData.tag..playerData.score, 702 * scaleW, yStart, 771 * scaleW, yStart + 19 * scaleH, tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, false, false, true, true)
                dxDrawText(playerData.tag..getPlayerPing(playerData.plr), 873 * scaleW, yStart, 896 * scaleW, yStart + 19 * scaleH, tocolor(255, 255, 255, 255), 1.20, "default-bold", "center", "center", false, false, false, true, true)
                end
            end
        end
    end
)


function normalVersion(state)
    if state then
        egplr = {} 
        for k, v in pairs(getElementsByType("player")) do
            local color = getElementData(v, "tagcolor") or "#FFFFFF"
            local skor = 0
            if getElementData(v, "taraf") == "Hırsız" then
                skor = getElementData(v, "skorhirsiz") or 0
            else
                skor = getElementData(v, "skorpolis") or 0
            end
            table.insert(egplr, {plr = v, score = skor, id = getElementData(v, "id"), tag = color})
        end
    else
        egplr = {}
        for i = 1, 300 do
            table.insert(egplr, {plr = localPlayer, score = 1, id = i})
        end
    end
    table.sort(egplr, function(a, b) return a.id < b.id end)
end


function playerPressedKey(button, press)
    if button == "tab" and press then 
		rectangleX = 1007
		rectangleY = 160 -- 510 max
		rectangleWidth = 13
		rectangleHeight = 83
		currentPage = 1
        scoreboard = not scoreboard
        showCursor(scoreboard)
        selectedPlayer = nil
        egplr = {}
		normalVersion(debugMode)
        totalPages = math.ceil(#egplr / playersPerPage)
    end
end
addEventHandler("onClientKey", root, playerPressedKey)

function playerClicked(button, state, absoluteX, absoluteY)
    if button == "left" and state == "up" and scoreboard then
        local totalPlayers = #egplr
        local startIndex = (currentPage - 1) * playersPerPage + 1
        local endIndex = math.min(startIndex + playersPerPage - 1, totalPlayers)

        for i = startIndex, endIndex do
            local playerData = egplr[i]
            if playerData then
                local yStart = 155 * scaleH + (i - startIndex) * 24 * scaleH
                if absoluteX >= 348 * scaleW and absoluteX <= (348 + 652) * scaleW and absoluteY >= yStart and absoluteY <= yStart + 19 * scaleH then
                    selectedPlayer = playerData
                    return  
                end
            end
        end
        selectedPlayer = nil
    end
end
addEventHandler("onClientClick", root, playerClicked)

function onClientKey(button, press)
    if scoreboard then
        local space = (550 - 160) / totalPages
        if button == "mouse_wheel_up" then
            if currentPage > 1 then
                currentPage = currentPage - 1
                rectangleY = rectangleY - space
				selectedPlayer = nil
            end
        elseif button == "mouse_wheel_down" then
            if currentPage < totalPages then
                currentPage = currentPage + 1
                rectangleY = rectangleY + space
				selectedPlayer = nil
            end
        end
    end
end
addEventHandler("onClientKey", root, onClientKey)

addEventHandler("onClientDoubleClick", root, function(button, absoluteX, absoluteY, worldX, worldY,  worldZ, clickedWorld)
	if scoreboard and button == "left" then
		if selectedPlayer then
			triggerServerEvent("scoreboardClick", localPlayer, selectedPlayer["plr"], selectedPlayer["id"])
		end
	end
end)


function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end