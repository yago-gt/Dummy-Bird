local TextHolder = require "lib/TextHolder"
local font = love.graphics.newFont("res/retro_gaming.ttf", 65)
font:setFilter("nearest")

-- game over text
local gameovertext = TextHolder(love.graphics.newText(font, "OUCH!!!"))
gameovertext.color = COLOR.white
gameovertext.ox = gameovertext.text:getWidth()/2
gameovertext.x = virtual_width/2
gameovertext.oy = gameovertext.text:getHeight()/2
gameovertext.y = virtual_height/6

-- scores text
gameovertext.scoretext = "SCORE: "
local font = love.graphics.newFont("res/retro_gaming.ttf", 50)
gameovertext.score = TextHolder(love.graphics.newText(font, ""))
gameovertext.bestscoretext = "BEST: "   
gameovertext.bestscore = TextHolder(love.graphics.newText(font, ""))

gameovertext.score.y = virtual_height/6 + 150 
gameovertext.score.x = virtual_width/2
gameovertext.bestscore.x = virtual_width/2
gameovertext.bestscore.y = virtual_height/6 + 230

function gameovertext:setscore(newscore)
    self.score.text:set(self.scoretext..tostring(newscore))
    self.score.ox = self.score.text:getWidth()/2
    self.score.oy = self.score.text:getHeight()/2
end


function gameovertext:setbest(bestscore, isnewbest)
    if isnewbest then
        self.bestscore.text:set({COLOR.yellow, "NEW ", COLOR.white,self.bestscoretext..tostring(bestscore)})
    else
        self.bestscore.text:set(self.bestscoretext..tostring(bestscore))
    end

    self.bestscore.ox = self.bestscore.text:getWidth()/2
    self.bestscore.oy = self.bestscore.text:getHeight()/2
end


return gameovertext