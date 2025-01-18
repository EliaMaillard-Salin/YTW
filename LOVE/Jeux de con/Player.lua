local playerStates = require("playerStates")

Player = {}

function Player:New(x, y)
    local obj = {
        x = x,
        y = y,
        speedX = 150,  
        speedY = 0,    
        jumpPower = -500,  
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
        states = playerStates,
        currentState = "idle",
    }
    setmetatable(obj, self)
    self.__index = self  
    return obj
end

function Player:Load()
    if self.sprite then
        self.width = self.sprite:getWidth()
        self.height = self.sprite:getHeight()
    end

    if self.states[self.currentState].Enter then
        self.states[self.currentState].Enter(self)
    end
end

function Player:Update(dt, platform)
    self.speedY = self.speedY + self.gravity * dt

    self:CheckCollisionWithPlatform(platform)

    -- Gérer le cooldown du dash
    if self.dashCooldownTimer > 0 then
        self.dashCooldownTimer = self.dashCooldownTimer - dt
    end

    self:HandleMovement(dt)

    if self.states[self.currentState].Update then
        self.states[self.currentState].Update(self, dt)
    end

    self.y = self.y + self.speedY * dt
end

function Player:Draw()
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

function Player:HandleMovement(dt)
    -- Détection du dash
    print(self.dashCount)
    if love.keyboard.isDown('lshift') and self.dashCooldownTimer <= 0 then
        if self.onGround or (not self.onGround and not self.hasDashedInAir) then
            if love.keyboard.isDown('d') and love.keyboard.isDown('z') then
                self.dashDirection = "right_up"
            elseif love.keyboard.isDown('q') and love.keyboard.isDown('z') then
                self.dashDirection = "left_up"
            elseif love.keyboard.isDown('q') and love.keyboard.isDown('s') then
                self.dashDirection = "left_down"
            elseif love.keyboard.isDown('d') and love.keyboard.isDown('s') then
                self.dashDirection = "right_down"
            elseif love.keyboard.isDown('d') then
                self.dashDirection = "right"
            elseif love.keyboard.isDown('q') then
                self.dashDirection = "left"
            elseif love.keyboard.isDown('space') then
                self.dashDirection = "up"
            end

            -- Initialisation du dash
            self.dashTimer = 0.2
            self.dashCount = self.dashCount + 1
            if not self.onGround then
                self.hasDashedInAir = true
            end
            self.dashCooldownTimer = self.dashCooldown
            self:changeState("dashing")
        end
    end

    -- Réinitialiser les dashs si au sol
    if self.onGround then
        self.hasDashedInAir = false
        self.dashCount = 0
    end
end

function Player:CheckCollisionWithPlatform(platform)
    if self.y + self.height <= platform.y and 
       self.y + self.height + self.speedY * love.timer.getDelta() >= platform.y and 
       self.x + self.width > platform.x and 
       self.x < platform.x + platform.width then
        self.y = platform.y - self.height
        self.speedY = 0
        self.onGround = true 
    end
end

function Player:changeState(newState)
    -- Appeler la fonction `exit` de l'état courant
    if self.states[self.currentState].Exit then
        self.states[self.currentState].Exit(self)
    end

    -- Changer l'état
    self.currentState = newState

    -- Appeler la fonction `enter` du nouvel état
    if self.states[self.currentState].Enter then
        self.states[self.currentState].Enter(self)
    end
end

return Player
