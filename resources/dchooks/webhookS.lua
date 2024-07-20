

local webhooks = {

["discordcheck"] = "https://discord.com/api/webhooks/1261381973566296124/JsgnNhVVINtYnHb_ms0OsJLKRv85bqZ5D9-Wdz9RcHnR-2MLIs2by3M-op2_qM0sAUjO",
["kayit"] = "https://discord.com/api/webhooks/1261431813235282054/KbP7IKQ30dvjIiXaFrRBlzvJfuTszFKvPfmtQPGG7bc6Jvm-TfviCNOwavhUu_ZhMFUl",
["checklog"] = "https://discord.com/api/webhooks/1261442897899814952/4y55gZVrwDmfVTfP-WJrq8_w7uT1mneLCl7JcRq40umtny44P7hLAgf-3E_IUhFbKY70",
["detectlog"] = "https://discord.com/api/webhooks/1262056888468635699/T4HIf7hb2cmvdI-IB6F4h3D4iKJ067sOa5Xn1o_O_qxcF2aAYKtYLEwo6LRcVz9Ogsc8",

}


function sendDiscordMessage(webhookid, message)
if webhooks[webhookid] ~= nil then
sendOptions = {
    formFields = {
        content=message
    },
}
fetchRemote ( webhooks[webhookid], sendOptions, WebhookCallback )
end
end
addEvent("sendDiscordMessage", true)
addEventHandler("sendDiscordMessage", root, sendDiscordMessage)

function WebhookCallback(responseData) 

end




