lovelyui = require 'lovelyui'

local lg = love.graphics
local lw = love.window

function love.load ()

    lw.setMode (1600, 900)
    --lovelyui:set_defaults ({perc_coords = false, border = 'circle', smooth_speed = 9000})
    
end

function love.keypressed (k)

    if k == 'escape' then love.event.quit () end
    
end
