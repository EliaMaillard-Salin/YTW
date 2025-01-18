require ("Platforms")
require ("Player")


P1 = Platform:Create(10,20,50,200)

P1:SetSprite("aaa.png")

player = Player:new(10,10)

function love.draw()
    P1:Draw()
end

function love.update(dt)
    player:update(dt)
end
