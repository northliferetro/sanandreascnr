sx, sy = guiGetScreenSize()
 -- tasarımı yapan kişinin ekran boyutları.
dev_screen = {1366,768} 
function setScreenPosition (x, y, w, h)
    return ((x / dev_screen[1]) * sx), ((y / dev_screen[2]) * sy), ((w / dev_screen[1]) * sx), ((h / dev_screen[2]) * sy)
end


renkler = {
    byz = tocolor(255,255,255),
    syh = tocolor(0,0,0,255),
    red = tocolor(0,255,0,255),
}

_dxDrawImage = dxDrawImage
_dxDrawRectangle = dxDrawRectangle
_dxDrawImageSection = dxDrawImageSection
_dxDrawText = dxDrawText
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    return _dxDrawImage (x, y, w, h, ...)
end
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    return _dxDrawRectangle (x, y, w, h, ...)
end
function dxDrawImageSection (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    return _dxDrawImageSection (x, y, w, h, ...)
end
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    return _dxDrawText (text, x, y, w, h, ...)
end
function dxDrawRoundedRectangle(radius,x,y,w,h,color,postGUI,subPixel,noTL,noTR,noBL,noBR)
	local x, y, w, h = setScreenPosition (x, y, w, h)
	local noTL = not noTL and dxDrawCircle(x+radius,y+radius,radius,180,270,color,color,9,1,postGUI) -- top left corner
	local noTR = not noTR and dxDrawCircle(x+w-radius,y+radius,radius,270,360,color,color,9,1,postGUI) -- top right corner
	local noBL = not noBL and dxDrawCircle(x+radius,y+h-radius,radius,90,180,color,color,9,1,postGUI) -- bottom left corner
	local noBR = not noBR and dxDrawCircle(x+w-radius,y+h-radius,radius,0,90,color,color,9,1,postGUI) -- bottom right corner
	_dxDrawRectangle(x+radius-(not noTL and radius or 0),y,w-2*radius+(not noTL and radius or 0)+(not noTR and radius or 0),radius,color,postGUI,subPixel) -- top rectangle
	_dxDrawRectangle(x,y+radius,w,h-2*radius,color,postGUI,subPixel) -- center rectangle
	_dxDrawRectangle(x+radius-(not noBL and radius or 0),y+h-radius,w-2*radius+(not noBL and radius or 0)+(not noBR and radius or 0),radius,color,postGUI,subPixel)-- bottom rectangle
	return isMouseInPosition(x,y,w,h)
end
function dxDrawButton(title,x,y,w,h,butonrengi,yazirenk,postGUI)
    local isHover = dxDrawRoundedRectangle(12,x,y,w,h,butonrengi or renkler.syh,postGUI,subPixel,noTL,noTR,noBL,noBR)
    dxDrawText(title,x,y,w,h,yazirenk or renkler.byz,1,"default","center","center",true,false,postGUI)
    return isHover
end


function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

-- local dx_elements = {}
-- addEventHandler("onClientRender",root,function()
	-- dx_elements.satinal = dxDrawButton("Satın Al",500,500,100,30)
	-- dx_elements.kapat = dxDrawButton("Satın Al",500,560,100,30)
	
	-- if dx_elements.satinal and isClicked() then
		
	-- elseif dx_elements.kapat and isClicked() then
		
	-- end
-- end)
















function isMouseInPosition(x,y,w,h)
	if not isCursorShowing() then
		return false
	end
	local cx,cy = getCursorPosition()
	local cx,cy = (cx*sx),(cy*sy)
	local x, y, w, h = setScreenPosition (x, y, w, h)
	return ((cx >= x and cx <= x+w) and (cy >= y and cy <= y+h))
end
local lastClick = getTickCount()
function isClicked()
	if getCursorAlpha() == 0 then return false end
	if getKeyState("mouse1") and lastClick < getTickCount() then lastClick=getTickCount()+1000 return true end
	return false
end
function cevir(number)  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end
function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end
function convertTime ( seconds ) 
	local min = math.floor ( ( seconds % 3600 ) /60 )
	local hou = math.floor ( ( seconds % 86400 ) /3600 )
	local sec = ( seconds %60 )
	return string.format("%02d:%02d:%02d", hou,min, sec) 
end 