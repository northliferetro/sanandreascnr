function xorEncryptDecrypt(input, key)
    local output = {}
    for i = 1, #input do
        local inputByte = input:byte(i)
        local keyByte = key:byte((i - 1) % #key + 1)
        table.insert(output, string.char(bitXor(inputByte, keyByte)))
    end
    return table.concat(output)
end

function bitXor(a, b)
    local result = 0
    for i = 0, 7 do
        local bitA = a % 2
        local bitB = b % 2
        if bitA ~= bitB then
            result = result + 2^i
        end
        a = (a - bitA) / 2
        b = (b - bitB) / 2
    end
    return result
end

function checkXMLValue(key, element)
    local xmlFile = xmlLoadFile("logins.xml")
    if not xmlFile then
        return false
    end
    local entries = xmlNodeGetChildren(xmlFile)

    local playerName = getPlayerName(element)
    
    for _, node in ipairs(entries) do
        local nodeKey = xmlNodeGetAttribute(node, "key")
        local nodeBefore = splitString(nodeKey, ":")[1] 
        if nodeBefore == playerName then
            local value = xmlNodeGetValue(node)
            xmlUnloadFile(xmlFile)
            return value
        end
    end
    
    xmlUnloadFile(xmlFile)
    return false
end


function updateXMLValue(key, newValue)
    local xmlFile = xmlLoadFile("logins.xml")
    if not xmlFile then
        return
    end
    local entries = xmlNodeGetChildren(xmlFile)
    for _, node in ipairs(entries) do
        local nodeKey = xmlNodeGetAttribute(node, "key")
        if nodeKey == key then
            xmlNodeSetValue(node, newValue)
            break
        end
    end
    xmlSaveFile(xmlFile)
    xmlUnloadFile(xmlFile)
end


