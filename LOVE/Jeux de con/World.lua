
require ("Player")
require ("Parallax")
require ("Menu")
local Platform = require ("Platform")

Level1 ={
    platformsCount = 42,
    platforms = {
        {x = 0, y  = 2700, w = 300, h = 50},
        {x = 260, y= 3050, w= 280, h= 180},
        {x = 970, y= 2590, w= 280, h= 180},
        {x = 2400, y= 2500, w= 280, h= 180},
        {x = 2660, y= 2500, w= 280, h= 180},
        {x = 3360, y= 2500, w= 280, h= 180},
        {x = 3540, y= 2500, w= 280, h= 180},
        {x = 2500, y= 1750, w= 280, h= 180},
        {x = 3880, y= 550, w= 100, h= 2132},
        {x = 3880, y= 0, w= 100, h= 440},
        {x = 2340, y= 1500, w= 150, h= 180},
        {x = 209, y= 876, w= 415, h= 180},
        {x = 1520, y= 415, w= 150, h= 180},
        {x = 1960, y= 0, w= 110, h= 600},
        {x = 2400, y= 390, w= 150, h= 180},
        {x = 4450, y= 0, w= 100, h= 1940},
        {x = 4565, y= 1515, w= 1800, h= 100},
        {x = 4920, y= 2200, w= 155, h= 180},
        {x = 6800, y= 2110, w= 150, h= 180},
        {x = 6095, y= 1155, w= 140, h= 100},
        {x = 5740, y= 910, w= 520, h= 100},
        {x = 6095, y= 885, w= 140, h= 100},
        {x = 5440, y= 1170, w= 400, h= 100},
        {x = 5440, y= 845, w= 230, h= 100},
        {x = 5440, y= 1170, w= 400, h= 100},
        {x = 5440, y= 845, w= 230, h= 100},
        {x = 5060, y= 910, w= 370, h= 100},
        {x = 4800, y= 1140, w= 380, h= 100},
        {x = 4790, y= 920, w= 130, h= 100},
        {x = 4800, y= 830, w= 2250, h= 100},
        {x = 5730, y= 580, w= 380, h= 100},
        {x = 5683, y= 0, w= 420, h= 100},
        {x = 5430, y= 570, w= 380, h= 100},
        {x = 4900, y= 580, w= 410, h= 100},
        {x = 5450, y= 120, w= 100, h= 450},
        {x = 4800, y= 110, w= 760, h= 100},
        {x = 4785, y= 450, w= 115, h= 230},
        {x = 4800, y= 210, w= 120, h= 100},
        {x = 5080, y= 200, w= 100, h= 100},
        {x = 5090, y= 400, w= 180, h= 100},
        {x = 6400, y= 330, w= 140, h= 100},
        {x = 7050, y= 170, w= 750, h= 125}
    }
}



World = {}

Camera = {}

function Camera:Create()
    local cam = {
        x = 0,
        y = 3220,
        scaleX = 1,
        scaleY = 1,
        rotation = 0,
        offsetX = 0,
        offsetY = 0,
        stateCount = 0
    }
    setmetatable(cam, Camera)
    self.__index = self
    Menu:Init(1920,1080)
    return cam
end



function Camera:set()
  love.graphics.push()
--   love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function World:Create()
    local world = {
        parallax = nil,
        currentState = nil,
        camera = Camera:Create(),
        onPause = true,
        pauseDelay = 0,    
        platforms = {}
    }
    setmetatable(world, self)
    self.__index = self
    self.parallax = Parallax:Create(1920,1080)
    return world
end

function World:Load()
    self.platforms = {}
    for i = 1,Level1.platformsCount, 1 do
        self.platforms[i]  = Platform:new(Level1.platforms[i].x, Level1.platforms[i].y - (1080*2) ,Level1.platforms[i].w,Level1.platforms[i].h)
    end
end

function World:Update(dt, player,platform)
    self.pauseDelay = self.pauseDelay + dt
    if self.onPause == false then
        player:Update(dt,platform)
        if player.changingState then 
            self.stateCount = player.currentFeeling
            self.parallax:ChangeState(self.stateCount)
            player.changingState = false
        end
        --local offsetY = player.y - self.camera.y
        local offsetX = player.x - self.camera.x
        self.camera.x = player.x
        self.parallax:Update(dt, offsetX)
    end

    if love.keyboard.isDown("escape")  and self.pauseDelay > 0.5 then
        self.pauseDelay = 0
        if self.onPause then
        
        else
            Menu:Update()
        end
        self.onPause = not self.onPause
    end
    
end


function World:Draw(player)
    self.parallax:Draw()
    player:Draw()
    for i = 1,Level1.platformsCount, 1 do 
        self.platforms[i]:draw()
    end
    love.graphics.setColor(1, 1, 1)
    -- if self.onPause then
    --     Menu:Draw()
    -- end
end

return World