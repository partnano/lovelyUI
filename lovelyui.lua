local u8 = require 'utf8'

local lg = love.graphics

-- local function decl
local print_table
local perc_to_abs

-- base settings
local lui = {
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

lui.draw_stack = {}

function lui:set_defaults (conf)
    
    if conf.width         ~= nil then lui.width         = conf.width         end
    if conf.height        ~= nil then lui.height        = conf.height        end
    if conf.perc_coords   ~= nil then lui.perc_coords   = conf.perc_coords   end
    if conf.uft8_supp     ~= nil then lui.utf8_supp     = conf.uft8_supp     end
    if conf.border        ~= nil then lui.border        = conf.border        end
    if conf.border_color  ~= nil then lui.border_color  = conf.border_color  end
    if conf.text_smooth   ~= nil then lui.text_smooth   = conf.text_smooth   end
    if conf.smooth_speed  ~= nil then lui.smooth_speed  = conf.smooth_speed  end
    if conf.fin_indicator ~= nil then lui.fin_indicator = conf.fin_indicator end
    
end

function lui:new_textbox (lines, x, y, w, h, img)

    local t = {}

    t._type = "text"
    
    if lui.perc_coords then
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
    t._visible   = true
    
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
    
    table.insert (lui.draw_stack, t)
    return t
 
end

function lui:new_selectionbox (lines, x, y, w, h)

    local s = {}

    s._type = 'selection'
    
    if lui.perc_coords then
	s.x, s.y = perc_to_abs (x, y)
	s.w, s.h = perc_to_abs (w, h)
    else
	s.x, s.y = x, y
	s.w, s.h = w, h
    end

    s.lines   = lines
    s._i      = 1
    s._visible = true
    
    function s:curr_hover ()
	return s.lines[s._i], s._i
    end

    function s:up ()
	if s._i > 1 then s._i = s._i -1 end
    end

    function s:down ()
	if s._i < #s.lines then s._i = s._i +1 end
    end

    table.insert (lui.draw_stack, s)
    return s

end

function lui:new_layout (x, y, w, h)

end

function lui:draw ()   
    -- iterate over draw_stack
    for i, e in pairs (lui.draw_stack) do
	if e._visible then

	    lg.setColor (lui.border_color)
	    lg.rectangle ('line', e.x, e.y, e.w, e.h)

	    if e._type == 'text' then
		lg.printf (e.curr_line, e.x +10, e.y +10, e.w, 'left')
	    elseif e._type == 'selection' then
		for k, line in ipairs (e.lines) do
		    local tmp = "   "
		    if k == e._i then tmp = ">  " end
		    lg.printf (tmp..line, e.x +10, e.y +10 +(k-1)*20, e.w, 'left')
		end
	    end

	end
    end
end

-- local functions
perc_to_abs = function (x, y)
    -- small integritycheck
    if lui.width  == nil then lui.width  = lg.getWidth  () end
    if lui.height == nil then lui.height = lg.getHeight () end
    return (lui.width /100) *x, (lui.height /100) *y
end


print_table = function (t)
    for k, v in pairs (t) do
	print (k, v)
    end
    print ("===========\n")
end


return lui
