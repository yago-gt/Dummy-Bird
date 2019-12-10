require "lib/extend"
local Animator = class : derive "Animator"
local Timer = require "lib/Timer"

local Animation = class : derive "Animation"

function Animator:__new()
    self._clock = 0
    self._animations = {}
    self._current_frame = 1
    self:play()
end

function Animator:add(name, image, frames, framerate, x, w, y, h)
    x = x or 0
    assert(frames > 0, "Error: animation needs at least one frame")
    assert(framerate >= 0, "Error: framerate can't be a negative number")
    w = w or image:getWidth()/frames
    y = y or 0
    h = h or image:getHeight()
    local quads = {}
    local frametime
    
    if framerate == 0 then 
        frametime = 0 
    else
        frametime = 1/framerate
    end

    for i = 1, frames do
        quads[i] = love.graphics.newQuad(x, y, w, h, image:getWidth(), image:getHeight())
        x = x + w
    end

    local animation = {image = image, quads = quads, frametime = frametime}
    self._animations[name] = animation
    if self:getamount() == 1 then self._animation = animation end
end

function Animator:play()
    self._state = "playing"
end

function Animator:pause()
    self._state = "paused"
end

function Animator:getviewport()
    assert(self._animation, "Error: an animation must be add first")
    return self._animation.quads[1]:getViewport()
end

function Animator:getsize()
    assert(self._animation, "Error: an animation must be add first")
    local x, y, w, h = self._animation.quads[1]:getViewport()
    return w, h
end

function Animator:select(name)
    assert(self._animations[name], "Error: the animation selected doesn't exist")
    self._animation = self._animations[name]
    self._current_frame = 1
end

function Animator:stop()
    self._state = "stopped"
    self._current_frame = 1
    self._clock = 0
end

function Animator:cycle()
    self._current_frame = utils.cycle(self._current_frame, 1, #self._animation.quads)
end

function Animator:getframe()
    return self._animation.image, self._animation.quads[self._current_frame]
end

function Animator:getamount()
    local amount = 0
    for _, __ in pairs(self._animations) do amount = amount + 1 end
    return amount
end

function Animator:update(delta)
    if self._state == "playing" and self._animation.frametime > 0 then
        self._clock = self._clock + delta 
        if self._clock > self._animation.frametime then
            self:cycle()
            self._clock = self._clock - self._animation.frametime
        end
    end
end

function Animator:setframerate(framerate)
    self._animation.frametime = 1/framerate
end

function Animator:getframerate()
    return 1 / self._animation.frametime
end

function Animator:getstate()
    return self._state
end

function Animator:getframenumber()
    return self._current_frame
end

function Animator:setframenumber(number)
    assert(number <= #self._animation.quads and number >= 1, "Error: frame out of range")
    self._current_frame = number
end

function Animator:resetclock()
    self._clock = 0
end


return Animator