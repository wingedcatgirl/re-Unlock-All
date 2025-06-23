--#region re:Unlock All
REUNLOCK = REUNLOCK or {}
---Debug messaging
---@param message string The message
---@param level? string Log level
function REUNLOCK.say(message, level)
    local date = os.date('%Y-%m-%d %H:%M:%S')
    local logger = "re:Unlock All"
    message = message or "???"
    level = level or "DEBUG"
    while #level < 5 do
        level = level.." "
    end
    print(date .. " :: " .. level .. " :: " .. logger .. " :: " .. message)
end

---Checks whether everything is, in fact, unlocked
---@return boolean
REUNLOCK.check = function()
    for k, v in pairs(G.P_CENTERS) do
        if not (v.discovered and v.unlocked) then
            --REUNLOCK.say("Locked center found")
            return false
        end
    end
    for k, v in pairs(G.P_BLINDS) do
        if not (v.discovered and v.unlocked) then
            --REUNLOCK.say("Locked blind found")
            return false
        end
    end
    for k, v in pairs(G.P_TAGS) do
        if not (v.discovered and v.unlocked) then
            --REUNLOCK.say("Locked tag found")
            return false
        end
    end

    return true
end
--#endregion re:Unlock All