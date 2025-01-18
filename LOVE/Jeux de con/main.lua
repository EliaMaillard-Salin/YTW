local Player = require "Player"
local Platform = require "Platform"
local Physics = require("Physics")

local player = nil
local platform
local objects = {}

function love.load()
    -- Créer une plateforme au centre de l'écran

    --TADARONNE = Platform:new(400,400)
    LESOL = Platform:new(0,450)
    LESOL.width = 400
    LESOL.height = 100
    player = Player:new(100, 400)
    player:load()

end

function love.update(dt)
    Physics.Collision(player, LESOL,dt)
    --Physics.Collision(player, TADARONNE,dt)

    player:update(dt, platform)


end

function love.draw()
    love.graphics.setColor(0, 1, 0) -- Vert pour le joueur
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    --love.graphics.rectangle("fill", TADARONNE.x, TADARONNE.y, TADARONNE.width, TADARONNE.height)
    love.graphics.setColor(1, 1, 0) -- Vert pour le joueur
    love.graphics.rectangle("fill", LESOL.x, LESOL.y, LESOL.width, LESOL.height)
    -- Dessiner les objets
    love.graphics.setColor(1, 0, 0) -- Rouge pour les objets
end
