-- Website: https://yagogt.itch.io/dummy-bird
-- Email: ygtassello@gmail.com
-- Copyright (c) 2019 Yago G. Tassello

local Start = {}

require "global"
local Timer = require "lib/Timer"
local Sprite = require "lib/Sprite"
local buttons = require "src/obj/buttons"
local TextHolder = require "lib/TextHolder"
local sky = require "src/obj/sky"
local backsky
local Outliner = require "lib/Outliner"

-- settings
local osc_clock
local changing_scene
local fade_in_color

-- title
local title = TextHolder()
local font = love.graphics.newFont("res/retro_gaming.ttf", 70, "mono")
--font = love.graphics.newImageFont("res/ralphanum.png", " ABCDEFGHIJKLMNOPQRSTUVXYZ1234567890")
font:setFilter "nearest"
title.text = love.graphics.newText(font, "Dummy Bird")
--title.sx = 6
--title.sy = 5
title.ox = title.text:getWidth()/2
title.oy = title.text:getHeight()/2
title.x = virtual_width/2
title.y = virtual_height/2 - 200

 -- version
local version = TextHolder()
font = love.graphics.newFont("res/retro_gaming.ttf", 20, "mono")
font:setFilter "nearest"
version.text = love.graphics.newText(font, "v"..VERSION._.." ")
version.ox = version.text:getWidth()
version.oy = version.text:getHeight()
version.x = virtual_width
version.y = virtual_height 

local name = TextHolder()
name.text = love.graphics.newText(font, " (c) Yago G. Tassello")
name.oy = name.text:getHeight()
name.y = virtual_height

local background = {}
background.sound = love.audio.newSource("res/mtheme.ogg", "stream")
background.sound:setLooping(true)

function Start.load()
-- settings
osc_clock = 0
fade_in_color = COLOR.black
changing_scene = false
Timer.clear()
Timer.tween(0.15, fade_in_color, COLOR.transparent_black)
-- sky
sky.xspeed = -70
sky.yspeed = -70
sky.scale = 2
sky.color = {1, 1, 1, 0.5}
sky.celest = {137/255, 201/255, 228/255}
-- backsky
backsky = table.copy(require "src/obj.sky")
backsky.color = COLOR.transparent
-- buttons
buttons.start:setcolor(COLOR.white)
-- title
title.outline_color = {0, 0, 0, 0.35}
-- sound
if not (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
    background.volume = 0.5
else
    background.volume = 1.0
end
background.sound:setVolume(background.volume)
background.sound:play()
end

function Start.update(delta)
    osc_clock = osc_clock + delta * 8
    buttons.start:setscale(math.abs(math.cos(osc_clock)/3+3.15))
    sky:move(delta)
    Timer.update(delta)
end


function Start.draw()
    love.graphics.clear(sky.celest)
    sky:draw()
    backsky:draw()
    Outliner:drawoutline(title, 7, title.outline_color)
    buttons.start:draw()
    buttons.exit:draw()
    version:draw()
    name:draw()
    title:draw()
    background.sound:setVolume(background.volume)
    love.graphics.setColor(fade_in_color)
    love.graphics.rectangle("fill", 0, 0, virtual_width, virtual_height)
    -- TODO: deactivate this v
    --start_button:drawshape()
    --love.graphics.print(love.timer.getFPS())
end

function Start.quit()
        Timer.tween(0.1, fade_in_color, COLOR.black)
        Timer.after(0.1, function() love.event.quit() end) 
end

function Start.mousepressed(x, y)
    buttons:pressall(x, y)
end

function Start.mousereleased(x, y)
    buttons:releaseall(x, y)
    if buttons.start:isreleased() then
        Start.changescene()
    end

    if buttons.exit:isreleased() then
        Start.quit()
    end
end

function Start.keypressed(key)
    if key == "return" then
        Start.changescene()
    elseif key == "escape" then
        Start.quit()
    end
end


function Start.changescene()
    local nextscene = function()  background.sound:stop() ; Start.loadscene = require "src/scn/MainGame" end
    if not changing_scene then
        local trans_time = 0.3
        sky.xspeed = 0
        sky.yspeed = 0
        Timer.after(trans_time, nextscene)
        Timer.tween(trans_time, sky, {scale = 4, x = 0, y = 0, color = {1, 1, 1, 0.2}})
        Timer.tween(trans_time, backsky, { color = {1, 1, 1, 0.1}, scale = 3} )
        --Timer.tween(trans_time/2, fade_color, COLOR.transparent)
        Timer.tween(trans_time/2, buttons.start._color, COLOR.transparent)
        Timer.tween(trans_time/2, buttons.exit._color, COLOR.transparent)
        Timer.tween(trans_time/2, title.outline_color, COLOR.transparent)
        Timer.tween(trans_time, background, {volume = 0})
        changing_scene = true
    end
end

-- load everything
Start.load()

return Start
