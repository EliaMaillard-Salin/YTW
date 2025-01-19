local Player = require "Player"
local Platform = require "Platform"
local bump = require "bump"

-- Crée un monde avec une taille de cellule de 50
local worldCollider = bump.newWorld(50)
love.window.setMode(1920, 1080)

local player = nil
local platforms = {}

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
    player:Update(dt)

    local actualX, actualY, cols, len = worldCollider:move(player, player.x, player.y)

    player.x, player.y = actualX, actualY
    
    for _, col in ipairs(cols) do
        if col.other.type == "plateform" then
            -- Si la collision est avec le bas du joueur, le joueur est sur la plateforme
            if player.y + player.height <= col.other.y then
                player.onGround = true
            end
        end
    end

    worldCollider:update(player, player.x, player.y)

    world:Update(dt,player)

end

function love.draw()
    -- Dessiner le joueur
    if player.onGround then
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("On Ground", player.x, player.y - 20)
    else
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("Not on Ground", player.x, player.y - 20)
    end

    love.graphics.setColor(1,1,1)
    world:Draw(player)
end
