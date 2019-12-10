-- Website: https://yagogt.itch.io/dummy-bird
-- Email: ygtassello@gmail.com
-- Copyright (c) 2019 Yago G. Tassello

require "lib/extend"
require "global"
local resizer = require "lib/Resizer"
local window = {} 
window.toggle_fullscreen = true
window.toggle_vsync = false
window.modes = {
	{virtual_width/2, virtual_height/2},
	{virtual_width/3*2, virtual_height/3*2},
	{virtual_width/3*2.5, virtual_height/3*2.5},
	{virtual_width, virtual_height},
	{virtual_width*2, virtual_width*2}
}
local scene
--local scene = require "src/scn/Start"
--local scene = require "src/scn/MainGame"


function love.load()
	if not (love.system.getOS() == "Android" or love.system.getOS() == "iOS") then
		local width, height = love.window.getDesktopDimensions()
		if height > 2000 then
			window.current_mode = 5
		elseif height > 1000 then
			window.current_mode = 3
		elseif height > 700 then
			window.current_mode = 2
		else
			window.current_mode = 1
		end
		if love.system.getOS() == "Linux" then
			toggle_vsync()
		else
		love.window.updateMode(unpack(window.modes[window.current_mode])) end
	end
	love.window.setIcon(love.image.newImageData("res/bird.png"))
	resizer:setresolution(love.graphics.getDimensions())
	scene = require "src/scn/SplashScreen"
	scene.load()
end


function love.update(delta)
    scene.update(delta)
    -- load next scene
	if scene.loadscene then 
		local temp = scene.loadscene
		scene.loadscene = nil
		scene = temp 
		if scene.load then scene.load() end
	end
end


function love.draw()
    -- set offset and scale of the draw images
	if not scene.disableresizer then
 	resizer:set()
    scene.draw()
	resizer:unset()
	else
	scene.draw()
	end
end

function love.mousepressed(x, y, button, istouch, presses)
    -- set offset and scale of the input
    local ox, oy = resizer:getoffset()
    local scale = resizer:getscale()
    local dx, dy =  (x - ox)/scale, (y - oy)/scale
	if scene.mousepressed then scene.mousepressed(dx, dy, button, istouch, presses) end

end

function love.mousereleased(x, y, button, istouch, presses)
    -- set offset and scale of the input
    local ox, oy = resizer:getoffset()
    local scale = resizer:getscale()
    local dx, dy =  (x - ox)/scale, (y - oy)/scale
    if scene.mousereleased then scene.mousereleased(dx, dy, button, istouch, presses) end
end

function love.keyreleased(key, scancode, isrepeat)
    if scene.keyreleased then scene.keyreleased(key, scancode, isrepeat) end
end

function toggle_vsync()
	local w, h = unpack(window.modes[window.current_mode])
	love.window.updateMode(w, h, {vsync = window.toggle_vsync})
	window.toggle_vsync = not window.toggle_vsync
end

function love.keypressed(key, scancode, isrepeat)
	if key == "f11" then 
		love.window.setFullscreen(window.toggle_fullscreen)
		if not window.toggle_fullscreen then
			love.window.updateMode(unpack(window.modes[window.current_mode]))
			love.resize(love.graphics.getDimensions())
		end
		window.toggle_fullscreen = not window.toggle_fullscreen
	elseif key == "+" then
		window.current_mode = window.current_mode + 1
		if window.current_mode > #window.modes then window.current_mode = #window.modes
		else love.window.updateMode(unpack(window.modes[window.current_mode]))	end
		love.resize(love.graphics.getDimensions())
	elseif key == "-" then
		window.current_mode = window.current_mode - 1
		if window.current_mode < 1 then window.current_mode = 1
		else love.window.updateMode(unpack(window.modes[window.current_mode]))	end
		love.resize(love.graphics.getDimensions())
	elseif key == "f12" then
		toggle_vsync()
	elseif scene.keypressed then scene.keypressed(key, scancode, isrepeat) end
end