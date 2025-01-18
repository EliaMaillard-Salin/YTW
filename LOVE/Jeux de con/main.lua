local Player = require "Player"
local Platform = require "Platform"
local Physics = require("Physics")

local player = nil
local platform
local objects = {}

function love.load()
    -- Créer une plateforme au centre de l'écran
    player = Player:new(100, 300)

    table.insert(objects, Physics.createObject(100, 500, 50, 50, 0, 0, 1))
    table.insert(objects, Physics.createObject(200, 50, 50, 50, 0, 0, 1))

    player = Player:new(200, 100)
    player:load()

    platform = Platform:new(0, love.graphics.getHeight() - 50, love.graphics.getWidth(), 50)
end

function love.update(dt)
    player:update(dt, platform)

    -- Vérifier la collision avec les objets
    for _, obj in ipairs(objects) do
        -- Appliquer la collision et ajuster la position du joueur
        Physics.Collision(player, obj)
		player:GoToDirection(12,102,20)
    end
end

function love.draw()
    love.graphics.setColor(0, 1, 0) -- Vert pour le joueur
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- Dessiner les objets
    love.graphics.setColor(1, 0, 0) -- Rouge pour les objets
    for _, obj in ipairs(objects) do
        love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)
    end
end
