local function updateDiscordRichPresence()
    local meslek = config[getElementData(localPlayer, "meslekindex")] or false
    if meslek then
		local metin = ""
        local tarafskor = getElementData(localPlayer, "tarafskor")
		if tarafskor == "skorpolis" then metin = "mensubu olarak oynuyor." else metin = "sınıfında dehşet saçıyor." end
        local m_tarafskor = getElementData(localPlayer, tarafskor)
        local m_maxexp = config[getElementData(localPlayer, "maxexp")][2]
        local m_meslek = config[getElementData(localPlayer, "maxexp")][1]
		local m_tarafskor_show = m_tarafskor
		if m_tarafskor > m_maxexp then
		m_tarafskor_show = m_maxexp
		end
        setDiscordRichPresenceState("("..m_tarafskor_show.."/"..m_maxexp..") > "..m_meslek)
        setDiscordRichPresenceDetails(meslek[1].." "..metin)
        local buttonSuccess = setDiscordRichPresenceButton(1, "Connect to server", "mtasa://000.000.00.00")
        if not buttonSuccess then
           iprint("paltadık")
        end
    else
        iprint("meslek datası yok")
    end
end

function discordEvent()
    local app_id = "1261242487662575680"
    if setDiscordApplicationID(app_id) then 
        setDiscordRichPresenceAsset("logo", "San Andreas Hırsız Polis")
        updateDiscordRichPresence()
        setTimer(updateDiscordRichPresence, 5000, 0)
    else
        iprint("giremedik app'a")
    end
end
addEvent("discordEvent", true)
addEventHandler("discordEvent", root, discordEvent)