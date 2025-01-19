Platform = require ("Platforms")
Player = require ("Player")
World = require ("World")

love.window.setMode(1920, 1080)


local world = World:Create()

local player = Player:new(10,10)

function love.update(dt)
    world:Update(dt,player)
end


function love.draw()
    world:Draw(player)
end