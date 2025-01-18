local Physics = {}

local Player = require "Player"
local Platform = require "Platform"

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

function Physics.Collision(object1, object2,dt)
    local iscolliding = false

    -- Obtenir les positions et dimensions des objets
    local playerX, playerY, playerWidth, playerHeight = object1.x, object1.y, object1.width, object1.height
    local platX, platY, platWidth, platHeight = object2.x, object2.y, object2.width, object2.height

    --[[
    local AisToTheRightOfB = playerX > platX + platWidth;
    local AisToTheLeftOfB = playerX + playerWidth < platX;
    local AisAboveB = playerY + playerHeight < platY;
    local AisBelowB = playerY > platY + platHeight;
    ]]

    local object1NextFrame = Player:new(object1.x, object1.y)
    local object2NextFrame = Platform:new(object2.x, object2.y)
    object1NextFrame.width = object1.width
    object1NextFrame.height = object1.height
    object2NextFrame.width = object2.width
    object2NextFrame.height = object2.height
    
    object1NextFrame.speedY = object1.speedY
    object1NextFrame.speedX = object1.speedX
   
    object1NextFrame:Move(dt)

    local CollidenextFrameRight = (object1NextFrame.x + object1NextFrame.width > object2NextFrame.x)
    local CollidenextFrameLeft = (object1NextFrame.x < object2NextFrame.x + object2NextFrame.width)
    local CollidenextFrameAbove = (object1NextFrame.y < object2NextFrame.y + object2NextFrame.height)
    local CollidenextFrameBelow = (object1NextFrame.y + object1NextFrame.height > object2NextFrame.y)

    if CollidenextFrameAbove and not CollidenextFrameRight or CollidenextFrameLeft then
        print("test")
        object1.y = playerY
        object1.onGround = true
    elseif CollidenextFrameBelow and not CollidenextFrameRight or CollidenextFrameLeft then
        print("test2")
        object1.y = playerY + platHeight
        object1.onGround = false
    end

    if CollidenextFrameRight and not CollidenextFrameAbove and not CollidenextFrameBelow then
        print("test3")
        object1.x = playerX
    elseif CollidenextFrameLeft and not CollidenextFrameAbove and not CollidenextFrameBelow then
        print("test4")
        object1.x = playerX + playerWidth
    end

    if object1.onGround then
        object1.speedY = 0
    end
    --[[
    -- Si une collision est détectée frame d'après
    if not (CollidenextFrameRight or CollidenextFrameLeft or CollidenextFrameAbove or CollidenextFrameBelow) then
        -- Résolution de la collision sur l'axe Y
        if AisAboveB then
            print("on est la")
            if not AisToTheLeftOfB and not AisToTheRightOfB then
                print("dessus")
                object1.y = platY - playerHeight
                object1.onGround = true
            else
                print("yahoo")
                object1.onGround = false
            end
            -- Placer au-dessus
        elseif AisBelowB then
            object1.y = platY + platHeight 
            -- Placer en dessousd
        -- Résolution de la collision sur l'axe X
        elseif AisToTheLeftOfB then
            print("gauche")
            object1.x = platX - playerWidth -- Placer à gauche
        elseif AisToTheRightOfB then
            print("droite")
            object1.x = platX + platWidth -- Placer à droite
        end
    elseif CollidenextFrameAbove then
        print("ici")
        object1.onGround = true
    elseif not CollidenextFrameBelow then
        print("feur")
         object1.onGround = false
    end
]]
    return iscolliding
end

return Physics

