local lovelyui = require 'lovelyui'

local lg = love.graphics
local lw = love.window

function love.load ()

    lw.setMode (1600, 900)
    lg.setBackgroundColor ({40, 40, 40})

    img = lg.newImage ("dat/avatar.png")
    fon_flat = lg.newFont ("dat/Aileron-Regular.otf", 20)
    fon_fancy = lg.newFont ("dat/Merriweather-Regular.ttf", 24)
    
    lg.setFont (fon_flat)
    
    long_text = "Hello to this small example of my petproject: lovelyUI! This is a UI library mainly directed at adventure and RPG games. \n\nHere, have this: ¢"
    long_text2 = "Hey, look! Another line. \nAlso, the box below has another theme! :O"
    
    s1 = lovelyui:new_selectionbox ({"Option 1", "Option 2", "Option 3"}, 45, 15, 10, 20)
    t1 = lovelyui:new_textbox ({long_text, long_text2}, 10, 10, 30, 25, img)
    t1.padding = 20

    layout = lovelyui:new_layout (10, 40, 50, 50)

    y1 = lovelyui:new_ynbox ("Will you accept this box?", 50, 0, 45, 30)
    y1.yn_font = fon_fancy
    y1.no_text = "Nahh ..."

    t2 = lovelyui:new_textbox ({"This textbox and yes/no box are managed in a layout!"}, 0, 0, 45, 30)
    t2.font = fon_fancy
    t2.box_theme = lovelyui.box_themes.old_school

    layout:add_element (y1)
    layout:add_element (t2)
    
end

function love.keypressed (k)

    if k == 'escape' then love.event.quit () end

    if k == 'left'  then lovelyui:set_active (t1) end
    if k == 'right' then lovelyui:set_active (s1) end
    
    if k == 'return'    then lovelyui:next () end
    if k == 'backspace' then lovelyui:prev () end
    if k == 'up'        then lovelyui:up   () end
    if k == 'down'      then lovelyui:down () end
    
    if k == 'y' then y1:yes () end
    if k == 'n' then y1:no  () end
    
end

function love.update (dt)
    lovelyui:update (dt)
end

function love.draw ()
    lovelyui:draw ()

    lg.print (love.timer.getFPS (), 10, 10)
end
