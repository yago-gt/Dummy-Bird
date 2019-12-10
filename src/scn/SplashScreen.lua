local SplashScreen = {}


local splashlib = require "lib/o-ten-one"
local splash = splashlib:new()
local sound = love.audio.newSource("res/bells.ogg", "stream")
local sound_setting = {}
local Timer = require "lib/Timer"
SplashScreen.disableresizer = true
splash.background = COLOR.black

local clock = 0

function SplashScreen.load()
    sound_setting.volume = 0.25
    sound:setVolume(sound_setting.volume)
    Timer.after(1, function() sound:play() end)
end

function SplashScreen.update(delta)
    splash:update(delta)
    Timer.update(delta)
    sound:setVolume(sound_setting.volume)
    --print(sound_setting.volume)
    clock = clock + delta
   -- print(clock)
end

function SplashScreen.draw()
    splash:draw()
end

function splash.onDone()
    SplashScreen.loadscene = require "src/scn/Start"
    spash = nil
    splashlib = nil
end

function SplashScreen.mousepressed()
    Timer.clear()
    Timer.tween(0.3, sound_setting, {volume = 0})
    splash:skip()
end

function SplashScreen.keypressed()
    Timer.clear()
    Timer.tween(0.3, sound_setting, {volume = 0})
    splash:skip()
end

return SplashScreen