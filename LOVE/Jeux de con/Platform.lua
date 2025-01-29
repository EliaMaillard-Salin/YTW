Platform = {}

function Platform:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        width = width or 200,  -- Largeur par défaut de la plateforme
        height = height or 20,  -- Hauteur par défaut
        type = "",
        state = 0,
        imgStates = { nil,nil,nil,nil }

    }
    setmetatable(obj, self)
    self.__index = self

    obj.imgStates[0] = love.graphics.newImage("PlatformNeutral.png");
    obj.imgStates[1] = love.graphics.newImage("platformSad.png");
    obj.imgStates[2] = love.graphics.newImage("PlatformAngry.png");
    obj.imgStates[3] = love.graphics.newImage("PlatformJoy.png");
    
    return obj
end


function Platform:draw()
    love.graphics.draw(self.imgStates[self.state],self.x /3,self.y/3 - 25)
end



return Platform
