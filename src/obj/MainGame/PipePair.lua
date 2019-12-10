require "lib/extend"
require "global"
local SBody = require "lib/SimpleBody"

local PipePair = class:derive "PipePair"


function PipePair:__new(height, color, gap, scale)
    self._height = height or virtual_height/2
    self._color = color or {0.33, 1, 0.33}
    self._gap = gap or 250
    self._scale = scale or 3
    
    local right_edge = virtual_width + self._img:getWidth() * self._scale
    local y_uppipe = self._height - self._img:getHeight()/2 * self._scale - self._gap/2 
    local y_lowpipe = y_uppipe + self._img:getHeight() * self._scale + self._gap

    self._uppipe = SBody(self._img, right_edge, y_uppipe, self._scale)
    self._uppipe:setcolor(self._color)
    self._lowpipe = SBody(self._img, right_edge, y_lowpipe, self._scale)
    self._lowpipe:setcolor(self._color)
end


function PipePair:setimage(image)
    self._img = image
end


function PipePair:setspeed(xspeed, yspeed)
    self._uppipe:setspeed(xspeed, yspeed)
    self._lowpipe:setspeed(xspeed, yspeed)
end


function PipePair:slide(delta)
    self._uppipe:slide(delta)
    self._lowpipe:slide(delta)
end


function PipePair:draw()
    self._uppipe:draw()
    self._lowpipe:draw()
end


function PipePair:getx()
    return self._uppipe:getx()
end

function PipePair:moveto(x)
    self._uppipe:moveto(x, self._uppipe:gety())
    self._lowpipe:moveto(x, self._lowpipe:gety())
end

function PipePair:collideswith(shape)
    return self._uppipe:collideswith(shape) or self._lowpipe:collideswith(shape)
end


function PipePair:drawshape()
    self._uppipe:drawshape()
    self._lowpipe:drawshape()
end

function PipePair:removeshape()
    self._uppipe:removeshape()
    self._lowpipe:removeshape()
end

function PipePair:getwidth()
    return self._uppipe:getwidth()
end

return PipePair