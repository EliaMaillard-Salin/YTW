BrokenPlatform = {}

function BrokenPlatform:new(x, y, width, height)
    local obj = {
        x = x,
        y = y,
        width = width or 200,  -- Largeur par défaut de la plateforme
        height = height or 20,  -- Hauteur par défaut
        type = "",
        isBroken = true
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


function BrokenPlatform:draw()
    love.graphics.setColor(0.5, 0.5, 0.5)  -- Couleur grise pour la plateforme
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end



return BrokenPlatform