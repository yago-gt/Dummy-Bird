-- Website: https://yagogt.itch.io/dummy-bird
-- Email: ygtassello@gmail.com
-- Copyright (c) 2019 Yago G. Tassello

local MainGame = {}


require "global"
local PipeStack = require "src/obj/MainGame/PipeStack"
local Timer = require "lib/Timer"
local frontsky = require "src/obj/sky"
local backsky = table.clone(require "src/obj/sky")
local help = require "src/obj/MainGame/help"
local bird = require "src/obj/MainGame/bird"
local score = require "src/obj/MainGame/score"
local buttons = require "src/obj/buttons"
local pausetext = require "src/obj/MainGame/pausetext"
local game = require "src/obj/MainGame/game"

-- one time set objects / game variables
frontsky.scale = 4
backsky.scale = 3
local gravity = 0
local pipestack = PipeStack()
pipestack.timer = Timer()
bird.flap_sound = love.audio.newSource("res/flap.ogg", "static")
bird.flap_sound:setVolume(0.5)
bird.head_hit_sound = love.audio.newSource("res/head-hit.ogg", "static")
game.nextscene.timer = Timer()

-- TODO: remove this v
--bird.die = false


function pipestack.whenpassmiddle()
    game.score = game.score + 1
    score:setscore(game.score)
end


function MainGame.load()
    -- game variables
    game.is_over = false
    game.has_started = false
    game.can_restart = false
    game.score = 0
    game.new_best_score = false
    game.levels[0] = table.copy(game.levels[1])
    game.endscreen.color = COLOR.white
    game.is_paused = false
    game.nextscene.color = COLOR.transparent_black 
    game.nextscene.transitioning = false
    game.nextscene.trans_time = 0.15
    game.nextscene.timer:clear()
    -- button color restore
    buttons.exit._color = COLOR.white
    -- bird entrance animation
    bird.has_entered = false
    bird.maxheight = virtual_height - bird:getheight()/2
    bird.minheight = 0 + bird:getheight()/2
    bird.start_position = {virtual_width/2, virtual_height/2}
    bird.entrance_position = {virtual_width/2, 0}
    bird.entrance_time = 1
    bird.is_entering = true
    bird.entrance_clock = 0
    bird._color = COLOR.white
    bird:setrotation(0)
    Timer.clear()
    Timer.after(bird.entrance_time/3, function() bird.is_entering = false end)
    Timer.tween(bird.entrance_time, bird.entrance_position, bird.start_position, 'out-elastic')
    bird.timer:clear()
    bird:selectanimation("fly")
    bird:setframerate(15)
    bird:playanimation()
    -- frontsky initial state
    frontsky.color = {1, 1, 1, 0.2}
    frontsky.xspeed = -10
    frontsky.yspeed = 0
    frontsky.celest = {137/255, 201/255, 228/255, 1}
    -- backsky initial state
    backsky.xspeed = -30
    backsky.yspeed = 0
    backsky.color = {1, 1, 1, 0.1}
    -- pipestack initial state
    pipestack.timer:clear()
    -- background night tweens set with the pipestack timer 
    pipestack.timer:after(game.leveltime*2 - 15, function()  
        pipestack.timer:tween(12, frontsky.celest, COLOR.black, "in-cubic") 
        pipestack.timer:tween(12, bird._color, {0.6, 0.6, 0.6, 1}, "in-cubic")
    end)
    -- bird blink timer
    bird.blinktimer:clear() 
    bird.blinktimer:every(2, function()
        local framenumber = bird:getframenumber()
        local framerate = bird:getframerate()
        bird:selectanimation("blink")
        bird:setframerate(framerate)
        bird:setframenumber(framenumber)
        bird.blinktimer:after(0.14, function() 
            local framenumber = bird:getframenumber()
            bird:selectanimation("fly")
            bird:setframenumber(framenumber)
        end)
    end)
    -- push new pipstacks
    pipestack.timer:every(game.levels[game.level].pipe_time, function() 
        local min, max = unpack(game.levels[game.level].pipe_range)
        local height = math.random(min, max)
        local color = game.levels[game.level].pipe_color
        local gap = game.levels[game.level].pipe_gap
        local speed = game.levels[game.level].pipe_speed
        pipestack:push(height, color, gap) 
        pipestack:setspeed(speed)
        backsky.xspeed = speed/10
        frontsky.xspeed = speed/3
    end)
    pipestack.timer:tween(game.leveltime, game.levels[0], game.levels[2], "in-cubic")
    pipestack.timer:after(game.leveltime, function() pipestack.timer:tween(game.leveltime, game.levels[0], game.levels[3], "in-cubic") end)
    pipestack:clean() 
    pipestack:push()
    pipestack:setspeed(game.levels[game.level].pipe_speed)
    -- score
    score:setscore(game.score)
    game.loadfile()
end


function MainGame.update(delta)
    if not game.is_paused then
        if not game.is_over then
            if not game.has_started then
                bird.entrance_clock = bird.entrance_clock + delta
                local yoscilation = (math.sin(bird.entrance_clock*10)*10)
                bird.entrance_position[2] = bird.entrance_position[2] + yoscilation
                bird:moveto(unpack(bird.entrance_position))
                bird.entrance_position[2] = bird.entrance_position[2] - yoscilation
            else
                pipestack.timer:update(delta)
                pipestack:slide(delta)
                bird:slide(delta, 0, gravity)
                bird:speedrotate()
                -- check if collides and if it does end the game
                if --[[bird.die and]] (pipestack:collideswith(bird:getshapes()) or 
                    bird:gety() > bird.maxheight or 
                    bird:gety() < bird.minheight) then
                    game.finish()
                end
            end
            bird.timer:update(delta)
            bird.blinktimer:update(delta)
            bird:updateanimation(delta)
            frontsky:move(delta)
            backsky:move(delta)
        end
    Timer.update(delta)
    end
    game.nextscene.timer:update(delta)
end


function MainGame.draw()
    love.graphics.clear(frontsky.celest)
    backsky:draw()
    frontsky:draw()  
    if not help.is_faded then game.drawhelp() end
    bird:draw()
    -- TODO: deactivate this v
    --bird:drawshape()
    pipestack:draw()
    --love.graphics.print(love.timer.getFPS())
    if game.is_over then  game.drawend() 
    else score:draw() end
    if game.is_paused then
        buttons.resume:draw()
        buttons.back:draw()
        pausetext:draw()
    end
    if game.nextscene.transitioning then     
        love.graphics.setColor(game.nextscene.color)
        love.graphics.rectangle("fill", 0, 0, virtual_width, virtual_height)
    end
end


function game.savefile()
    local save_file = love.filesystem.newFile("game.sav")
    local open_success, error = save_file:open("w")
    if open_success then 
        save_file:write(tostring(game.bestscore)..'\n')


    else
        print(error)
    end
end


function game.loadfile()
    local save_file = love.filesystem.newFile("game.sav")
    local open_success, error = save_file:open("r")
    if open_success then 
        local next_line = save_file:lines()
        local line = next_line()
        if line then game.bestscore = tonumber(line) end


    else
        print(error)
    end
end


function game.start()
    local fadehelp = function() help.is_faded = true end
    frontsky.xspeed = -150
    game.has_started = true
    bird:jump()
    gravity = 2300
    local fade_time = 0.2
    Timer.after(fade_time, fadehelp)
    Timer.tween(fade_time, help.color, COLOR.transparent)
end


function game.finish()
    bird:selectanimation("over")
    love.system.vibrate(0.05)
    bird.flap_sound:stop()
    bird.head_hit_sound:play()
    Timer.tween(game.endscreen.transition_time, game.endscreen.color, game.endscreen.final_color)
    game.is_over = true
    Timer.after(game.over.freeze_time, function() game.can_restart = true end)
    game.over.text:setscore(game.score)
    if game.score > game.bestscore then
        game.bestscore = game.score
        game.new_best_score = true
    end
    game.over.text:setbest(game.bestscore, game.new_best_score)
    game.savefile()
end


function game.pause()
    game.is_paused = true
end


function game.unpause()
    game.is_paused = false
end


function game.drawhelp()
    love.graphics.setColor(help.color)
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        help.touch:draw() 
    else 
        help.key:draw()  
    end
     love.graphics.setColor(COLOR.white)
end


function game.drawend()
    love.graphics.setColor(game.endscreen.color)
    love.graphics.rectangle("fill", 0, 0, virtual_width, virtual_height)
    love.graphics.setColor(game.over.text.color)
    game.over.text:draw()
    game.over.text.score:draw()
    game.over.text.bestscore:draw()
    buttons.play_again:draw()
    buttons.back:draw()
end


function MainGame.nextscene()
    game.nextscene.transitioning = true
    game.nextscene.timer:tween(game.nextscene.trans_time/10*9, game.nextscene, {color = COLOR.black})
    game.nextscene.timer:after(game.nextscene.trans_time, function() MainGame.loadscene = require "src/scn/Start" end)
end


----------------------------------------------------inputs--------------------------------------------------------------------

function MainGame.mousepressed(x, y)
    buttons:pressall(x, y)
    if not game.is_over and not game.is_paused then
            if not game.has_started and not bird.is_entering then game.start()
            elseif not bird.is_entering then bird:jump() end
    end
end


function MainGame.mousereleased(x, y)
    buttons:releaseall(x, y)
    if game.is_over then
        if game.can_restart and buttons.play_again:isreleased() then MainGame.load()
        elseif buttons.back:isreleased() then MainGame.nextscene() end
    else 
        if game.is_paused then
            if buttons.resume:isreleased() then game.unpause()
            elseif buttons.back:isreleased() then MainGame.nextscene() end
        end
    end
end


function MainGame.keypressed(key)
    if game.is_over then
        if key == "return" and game.can_restart then MainGame.load()
        elseif key == "escape" then MainGame.nextscene()     end
    else
        if game.is_paused then
            if key == "p" or key == "escape" then game.unpause() end
        else
            if key == "p" or key == "escape" then game.pause()
            elseif key == "space" and not bird.is_entering then
                if not game.has_started then game.start()
                else bird:jump() end
            end
        end
    end

    --if key == "right" then bird:rotate(0.5) end
    --if key == "k" then game.finish() end
    --if key == "c" then bird:moveto(virtual_width/2, virtual_height/2) end
    --if key == "m" then bird:selectanimation("over") end
    --if key == "i" then bird.die = not bird.die end
end

function love.focus(f)
  if not f and not game.is_over then
    game.pause()
  end
end

return MainGame
