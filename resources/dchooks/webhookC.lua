function sendDiscordMessage( message )
	if ( message ) then
		exports.anticheat:triggerSafeServerEvent("tea", "webhook > send_message", 37, resourceRoot, "webhook > send_message", message)
	end
end
