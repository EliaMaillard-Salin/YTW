
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
    self.BackGrounds1 = BackGround:Create(200, love.graphics.newImage("BG1.png"),width, height)
    self.BackGrounds2 = BackGround:Create(300, love.graphics.newImage("BG2.png"),width, height)
    self.BackGrounds3 = BackGround:Create(400, love.graphics.newImage("BG3.png"),width, height)
    self.BackGrounds4 = BackGround:Create(500, love.graphics.newImage("BG4.png"),width, height)
    self.BackGrounds12 = BackGround:Create(200, love.graphics.newImage("BG1.png"),width, height)
    self.BackGrounds22 = BackGround:Create(300, love.graphics.newImage("BG2.png"),width, height)
    self.BackGrounds32 = BackGround:Create(400, love.graphics.newImage("BG3.png"),width, height)
    self.BackGrounds42 = BackGround:Create(500, love.graphics.newImage("BG4.png"),width, height)

    self.BackGrounds12.posX = self.BackGrounds1.posX + self.BackGrounds1.width -10
    self.BackGrounds22.posX = self.BackGrounds2.posX + self.BackGrounds2.width -10
    self.BackGrounds32.posX = self.BackGrounds3.posX + self.BackGrounds3.width -10
    self.BackGrounds42.posX = self.BackGrounds4.posX + self.BackGrounds4.width -10

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

BackGround = {}

function BackGround:Create(speed, sprite,width, height)
    local bg = {
        speed = speed,
        posX = 0,
        posY = 0,
        width = width,
        height = height,
        sprite = sprite
    }
    setmetatable(bg, self)
    self.__index = self
    return bg
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
    love.graphics.draw(self.sprite,self.posX,self.posY)
end