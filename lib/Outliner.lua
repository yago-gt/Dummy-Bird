local Outliner = class : derive "Outliner"

function Outliner:drawoutline(text_holder, offset, color)
    color = color or {0, 0, 0, 0.3}
    offset = offset or 1
    love.graphics.setColor(color)
    love.graphics.draw(text_holder.text, text_holder.x + offset, text_holder.y + offset, text_holder.r, 
        text_holder.sx, text_holder.sy, text_holder.ox, text_holder.oy, text_holder.kx, text_holder.ky)
    --[[love.graphics.draw(text_holder.text, text_holder.x, text_holder.y - offset, text_holder.r, 
        text_holder.sx, text_holder.sy, text_holder.ox, text_holder.oy, text_holder.kx, text_holder.ky)
    love.graphics.draw(text_holder.text, text_holder.x + offset, text_holder.y, text_holder.r, 
        text_holder.sx, text_holder.sy, text_holder.ox, text_holder.oy, text_holder.kx, text_holder.ky)
    love.graphics.draw(text_holder.text, text_holder.x - offset, text_holder.y, text_holder.r, 
        text_holder.sx, text_holder.sy, text_holder.ox, text_holder.oy, text_holder.kx, text_holder.ky)]]
    love.graphics.setColor(COLOR.white)
end

return Outliner