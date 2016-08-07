local u8 = require 'utf8'

local lg = love.graphics

-- local function decl
local new_box
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

-- set defaults, everything is purely optional
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

-- create and return a new textbox
-- gets added to the draw_stack
function lui:new_textbox (lines, x, y, w, h, img)

    -- starting point: a base box
    local t = new_box (x, y, w, h)

    t._type     = "text"       -- what this is, important for draw_stack
    t.lines     = lines        -- all the text that can be displayed
    t.curr_line = lines[t._i]  -- the currently shown line
    t.img       = img or nil   -- TODO: the displayed image

    -- show the next line in the lines array, if available
    function t:next ()
	if t.lines[t._i +1] ~= nil then
	    t._i = t._i +1
	    t.curr_line = lines[t._i]
	end
    end

    -- show the previous line in the lines array, if available
    function t:prev ()
	if t.lines[t._i -1] ~= nil then
	    t._i = t._i -1
	    t.curr_line = lines[t._i]
	end
    end

    -- is this is the first object, set it active
    if lui._act == nil then lui:set_active (t) end

    -- insert into draw stack and return it for the user
    table.insert (lui.draw_stack, t)
    return t
 
end

-- create and return a new selectionbox
-- gets added to the draw stack
function lui:new_selectionbox (lines, x, y, w, h)

    -- be a base box
    local s = new_box (x, y, w, h)

    s._type = 'selection' -- what this is, important for draw_stack
    s.lines   = lines     -- text displayed

    -- text, which is currently indicated at
    function s:curr_hover ()
	return s.lines[s._i], s._i
    end

    -- move indicator up by one
    function s:up ()
	if s._i > 1 then s._i = s._i -1 end
    end

    -- move indicator down by one
    function s:down ()
	if s._i < #s.lines then s._i = s._i +1 end
    end

    -- first object to be created? set active
    if lui._act == nil then lui:set_active (s) end

    -- add to draw stack and return for the user
    table.insert (lui.draw_stack, s)
    return s

end

-- TODO: all the functionality
function lui:new_layout (x, y, w, h)

end

-- active-mechanism handling .. rather simple really
function lui:set_active (box) lui._act = box end
function lui:get_active () return lui._act end
function lui:up   () lui._act:up   () end
function lui:down () lui._act:down () end
function lui:next () lui._act:next () end
function lui:prev () lui._act:prev () end

-- this handles all the UI drawing
function lui:draw ()   

    -- iterate over draw_stackremove any  from here, this should be drawing ONLY
    for i, e in ipairs (lui.draw_stack) do
	if e._visible then
	    -- this is not ready for anything other than the 'box' suptype
	    
	    local x, y = e.get_pos ()
	    local w, h = e.get_size ()
	    
	    lg.setColor (lui.border_color)
	    lg.rectangle ('line', x, y, w, h)

	    -- for a textbox just print the current text
	    if e._type == 'text' then lg.printf (e.curr_line, x +10, y +10, w, 'left')
	    elseif e._type == 'selection' then
		-- for a selectionbox print all the text
		-- but handle the hover line differently
		-- TODO: this should be less magic-numbery
		for k, line in ipairs (e.lines) do
		    
		    if k == e._i then lg.printf (">", x +10, y +10 +(k-1)*20, w, 'left') end
		    lg.printf (line, x +30, y +10 +(k-1)*20, w, 'left')

		end
	    end

	end
    end
    
end

-- LOCAL FUNCTIONS

-- base box, parent object for the other boxes
new_box = function (x, y, w, h)

    local b = {}

    b._suptype = 'box'

    -- if settings say percentage, position and size need to be recalculated
    if lui.perc_coords then
	b._x, b._y = perc_to_abs (x, y)
	b._w, b._h = perc_to_abs (w, h)
    else
	b._x, b._y = x, y
	b._w, b._h = w, h
    end

    b._i = 1          -- which line is currently relevant
    b._visible = true -- if object is drawn

    -- get, set, hide, show and prep work for subobjects (so love / lua won't crash)
    function b:get_pos () return b._x, b._y end
    function b:get_size () return b._w, b._h end
    function b:set_pos (x, y)
	if lui.perc_coords then b._x, b._y = perc_to_abs (x, y)
	else b._x, b._y = x, y
	end
    end
    function b:set_size (w, h)
	if lui.perc_coords then b._w, b._h = perc_to_abs (w, h)
	else b._w, b._h = w, h
	end
    end
    function b:hide () b._visible = false end
    function b:show () b._visible = true  end
    function b:up   () end
    function b:down () end
    function b:next () end
    function b:prev () end

    -- done
    return b
    
end

-- calc for percentage to actual pixelcoords
perc_to_abs = function (x, y)
    -- small integritycheck
    if lui.width  == nil then lui.width  = lg.getWidth  () end
    if lui.height == nil then lui.height = lg.getHeight () end
    return (lui.width /100) *x, (lui.height /100) *y
end

-- simple debug print
print_table = function (t)
    for k, v in pairs (t) do
	print (k, v)
    end
    print ("===========\n")
end

-- return lib contents
return lui
