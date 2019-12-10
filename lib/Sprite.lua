require "lib/extend"

local Sprite = class:derive "Sprite"

function Sprite:__new(image, x, y, r, sx, sy, ox, oy, kx, ky)
    self.image = image
    self.x = x or 0
    self.y = y or 0
    self.r = r or 0
    self.sx = sx or 1
    self.sy = sy or sx or 1
    self.ox = ox or 0
    self.oy = oy or 0
    self.kx = kx or 0
    self.ky = ky or 0
end

function Sprite:draw()
    love.graphics.draw(self.image, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
end


function Sprite:getrectangle()
    return self.x - self.ox*self.sx, self.y - self.oy*self.sy, self.image:getWidth() * self.sx, self.image:getHeight() * (self.sy or self.sx)
end


return Sprite