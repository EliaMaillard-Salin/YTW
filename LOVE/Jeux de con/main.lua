local Player = require "Player"
local Platform = require "Platform"
local BrokenPlatform = require "BrokenPlatform"
local bump = require "bump"

-- Crée un monde avec une taille de cellule de 50
local world = bump.newWorld(50)

local player = nil
local platforms = {}
local broke = {}

function love.load()
    -- Créer le joueur et les plateformes
    player = Player:New(200, 150)
    player:Load()

    -- Crée une plateforme (LE SOL)
    LESOL = Platform:new(0, 450, 400, 100)
    LESOL.type = "plateform"

    TADARONNE = Platform:new(200, 300, 100, 50)
    TADARONNE.type = "plateform"

    brise = BrokenPlatform:new(200, 400, 100, 20)  -- Une plateforme brisée
    brise.type = "broke"

    -- Ajouter les objets au monde `bump`
    world:add(player, player.x, player.y, player.width, player.height)
    world:add(LESOL, LESOL.x, LESOL.y, LESOL.width, LESOL.height)
    world:add(TADARONNE, TADARONNE.x, TADARONNE.y,TADARONNE.width,TADARONNE.height)
    world:add(brise,brise.x, brise.y, brise.width, brise.height)

    -- Sauvegarder les plateformes
    table.insert(platforms, LESOL)
    table.insert(platforms, TADARONNE)
    table.insert(broke, brise)
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

    for _, col in ipairs(cols) do
        if col.other.type == "broke" then
            -- Si la collision est avec le bas du joueur, le joueur est sur la plateforme
            if player.y + player.height <= col.other.y then
                player.onGround = true
            end
        end
    end

        if broke.isBroken then
            -- Vérifier si la plateforme est brisée et si le joueur est en état angry
            if Collision(player, broke) and player.feelingCount == 2 then
                -- Supprimer la plateforme brisée
                table.remove(broke, _)
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

    love.graphics.setColor(1, 1, 0) -- Jaune
    for _, broke in ipairs(broke) do
        love.graphics.rectangle("fill", broke.x, broke.y, broke.width, broke.height)
        
    end

    if player.onGround then
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("On Ground", player.x, player.y - 20)
    else
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.print("Not on Ground", player.x, player.y - 20)
    end
end
