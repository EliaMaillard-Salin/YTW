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
        if player.feelingCount == 3  and player.onGround == true then
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
        if player.jumpCount <= 0 then 
            player.jumpCount = 0
        end
        if player.feelingCount ~= 3 then
            player.jumpCount = 0
        end

        print("Saut restant :", player.jumpCount)
    end,
    Update = function(player, dt)
        player.speedY = player.speedY + (player.gravity * dt)
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
        player.onGround = false
    end,
    Update = function(player, dt)
        player.speedY = player.speedY + (player.gravity * dt)
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
    end,
    Update = function(player, dt)
        local progress = (0.2 - player.dashTimer) / 0.2
        if player.dashDirection == "right" then
            player.x = player.dashStartX + player.speedDistance * progress
        elseif player.dashDirection == "left" then
            player.x = player.dashStartX - player.speedDistance * progress
        elseif player.dashDirection == "up" then
            player.y = player.dashStartY - player.speedDistance * progress
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