metin = {}
sira = {}

local originalWidth, originalHeight = 1366, 768
local screenWidth, screenHeight = guiGetScreenSize()
local scaleX, scaleY = screenWidth / originalWidth, screenHeight / originalHeight
local yOffset = 30 * scaleY
local lastSira = 0
local panelWidth = 300 * scaleX 

function formatMetin(metin, max_karakter)
    local satirlar = {}
    local satir = ""
    
    for kelime in metin:gmatch("%S+") do
        if #satir + #kelime + 1 <= max_karakter then
            if #satir > 0 then
                satir = satir .. " " .. kelime
            else
                satir = kelime
            end
        else
            table.insert(satirlar, satir)
            satir = kelime
        end
    end
    
    if #satir > 0 then
        table.insert(satirlar, satir)
    end
    
    return table.concat(satirlar, "\n")
end

addEventHandler("onClientRender", root,
    function()
        if metin[localPlayer] then
            for i, v in pairs(metin[localPlayer]) do
                local lines = formatMetin(v.text, 32) 
                local lineCount = select(2, lines:gsub('\n', '\n')) + 1
                local rectHeight = 66 * scaleY + (lineCount - 1) * 14 * scaleY
                dxDrawRectangle(1062 * scaleX, (214 + yOffset) * scaleY, panelWidth, rectHeight, tocolor(0, 0, 0, 208), false)

                dxDrawText(v.title, (1061 - 1) * scaleX, (200 - 1 + yOffset) * scaleY, (1062 - 1 + panelWidth) * scaleX, (218 - 1 + yOffset) * scaleY, tocolor(0, 0, 0, 255), 1.00 * scaleY, "pricedown", "left", "top", false, false, false, false, false)
                dxDrawText(v.title, (1061 + 1) * scaleX, (200 - 1 + yOffset) * scaleY, (1062 + 1 + panelWidth) * scaleX, (218 - 1 + yOffset) * scaleY, tocolor(0, 0, 0, 255), 1.00 * scaleY, "pricedown", "left", "top", false, false, false, false, false)
                dxDrawText(v.title, (1061 - 1) * scaleX, (200 + 1 + yOffset) * scaleY, (1062 - 1 + panelWidth) * scaleX, (218 + 1 + yOffset) * scaleY, tocolor(0, 0, 0, 255), 1.00 * scaleY, "pricedown", "left", "top", false, false, false, false, false)
                dxDrawText(v.title, (1061 + 1) * scaleX, (200 + 1 + yOffset) * scaleY, (1062 + 1 + panelWidth) * scaleX, (218 + 1 + yOffset) * scaleY, tocolor(0, 0, 0, 255), 1.00 * scaleY, "pricedown", "left", "top", false, false, false, false, false)
                dxDrawText(v.title, 1061 * scaleX, (200 + yOffset) * scaleY, (1062 + panelWidth) * scaleX, (218 + yOffset) * scaleY, tocolor(255, 255, 255, 255), 1.00 * scaleY, "pricedown", "left", "top", false, false, false, false, false)

                dxDrawText(lines, (1066 - 1) * scaleX, (236 - 1 + yOffset) * scaleY, (1062 - 1 + panelWidth) * scaleX, (236 - 1 + yOffset + rectHeight) * scaleY, tocolor(0, 0, 0, 255), 0.50 * scaleY, "bankgothic", "left", "top", false, false, false, false, false)
                dxDrawText(lines, (1066 + 1) * scaleX, (236 - 1 + yOffset) * scaleY, (1062 + 1 + panelWidth) * scaleX, (236 - 1 + yOffset + rectHeight) * scaleY, tocolor(0, 0, 0, 255), 0.50 * scaleY, "bankgothic", "left", "top", false, false, false, false, false)
                dxDrawText(lines, (1066 - 1) * scaleX, (236 + 1 + yOffset) * scaleY, (1062 - 1 + panelWidth) * scaleX, (236 + 1 + yOffset + rectHeight) * scaleY, tocolor(0, 0, 0, 255), 0.50 * scaleY, "bankgothic", "left", "top", false, false, false, false, false)
                dxDrawText(lines, (1066 + 1) * scaleX, (236 + 1 + yOffset) * scaleY, (1062 + 1 + panelWidth) * scaleX, (236 + 1 + yOffset + rectHeight) * scaleY, tocolor(0, 0, 0, 255), 0.50 * scaleY, "bankgothic", "left", "top", false, false, false, false, false)
                dxDrawText(lines, 1066 * scaleX, (236 + yOffset) * scaleY, (1062 + panelWidth) * scaleX, (236 + yOffset + rectHeight) * scaleY, tocolor(255, 255, 255, 255), 0.50 * scaleY, "bankgothic", "left", "top", false, false, false, false, false)

                if getTickCount() > v.tick + 5000 then
                    lastSira = lastSira + 1
                    siraKontrol()
                end
            end
        end
    end
)




addEvent("infobox", true)
addEventHandler("infobox", root, function(title, text, spam)
	if title and text then
		if #title > 20 then return end
		if not metin[localPlayer] then metin[localPlayer] = {} 
		local ticksound = playSound("tick.mp3")
		setSoundVolume(ticksound, 2)
		metin[localPlayer][1] = {tick = getTickCount(), title = title, text = text}
		else
		if spam then
		if metin[localPlayer][1]["title"] == title and metin[localPlayer][1]["text"] == text then return end
		else
		if not sira[localPlayer] then sira[localPlayer] = {} end
		local siraSon = #sira[localPlayer]+1
		sira[localPlayer][siraSon] = {tick = getTickCount(), title = title, text = text}
		end
		end
	end
end)

function siraKontrol()
	if sira[localPlayer] then
	if sira[localPlayer][lastSira] then
	sira[localPlayer][lastSira]["tick"] = getTickCount()
	metin[localPlayer][1] = sira[localPlayer][lastSira]
	local ticksound = playSound("tick.mp3")
	setSoundVolume(ticksound, 2)
	else
	sira[localPlayer] = nil
	lastSira = 0
	metin[localPlayer] = nil
	end
	else
	sira[localPlayer] = nil
	lastSira = 0
	metin[localPlayer] = nil
	end
end
