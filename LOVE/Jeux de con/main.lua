local Player = require "Player"
local Platform = require "Platform"
local bump = require "bump"

-- Crée un monde avec une taille de cellule de 50
local world = bump.newWorld(50)

local player = nil
local platforms = {}

function love.load()
    -- Créer le joueur et les plateformes
    player = Player:New(200, 150)
    player:Load()

    -- Crée une plateforme (LE SOL)
    LESOL = Platform:new(0, 450, 400, 100)
    LESOL.type = "plateform"

    TADARONNE = Platform:new(200, 300, 100, 50)
    TADARONNE.type = "plateform"

    -- Ajouter les objets au monde `bump`
    world:add(player, player.x, player.y, player.width, player.height)
    world:add(LESOL, LESOL.x, LESOL.y, LESOL.width, LESOL.height)
    world:add(TADARONNE, TADARONNE.x, TADARONNE.y,TADARONNE.width,TADARONNE.height)

    -- Sauvegarder les plateformes
    table.insert(platforms, LESOL)
    table.insert(platforms, TADARONNE)
end

function love.update(dt)
    -- Mettre à jour les mouvements du joueur q
    player:Update(dt)

    local actualX, actualY, cols, len = world:move(player, player.x, player.y)

    player.x, player.y = actualX, actualY


    for _, col in ipairs(cols) do
        if col.other.type == "plateform" then
            -- Si la collision est avec le bas du joueur, le joueur est sur la plateforme
            if player.y + player.height <= col.other.y then
                player.onGround = true
            end
        end
    end

    world:update(player, player.x, player.y)

end

function love.draw()
    -- Dessiner le joueur
    love.graphics.setColor(0, 1, 0) -- Vert
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- Dessiner les plateformes
    love.graphics.setColor(1, 1, 0) -- Jaune
    for _, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
        
    end

    if player.onGround then
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("On Ground", player.x, player.y - 20)
    else
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("Not on Ground", player.x, player.y - 20)
    end
end
