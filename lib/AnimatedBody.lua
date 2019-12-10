local hc = require "lib/HC"
local SBody = require "lib/SimpleBody"
local Animator = require "lib/Animator"

local ABody = SBody : derive "AnimatedBody"


function ABody:__new(image, x, y, s)
    self._spritesheet = image
    self._animator = Animator()
    self._x = x or 0
    self._y = y or 0
    self._sx = s or 1
    self._sy = s or 1
    self._xspeed = 0
    self._yspeed = 0
    self._shapes = {}
    self._shapesoffset = {}
    self._color = {1, 1, 1, 1}
end

function ABody:addanimation(name, image, frames, framerate, x, w, y, h)
    framerate = framerate or 0
    if image == 0 then
        self._animator:add(name, self._spritesheet, frames, framerate, x, w, y, h)
    else 
        self._animator:add(name, image, frames, framerate, x, w, y, h)
    end
    self._ox, self._oy = self._animator:getsize()
    self._ox, self._oy = self._ox/2, self._oy/2
    --self:addshape(shape)
end

function ABody:getspritesheet()
    return self._spritesheet
end


function ABody:addshape(shape, cx, cy)
    local x, y, w, h = self._animator:getviewport()
    shape = shape or hc.rectangle(x, y, w*self._sx, h*self._sy)
    local offset = {x = cx, y = cy}
    table.insert(self._shapes, shape)
    table.insert(self._shapesoffset, offset)
end

function ABody:draw()
    assert(self._animator:getamount() > 0, "Error: an animation must be add first")
    -- disable color if not needed for perfomance
    love.graphics.setColor(self._color)
    local image, quad = self._animator:getframe()
    love.graphics.draw(image, quad, self._x, self._y, self._r, self._sx, self._sy, self._ox, self._oy, self._kx, self._ky)
end

function ABody:setfilter(filter)
    self._spritesheet:setFilter(filter)
end

function ABody:updateanimation(delta)
    self._animator:update(delta)
end

function ABody:getimgrect()
    assert(false, "Error: function no supported with AnimatedBody")
end

function ABody:getwidth()
    assert(self._animator:getamount() > 0, "Error: an animation must be add first")
    local x, y, w, h = self._animator:getviewport()
    return w * self._sx
end

function ABody:getheight()
    assert(self._animator:getamount() > 0, "Error: an animation must be add first")
    local x, y, w, h = self._animator:getviewport()
    return h * self._sy
end

function ABody:playanimation()
    self._animator:play()
end

function ABody:stopanimation()
    self._animator:stop()
end

function ABody:pauseanimation()
    self._animator:pause()
end

function ABody:setframerate(framerate)
    self._animator:setframerate(framerate)
end

function ABody:getframerate()
    return self._animator:getframerate()
end

function ABody:selectanimation(name)
    self._animator:select(name)
end

function ABody:getframenumber()
    return self._animator:getframenumber()
end

function ABody:setframenumber(number)
    self._animator:setframenumber(number)
end

function ABody:cycleanimation()
    self._animator:cycle()
end

function ABody:getanimationstate()
    return self._animator:getstate()
end

return ABody