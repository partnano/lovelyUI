local u8 = require 'utf8'

local lg = love.graphics

-- local function decl
local new_box
local print_table
local perc_to_abs

-- local vars
local id_count = 0

-- base settings
local lui = {
    width, height    = nil, nil,
    perc_coords      = true,
    box_theme        = nil,  -- set a bit later in code
    text_anim        = true,
    text_padding     = 10,
    smooth_speed     = 10
}

lui.draw_stack = {}  -- for drawing of elements
lui.anim_stack = {}  -- for text animation

-- set defaults, everything is purely optional
function lui:set_defaults (conf)
    
    if conf.width            ~= nil then lui.width            = conf.width            end
    if conf.height           ~= nil then lui.height           = conf.height           end
    if conf.perc_coords      ~= nil then lui.perc_coords      = conf.perc_coords      end
    if conf.box              ~= nil then lui.box              = conf.box              end
    if conf.text_smooth      ~= nil then lui.text_smooth      = conf.text_smooth      end
    if conf.smooth_speed     ~= nil then lui.smooth_speed     = conf.smooth_speed     end
    
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
    t._l        = ""           -- for text animation
    t._lt       = 0            -- for text animation
    t._lc       = 1            -- for text animation
    
    -- show the next line in the lines array, if available
    function t:next ()
	if t.lines[t._i +1] ~= nil then
	    t._i = t._i +1
	    t.curr_line = lines[t._i]
	    t:reset_anim ()
	end
    end

    -- show the previous line in the lines array, if available
    function t:prev ()
	if t.lines[t._i -1] ~= nil then
	    t._i = t._i -1
	    t.curr_line = lines[t._i]
	    t:reset_anim ()
	end
    end

    function t:reset_anim ()
	-- remove from anim_stack, so no double effects happen
	for k, v in ipairs (lui.anim_stack) do
	    if t._id == v._id then table.remove (lui.anim_stack, k) end
	end

	-- base values for text animation
	t._l = ""
	t._lt = 0
	t._lc = 1
	table.insert (lui.anim_stack, t)
    end

    -- if this is the first object, set it active
    if lui._act == nil then lui:set_active (t) end

    -- insert into draw stack, anim_stack and return it for the user
    table.insert (lui.anim_stack, t)
    table.insert (lui.draw_stack, t)
    return t
 
end

-- create and return a new selectionbox
-- gets added to the draw stack
function lui:new_selectionbox (lines, x, y, w, h)

    -- be a base box
    local s = new_box (x, y, w, h)

    s._type     = 'selection' -- what this is, important for draw_stack
    s.lines     = lines       -- text displayed
    s.indicator = ">"

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

function lui:new_ynbox (text, x, y, w, h)

    local yn = new_box (x, y, w, h)

    yn._type = 'yn'
    yn.text  = text
    yn.yes_text = 'Yes'
    yn.no_text = 'No'
    yn.yn_font = yn.font

    -- functions meant to be overridden by the user
    -- meant to be kept simple
    function yn:yes () print ('User chose yes!') end
    function yn:no  () print ('User chose no!')  end

    table.insert (lui.draw_stack, yn)
    return yn
end

function lui:new_layout (x, y, w, h)

    local l = new_box (x, y, w, h)

    l._type = 'layout'
    l.elements = {}
    
    function l:add_element (e)
	if e._suptype ~= 'box' then
	    print ("Trying to add non lovelyUI element!")
	else
	    e._layout = l
	    e:set_size (e._bw, e._bh)
	    e:set_pos (e._bx, e._by)

	    table.insert (l.elements, e)
	end
    end

    function l:remove_element (e)
	if e._suptype ~= 'box' then
	    print ("Trying to remove a non lovelyUI element!")
	else
	    for k, v in pairs (l.elements) do
		if v._id == e._id then
		    table.remove (l.elements, k)
		    e._layout = nil

		    -- setting of the new active element, should the removed one be the active
		    if l._act == e then
			if l.elements[k+1] ~= nil then l._act = l.elements[k+1]
			elseif l.elements[k-1] ~= nil then l._act = l.elements[k-1]
			else
			    l._act = nil
			end
		    end
		end
	    end
	end
    end

    return l
    
end

-- global active-mechanism handling .. rather simple really
function lui:set_active (box) lui._act = box end
function lui:get_active () return lui._act end
function lui:up   () lui._act:up   () end
function lui:down () lui._act:down () end
function lui:next () lui._act:next () end
function lui:prev () lui._act:prev () end
function lui:yes  () lui._act:yes  () end
function lui.no   () lui._act:no   () end

-- some default box themes
-- pure love2d drawings
lui.box_themes = {
    def1 = function (x, y, w, h, a)	
	if a then lg.setColor ({230, 230, 230})
	else lg.setColor ({180, 180, 180}) end
	lg.rectangle ('fill', x-3, y-3, w+6, h+6, 5, 5, 5)

	if a then lg.setColor ({0, 0, 0})
	else lg.setColor ({30, 30, 30}) end
	
	lg.rectangle ('line', x, y, w, h, 5, 5, 30)
	lg.rectangle ('line', x-3, y-3, w+6, h+6, 5, 5, 30)

	-- last color is also the text color
	lg.setColor ({20, 20, 20})
    end,

    def2 = function (x, y, w, h, a)
	if a then lg.setColor ({15, 15, 15})
	else lg.setColor ({30, 30, 30}) end
	lg.rectangle ('fill', x-3, y-3, w+6, h+6, 5, 5, 5)

	if a then lg.setColor ({240, 240, 240})
	else lg.setColor ({200, 200, 200}) end
	
	lg.rectangle ('line', x, y, w, h, 5, 5, 30)
	lg.rectangle ('line', x-3, y-3, w+6, h+6, 5, 5, 30)

	-- last color is also the text color
	lg.setColor ({200, 200, 200})
    end,

    old_school = function (x, y, w, h)
	-- this does not care about active
	lg.setColor ({255, 255, 255})
	lg.rectangle ('fill', x, y, w, h, 20, 20, 2)

	lg.setColor ({0, 0, 0})
	lg.rectangle ('line', x, y, w, h, 20, 20, 2)
	lg.rectangle ('line', x-1, y-1, w+2, h+2, 20, 20, 2)

	-- text color
	lg.setColor ({0, 0, 0})
    end
}

-- default box_theme
lui.box_theme = lui.box_themes.def2

-- this handles timed data structures
function lui:update (dt)

    -- if text animation is turned off, just draw the full line
    if lui.text_anim == false then
	for i, e in ipairs (lui.anim_stack) do
	    e._l = e.curr_line
	end
	lui.anim_stack = {}
    else

	-- if text animation is turned on, draw only letters at a time
	for i, e in ipairs (lui.anim_stack) do
	    if e._visible then

		-- element timer to determine when (and how many) letters are drawn in the frame
		e._lt = e._lt +dt
		while e._lt > lui.smooth_speed /1000 do -- smooth speed in milliseconds

		    -- find beginning letter to draw (utf8 compatible)
		    local o = u8.offset (e.curr_line, e._lc)

		    -- if not at the end of the line, find beginning of next letter
		    -- next letter -1 byte = end of current letter
		    if e._lc < #e.curr_line then
			local o2 = u8.offset (e.curr_line, e._lc+1)
			e._l = e._l .. e.curr_line:sub (o, o2 -1)
		    else
			e._l = e._l .. e.curr_line:sub (o)
		    end

		    -- set counter for the next letter
		    e._lc = e._lc +1
		    -- deduct time for next drawing
		    e._lt = e._lt - lui.smooth_speed /1000

		    -- end, if the whole line is drawn
		    if e._lc > u8.len (e.curr_line) then
			table.remove (lui.anim_stack, i)
			break
		    end
		end
		
	    end
	end

    end
    
end

-- this handles all the UI drawing
function lui:draw ()   

    -- get current font and color for reset purposes
    local curr_font = lg.getFont ()
    local curr_color = {lg.getColor ()}
    
    -- iterate over draw_stack
    for i, e in ipairs (lui.draw_stack) do
	if e._visible then
	    -- this is not ready for anything other than the 'box' suptype

	    local x, y = e.get_pos  ()
	    local w, h = e.get_size ()
	    local p = e.padding
	    
	    if e._layout ~= nil then
		local l = e._layout

		x, y = x +l._x, y +l._y		
	    end

	    local a = e._id == lui:get_active()._id
	    
	    e.box_theme (x, y, w, h, a, e)
	    lg.setFont (e.font)
	    
	    if e._type == 'text' then
		if e.img ~= nil then
		    -- if it's a box with image, short reset to base color for the image
		    text_col = {lg.getColor()}
		    lg.setColor (curr_color)

		    local iw = e.img:getWidth ()
		    lg.draw (e.img, x +p, y +p)
		    
		    lg.setColor (text_col)
		    lg.printf (e._l, x +2*p +iw, y +p, w -3*p -iw, 'left')

		else		    
		    lg.printf (e._l, x +p, y +p, w -2*p, 'left')
		end

	    elseif e._type == 'selection' then
		-- for a selectionbox print all the text
		-- but handle the hover line differently
		
		m = e.font:getWidth("M")
		for k, line in ipairs (e.lines) do

		    local breaks = ""
		    for j = 1, k-1 do breaks = breaks.."\n" end
		    
		    if k == e._i then lg.printf (breaks..e.indicator, x +p, y +2*p, w -2*p, 'left') end		    
		    lg.printf (breaks..line, x +p +m, y +2*p, w -2*p+40, 'left')

		end
		
	    elseif e._type == 'yn' then

		local fw = e.font:getWidth (e.no_text)
		local fh = e.font:getHeight ()

		-- perfect. /s (this maybe needs some fixing)
		lg.printf (e.text, x+p, y+p, w-2*p, 'center')

		lg.setFont (e.yn_font)
		fw = e.yn_font:getWidth (e.no_text)
		fh = e.yn_font:getHeight ()
		
		lg.printf (e.yes_text, x+3*p, y+h-2*p-fh, w/2, 'left')
		lg.printf (e.no_text, x+w-3*p-fw, y+h-2*p-fh, w/2, 'left')
		
	    end

	end
    end

    -- restore state so dev doesn't get a random font
    lg.setFont (curr_font)
    lg.setColor (curr_color)
    
end

-- LOCAL FUNCTIONS

-- base box, parent object for the other boxes
new_box = function (x, y, w, h)

    local b = {}

    b._suptype = 'box'

    -- unchanged base values
    b._bx, b._by, b._bw, b._bh = x, y, w, h
    
    -- if settings say percentage, position and size need to be recalculated
    if lui.perc_coords then
	b._x, b._y = perc_to_abs (x, y)
	b._w, b._h = perc_to_abs (w, h)
    else
	b._x, b._y = x, y
	b._w, b._h = w, h
    end

    b._i = 1                     -- which line is currently relevant
    b._visible = true            -- if object is drawn
    b.padding = lui.text_padding -- text distance from border

    b.font = lg.getFont ()       -- font used in the element

    b.box_theme = lui.box_theme
    
    -- get, set, hide, show and prep work for subobjects (so love / lua won't crash)
    function b:get_pos  () return b._x, b._y end
    function b:get_size () return b._w, b._h end
    function b:set_pos (sx, sy)
	if lui.perc_coords then
	    if b._layout ~= nil then b._x, b._y = perc_to_abs (sx, sy, b._layout:get_size())
	    else b._x, b._y = perc_to_abs (sx, sy)
	    end
	else b._x, b._y = sx, sy
	end
    end
    function b:set_size (sw, sh)
	if lui.perc_coords then
	    if b._layout ~= nil then b._w, b._h = perc_to_abs (sw, sh, b._layout:get_size())
	    else b._w, b._h = perc_to_abs (sw, sh)
	    end
	else b._w, b._h = sw, sh
	end
    end
    function b:hide () b._visible = false end
    function b:show () b._visible = true  end
    function b:up   () end
    function b:down () end
    function b:next () end
    function b:prev () end
    function b:yes  () end
    function b:no   () end

    b._id = id_count
    id_count = id_count +1
    
    -- done
    return b
    
end

-- calc for percentage to actual pixelcoords
perc_to_abs = function (x, y, w, h)
    -- small integritycheck
    if lui.width  == nil then lui.width  = lg.getWidth  () end
    if lui.height == nil then lui.height = lg.getHeight () end

    local _w, _h = w or lui.width, h or lui.height
    return (_w /100) *x, (_h /100) *y
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
