local SButton = require "lib/SimpleButton"
local Buttons = SButton : derive "Button"


function Buttons:__new(image, x, y, s)
    SButton.__new(self, image, x, y, s)
    if not Buttons._buttons then Buttons._buttons = {} end
    table.insert(Buttons._buttons, self)
end

function Buttons:addpressedimage(image)
    self._pressedimg = image
    self._releasedimg = self._image
end

function Buttons:press(x, y)
    SButton.press(self, x, y)
    if self._pressed and self._pressedimg then self._image = self._pressedimg end
end

function Buttons:release(x, y)
    SButton.release(self, x, y)
    if not self._pressed and self._pressedimg then self._image = self._releasedimg end
end 

function Buttons:pressall(x, y)
    for _, button in pairs(Buttons._buttons) do
        button:press(x, y)
    end
end


function Buttons:releaseall(x, y)
    for _, button in pairs(Buttons._buttons) do
        button:release(x, y)
    end
end

function Buttons:drawall()
    for _, button in pairs(Buttons._buttons) do
        button:draw()
    end
end

return Buttons