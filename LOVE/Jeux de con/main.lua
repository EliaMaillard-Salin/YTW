require ("Platforms")

P1 = Platform:Create(10,20,50,200)

P1:SetSprite("aaa.png")

function love.draw()
    P1:Draw()
end
