
Parallax = {}

function Parallax:Create(width, height)
    local parallax = {
        BackGrounds1 = nil,
        BackGrounds2 = nil,
        BackGrounds3 = nil,
        BackGrounds4 = nil,
        BackGrounds12 = nil,
        BackGrounds22 = nil,
        BackGrounds32 = nil,
        BackGrounds42 = nil
    }
    setmetatable(parallax, self)
    self.__index = self
    self.BackGrounds1 = BackGround:Create(200,width, height)
    self.BackGrounds2 = BackGround:Create(300,width, height)
    self.BackGrounds3 = BackGround:Create(400,width, height)
    self.BackGrounds4 = BackGround:Create(500, width, height)
    self.BackGrounds12 = BackGround:Create(200,width, height)
    self.BackGrounds22 = BackGround:Create(300, width, height)
    self.BackGrounds32 = BackGround:Create(400,width, height)
    self.BackGrounds42 = BackGround:Create(500, width, height)

    local imgBG1Neutral = love.graphics.newImage("BG1Neutral.png")
    local imgBG1Sad = love.graphics.newImage("BG1sad.png")
    local imgBG1Anger = love.graphics.newImage("BG1anger.png")
    local imgBG1Joy = love.graphics.newImage("BG1Joy.png")

    local imgBG2Neutral = love.graphics.newImage("BG2Neutral.png")
    local imgBG2Sad = love.graphics.newImage("BG2sad.png")
    local imgBG2Anger = love.graphics.newImage("BG2anger.png")
    local imgBG2Joy = love.graphics.newImage("BG2Joy.png")

    local imgBG3Neutral = love.graphics.newImage("BG3Neutral.png")
    local imgBG3Sad = love.graphics.newImage("BG3sad.png")
    local imgBG3Anger = love.graphics.newImage("BG3anger.png")
    local imgBG3Joy = love.graphics.newImage("BG3Joy.png")

    local imgBG4Neutral = love.graphics.newImage("BG4Neutral.png")
    local imgBG4Sad = love.graphics.newImage("BG4sad.png")
    local imgBG4Anger = love.graphics.newImage("BG4anger.png")
    local imgBG4Joy = love.graphics.newImage("BG4Joy.png")

    self.BackGrounds1:init(imgBG1Neutral,imgBG1Sad,imgBG1Anger,imgBG1Joy)
    self.BackGrounds2:init(imgBG2Neutral,imgBG2Sad,imgBG2Anger,imgBG2Joy)
    self.BackGrounds3:init(imgBG3Neutral,imgBG3Sad,imgBG3Anger,imgBG3Joy)
    self.BackGrounds4:init(imgBG4Neutral,imgBG4Sad,imgBG4Anger,imgBG4Joy)

    self.BackGrounds12:init(imgBG1Neutral,imgBG1Sad,imgBG1Anger,imgBG1Joy)
    self.BackGrounds22:init(imgBG2Neutral,imgBG2Sad,imgBG2Anger,imgBG2Joy)
    self.BackGrounds32:init(imgBG3Neutral,imgBG3Sad,imgBG3Anger,imgBG3Joy)
    self.BackGrounds42:init(imgBG4Neutral,imgBG4Sad,imgBG4Anger,imgBG4Joy)

    self.BackGrounds12.posX = self.BackGrounds1.posX + self.BackGrounds1.width - 10
    self.BackGrounds22.posX = self.BackGrounds2.posX + self.BackGrounds2.width - 10
    self.BackGrounds32.posX = self.BackGrounds3.posX + self.BackGrounds3.width - 10
    self.BackGrounds42.posX = self.BackGrounds4.posX + self.BackGrounds4.width - 10

    return parallax
end

function Parallax:Update(dt,offsetX)
    self.BackGrounds1:Update(dt,offsetX)
    self.BackGrounds12:Update(dt,offsetX)
    self.BackGrounds2:Update(dt,offsetX)
    self.BackGrounds22:Update(dt,offsetX)
    self.BackGrounds3:Update(dt,offsetX)
    self.BackGrounds32:Update(dt,offsetX)
    self.BackGrounds4:Update(dt,offsetX)
    self.BackGrounds42:Update(dt,offsetX)
end

function Parallax:Draw()
    self.BackGrounds1:Draw()
    self.BackGrounds12:Draw()
    self.BackGrounds2:Draw()
    self.BackGrounds22:Draw()
    self.BackGrounds3:Draw()
    self.BackGrounds32:Draw()
    self.BackGrounds4:Draw()
    self.BackGrounds42:Draw()
end

function Parallax:ChangeState(newState)
    self.BackGrounds1.stateCount = newState
    self.BackGrounds12.stateCount = newState
    self.BackGrounds2.stateCount = newState
    self.BackGrounds22.stateCount = newState
    self.BackGrounds3.stateCount = newState
    self.BackGrounds32.stateCount = newState
    self.BackGrounds4.stateCount = newState
    self.BackGrounds42.stateCount = newState
end

BackGround = {}

function BackGround:Create(speed,width, height)
    local bg = {
        speed = speed,
        posX = 0,
        posY = 0,
        width = width,
        height = height,
        sprites = {nil,nil,nil,nil}, 
        stateCount = 0
    }
    setmetatable(bg, self)
    self.__index = self
    return bg
end

function BackGround:init(sprite1, sprite2,sprite3,sprite4)
    self.sprites[0] =  sprite1
    self.sprites[1] =  sprite2
    self.sprites[2] =  sprite3
    self.sprites[3] =  sprite4
end

function BackGround:Update(dt,offsetX)
    self.posX = self.posX - ( offsetX * self.speed * dt)
    if self.posX + self.width <= 0 then 
        self.posX = self.width -10
    elseif self.posX >= self.width then
        self.posX = -self.width +10
    end
end

function BackGround:Draw()
    love.graphics.draw(self.sprites[self.stateCount],self.posX,self.posY)
end