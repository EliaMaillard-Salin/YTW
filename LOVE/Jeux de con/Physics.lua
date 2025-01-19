local Physics = {}

local Player = require "Player"
local Platform = require "Platform"
local BrokenPlatform = require "BrokenPlatform"

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

function isColliding(a,b)
    if ((b.x >= a.x + a.width) or
        (b.x + b.width <= a.x) or
        (b.y >= a.y + a.height) or
        (b.y + b.height <= a.y)) then
           return false 
    else return true
        end
 end

function Physics.Collision(object1, platforms ,dt)
    for _, object2 in ipairs(platforms) do
        -- Obtenir les positions et dimensions des objets
        local playerX, playerY, playerWidth, playerHeight = object1.x, object1.y, object1.width, object1.height
        local platX, platY, platWidth, platHeight = object2.x, object2.y, object2.width, object2.height

        

        local object1NextFrame = Player:New(object1.x, object1.y)
        local object2 = Platform:new(object2.x, object2.y, object2.width, object2.height)
        object1NextFrame.width = object1.width
        object1NextFrame.height = object1.height    
        object1NextFrame.speedY = object1.speedY
        object1NextFrame.speedX = object1.speedX
    
        if isColliding(object1,object2) then
            object1NextFrame:Move(dt)

            local AisToTheRightOfB = playerX > platX + platWidth;
            local AisToTheLeftOfB = playerX + playerWidth < platX;
            local AisAboveB = playerY + playerHeight < platY;
            local AisBelowB = playerY > platY + platHeight;

            local CollidenextFrameRight = (object1NextFrame.x > object2.x + object2.width )
            local CollidenextFrameLeft = (object1NextFrame.x + object1.width < object2.x)
            local CollidenextFrameAbove = (object1NextFrame.y + object1.height <= object2.y) and CollidenextFrameLeft ~= true and CollidenextFrameRight ~= true
            -- local CollidenextFrameBelow = CollidenextFrameLeft ~= true and CollidenextFrameRight ~= true and CollidenextFrameAbove ~= true
            local CollidenextFrameBelow = (object1NextFrame.y >= object2.y + object2.height) 
            
            print("sur le sol", object1.onGround)
            print("à droite", AisToTheRightOfB)
            if not CollidenextFrameAbove and not CollidenextFrameBelow and not CollidenextFrameLeft and not CollidenextFrameRight then
                object1.onGround = true
            else
                object1.onGround = false
            end 

            if CollidenextFrameBelow then
                if object1.speedY < 0 then -- Si le joueur monte
                    object1.speedY = 0 -- Annule la vitesse verticale
                    object1.y = object2.y + object2.height + 1 -- Positionne le joueur juste en dessous de la plateforme
                end
            end

            if AisToTheLeftOfB then
                if object1.dirX == 1 and object1.x + object1.width >= object2.x - 10 then
                    object1.speedX = 0
                    object1.x = object2.x - object1.width - 1
                elseif object1.dirX == -1 then
                    object1.speedX = 150
                end
            end

            if AisToTheRightOfB then
                -- Si le joueur se déplace vers la gauche et touche la plateforme par la droite
                if object1.dirX == -1 and object1.x <= object2.x + object2.width + 2 and 
                object1.y + object1.height > object2.y and object1.y < object2.y + object2.height then
                    -- Collision détectée à droite
                    print("Collision à droite détectée")
                    object1.speedX = 0
                    object1.x = object2.x + object2.width + 1 -- Place légèrement à droite de la plateforme
                end
            end


            if CollidenextFrameAbove then
                if object1.currentState == "idle" then
                    object1.y = playerY
                elseif object1.currentState == "moving" then
                    if(object1.y + object1.height > object2.y) then
                        object1.onGround = false
                    end
                elseif object1.currentState == "jumping" then
                    object1.onGround = false
                end
            end




            

        --[[
        elseif CollidenextFrameBelow and not CollidenextFrameRight or CollidenextFrameLeft then
            print("test2")
            object1.y = playerY + platHeight
            object1.onGround = false
        end
        ]]

            if object1.onGround then
                object1.speedY = 1
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
        end
    end
end

return Physics

