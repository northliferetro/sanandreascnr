

local function getPlayerCustomName(player) -- ИМЯ ФАМИЛИЯ
	local FIRST_NAME = getElementData(player, "Name") --свою переменную 
	local LAST_NAME = getElementData(player, "Familia")--свою переменную 
	
	if not FIRST_NAME or not LAST_NAME then
		return getPlayerName(player)
	end
	
	return tostring(FIRST_NAME.." "..LAST_NAME)
end


local drawDistance = 17 --меняйте на свое значение - если нужно!
g_StreamedInPlayers = {}


function drawHPBar(x, y, v, d)
  if v < 0 then
    v = 0
  elseif v > 100 then
    v = 100
  end
  dxDrawRectangle(x - 21, y, 42, 5, tocolor(0, 0, 0, 255 - d))
  dxDrawRectangle(x - 20, y + 1, v / 2.5, 3, tocolor(192,4,10,255))
end


function drawArmourBar(x, y, v, d)
  if v < 0 then
    v = 0
  elseif v > 100 then
    v = 100
  end
  dxDrawRectangle(x - 21, y, 42, 5, tocolor(0, 0, 0, 255 - d))
  dxDrawRectangle(x - 20, y + 1, v / 2.5, 3, tocolor(255, 255, 255, 255 - d))
end


function drawHud()
  healthColor = tocolor(0, 0, 0, 255)
  healthbgColor = tocolor(255, 151, 0, 127)
  healthfgColor = tocolor(255, 151, 0, 185)
  sx, sy = guiGetScreenSize()
  healthx = sx / 800 * 683
  healthy = sy / 600 * 89
  healthxoverlay = sx / 800 * 685
  healthyoverlay = sy / 600 * 91
  vehiclehealthx = sx / 800 * 619
  vehiclehealthy = sy / 600 * 169
  vehiclehealthxoverlay = sx / 800 * 621
  vehiclehealthyoverlay = sy / 600 * 171
  if not normalhealthbar then
    local health = getElementHealth(getLocalPlayer())
    local armour = getPedArmor(getLocalPlayer())
    local rate = 500 / getPedStat(getLocalPlayer(), 24)
    if getElementHealth(getLocalPlayer()) == 0 then
      if 500 > getTickCount() - visibleTick then
        do
          local healthRelative = health * rate / 100
          local v = health * rate
          dxDrawRectangle(healthx, healthy, 76, 12, healthColor, false)
          dxDrawRectangle(healthxoverlay, healthyoverlay, 72, 8, tocolor((100 - v) * 2.55, v * 2.55, 0, 127), false)
          dxDrawRectangle(healthxoverlay, healthyoverlay, 72 * healthRelative, 8, tocolor((100 - v) * 2.55, v * 2.55, 0, 185), false)
        end
      elseif getTickCount() - visibleTick >= 1000 then
        visibleTick = getTickCount()
      end
    else
      local healthRelative = health * rate / 100
      local v = health * rate
      dxDrawRectangle(healthx, healthy, 76, 12, healthColor, false)
      dxDrawRectangle(healthxoverlay, healthyoverlay, 72, 8, tocolor((100 - v) * 2.55, v * 2.55, 0, 127), false)
      dxDrawRectangle(healthxoverlay, healthyoverlay, 72 * healthRelative, 8, tocolor((100 - v) * 2.55, v * 2.55, 0, 185), false)
    end
  end
end


function unfuck(text)
  return string.gsub(text, "(#%x%x%x%x%x%x)", function(colorString)
    return ""
  end)
end

function hexToRGB(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)

    return r, g, b
end

function onClientRender()
  if getElementData(localPlayer, "logged") then
  local cx, cy, cz, lx, ly, lz = getCameraMatrix()
  if getElementData(localPlayer, "aranma") then
	local originalWidth, originalHeight = 1366, 768
	local screenWidth, screenHeight = guiGetScreenSize()
	local scaleX, scaleY = screenWidth / originalWidth, screenHeight / originalHeight
	dxDrawText("★", 1064 * scaleX, 169 * scaleY, 1083 * scaleX, 196 * scaleY, tocolor(226, 233, 21, 255), 2.00 * scaleY, "default", "left", "top", false, false, false, false, false)
	dxDrawText(getElementData(localPlayer, "aranma"), 1083 * scaleX, 177 * scaleY, 1349 * scaleX, 196 * scaleY, tocolor(217, 217, 217, 255), 1.20 * scaleY, "default-bold", "left", "center", false, false, false, false, false)
  end
  for k, player in pairs(g_StreamedInPlayers) do
    if isElement(player) and isElementStreamedIn(player) then
      do
        local vx, vy, vz = getPedBonePosition(player, 8)
        local dist = getDistanceBetweenPoints3D(cx, cy, cz, vx, vy, vz)
        if dist < drawDistance and isLineOfSightClear(cx, cy, cz, vx, vy, vz, true, false, false) then
          local x, y = getScreenFromWorldPosition(vx, vy, vz + 0.3)
          if x and y then
            local name = getPlayerName(player)
            local name2 = unfuck(getPlayerName(player))
            local w = dxGetTextWidth(name, 1, "default-bold")
            local h = dxGetFontHeight(1, "default-bold")
            dxDrawText(name2.." ("..getElementData(player, "id")..")", x - 1 - w / 2, y - 1 - h - 12, w, h, tocolor(0, 0, 0), 1, "default-bold")
			local tagcolor = getElementData(player, "tagcolor") or "#FFFFFF"
            dxDrawColorText(name.." ("..getElementData(player, "id")..")", x - w / 2, y - h - 12, w, h, tocolor(hexToRGB(tagcolor)), 1, "default-bold")
            local health = getElementHealth(player)
            local armour = getPedArmor(player)
            if health > 0 then
              local rate = 500 / getPedStat(player, 24)
              drawHPBar(x, y - 6, health * rate, dist)
              if armour > 0 then
                drawArmourBar(x, y - 12, armour, dist)
              end
            end
          end
        end
      end
    else
      table.remove(g_StreamedInPlayers, k)
    end
  end
end
end
addEventHandler("onClientRender", root, onClientRender)


function onClientElementStreamIn()
  if getElementType(source) == "player" and source ~= getLocalPlayer() then
    setPlayerNametagShowing(source, false)
    table.insert(g_StreamedInPlayers, source)
  end
end
addEventHandler("onClientElementStreamIn", root, onClientElementStreamIn)


function onClientResourceStart(startedResource)
  visibleTick = getTickCount()
  counter = 0
  normalhealthbar = false
  local players = getElementsByType("player")
  for k, v in pairs(players) do
    if isElementStreamedIn(v) and v ~= getLocalPlayer() then
      setPlayerNametagShowing(v, false)
      table.insert(g_StreamedInPlayers, v)
    end
  end
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)


function dxDrawColorText(str, ax, ay, bx, by, color, scale, font)
  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  while s do
    if cap == "" and col then
      color = tocolor(tonumber("0x" .. col:sub(1, 2)), tonumber("0x" .. col:sub(3, 4)), tonumber("0x" .. col:sub(5, 6)), 255)
    end
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
      dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
      ax = ax + w
      color = tocolor(tonumber("0x" .. col:sub(1, 2)), tonumber("0x" .. col:sub(3, 4)), tonumber("0x" .. col:sub(5, 6)), 255)
    end
    last = e + 1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str then
    cap = str:sub(last)
    local w = dxGetTextWidth(cap, scale, font)
    dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
  end
end
