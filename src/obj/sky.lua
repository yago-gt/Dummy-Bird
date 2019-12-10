require "global"

local sky = {}

sky.image = love.graphics.newImage "res/sky.png"
sky.image:setFilter "nearest"
sky.image:setWrap "repeat"
sky.x = 0
sky.y = 0
sky.xspeed = -70
sky.yspeed = -70
sky.scale = 2
sky.color = {1, 1, 1, 0.5}
sky.quad =  love.graphics.newQuad(0, 0, virtual_width*2, virtual_height*2, sky.image:getDimensions())
sky.celest = {137/255, 201/255, 228/255}
sky.dist = 0


function sky:move(delta)
    self.x = self.x + self.xspeed * delta
    self.y = self.y + self.yspeed * delta
    if -self.x >= self.image:getWidth()*self.scale then self.x = 0 end
    if -self.y >= self.image:getHeight()*self.scale then self.y = 0 end
end



function sky:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image, self.quad, self.x, self.y, 0, self.scale)
    love.graphics.setColor(COLOR.white)
end

return sky