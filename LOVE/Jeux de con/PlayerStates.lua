PlayerStates = {}

local STATES = {}
STATES.DASHING = "dashing"
STATES.IDLE = "idle"
STATES.JUMPING = "jumping"
STATES.FALLING = "falling"
STATES.MOVING = "moving"

PlayerStates.idle = {
    Enter = function(player)
        print("Entrée dans l'état 'idle'")
    end,
    Update = function(player, dt)
        -- Change Sprite
        if not player.onGround then
            player:ChangeState("falling")
        elseif love.keyboard.isDown("d") or love.keyboard.isDown("q") then
            player:ChangeState("moving")
        elseif love.keyboard.isDown("space") and player.onGround then
            player.speedY = player.jumpPower
            player.onGround = false
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
        if love.keyboard.isDown("d") then        
            player.x = player.x + player.speedX * dt
        elseif love.keyboard.isDown("q") then
            player.x = player.x - player.speedX * dt
        else
            player:ChangeState("idle")
        end

        if love.keyboard.isDown("space") and player.onGround then
            player.speedY = player.jumpPower
            player.onGround = false
            player:ChangeState("jumping")
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'moving'")
    end
}

PlayerStates.jumping = {
    Enter = function(player)
        print("Entrée dans l'état 'jumping'")
        if player.speedY == 0 then
            player.speedY = player.jumpPower
        end
    end,
    Update = function(player, dt)
        player.speedY = player.speedY + (player.gravity * dt)
        player.y = player.y + (player.speedY * dt)

        -- Mouvement horizontal (axe X)
        if love.keyboard.isDown("d") then
            player.x = player.x + (player.speedX * dt)
            player.direction = "right"
        elseif love.keyboard.isDown("q") then
            player.x = player.x - (player.speedX * dt)
            player.direction = "left"
        end

        if player.speedY >= 0 then
            player:ChangeState("falling")
        end
    end,
    Exit = function(player)
        print("Sortie de l'état 'jumping'")
    end
}

PlayerStates.falling = {
    Enter = function(player)
        print("Entrée dans l'état 'falling'")
    end,
    Update = function(player, dt)
        -- Mouvement horizontal
        
        if love.keyboard.isDown("d") then
            player.x = player.x + (player.speedX * dt)
        elseif love.keyboard.isDown("q") then
            player.x = player.x - (player.speedX * dt)
        end

        -- Transition vers 'idle' si au sol
        if player.onGround then
            player:ChangeState("idle")
        end
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