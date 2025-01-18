
Platform  = {}

function Platform:Create(posX, posY, width, height, isBreakable) --float, float, float ,float, boolean -> Platform
    local plat = {
        positionX = posX,
        positionY = posY,
        width = width,
        height = height,
        hasSprite = false,
        scaleX = 1,
        scaleY = 1,
        breakable = isBreakable
    }
    setmetatable(plat, Platform)
    self.__index = self
    return plat
end

function Platform:SetScale(scaleX, scaleY) --float, float
    self.scaleX = scaleX
    self.scaleY = scaleY
end

function Platform:SetSprite(imgpath) --string
    self.hasSprite = true
    local image = love.graphics.newImage(imgpath)
    self.sprite = image
end

function Platform:Draw()
	if self.hasSprite == true then
        love.graphics.scale(self.scaleX,self.scaleY)
        love.graphics.draw(self.sprite, self.positionX,self.positionY)
    else
        love.graphics.rectangle("fill", self.positionX,self.positionY,self.width, self.height)
    end
end

