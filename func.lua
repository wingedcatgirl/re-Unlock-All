--#region re:Unlock All
REUNLOCK = REUNLOCK or {}
REUNLOCK.mod_unlock = {
    current_option = 1,
    option_value = "Vanilla"
}
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

---Checks whether everything (in a specified mod) is, in fact, unlocked
---@param mod string ID of the mod to check; checks everything by default
---@return boolean
REUNLOCK.check = function(mod, debug)
    mod = (mod or "all")
    local found = false

    for k, v in pairs(G.P_CENTERS) do
        if not (v.discovered and v.unlocked) then
            if (mod == "all") or (mod == "vanilla" and not v.mod) or (v.mod and v.mod.id == mod) then
                if debug then
                    REUNLOCK.say("Locked center found: "..k)
                    found = true
                else
                    return false
                end
            end
        end
    end
    for k, v in pairs(G.P_BLINDS) do
        if not (v.discovered) then
            if (mod == "all") or (mod == "vanilla" and not v.mod) or (v.mod and v.mod.id == mod) then
                if debug then
                    REUNLOCK.say("Locked blind found: "..k)
                    found = true
                else
                    return false
                end
            end
        end
    end
    for k, v in pairs(G.P_TAGS) do
        if not (v.discovered) then
            if (mod == "all") or (mod == "vanilla" and not v.mod) or (v.mod and v.mod.id == mod) then
                if debug then
                    REUNLOCK.say("Locked tag found: "..k)
                    found = true
                else
                    return false
                end
            end
        end
    end

    return not found
end
--#endregion re:Unlock All