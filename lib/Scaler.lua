if not class then require "lib/extend" end

local Scaler = class:derive "Scaler"

function Scaler:setresolution(width, height)
    local screenratio = width/height
    if screenratio == self._ratio then
        self._scale = width/self._width
        self._xsize = width
        self._ysize = height
        self._xoffset, self._yoffset = 0, 0
    elseif screenratio > self._ratio then
        self._scale = height/self._height
        self._xsize = height * self._ratio
        self._ysize = height
        self._xoffset = math.floor((width - self._xsize)/2)
        self._yoffset = 0
    else
        self._scale = width/self._width
        self._xsize = width
        self._ysize = width/self._ratio
        self._xoffset = 0
        self._yoffset = math.floor((height - self._ysize)/2)
    end
end

function Scaler:__new(width, height)
        self._ratio, self._width, self._height = width/height, width, height
        self._xsize, self._ysize = width, height
        self._scale = 1
end

-- get size of the box that is going to be drawn
function Scaler:getsize() return self._xsize, self._ysize end
-- get offset of the box so it is in the center (upper left corner)
function Scaler:getoffset() return self._xoffset, self._yoffset end

function Scaler:getscale() return self._scale end

function Scaler:getvirtualres() return self._width, self._height end

return Scaler