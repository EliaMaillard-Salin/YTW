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
        speedX = 150,  
        speedY = 1,    
        maxSpeedY = 300,
        dirX = 0,
        dirY = 0,
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
        hasDashedInAir = false,
        feeling = PlayerFeeling:Create(),
        states = PlayerStates,
        currentState = STATES.IDLE,
        currentFeeling = 0,
        isColliding = false,
        nextX = 0,
        nextY = 50,
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

function Player:Update(dt)

    self.speedY = self.speedY + self.gravity * dt
    self.feeling:Update(self, dt)

    if self.speedY > self.maxSpeedY then
        self.speedY = self.maxSpeedY
    end
    -- Gérer le cooldown du dash
    if self.dashCooldownTimer > 0 then
        self.dashCooldownTimer = self.dashCooldownTimer - dt
    end

    self:handleMovement(dt)

    if self.states[self.currentState].Update then
        self.states[self.currentState].Update(self, dt)
    end
end

function Player:handleMovement(dt)
    
    local buttonPressed = 0
    -- Vérifier si le joueur veut planer pendant la chute (par exemple avec la touche "space")
    if self.currentFeeling == 1 then
        if self.currentState == STATES.FALLING then
            if love.keyboard.isDown("space") then  -- Si "space" est pressé
                -- Appliquer l'effet de planage en réduisant la vitesse verticale
                self.speedY = self.speedY * 0.85  -- Par exemple, réduire la vitesse de 2% à chaque frame
            end
        end
    elseif self.currentFeeling == 2 then
        if not self.onGround then
            if love.keyboard.isDown("s") then
                self.speedY = self.speedY * 1.25
            end
        end
    end

    if love.keyboard.isDown('u') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Neutral)
        self.feelingCount = 0
        self.changingState = true
    end
    if love.keyboard.isDown('i') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Sadness)
        self.feelingCount = 1
        self.changingState = true
    end
    if love.keyboard.isDown('o') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Anger)
        self.feelingCount = 2
        self.changingState = true
    end
    if love.keyboard.isDown('p') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Joy)
        self.feelingCount = 3
        self.changingState = true
    end

        -- Vérifier si le joueur veut planer pendant la chute (par exemple avec la touche "space")
        if self.currentFeeling == 1 then
            if self.currentState == STATES.FALLING then
                if love.keyboard.isDown("space") then  -- Si "space" est pressé
                    -- Appliquer l'effet de planage en réduisant la vitesse verticale
                    self.speedY = self.speedY * 0.85  -- Par exemple, réduire la vitesse de 2% à chaque frame
                end
            end
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

function Player:SetPosition(x, y)
    self.x = x
    self.y = y
end

function Player:GoToDirection(x, y, speed)
    if speed > 0 then
        self.mSpeed = speed
    end

    local position = self:GetPosition()
    local X = x - position.x
    local Y = y - position.y

    local success = Normalize(X,Y)
    if not success then
        return false
    end

    self.dirX = X
    self.dirY = Y
    return true
end

function Player:GetPosition(offsetX, offsetY)
    return {
        x = self.x + (offsetX or 0), -- Ajoute l'offset X à la position X actuelle
        y = self.y + (offsetY or 0)  -- Ajoute l'offset Y à la position Y actuelle
    }
end

function Normalize(x, y)
    local magnitude = math.sqrt(x^2 + y^2)
    if magnitude == 0 then
        return false -- Impossible de normaliser un vecteur nul
    end
    x = x / magnitude
    y = y / magnitude
    return true
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
