local lovelyui = require 'lovelyui'

local lg = love.graphics
local lw = love.window

function love.load ()

    lw.setMode (1600, 900)
    --lovelyui:set_defaults ({perc_coords = false, border = 'circle', smooth_speed = 9000})

    img = lg.newImage ("avatar.png")
    
    s1 = lovelyui:new_selectionbox ({"Option 1", "Option 2", "Option 3"}, 30, 10, 10, 20)
    t1 = lovelyui:new_textbox ({"Hello this is µµ þþþ a rather long text to see the current default line height. Hello this is µµ þþþ a rather long text to see the current default line height. Hello this is µµ þþþ a rather long text to see the current default line height. Hello this is µµ þþþ a rather long text to see the current default line height. ", "Worldstar"}, 5, 10, 30, 30, img)
    y1 = lovelyui:new_ynbox ("Will you accept this box?", 40, 40, 12, 10)
    layout = lovelyui:new_layout (10, 0, 30, 10)
    layout:add_element (s1)
    t1:set_padding (20)

    t2 = lovelyui:new_textbox ({"This is a second textbox, just to test this stuff."}, 60, 60, 20, 15)

    -- font = lg.newFont (14)
    -- lg.setFont (font)
    -- font:setLineHeight (2.0)
    
end

function love.keypressed (k)

    if k == 'escape' then love.event.quit () end
    
    if k == 'return' then t1:next () end
    if k == 'backspace' then t1:prev () end
    if k == 'up' then lovelyui:up () end
    if k == 'down' then lovelyui:down () end
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
