local lovelyui = require 'lovelyui'

local lg = love.graphics
local lw = love.window

function love.load ()

    lw.setMode (1600, 900)
    --lovelyui:set_defaults ({perc_coords = false, border = 'circle', smooth_speed = 9000})

    t1 = lovelyui:new_textbox ({"Hello", "World"}, 10, 10, 10, 10)
    s1 = lovelyui:new_selectionbox ({"Option 1", "Option 2", "Option 3"}, 30, 10, 10, 20)
    
end

function love.keypressed (k)

    if k == 'escape' then love.event.quit () end
    if k == 'return' then t1:next_line () end
    if k == 'backspace' then t1:prev_line () end
    if k == 'up' then s1:up () end
    if k == 'down' then s1:down () end
    
end

function love.draw ()
    lovelyui:draw ()
end
