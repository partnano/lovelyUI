# lovelyUI - a simple LÖVE UI library

---

This little library is supposed to help you to quickly set up a simple UI, which however leaves you as much freedom as you want. It offers simple element creation, percentage based positioning, a simple text animation and other things. Most of the options can be configured, so, for example, shouldn't you like that x=100 is the rightmost edge of the window, just turn the functionality off!

**Hey folks, small lua-style disclaimer**: Although I don't always use *self* in functions I generally differentiate between attributes (table.attribute) and functions (table:function)

## how to use

Simply download the lovelyui.lua file and require it in your project like this:

    lovelyui = require 'path.to.folder.lovelyui'

and execute the lovelyui update and draw functions in the respective love.update and love.draw functions (or whatever you use) like this:

	function love.update (dt)
		lovelyui:update (dt)
	end

	function love.draw ()
		lovelyui:draw ()
	end

## example

![here should be an example](https://github.com/partnano/lovelyui/blob/master/example.gif "Example")

(image currently depicts older version)  
for the code, see ***main.lua***

## how to configure

Via the  
    
    :set_defaults ({--array of options--})

function, you can set your base config. These options are available (with their respective default values):

    width, height    = window width & height         -- for percentage positioning calculations
    perc_coords      = true                          -- percentage position turned on / off
    box              = lovelyui.box_themes.rectangle -- theme for the elements (function)
    text_padding     = 10                            -- inner distance text to border
    text_anim        = true                          -- text animation turned on / off
    smooth_speed     = 10                            -- animation speed in ms

Most of these options are configurable on an element basis as well.

## elements

Currently 3 types of elements & a simple layouting mechanism are available:

### text box

A textbox that displays text and optionally an image.

    :new_textbox (lines, x, y, width, height, [image])

            lines:  an array of strings, which will be displayed in the textbox  
             x, y:  top right screen coordinates (will be recalculated if perc_coords = true)
	width, height:  size (will be recalculated if perc_coords = true)
            image:  optional possibility to also display an image in the top right of the box

These attributes and functions are available:

        lines:  array of all the text lines
    curr_line:  the currently displayed line
          img:  the image displayed

          next():  display next line in array
          prev():  display prev line in array
    reset_anim():  resets text animation of current line (no effect if text_anim = false)

### selection box

A box of horizontal options (text lines) with indicator (currently a ">")

    :new_selectionbox (lines, x, y, width, height)

    for variable description see above

These attributes and functions are available:

    lines:  array of all the options
    
    curr_hover():  returns the line / option that is currently indicated
            up():  moves indicator up
          down():  moves indicator down

### yes / no selection box

A small yes / no dialogue

    :new_ynbox (text, x, y, width, height)

    text:  the string displayed in the box
	for rest see above

These attributes and functions are available:

	    text:  displayed string
	yes_text:  string for the yes answer
	 no_text:  string for the no answer
	 yn_font:  font for the yes / no strings

	yes():  yes action
	 no():  no action

The yes & no functions are special, as you have to define them yourself, as they are not doing much per default (just printing a statement).

example:

	function my_ynbox:yes ()
		level_up_char ()
		print ("Level upped your character!")
	end

### layouts

Layouts are non-drawn elements to manage and group other elements. These are really only useful with percentage based positioning,
since they scale and position relative to the layout values. (e.g. x=0 is layout-x and x=100 is layout-x+layout-w

	:new_layout (x, y, width, height)

These attributes and functions are available:

	elements:  the elements managed by this layout

	   add_element(e):  add an element to the layout
	remove_element(e):  removes specified element from the layout

### general attributes & functions

these attributes and functions are available for all elements:

	         padding:  distance text to border
	       box_theme:  the theme of the element
	            font:  font of the text in the element
    (attributes don't affect layouts)

	 get_pos():  returns pixel position
    get_size():  returns pixel size
	 set_pos():  sets element position (& recalcs if percentage based)
	set_size():  sets element size (& recalcs if percentage based)
	    hide():  hides element (doesn't get drawn until show() is called)
	    show():  shows element if it was hidden

A global active mechanism is available as well, for focusing a single element and calling an action easily globally:

	lovelyui:set_active(e): sets specified element to active one
	lovelyui:get_active():  returns current active element (nil if there isn't one)

	all this methods are available globally without throwing an error,
	however will only do something for the respective elements
	lovelyui:up(), down(), next(), prev(), yes(), no()

### themes

For now there are 3 default themes:

	lovelyui.box_themes.def1
	lovelyui.box_themes.def2
	lovelyui.box_themes.old_school

These are not really special at all, but this was not the intended goal. For your own purposes just define a theme function that takes 4-6 parameters:

	function (x, y, width, height, [active, [element]])

	         x, y:  top right pixel coordinates of element
	width, height:  pixel size of element
		   active:  true/false depending if the element is active
	            e:  the element itself if anything else is needed (optional)

Here is a simple example (for some other examples look in the library code ;) ):

	rounded_rectangle = function (x, y, w, h, a)	
		lg.setColor ({230, 230, 230})
		lg.rectangle ('fill', x, y, w, h, 10, 10, 10)

	    if a then lg.setColor ({20, 230, 20})
	    else lg.setColor ({80, 80, 80}) end
	
	    lg.rectangle ('line', x, y, w, h, 10, 10, 20)

	    -- last setcolor is for the text color
	    lg.setColor ({20, 20, 20})
    end

Assign your function to either the base option lovelyui.box_theme or to any element.box_theme and you're set!

---

## license

The MIT License (MIT)  
Copyright (c) 2016 Bernhard Wick

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
