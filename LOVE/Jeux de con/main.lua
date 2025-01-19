local bump = require "bump"

-- Crée un monde avec une taille de cellule de 50
local worldCollider = bump.newWorld(50)
love.window.setMode(1920, 1080)

local world = require ("World")
local Player = require ("Player")
local Platform = require ("Platform")

local player
local platform

function love.load()

    player = Player:New(0, love.graphics.getHeight() - 300)
    player:Load()
    -- Ajouter les objets au monde `bump`
    worldCollider:add(player, player.x, player.y, player.width, player.height)
    world:Create()
    world:Load(worldCollider)
end

function love.update(dt)
    -- Mettre à jour les mouvements du joueur q
    world:Update(dt,player,worldCollider)    
    worldCollider:update(player, player.x, player.y)
end

function love.draw()
    
    love.graphics.setColor(1,1,1)
    world:Draw(player)
    
    -- Dessiner le joueur
    if player.onGround then
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("On Ground", player.x, player.y - 20)
    else
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("Not on Ground", player.x, player.y - 20)
    end
end
