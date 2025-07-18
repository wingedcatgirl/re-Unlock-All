SMODS.Atlas({
    key = 'modicon',
    path = 'icon.png',
    px = 34,
    py = 34
})

--#region config
G.FUNCS.reunlock_optcycle = function(args)
    local refval = args.cycle_config.ref_value
    REUNLOCK[refval].current_option = args.cycle_config.current_option
    REUNLOCK[refval].option_value = args.to_val
end

---Unlocks all items on a per-mod basis
---@param mod string ID of the mod to unlock
G.FUNCS.reunlock_per_mod = function (mod)
    mod = (type(mod) == "string") and mod or REUNLOCK.mod_unlock.option_value
    --REUNLOCK.say("Time to unlock everything from "..mod)
    if not (mod == "Vanilla" or SMODS.Mods[mod]) then return end
    G.PROFILES[G.SETTINGS.profile].all_unlocked = true
    local count = 0
    for k, v in pairs(G.P_CENTERS) do
        if (mod == "all") or (mod == "Vanilla" and not v.mod) or (v.mod and v.mod.id == mod) then
            if not (v.discovered and v.unlocked) then
                count = count+1
            end
            v.alerted = true
            v.discovered = true
            v.unlocked = true
        end
    end
    for k, v in pairs(G.P_BLINDS) do
        if (mod == "all") or (mod == "Vanilla" and not v.mod) or (v.mod and v.mod.id == mod) then
            if not (v.discovered) then
                count = count+1
            end
            v.alerted = true
            v.discovered = true
            v.unlocked = true
        end
    end
    for k, v in pairs(G.P_TAGS) do
        if (mod == "all") or (mod == "Vanilla" and not v.mod) or (v.mod and v.mod.id == mod) then
            if not (v.discovered) then
                count = count+1
            end
            v.alerted = true
            v.discovered = true
            v.unlocked = true
        end
    end
    if count > 0 then
        set_profile_progress()
        set_discover_tallies()
        G:save_progress()
        G.FILE_HANDLER.force = true
        play_sound('explosion_release1')
    end
end

G.FUNCS.reunlock_clear_alerts = function ()
    for _, v in pairs(G.P_CENTERS) do
            v.alerted = true
    end
    for _, v in pairs(G.P_BLINDS) do
            v.alerted = true
    end
    for _, v in pairs(G.P_TAGS) do
            v.alerted = true
    end
    set_profile_progress()
    set_discover_tallies()
    G:save_progress()
    G.FILE_HANDLER.force = true
end

SMODS.current_mod.config_tab = function()
    local mods = REUNLOCK.check("vanilla") and {} or {"Vanilla"}
    for k,v in pairs(SMODS.Mods) do
        local id = v and v.id
        if not REUNLOCK.check(id) then
            table.insert(mods, id)
        end
    end
    local unlock_per_mod_button = UIBox_button({
                button = "reunlock_per_mod",
                label = {"Unlock all from selected mod"},
                colour = G.C.GREY,
                minw = 5.5
            })
    local unlock_per_mod_cycle = create_option_cycle {
                label = "Mods with unlocked/undiscovered features:",
                options = mods,
                current_option = REUNLOCK.mod_unlock.current_option,
                ref_table = REUNLOCK,
                ref_value = "mod_unlock",
                opt_callback = 'reunlock_optcycle',
                w = 5.5
            }
    local clear_alerts = UIBox_button({
                button = "reunlock_clear_alerts",
                label = {"Clear all (!) discovery alerts"},
                colour = G.C.GREY,
                minw = 5.5
            })
    local no_unlocks_left = {n = G.UIT.T, config = {text = "Nothing left to unlock, yo!", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, align = "cm"}}
    local buttons = {
        unlock_per_mod_cycle,
        unlock_per_mod_button,
        clear_alerts,
    }
    if next(mods) then
        REUNLOCK.mod_unlock = {
            current_option = 1,
            option_value = mods[1]
        }
    else
        buttons = {
            clear_alerts,
            --no_unlocks_left, --text nodes are janky as hell and i'm not dealing with them today 👍️
        }
    end

    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 8, minh = 6, align = "cm", padding = 0.2, colour = G.C.BLACK}, nodes = {
        {n = G.UIT.C, config = {minw=1, minh=1, align = "cm", colour = G.C.CLEAR, padding = 0.15}, nodes = buttons}
    }}
end
--#endregion