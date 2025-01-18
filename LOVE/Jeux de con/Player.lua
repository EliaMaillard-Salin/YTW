require ("PlayerFeeling")

Player = {}

function Player:new(x, y)
    local obj = {
        x = x,
        y = y,
        speedX = 150,  
        speedY = 0,    
        jumpPower = -300,  
        gravity = 800,
        sprite = nil,
        width = 50,   
        height = 50,  
        onGround = false,  
        speedDistance = 200,
        dashCount = 0,
        maxDash = 1,
        dashTimer = 0,
        dashCooldown = 1,
        dashCooldownTimer = 0,
        dashStartX = 0,
        dashStartY = 0,
        dashDirection = " ",
        timer = 0, 
        hasDashedInAir = false,
        feeling = PlayerFeeling:Create()
    }
    setmetatable(obj, self)
    self.__index = self  
    return obj
end

function Player:load()
    if self.sprite then
        self.width = self.sprite:getWidth()
        self.height = self.sprite:getHeight()
    end
end

function Player:update(dt)
    --self.feeling.Update()

    self.speedY = self.speedY + self.gravity * dt

    -- Gérer le cooldown du dash
    if self.dashCooldownTimer > 0 then
        self.dashCooldownTimer = self.dashCooldownTimer - dt
    end

    self.timer = self.timer + dt
    self:handleMovement(dt)

    self.y = self.y + self.speedY * dt
end

function Player:draw()
    
    if (self.dashCooldownTimer <= 0 and self.dashCount < self.maxDash) then
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end

    if self.sprite then
        love.graphics.draw(self.sprite, self.x, self.y)
    else
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end

function Player:handleMovement(dt)
    -- Gérer le dash avec cooldown
    if love.keyboard.isDown('u') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Neutral)
    end
    if love.keyboard.isDown('i') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Sadness)
    end
    if love.keyboard.isDown('o') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Anger)
    end
    if love.keyboard.isDown('p') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Joy)
    end

    if love.keyboard.isDown('lshift') and self.dashCooldownTimer <= 0 then
        -- Si le joueur est au sol ou qu'il n'a pas encore effectué de dash en l'air
        if self.onGround or (not self.onGround and not self.hasDashedInAir) then
            -- Déterminer la direction du dash
            if love.keyboard.isDown('d') and love.keyboard.isDown('z') then
                -- Dash diagonale haut-droite
                self.dashDirection = "right_up"
            elseif love.keyboard.isDown('q') and love.keyboard.isDown('z') then
                -- Dash diagonale haut-gauche
                self.dashDirection = "left_up"
            elseif love.keyboard.isDown('d') then
                -- Dash horizontal droite
                self.dashDirection = "right"
            elseif love.keyboard.isDown('q') then
                -- Dash horizontal gauche
                self.dashDirection = "left"
            elseif love.keyboard.isDown('space') then
                -- Dash vertical (haut)
                self.dashDirection = "up"
            end

            -- Démarrer un dash et initialiser le timer
            self.dashTimer = 0.2  -- Durée du dash en secondes
            self.dashStartX = self.x  -- Enregistrer la position de départ
            self.dashStartY = self.y  -- Enregistrer la position de départ
            self.dashCount = self.dashCount + 1

            -- Si c'est un dash en l'air, marquer cette condition
            if not self.onGround then
                self.hasDashedInAir = true
            end

            -- Réinitialiser le cooldown
            self.dashCooldownTimer = self.dashCooldown
        end
    end
    
    -- Si un dash est actif, déplacer le joueur progressivement
    if self.dashTimer > 0 then
        -- Calculer le déplacement en fonction de la direction du dash
        if self.dashDirection == "right" then
            self.x = self.dashStartX + (self.speedDistance * (1 - self.dashTimer / 0.2))  -- Déplacement progressif vers la droite
        elseif self.dashDirection == "left" then
            self.x = self.dashStartX - (self.speedDistance * (1 - self.dashTimer / 0.2))  -- Déplacement progressif vers la gauche
        elseif self.dashDirection == "up" then
            self.y = self.dashStartY - (self.speedDistance * (1 - self.dashTimer / 0.2))  -- Déplacement progressif vers le haut
        elseif self.dashDirection == "right_up" then
            -- Déplacement en diagonale haut-droite
            self.y = self.dashStartY - (self.speedDistance * (1 - self.dashTimer / 0.2))  -- Déplacement vertical
            self.x = self.dashStartX + (self.speedDistance * (1 - self.dashTimer / 0.2))  -- Déplacement horizontal
        elseif self.dashDirection == "left_up" then
            -- Déplacement en diagonale haut-gauche
            self.y = self.dashStartY - (self.speedDistance * (1 - self.dashTimer / 0.2))  -- Déplacement vertical
            self.x = self.dashStartX - (self.speedDistance * (1 - self.dashTimer / 0.2))  -- Déplacement horizontal
        end
        -- Réduire le timer du dash
        self.dashTimer = self.dashTimer - dt
    end

    -- Gestion du cooldown du dash
    if self.dashCooldownTimer > 0 then
        self.dashCooldownTimer = self.dashCooldownTimer - dt  -- Décrémenter le cooldown
    end

    -- Réinitialiser le dashCount au sol
    if self.onGround then
        -- Si le joueur touche le sol, réinitialiser le dash en l'air
        self.hasDashedInAir = false
        self.dashCount = 0  -- Réinitialiser le compteur de dashes lorsqu'on est au sol
    end

    -- Mouvement normal (en dehors du dash)
    if love.keyboard.isDown('d') then
        self.direction = "right"
        self.x = self.x + (self.speedX * dt)
    elseif love.keyboard.isDown('q') then
        self.direction = "left"
        self.x = self.x - (self.speedX * dt)
    end

    if love.keyboard.isDown('space') and self.onGround then
        self.direction = "up"
        self.speedY = self.jumpPower
        self.onGround = false 
    end
end

function Player:checkCollisionWithPlatform(platform)
    if self.y + self.height <= platform.y and 
       self.y + self.height + self.speedY * love.timer.getDelta() >= platform.y and 
       self.x + self.width > platform.x and 
       self.x < platform.x + platform.width then
        self.y = platform.y - self.height
        self.speedY = 0
        self.onGround = true 
    end
end

return Player
