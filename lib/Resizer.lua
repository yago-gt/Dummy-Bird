require "global"
local Scaler = require "lib/Scaler"
local scaler = Scaler(virtual_width, virtual_height)

function scaler:set()
    love.graphics.translate(scaler:getoffset())
    local x, y = scaler:getoffset()
    local dx, dy = scaler:getsize()
    love.graphics.setScissor(x, y, dx, dy)
    love.graphics.scale(scaler:getscale())
end

function scaler:unset()
    love.graphics.setScissor()
end

function love.resize(width, height)
    scaler:setresolution(width, height)
end

return scaler