require "lib/extend"
local hc = require "lib/HC"

local SimpleBody = class : derive "SimpleBody"

function SimpleBody:__new(image, x, y, s, shape)
    self._image = image
    self._x = x or 0
    self._y = y or 0
    self._sx = s or 1
    self._sy = s or 1
    self._ox = self._image:getWidth()/2
    self._oy = self._image:getHeight()/2
    self._xspeed = 0
    self._yspeed = 0
    self._shapes = {}
    self._shapesoffset = {}
    self:addshape(shape)
    self._color = {1, 1, 1, 1}
end

function SimpleBody:addshape(shape, cx, cy)
    shape = shape or hc.rectangle(self:getimgrect())
    local offset = {x = cy, y = cy}
    table.insert(self._shapes, shape)
    table.insert(self._shapesoffset, offset)
end

function SimpleBody:removeshape(index)
    index = index or #self._shapes
    local shape = self._shapes[index]
    hc.remove(shape)
    table.remove(self._shapes, index)
    table.remove(self._shapesoffset, index)
end

function SimpleBody:setfilter(filter)
    self._image:setFilter(filter)
end

function SimpleBody:getcolor()
    return self._color
end

function SimpleBody:setcolor(color)
    self._color = color
end

function SimpleBody:move(dx, dy)
    self._x = self._x + dx
    self._y = self._y + dy
    for _, shape in pairs(self._shapes) do
        shape:move(dx, dy)
    end
end

function SimpleBody:getposition()
    return self._x, self._y
end

function SimpleBody:getx()
    return self._x
end

function SimpleBody:gety()
    return self._y
end


function SimpleBody:rotate(dr)
    self._r = self._r + dr
    for i, shape in pairs(self._shapes) do
        local offset = self._shapesoffset[i]
        shape:rotate(dr, self._x, self._y)
    end
end

function SimpleBody:setrotation(r)
    self._r = r
    for i, shape in pairs(self._shapes) do
        local offset = self._shapesoffset[i]
        shape:setRotation(r, self._x, self._y)
    end
end

function SimpleBody:moveto(x, y)
    self._x, self._y = x, y
    for i, shape in ipairs(self._shapes) do
        local offset = self._shapesoffset[i]
        if offset.x then
            shape:moveTo(x + offset.x, y + offset.y)
        else
            shape:moveTo(x, y)
        end
    end
end

function SimpleBody:getwidth()
    return self._image:getWidth() * self._sx
end

function SimpleBody:getheight()
    return self._image:getHeight() * self._sy
end

function SimpleBody:contains(x, y)
    local contains = false
    for _, shape in pairs(self._shapes) do
        if shape:contains(x, y) then 
            contains = true 
            break
        end
    end
    return contains
end

function SimpleBody:collideswith(testshape)
    local iscolliding = false
    if testshape then
        if type(testshape) == "table" then
            for _, shape in pairs(self._shapes) do
                for __, other_shape in pairs(testshape) do
                    if shape:collidesWith(other_shape) then
                        iscolliding = true
                        break
                    end
                end
            end
        else
            for _, shape in pairs(self._shapes) do
                if shape:collidesWith(testshape) then 
                    iscolliding = true 
                    break
                end
            end
        end
    end
    return iscolliding
end

function SimpleBody:scale(sx, sy)
    self._sx = self._sx * sx
    self._sy = self._sy * (sy or sx)
    if not sy then 
        for _, shape in pairs(self._shapes) do
            shape:scale(sx)
        end
    end
end

function SimpleBody:setscale(sx, sy)
    if not sy then 
        for _, shape in pairs(self._shapes) do
            shape:scale(1/self._sx * sx)
        end
    end
    -- this should be done after you need the previous _sx value
    self._sx = sx
    self._sy = sy or sx
end

function SimpleBody:getshapes()
    return self._shapes
end

function SimpleBody:getshape(index)
    index = index or 1
    return self._shapes[index]
end

function SimpleBody:drawshape()
    for _, shape in pairs(self._shapes) do
        shape:draw()
    end
end

function SimpleBody:draw()
    -- disable color if not needed for perfomance
    love.graphics.setColor(self._color)
    love.graphics.draw(self._image, self._x, self._y, self._r, self._sx, self._sy, self._ox, self._oy, self._kx, self._ky)
end


function SimpleBody:getimgrect()
    local x, y, w, h
    x = self._x - self._ox * self._sx
    y = self._y - self._oy * self._sy
    w = self._image:getWidth() * self._sx
    h = self._image:getHeight() * self._sy
    return x, y, w, h
end

function SimpleBody:setspeed(xspeed, yspeed)
    assert(yspeed, "setspeed needs both x and y speed values") 
    self._xspeed = xspeed
    self._yspeed = yspeed
end

function SimpleBody:changespeed(dxspeed, dyspeed)
    self._xspeed = self._xspeed + dxspeed
    self._yspeed = self._yspeed + dyspeed
end

function SimpleBody:getspeed()
    return self._xspeed, self._yspeed
end

function SimpleBody:slide(delta, xforce, yforce)
    if xforce then self._xspeed = self._xspeed + delta * xforce end
    if yforce then self._yspeed = self._yspeed + delta * yforce end
    local dx = self._xspeed * delta
    local dy = self._yspeed * delta
    self:move(dx, dy)
end

return SimpleBody