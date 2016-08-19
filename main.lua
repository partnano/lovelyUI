local lovelyui = require 'lovelyui'

local lg = love.graphics
local lw = love.window

function love.load ()

    lw.setMode (1600, 900)

    img = lg.newImage ("avatar.png")
    fon_flat = lg.newFont ("Aileron-Regular.otf", 20)
    fon_fancy = lg.newFont ("Merriweather-Regular.ttf", 24)
    
    lg.setFont (fon_flat)
    
    long_text = "Hello to this small example of my petproject: lovelyUI! This is a UI library mainly directed at adventure and RPG games. \n\nHere, have this: ¢"
    
    s1 = lovelyui:new_selectionbox ({"Option 1", "Option 2", "Option 3"}, 40, 10, 10, 20)
    t1 = lovelyui:new_textbox ({long_text, "Hey, look! Another line."}, 5, 10, 30, 30, img)

    layout = lovelyui:new_layout (10, 0, 50, 50)
    layout:add_element (s1)
    layout:add_element (t1)
    layout:down ()

    t1.padding = 20

    y1 = lovelyui:new_ynbox ("Will you accept this box?", 40, 45, 20, 15)
    y1.yn_font = fon_fancy
    y1.no_text = "Nahh ..."

    t2 = lovelyui:new_textbox ({"This is a second textbox, just to show more stuff on screen."}, 15, 45, 20, 15)
    t2.font = fon_flat
    
end

function love.keypressed (k)

    if k == 'escape' then love.event.quit () end
    
    if k == 'return' then t1:next () end
    if k == 'backspace' then t1:prev () end
    if k == 'up' then s1:up () end
    if k == 'down' then s1:down () end
    if k == 'y' then y1:yes () end
    if k == 'n' then y1:no () end
    
end

function love.update (dt)
    lovelyui:update (dt)
end

function love.draw ()
    lovelyui:draw ()

    lg.print (love.timer.getFPS (), 10, 10)
end
