local TextHolder = require "lib/TextHolder"

local font = love.graphics.newFont("res/retro_gaming.ttf", 50)
font:setFilter("nearest")
local pausetext = TextHolder(love.graphics.newText(font, "PAUSED"))
pausetext.ox = pausetext.text:getWidth()/2
pausetext.oy = pausetext.text:getHeight()/2
pausetext.x = virtual_width/2
pausetext.y = virtual_height/5


return pausetext