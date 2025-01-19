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
        player.speedY = player.speedY + (player.gravity * dt)
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
        player.onGround = false
        player.dirY = 1

    end,
    Update = function(player, dt)
        -- Transition vers 'idle' si au sol
        player.speedY = player.speedY + (player.gravity * dt)

        if player.onGround or player.speedY > 0 then
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
    end,
    Update = function(player, dt)
        local progress = (0.2 - player.dashTimer) / 0.2
        if player.dashDirection == "right" then
            player.x = player.dashStartX + player.speedDistance * progress
        elseif player.dashDirection == "left" then
            player.x = player.dashStartX - player.speedDistance * progress
        elseif player.dashDirection == "up" then
            player.y = player.dashStartY - player.speedDistance * progress
        elseif player.dashDirection == "right_up" then
            player.y = player.dashStartY - player.speedDistance * progress
            player.x = player.dashStartX + player.speedDistance * progress
        elseif player.dashDirection == "left_up" then
            player.y = player.dashStartY - player.speedDistance * progress
            player.x = player.dashStartX - player.speedDistance * progress
        elseif player.dashDirection == "left_down" then
            player.x = player.dashStartX - player.speedDistance * progress
            player.y = player.dashStartY + player.speedDistance * progress
        elseif player.dashDirection == "right_down" then
            player.x = player.dashStartX + player.speedDistance * progress
            player.y = player.dashStartY + player.speedDistance * progress
        end

        player.dashTimer = player.dashTimer - dt


        if player.dashTimer <= 0 then
            player:ChangeState(STATES.IDLE)
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'dashing'")
    end
}

return PlayerStates