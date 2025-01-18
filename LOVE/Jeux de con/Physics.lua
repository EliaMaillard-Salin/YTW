local Physics = {}

local Player = require "Player"

local player = nil

-- Fonction pour créer un objet physique
function Physics.createObject(x, y, width, height, vx, vy, mass)
    return {
        x = x,
        y = y,
        width = width,
        height = height,
        vx = vx,
        vy = vy,
        mass = mass,
        gravity = 800,
        friction = 0.98,
        onGround = false,
        alreadyCollideY = false
    }
end


-- Mise à jour des objets physiques
function Physics.update(objects, dt)
    for _, obj in ipairs(objects) do
        if not obj.onGround then
            obj.vy = obj.vy + obj.gravity * dt
        end
        obj.x = obj.x + obj.vx * dt
        obj.y = obj.y + obj.vy * dt
        obj.vx = obj.vx * obj.friction
        obj.vy = obj.vy * obj.friction

        if obj.y + obj.height >= 480 then
            obj.y = 480 - obj.height
            obj.vy = 0
            obj.onGround = true
        else
            obj.onGround = false
        end
    end
end

function Physics.Collision(object1, object2)
    local iscolliding = false

    -- Obtenir les positions et dimensions des objets
    local x1, y1, width1, height1 = object1.x, object1.y, object1.width, object1.height
    local x2, y2, width2, height2 = object2.x, object2.y, object2.width, object2.height

    -- Vérifier les collisions
    local x_collision = x1 < x2 + width2 and x1 + width1 > x2
    local y_collision = y1 < y2 + height2 and y1 + height1 > y2

    -- Si une collision est détectée
    if x_collision and y_collision then
        iscolliding = true
        

        -- Si object1 est en dessous de object2
        if y1 > y2 then
            print("lkjhlkjhlkjhgfd")
            -- Vérifier que les fonctions existent avant de les appeler
            if type(object1.SetDirection) == "function" then 
                print("ta tante")
                object1:SetDirection(object2.x, object2.y + height2) -- Exemple : Réinitialiser la direction
            elseif type(object1.GoToDirection) == "function" then
                print("ton onle")
                object1:GoToDirection(0, 0, 0) -- Exemple : Arrêter object1
            end
        end

        -- Résolution de la collision sur l'axe Y
        if y1 + height1 > y2 and y1 < y2 then
            object1.y = y2 - height1 -- Placer au-dessus
        elseif y1 < y2 + height2 and y1 + height1 > y2 + height2 then
            object1.y = y2 + height2 -- Placer en dessous
        end

        -- Résolution de la collision sur l'axe X
        if x1 + width1 > x2 and x1 < x2 then
            object1.x = x2 - width1 -- Placer à gauche
        elseif x1 < x2 + width2 and x1 + width1 > x2 + width2 then
            object1.x = x2 + width2 -- Placer à droite
        end
    end

    return iscolliding
end


-- function IsSpritesColliding(sprite1, sprite2)
--     -- Récupérer les rectangles englobants des deux sprites
--     local rect1 = { x = sprite1.x, y = sprite1.y, width = sprite1:getWidth(), height = sprite1:getHeight() }
--     local rect2 = { x = sprite2.x, y = sprite2.y, width = sprite2:getWidth(), height = sprite2:getHeight() }

--     -- Vérification du chevauchement sur l'axe X et Y
--     local xOverlap = rect1.x + rect1.width > rect2.x and rect1.x < rect2.x + rect2.width
--     local yOverlap = rect1.y + rect1.height > rect2.y and rect1.y < rect2.y + rect2.height

--     -- Si les sprites se chevauchent, traiter la collision
--     if xOverlap and yOverlap then
--         -- Trouver l'axe de chevauchement le plus important (X ou Y)
--         local overlapX = math.min(rect1.x + rect1.width - rect2.x, rect2.x + rect2.width - rect1.x)
--         local overlapY = math.min(rect1.y + rect1.height - rect2.y, rect2.y + rect2.height - rect1.y)

--         -- Déplacer le sprite 1 pour le séparer selon l'axe de chevauchement le plus petit
--         if overlapX < overlapY then
--             if rect1.x < rect2.x then
--                 sprite1.x = sprite1.x - overlapX -- Déplace sprite1 à gauche
--             else
--                 sprite1.x = sprite1.x + overlapX -- Déplace sprite1 à droite
--             end
--         else
--             if rect1.y < rect2.y then
--                 sprite1.y = sprite1.y - overlapY -- Déplace sprite1 vers le haut
--             else
--                 sprite1.y = sprite1.y + overlapY -- Déplace sprite1 vers le bas
--             end
--         end

--         return true -- Collision détectée et résolution effectuée
--     end

--     return false -- Pas de collision
-- end












return Physics

