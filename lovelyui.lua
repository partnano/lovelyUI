local lg = love.graphics

local lovelyui = {
    perc_coords   = true,
    utf8_supp     = true,
    border        = 'rectangle',
    border_color  = {0, 0, 0},
    text_color    = {0, 0, 0},
    text_smooth   = true,
    smooth_speed  = 30,
    fin_indicator = true
}

function lovelyui:set_defaults (conf)

    print_table (lovelyui)
    
    if conf.perc_coords   ~= nil then lovelyui.perc_coords   = conf.perc_coords   end
    if conf.uft8_supp     ~= nil then lovelyui.utf8_supp     = conf.uft8_supp     end
    if conf.border        ~= nil then lovelyui.border        = conf.border        end
    if conf.border_color  ~= nil then lovelyui.border_color  = conf.border_color  end
    if conf.text_smooth   ~= nil then lovelyui.text_smooth   = conf.text_smooth   end
    if conf.smooth_speed  ~= nil then lovelyui.smooth_speed  = conf.smooth_speed  end
    if conf.fin_indicator ~= nil then lovelyui.fin_indicator = conf.fin_indicator end
    
    print_table (lovelyui)
    
end

-- DEBUG AREA
function print_table (t)
    for k, v in pairs (t) do
	print (k, v)
    end
    print ("===========\n")
end


return lovelyui
