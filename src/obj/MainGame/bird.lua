require "global"
local hc = require "lib/HC"
local Timer = require "lib/Timer"
local ABody = require "lib/AnimatedBody"

local img = love.graphics.newImage("res/bird-fly.png")
--local quad = love.graphics.newQuad(0, 0, 32, 32, img:getDimensions())
local bird = ABody(img)
bird:setscale(2.5)
bird:setfilter("nearest")
bird.jumpspeed = -650
bird.framenumber = 0
bird:addanimation("fly", 0, 4, 15)
img = love.graphics.newImage("res/bird-fly-blink.png")
img:setFilter("nearest")
bird:addanimation("blink", img, 4, 15)

img = love.graphics.newImage("res/bird-game-over.png")
img:setFilter("nearest")
bird:addanimation("over", img, 1)
bird:addshape(hc.circle(0, 0, 20), 11, -15)
bird:addshape(hc.circle(0, 0, 25), -9, 10)

bird.timer = Timer.new()
bird.blinktimer = Timer.new()

function bird:jump() 
    self:setspeed(0, self.jumpspeed) 
    self.flap_sound:play()
    self:playanimation()
    self:setframerate(30)
    self.timer:clear()
    self.timer:after(0.3, function() self:stopanimation() end)
end

function bird:speedrotate(xspeed)
    xspeed = xspeed or -150
    xspeed = -(xspeed * 15)
    bird:setrotation(math.atan(self._yspeed/xspeed))
end


return bird