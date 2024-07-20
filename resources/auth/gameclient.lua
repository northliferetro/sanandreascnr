local dxfont0_font = dxCreateFont(":auth/GFX/font.ttf", 20)
local dxfont1_font = dxCreateFont(":auth/GFX/font.ttf", 14)
local dxfont3_font = dxCreateFont(":auth/GFX/font.ttf", 10)

local ipucular = {

[1] = "Polis olmak her zaman kazançlı bir meslektir!",
[2] = "Daha fazla bilgi için iletişim adreslerimizi kullanın!",
[3] = "Sunucumuz Türkiye'deki ilk yerel hırsız polis konseptidir.",
[4] = "Arkadaşlarınıza önermeyi unutmayın, keyifli eğlenceler!",
[5] = "Sunucumuz klimalıdır!",

}

local ipucu = ""
local ipucuIndex = 1

function ipucuDegis()
	if(ipucuIndex+1) > #ipucular then
		ipucuIndex = 1
	else
		ipucuIndex = ipucuIndex + 1
	end
	ipucu = ipucular[ipucuIndex]
end
setTimer(ipucuDegis, 5000, 0)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function yuzdelikHesapla(puan, maksimum, format)
    if puan < 0 or maksimum <= 0 then
        return nil, "Geçersiz giriş"
    end
    local yuzde = {string.format("%.1f", (puan / maksimum) * 100), math.floor((puan / maksimum) * 100)}
    return yuzde
end

function yuklenmeSuresiHesapla(puan)
    local sure = 0
    local yukleme = 1
    if tonumber(puan) then
        if puan < 101 then
            sure = 50
        elseif puan >= 101 and puan < 200 then
            sure = 40
        elseif puan >= 200 and puan < 500 then
            sure = 30
        elseif puan >= 501 and puan < 1000 then
            sure = 20
			yukleme = 2
        elseif puan >= 1000 and puan < 1500 then
            sure = 10
            yukleme = 2
        elseif puan >= 1500 and puan < 2000 then
            sure = 1
            yukleme = 3
        elseif puan >= 2000 and puan < 5000 then
            sure = 0.5
            yukleme = 4
        elseif puan >= 5000 and puan < 10000 then
            sure = 0.2
            yukleme = 30
        elseif puan >= 10000 and puan < 20000 then
            sure = 0.1
            yukleme = 40
        elseif puan >= 20000 and puan < 30000 then
            sure = 0.1
            yukleme = 50
		elseif puan >= 30000 then
			sure = 0.1
			yukleme = 60
        end
        return sure, yukleme
    end
end


function expUp()
	if tilk and maxexp then
    local maths = yuzdelikHesapla(tilk, maxexp)
   dxDrawRectangle(436, 646, 494, 37, tocolor(0, 0, 0, 196), false)
   dxDrawImage(892, 596, 57, 108, ":auth/GFX/skins/285.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
   dxDrawLine(466 - 1, 656 - 1, 466 - 1, 673, tocolor(0, 0, 0, 255), 1, false)
   dxDrawLine(902, 656 - 1, 466 - 1, 656 - 1, tocolor(0, 0, 0, 255), 1, false)
   dxDrawLine(466 - 1, 673, 902, 673, tocolor(0, 0, 0, 255), 1, false)
   dxDrawLine(902, 673, 902, 656 - 1, tocolor(0, 0, 0, 255), 1, false)
   dxDrawRectangle(466, 656, 436, 17, tocolor(23, 120, 131, 196), false) -- iç
   dxDrawRectangle(466, 656, maths[1]*4+37, 17, tocolor(35, 178, 195, 196), false) -- dış (max 437)
   dxDrawImage(415, 596, 57, 108, ":auth/GFX/skins/280.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
   dxDrawText(tilk.." / "..maxexp.." (%"..maths[1]..")", 466 + 1, 655 + 1, 904 + 1, 673 + 1, tocolor(0, 0, 0, 255), 1.00, dxfont3_font, "center", "center", false, false, false, false, false)
   dxDrawText(tilk.." / "..maxexp.." (%"..maths[1]..")", 466, 655, 904, 673, tocolor(255, 255, 255, 255), 1.00, dxfont3_font, "center", "center", false, false, false, false, false)
   end
end

function expBarTrigger(player, state, ilk, value)
	tilk = ilk
	local exps = getElementData(localPlayer, "exp") or 0
	maxexp = getElementData(localPlayer, "maxexp") or 1000
	local _, loads = yuklenmeSuresiHesapla(tonumber(value))
	print(value)
	if state and tonumber(value) then
		if not isEventHandlerAdded("onClientRender", getRootElement(), expUp) then
		addEventHandler("onClientRender", getRootElement(), expUp)
		if exps and ilk then
			if not isTimer(timer) then
			timer = setTimer(function()
			local guncel_exp = getElementData(localPlayer, "exp")
			if ilk >= maxexp then
			local fark = guncel_exp - maxexp
			ilk = 0
			tilk = 0
			maxexp = maxexp + 1000
			setElementData(localPlayer, "maxexp", maxexp)
			setElementData(localPlayer, "exp", fark)
			levelTrigger()
			else
			if ilk < guncel_exp then
			ilk = ilk + loads
			tilk = ilk
			else
			local last_timer = setTimer(function()
			if isTimer(timer) then killTimer(timer) end
			removeEventHandler("onClientRender", getRootElement(), expUp)
			end, 1200, 1)
			end
			end
			end, yuklenmeSuresiHesapla(tonumber(value)), 0, true)
			end
		end
		end
	elseif not state and tonumber(value) then
		if not isEventHandlerAdded("onClientRender", getRootElement(), expUp) then
		addEventHandler("onClientRender", getRootElement(), expUp)
		if exps and ilk then
			timer = setTimer(function()
			if ilk ~= exps then
			ilk = ilk - loads
			tilk = ilk
			else
			local last_timer = setTimer(function()
			removeEventHandler("onClientRender", getRootElement(), expUp)
			end, 1200, 1)
			end
			end, yuklenmeSuresiHesapla(tonumber(value)), value+1, true)
		end
		end
	end
end
addEvent("giveExp", true)
addEventHandler("giveExp", root, expBarTrigger)


function seviyeHesapla(sayi)
    local basamakSayisi = math.floor(math.log10(sayi)) + 1
    local ilkBasamak = math.floor(sayi / 10^(basamakSayisi - 1))
    if ilkBasamak == 0 then
        return 1
    end
    return ilkBasamak
end

function levelTrigger()
	triggerServerEvent("seviyeAtlama", localPlayer)
	local plr_level = getElementData(localPlayer, "level") or 1
	setElementData(localPlayer, "level", plr_level+1)
	if not isEventHandlerAdded("onClientRender", getRootElement(), levelbar) then addEventHandler("onClientRender", getRootElement(), levelbar) local sound = playSound("SFX/levelup.mp3") setSoundVolume(sound, 0.5) end
	setTimer(function()
	stopSound(sound)
	removeEventHandler("onClientRender", getRootElement(), levelbar)
	end, 6800, 1)
end



    function levelbar()
		local detailed_level = getElementData(localPlayer, "level")-1
        dxDrawText("SEVİYE ATLADIN!\nYeni seviye: "..detailed_level, 494 - 1, 601 - 1, 893 - 1, 638 - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, true, false)
        dxDrawText("SEVİYE ATLADIN!\nYeni seviye: "..detailed_level, 494 + 1, 601 - 1, 893 + 1, 638 - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, true, false)
        dxDrawText("SEVİYE ATLADIN!\nYeni seviye: "..detailed_level, 494 - 1, 601 + 1, 893 - 1, 638 + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, true, false)
        dxDrawText("SEVİYE ATLADIN!\nYeni seviye: "..detailed_level, 494 + 1, 601 + 1, 893 + 1, 638 + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, true, false)
        dxDrawText("SEVİYE ATLADIN!\nYeni seviye: "..detailed_level, 494, 601, 893, 638, tocolor(254, 45, 23, 255), 1.00, "bankgothic", "center", "center", false, false, false, true, false)
    end

