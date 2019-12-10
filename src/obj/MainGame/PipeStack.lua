local PipeStack = class:derive "PipeStack"
local PipePair = require "src/obj/MainGame/PipePair"



function PipeStack:__new()
    local image = love.graphics.newImage("res/pipe-gray.png")
    image:setFilter "nearest"
    PipePair:setimage(image)
    self.pipes = {}
end


function PipeStack:push(height, color, gap, scale)
    self.pipes[#self.pipes + 1] = PipePair(height, color, gap, scale)
end


function PipeStack:pop()
        self.pipes[1]:removeshape()
        table.remove(self.pipes, 1)
end

function PipeStack:clean()
    while #self.pipes > 0 do
        self:pop()
    end
end

function PipeStack:getamount()
    return #self.pipes
end

function PipeStack:setspeed(xspeed, yspeed)
    if not yspeed then yspeed = 0 end
    self._xspeed = xspeed
    self._yspeed = yspeed
    for _, pipe in pairs(self.pipes) do
        pipe:setspeed(xspeed, yspeed)
    end
end

function PipeStack:slide(delta)
    local passedmiddle = false
    local needtopop = false
    for _, pipe in pairs(self.pipes) do
        local previous_x_position = pipe:getx()
        pipe:slide(delta)
        -- delete the pipe that is already out of the view
        if pipe:getx() < -pipe:getwidth()/2 then
            needtopop = true
        -- if the pipe isn't out of the view, is in the middle?
        elseif previous_x_position > virtual_width/2 and pipe:getx() < virtual_width/2 then
            -- delete if it is
            passedmiddle = true
        end
    end
    if needtopop then self:pop() end
    if passedmiddle and self.whenpassmiddle then self.whenpassmiddle() end
end

function PipeStack:draw()
    for _, pipe in pairs(self.pipes) do
        pipe:draw()
        -- TODO: remove this v
        --pipe:drawshape()
    end
    -- disable if not needed for better performance
    love.graphics.setColor(COLOR.white)
end

function PipeStack:collideswith(shape)
    local iscolliding = false
    for _, pipe in pairs(self.pipes) do
        if pipe:collideswith(shape) then
            iscolliding = true
        end
    end
    return iscolliding
end


return PipeStack