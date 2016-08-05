local lg = love.graphics

-- local function decl
local print_table
local perc_to_abs

-- base settings
local lovelyui = {
    width, height = nil, nil,
    perc_coords   = true,
    utf8_supp     = true,
    border        = 'rectangle',
    border_color  = {255, 255, 255},
    text_color    = {255, 255, 255},
    text_smooth   = true,
    smooth_speed  = 30,
    fin_indicator = true
}

lovelyui.draw_stack = {}

function lovelyui:set_defaults (conf)
    
    if conf.width         ~= nil then lovelyui.width         = conf.width         end
    if conf.height        ~= nil then lovelyui.height        = conf.height        end
    if conf.perc_coords   ~= nil then lovelyui.perc_coords   = conf.perc_coords   end
    if conf.uft8_supp     ~= nil then lovelyui.utf8_supp     = conf.uft8_supp     end
    if conf.border        ~= nil then lovelyui.border        = conf.border        end
    if conf.border_color  ~= nil then lovelyui.border_color  = conf.border_color  end
    if conf.text_smooth   ~= nil then lovelyui.text_smooth   = conf.text_smooth   end
    if conf.smooth_speed  ~= nil then lovelyui.smooth_speed  = conf.smooth_speed  end
    if conf.fin_indicator ~= nil then lovelyui.fin_indicator = conf.fin_indicator end
    
end

function lovelyui:new_textbox (lines, x, y, w, h, img)

    local t = {}
    
    if lovelyui.perc_coords then
	t.x, t.y = perc_to_abs (x, y)
	t.w, t.h = perc_to_abs (w, h)
    else
	t.x, t.y = x, y
	t.w, t.h = w, h
    end

    t.lines     = lines
    t._i        = 1
    t.curr_line = lines[t._i]
    t.img       = img or nil
    t.visible   = true

    function t:next_line ()
	if t.lines[t._i +1] ~= nil then
	    t._i = t._i +1
	    t.curr_line = lines[t._i]
	end
    end

    function t:prev_line ()
	if t.lines[t._i -1] ~= nil then
	    t._i = t._i -1
	    t.curr_line = lines[t._i]
	end
    end
    
    table.insert (lovelyui.draw_stack, t)
    return t
 
end

function lovelyui:new_selectionbox (lines, x, y, w, h)

end

function lovelyui:new_layout (x, y, w, h)

end

function lovelyui:draw ()
    
    -- iterate over draw_stack
    for i, e in pairs (lovelyui.draw_stack) do
	lg.setColor (lovelyui.border_color)
	lg.rectangle ('line', e.x, e.y, e.w, e.h)
	lg.printf (e.curr_line, e.x +10, e.y +10, e.w, 'left')
    end
    
end

-- local functions
perc_to_abs = function (x, y)
    -- small integritycheck
    if lovelyui.width  == nil then lovelyui.width  = lg.getWidth  () end
    if lovelyui.height == nil then lovelyui.height = lg.getHeight () end
    return (lovelyui.width /100) *x, (lovelyui.height /100) *y
end


print_table = function (t)
    for k, v in pairs (t) do
	print (k, v)
    end
    print ("===========\n")
end


return lovelyui
