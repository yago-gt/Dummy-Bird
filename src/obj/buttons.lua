local Button = require "src/obj/Button"


-- resume button
local img = love.graphics.newImage("res/resume.png")
img:setFilter "nearest"
Button.resume = Button(img, virtual_width/2, virtual_height/2 + 180, 3)
img = love.graphics.newImage "res/resume-pressed.png"
img:setFilter "nearest"
Button.resume:addpressedimage(img)
    
-- play again
img = love.graphics.newImage("res/play_again.png")
img:setFilter "nearest"
Button.play_again = Button(img, virtual_width/2, virtual_height/2 + 180, 3)
img = love.graphics.newImage "res/play_again-pressed.png"
img:setFilter "nearest"
Button.play_again:addpressedimage(img)

-- exit button
img = love.graphics.newImage("res/exit.png")
img:setFilter "nearest"
Button.exit = Button(img, virtual_width/2, virtual_height/3*2 + 180, 3)
img = love.graphics.newImage "res/exit-pressed.png"
img:setFilter "nearest"
Button.exit:addpressedimage(img)

-- start button
img = love.graphics.newImage("res/start.png")
img:setFilter "nearest"
Button.start = Button(img, virtual_width/2, virtual_height/2 + 180, 2)
img = love.graphics.newImage "res/start-pressed.png"
img:setFilter "nearest"
Button.start:addpressedimage(img)
    
-- back button
img = love.graphics.newImage("res/back.png")
img:setFilter "nearest"
Button.back = Button(img, virtual_width/2, virtual_height/3*2 + 180, 3)
img = love.graphics.newImage "res/back-pressed.png"
img:setFilter "nearest"
Button.back:addpressedimage(img)

return Button