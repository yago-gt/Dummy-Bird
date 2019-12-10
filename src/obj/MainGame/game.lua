local game = {}
game.over = {}
game.nextscene = {}
game.is_paused = false
game.over.text = require "src/obj/MainGame/gameovertext"
game.over.freeze_time = 0.2
game.bestscore = 0
game.leveltime = 30
game.endscreen = {}
game.endscreen.color = COLOR.white
game.endscreen.final_color = {0, 0, 0, 0.3}
game.endscreen.transition_time = 0.5
game.level = 0
game.levels = {}

game.levels[1] = { 
    pipe_time = 1.2,
    pipe_gap = 205,
    pipe_color = {0.33, 1, 0.33}, 
    pipe_speed = -350, 
    pipe_range = {math.floor(virtual_height/3), math.floor(virtual_height/3*2)}
}
game.levels[2] = { 
    pipe_time = 1,
    pipe_gap = 195,
    pipe_color = {1, 1, 0.33}, 
    pipe_speed = -400, 
    pipe_range = {math.floor(virtual_height/3), math.floor(virtual_height/3*2)}
}
game.levels[3] = { 
    pipe_time = 0.8,
    pipe_gap = 230,
    pipe_color = {1*0.6, 0.33*0.6, 0.33*0.6}, 
    pipe_speed = -500, 
    pipe_range = {math.floor(virtual_height/3), math.floor(virtual_height/3*2)}
}
--frontsky.celest = {0.5, 0.5, 0.5}
--local shader_code = love.filesystem.read("string", "lib/Blur.fsh")
--game.pause_shader = love.graphics.newShader(shader_code)

return game