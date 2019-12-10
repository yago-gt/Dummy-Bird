local help = {}
local TextHolder = require "lib/TextHolder"

help.font = love.graphics.newFont("res/retro_gaming.ttf", 40)
help.font:setFilter("nearest")
help.highlight = {1, 0.5, 0.2}
help.touch = TextHolder(love.graphics.newText(help.font, {help.highlight, "Tap", COLOR.white, " to jump"}))
help.touch.x = virtual_width/2
help.touch.y = virtual_height/4
help.touch.ox = help.touch.text:getWidth()/2
help.touch.oy = help.touch.text:getHeight()/2
help.key = TextHolder()
help.key.x = 40
help.key.y = virtual_height/7.5
help.key.text = love.graphics.newText(help.font, 
    {COLOR.white, " Press the ", help.highlight, "space", COLOR.white,
     "\n    key  or ", help.highlight, "click", COLOR.white, "\nanywhere to jump\n"})
help.color = COLOR.white
help.isfaded = false

return help