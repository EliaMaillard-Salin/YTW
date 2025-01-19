local PlayerStates = require("PlayerStates")
local PlayerFeeling = require("PlayerFeeling")

Player = {}

local STATES = {}
STATES.DASHING = "dashing"
STATES.IDLE = "idle"
STATES.JUMPING = "jumping"
STATES.FALLING = "falling"
STATES.MOVING = "moving"

function Player:New(x, y)
    local obj = {
        x = x,
        y = y,
        dirX = 0, 
        dirY = 0,
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
        states = PlayerStates,
        currentState = STATES.IDLE,
        feeling = nil,
        currentFeeling = 0,
        changingState = false
    }
    setmetatable(obj, self)
    self.__index = self  
    obj.feeling = PlayerFeeling:Create()
    
    print("Player created with state: " .. tostring(obj.state))  -- Debugging statement
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

    self.timer = self.timer + dt

    
    self.dirX = 0
    self.dirY = 0
    self.speedY = self.speedY + self.gravity * dt
    
    self:CheckCollisionWithPlatform(platform)
    
    if self.dashCooldownTimer > 0 then
        self.dashCooldownTimer = self.dashCooldownTimer - dt
    end
    
    self.feeling:Update(self, dt)
    
    self:handleMovement(dt)
    self:Move(dt)
    
    
    if self.states[self.currentState].Update then
        self.states[self.currentState].Update(self, dt)
    end    
    self.y = self.y + self.speedY * dt

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

    love.graphics.setColor(255, 255, 255)
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

    local buttonPressed = 0
    -- Vérifier si le joueur veut planer pendant la chute (par exemple avec la touche "space")
    if self.currentFeeling == 1 then
        if self.currentState == STATES.FALLING then
            if love.keyboard.isDown("space") then  -- Si "space" est pressé
                -- Appliquer l'effet de planage en réduisant la vitesse verticale
                self.speedY = self.speedY * 0.85  -- Par exemple, réduire la vitesse de 2% à chaque frame
            end
        end
        

    end

    if love.keyboard.isDown('u') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Neutral)
        self.currentFeeling = 0
    end
    if love.keyboard.isDown('i') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Sadness)
        self.currentFeeling = 1
    end
    if love.keyboard.isDown('o') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Anger)
        self.currentFeeling = 2
    end
    if love.keyboard.isDown('p') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Joy)
        self.currentFeeling = 3
    end

    if love.keyboard.isDown('lshift') and self.dashCooldownTimer <= 0 and buttonPressed < 1 then
        if self.onGround or (not self.onGround and not self.hasDashedInAir) then
            buttonPressed = buttonPressed + 1
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
            buttonPressed = 0
            if not self.onGround then
                self.hasDashedInAir = true
            end
            self.dashCooldownTimer = self.dashCooldown
            self:ChangeState(STATES.DASHING)
        end
    end

    -- Réinitialiser les dashs si au sol
    if self.onGround then
        buttonPressed = 0
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

function  Player:Move(dt)
    self.x = self.x + (self.dirX * self.speedX * dt)
    self.y = self.y +  ( self.speedY * dt )
end

function Player:ChangeState(newState)
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
