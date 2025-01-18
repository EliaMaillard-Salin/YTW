require ("Platforms")
require ("Player")
require ("World")

love.window.setMode(1920, 1080)

function love.load()
    alpha = 255
end

world = World:Create()
P1 = Platform:Create(10,20,50,200)

P1:SetSprite("aaa.png")

player = Player:new(10,10)

function love.update(dt)
    player:update(dt)
    world:Update(dt,player)
end


function love.draw()
    P1:Draw()
    world:Draw()
end