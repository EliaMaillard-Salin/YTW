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
        jumpPower = -550,  
        gravity = 800,
        sprite = nil,
        width = 32*3,   
        height = 32*3,  
        onGround = false,  
        speedDistance = 800,
        dashCount = 0,
        maxDash = 1,
        dashTimer = 0,
        dashCooldown = 0.5,
        dashCooldownTimer = 0,
        dashStartX = 0,
        dashStartY = 0,
        dashDirection = " ",
        dashDirectionX = 0,
        dashDirectionY = 0,
        hasDashedInAir = false,
        feeling = PlayerFeeling:Create(),
        states = PlayerStates,
        currentState = STATES.IDLE,
        currentFeeling = 0,
        isStomping = false,
        nextX = 0,
        sprites = {nil,nil,nil,nil},
        nextY = 0,
        keyStates = {}
    }
    setmetatable(obj, self)
    self.__index = self  
        
        
    obj.sprites[0] = love.graphics.newImage("player/Neutralfacing.png")
    obj.sprites[1] = love.graphics.newImage("player/sadFacing.png")
    obj.sprites[2] = love.graphics.newImage("player/angryfacing.png")
    obj.sprites[3] = love.graphics.newImage("player/joyfacing.png")
    return obj
end

function Player:isKeyPressed(key)
    -- Vérifie si la touche n'est pas encore enfoncée et n'est pas actuellement enfoncée
    if love.keyboard.isDown(key) and not self.keyStates[key] then
        -- Marque la touche comme enfoncée
        self.keyStates[key] = true
        return true
    end
    return false
end

function Player:resetKeyPresses()
    -- Réinitialise l'état des touches après chaque mise à jour
    for key, _ in pairs(self.keyStates) do
        if not love.keyboard.isDown(key) then
            self.keyStates[key] = false
        end
    end
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

    if self.isStomping then
        print(self.speedY)
    end

    self.feeling:Update(self, dt)

    -- Gérer le cooldown du dash
    if self.dashCooldownTimer > 0 then
        self.dashCooldownTimer = self.dashCooldownTimer - dt
    end

    self:handleMovement(dt)

    if self.states[self.currentState].Update then
        self.states[self.currentState].Update(self, dt)
    end

    love.graphics.setColor(255, 255, 255)
end

function Player:handleMovement(dt)
    local buttonPressed = 0
    
    -- Gestion des sentiments
    if love.keyboard.isDown('u') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Neutral)
        self.currentFeeling = 0
        self.changingState = true
    end
    if love.keyboard.isDown('i') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Sadness)
        self.currentFeeling = 1
        self.changingState = true
    end
    if love.keyboard.isDown('o') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Anger)
        self.currentFeeling = 2
        self.changingState = true
    end
    if love.keyboard.isDown('p') then 
        self.feeling:SwitchFeeling(self.feeling.allFeelings.Joy)
        self.currentFeeling = 3
        self.changingState = true
    end

    if self.currentFeeling == 1 and self.currentState == "falling" then
        if love.keyboard.isDown("space") then
            print("Planing in fall...")
            -- Appliquer l'effet de planage
            self.speedY = self.speedY * 0.10 * dt -- Réduire la vitesse verticale
        end
    end
    
    --FAIT LE STOMP ICI 
    if self.currentFeeling == 2 and self.currentState == "falling" then
        if self:isKeyPressed("s") then
            self.isStomping = true
            print("Stomp activé !")
            
            -- Appliquer un boost vertical fort pour simuler un stomp
            if self.speedY < 0 then  -- Si le joueur descend (chute)
                self.speedY = self.speedY * 5.25  -- Inverser et augmenter la vitesse
            else
                self.speedY = self.speedY * 5.5  -- Si déjà dans une position montante, forcer la descente
            end
            
            -- Ajouter un peu d'effet de "choc" à la position (pour simuler un impact plus marqué)
            self.y = self.y + 10 * dt  -- Simuler un petit mouvement vers le bas à l'impact

            if self.onGround then
                self.isStomping = false
            end
        end
    end

    -- Gérer le dash
    if self:isKeyPressed('lshift') and self.dashCooldownTimer <= 0 and buttonPressed < 1 then
        -- Déterminer la direction du dash
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

            -- Initialiser le dash
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

    -- Réinitialiser les dashs si le joueur est au sol
    if self.onGround then
        buttonPressed = 0
        self.hasDashedInAir = false
        self.dashCount = 0
    end

    self:resetKeyPresses()

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

function Player:Draw()

    -- if (self.dashCooldownTimer <= 0 and self.dashCount < self.maxDash) then
    --     love.graphics.setColor(255, 0, 0)
    -- else
    --     love.graphics.setColor(255, 255, 255)
    -- end

    -- if self.sprite then
    --     love.graphics.draw(self.sprite, self.x, self.y)
    -- else
    --     love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    -- end
    love.graphics.setColor(255, 255, 255)
    love.graphics.push("all")
    love.graphics.scale(3, 3)
    love.graphics.draw(self.sprites[self.currentFeeling], self.x/3,self.y /3)
    love.graphics.pop()

end
return Player
