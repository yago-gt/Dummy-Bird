require "lib/extend"

local TextHolder = class:derive "TextHolder"

function TextHolder:__new(text, x, y, r, sx, sy, ox, oy, kx, ky)
    self.text = text
    self.x = x or 0
    self.y = y or 0
    self.r = r
    self.sx = sx
    self.sy = sy
    self.ox = ox 
    self.oy = oy
    self.kx = kx
    self.ky = ky 
end

function TextHolder:draw()
    love.graphics.draw(self.text, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
end

return TextHolder