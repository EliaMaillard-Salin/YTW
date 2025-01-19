PlayerStates = {}

local STATES = {}
STATES.DASHING = "dashing"
STATES.IDLE = "idle"
STATES.JUMPING = "jumping"
STATES.FALLING = "falling"
STATES.MOVING = "moving"

local function handleMovement(player, dt)
    -- Gérer le mouvement horizontal (X)
    if love.keyboard.isDown("d") then
        player.direction = "right"
        player.dirX = 1
    elseif love.keyboard.isDown("q") then
        player.direction = "left"
        player.dirX = -1
    else
        player.dirX = 0
    end
    -- Calculer les nouvelles positions pour les axes X et Y
    player.x = player.x + player.speedX * player.dirX * dt
    player.y = player.y + (player.speedY * dt)

end

PlayerStates.idle = {
    Enter = function(player)
        print("Entrée dans l'état 'idle'")
        end,
    Update = function(player, dt)
        -- Change Sprite
        player.speedY = player.speedY + (player.gravity * dt)

        handleMovement(player, dt)

        if player.onGround == false then
            player:ChangeState("falling")
        elseif love.keyboard.isDown("d") or love.keyboard.isDown("q") then
            player:ChangeState("moving")
        elseif love.keyboard.isDown("space") and player.onGround then
            player:ChangeState("jumping") 
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'idle'")
    end
}

PlayerStates.moving = {
    Enter = function(player)
        print("Entrée dans l'état 'moving'")
    end,
    Update = function(player, dt)
        if not player.isStomping then
            player.speedY = player.speedY + (player.gravity * dt)
        end

        handleMovement(player, dt)

        if not player.onGround then
            player:ChangeState(STATES.FALLING)
        elseif player.dirX == 0 then  -- Si aucune touche de direction n'est pressée
            player:ChangeState(STATES.IDLE)
        end

        -- Si le joueur est sur le sol et appuie sur 'space', il saute
        if love.keyboard.isDown("space") and player.onGround then
            player:ChangeState(STATES.JUMPING)
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'moving'")
        player.dirX = 0 -- Réinitialiser la direction
    end
}


PlayerStates.jumping = {
    Enter = function(player)
        print("Entrée dans l'état 'jumping'")
        player.onGround = false
        player.speedY = player.jumpPower
        print('speedY1', player.speedY)
        player.dirY = -1
    end,
    Update = function(player, dt)
        -- Mettre à jour la vitesse Y pour la gravité
        if not player.isStomping then
            player.speedY = player.speedY + (player.gravity * dt)
        end
        -- Appeler handleMovement pour gérer les déplacements horizontaux et verticaux
        handleMovement(player, dt)

        if(player.speedY > 0) then
            player:ChangeState(STATES.FALLING)
            end

    end,
    Exit = function(player)
        print("Sortie de l'état 'jumping'")
    end
}


PlayerStates.falling = {
    Enter = function(player)
        print("Entrée dans l'état 'falling'")
        player.dirY = 1
        player.speedY = 0
    end,
    Update = function(player, dt)
        -- Transition vers 'idle' si au sol
        if not player.isStomping then
            player.speedY = player.speedY + (player.gravity * dt)
        end

        if player.onGround then
            player:ChangeState("idle")
        end

        handleMovement(player, dt)


    end,
    Exit = function(player)
        print("Sortie de l'état 'falling'")
    end
}

PlayerStates.dashing = {
    Enter = function(player)
        print("Entrée dans l'état 'dashing'")
        player.dashStartX = player.x
        player.dashStartY = player.y
        player.dashDirectionX = 0
        player.dashDirectionY = 0

        if player.dashDirection == "right" then
            player.dashDirectionX = 1
        elseif player.dashDirection == "left" then
            player.dashDirectionX = -1
        elseif player.dashDirection == "up" then
            player.dashDirectionY = -1
        elseif player.dashDirection == "down" then
            player.dashDirectionY = 1
        elseif player.dashDirection == "right_up" then
            player.dashDirectionX = 1
            player.dashDirectionY = -1
        elseif player.dashDirection == "left_up" then
            player.dashDirectionX = -1
            player.dashDirectionY = -1
        elseif player.dashDirection == "right_down" then
            player.dashDirectionX = 1
            player.dashDirectionY = 1
        elseif player.dashDirection == "left_down" then
            player.dashDirectionX = -1
            player.dashDirectionY = 1
        end
        local magnitude = math.sqrt(player.dashDirectionX^2 + player.dashDirectionY^2)
        if magnitude > 0 then
            player.dashDirectionX = player.dashDirectionX / magnitude
            player.dashDirectionY = player.dashDirectionY / magnitude
        end
    end,
    Update = function(player, dt)
        local distance = player.speedDistance * dt
        -- Mettre à jour les positions selon les directions
        player.x = player.x + player.dashDirectionX * distance
        player.y = player.y + player.dashDirectionY * distance
        
        -- Réduire le temps du dash
        player.dashTimer = player.dashTimer - dt

        -- Transitionner à un autre état après le dash
        if player.dashTimer <= 0 then
            if player.onGround then
                player:ChangeState(STATES.IDLE)
            else
                player:ChangeState(STATES.FALLING)
            end
        end

    end,
    Exit = function(player)
        print("Sortie de l'état 'dashing'")
        player.dashDirectionX = 0
        player.dashDirectionY = 0
        player.onGround = false
    end
}

return PlayerStates