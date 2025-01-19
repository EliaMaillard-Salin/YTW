Platform = {}

function Platform:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        width = width or 200,  -- Largeur par défaut de la plateforme
        height = height or 20,  -- Hauteur par défaut
        type = ""
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Platform:draw()
    love.graphics.setColor(1, 0, 0)
    print(self.x,self.y,self.width,self.height)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Platform
