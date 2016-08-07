local lovelyui = require 'lovelyui'

local lg = love.graphics
local lw = love.window

function love.load ()

    lw.setMode (1600, 900)
    --lovelyui:set_defaults ({perc_coords = false, border = 'circle', smooth_speed = 9000})

    s1 = lovelyui:new_selectionbox ({"Option 1", "Option 2", "Option 3"}, 30, 10, 10, 20)
    t1 = lovelyui:new_textbox ({"Hello", "World"}, 10, 10, 10, 10)
    
end

function love.keypressed (k)

    if k == 'escape' then love.event.quit () end
    if k == 'return' then lovelyui:next () end
    if k == 'backspace' then lovelyui:prev () end
    if k == 'up' then lovelyui:up () end
    if k == 'down' then lovelyui:down () end
    
end

function love.draw ()
    lovelyui:draw ()
end
