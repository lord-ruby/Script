ScriptConfigTag = function()
    if not Script.config.Enabled then Script.config.Enabled = {} end
    if not G.SCRIPT_PAGE then G.SCRIPT_PAGE = 1 end
    bstrp_nodes = {
    }
    bstrp_nodes2 = {
    }
    left_settings = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
    right_settings = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
    config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { left_settings, right_settings } }
    bstrp_nodes2[#bstrp_nodes2 + 1] = config
    local real_buffer = {}
    for i, v in ipairs(Script.files) do
        real_buffer[#real_buffer+1] = v.path
    end
    local page = (G.SCRIPT_PAGE and G.SCRIPT_PAGE * 6 or 6) - (6 - 1)
    local max_pages = math.floor(#real_buffer/6)
    if max_pages * 6 < #real_buffer then --idk why this is needed but it is
        max_pages = max_pages + 1
    end
    local sound_options = {}
    for i = 1, max_pages do
        table.insert(
            sound_options,
            localize("k_page") .. " " .. tostring(i) .. "/" .. tostring(max_pages)
        )
    end	
    for i = page, math.min(page + 6 - 1, #real_buffer) do
        local key = real_buffer[i]
        if Script.config.Enabled[key] == nil then
            Script.config.Enabled[key] = true
        end
        table.insert(bstrp_nodes, create_toggle({
            label = key,
            active_colour = HEX("40c76d"),
            ref_table = Script.config.Enabled,
            ref_value = key,
            callback = function()
                Script.save_config()
            end
        }))
    end
    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 10,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK,
        },
        nodes = {
            { n = G.UIT.R, config = { align = "cm", r = 0.1, colour = {0,0,0,0}, emboss = 0.05 }, nodes = bstrp_nodes2 },
            { n = G.UIT.R, config = { align = "cm", r = 0.1, colour = {0,0,0,0}, emboss = 0.05 }, nodes = bstrp_nodes },
            {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    create_option_cycle({
                        options = sound_options,
                        w = 4.5,
                        cycle_shoulders = true,
                        opt_callback = "script_set_config_page",
                        current_option = G.SCRIPT_PAGE or 1,
                        colour = G.C.RED,
                        no_pips = true,
                        focus_args = { snap_to = true, nav = "wide" },
                    }),
                },
            }
        },
    }
end
G.FUNCS.script_set_config_page = function(args)
    G.SCRIPT_PAGE = args.cycle_config.current_option
    G.FUNCS["openModUI_bstrp"]()
end
SMODS.current_mod.config_tab = ScriptConfigTag