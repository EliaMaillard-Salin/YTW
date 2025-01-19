
require ("Player")
require ("Parallax")
require ("Menu")

World = {}

Camera = {}

function Camera:Create()
    local cam = {
        x = 0,
        y = 0,
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
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
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
        onPause = false,
        pauseDelay = 0,    }
    setmetatable(world, self)
    self.__index = self
    self.parallax = Parallax:Create(1920,1080)
    return world
end

function World:Update(dt, player)
    self.pauseDelay = self.pauseDelay + dt
    if self.onPause == false then
        player:update(dt)
        if player.changingState then 
            self.stateCount = player.feelingCount
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
    player:draw()
    if self.onPause then
        Menu:Draw()
    end
end

return World