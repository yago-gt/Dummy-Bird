local SBody = require "lib/SimpleBody"
local SButton = SBody : derive "SimpleButton"


function SButton:__new(image, x, y, s)
    SBody.__new(self, image, x, y, s)
    self._released = false
    self._pressed = false
end

function SButton:press(x, y)
    if self:contains(x, y) then self._pressed = true end
    self._released = false
end

function SButton:release(x, y)
    if self:contains(x, y) and self._pressed then
        self._released = true
    end
    self._pressed = false
end


function SButton:ispressed()
    return self._pressed
end


function SButton:isreleased()
    return self._released
end


return SButton