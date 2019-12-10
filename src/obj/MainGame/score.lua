local TextHolder = require "lib/TextHolder"

local font = love.graphics.newFont("res/retro_gaming.ttf", 55)
font:setFilter("nearest")

local score = TextHolder(love.graphics.newText(font, "unsigned score"))
score.color = COLOR.white
score.x = virtual_width/2
score.y = virtual_height/3 - 230


function score:setscore(newscore)
    self.text:set(newscore)
    self.ox = self.text:getWidth()/2
    self.oy = self.text:getHeight()/2
end


return score