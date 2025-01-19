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

-- État IDLE
PlayerStates.idle = {
    Enter = function(player)
        print("Entrée dans l'état 'idle'")
        if player.currentFeeling == 3  and player.onGround == true then
            player.jumpCount = 2
        else 
            player.jumpCount = 0
        end
    end,
    Update = function(player, dt)
        player.speedY = player.speedY + (player.gravity * dt)

        handleMovement(player, dt)

        if not player.onGround then
            player:ChangeState(STATES.FALLING)
        elseif love.keyboard.isDown("d") or love.keyboard.isDown("q") then
            player:ChangeState(STATES.MOVING)
        elseif love.keyboard.isDown("space") and (player.onGround or player.jumpCount > 0) then
            player:ChangeState(STATES.JUMPING)
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'idle'")
    end
}

-- État MOVING
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
        elseif player.dirX == 0 then
            player:ChangeState(STATES.IDLE)
        elseif love.keyboard.isDown("space") and (player.onGround or player.jumpCount > 0) then
            player:ChangeState(STATES.JUMPING)
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'moving'")
    end
}

-- État JUMPING
PlayerStates.jumping = {
    Enter = function(player)
        print("Entrée dans l'état 'jumping'")
        player.onGround = false
        player.speedY = player.jumpPower
        player.jumpCount = player.jumpCount - 1 -- Consommer un saut
        player.dirY = -1
        if player.jumpCount <= 0 then 
            player.jumpCount = 0
        end
        if player.currentFeeling ~= 3 then
            player.jumpCount = 0
        end

        print("Saut restant :", player.jumpCount)
    end,
    Update = function(player, dt)
        -- Mettre à jour la vitesse Y pour la gravité
        if not player.isStomping then
            player.speedY = player.speedY + (player.gravity * dt)
        end
        -- Appeler handleMovement pour gérer les déplacements horizontaux et verticaux
        handleMovement(player, dt)

        if player.speedY > 0 then
            player:ChangeState(STATES.FALLING)
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'jumping'")
    end
}

-- État FALLING
PlayerStates.falling = {
    Enter = function(player)
        print("Entrée dans l'état 'falling'")
        player.dirY = 1
        player.speedY = 0
    end,
    Update = function(player, dt)
        if not player.isStomping then
            player.speedY = player.speedY + (player.gravity * dt)
        end        
        handleMovement(player, dt)

        if player.onGround then
            player:ChangeState(STATES.IDLE)
        elseif love.keyboard.isDown("space") and player.jumpCount > 0 then
            player:ChangeState(STATES.JUMPING)
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'falling'")
    end
}

-- État DASHING (inchangé dans cet exemple)
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