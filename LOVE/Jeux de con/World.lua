
require ("Player")
require ("Parallax")
require ("Menu")
local Platform = require ("Platform")

Level1 ={
    platformsCount = 4,
    platforms = {
        {x = -10000, y  = 3200, w = 8000000, h = 50},
        {x = 260, y= 3000, w= 280, h= 50},
        {x = 970, y= 2590, w= 280, h= 50},
        {x = 500, y= 2500, w= 280, h= 50},

    }
}



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
    setmetatable(cam, self)
    self.__index = self
    Menu:Init(1920,1080)
    return cam
end

function Camera:set()
  love.graphics.translate(-self.x + 1920/2, -self.y)
end

function Camera:unset()
end


function World:Create()
    local world = {
        parallax = nil,
        currentState = nil,
        camera = nil,
        onPause = false,
        pauseDelay = 0,    
        platforms = {}
    }
    setmetatable(world, self)
    self.__index = self
    self.parallax = Parallax:Create(1920,1080)
    self.pauseDelay = 0
    self.camera = Camera:Create()
    return world
end

function World:Load(worldCollider)
    self.pauseDelay = 0
    self.platforms = {}
    for i = 1,Level1.platformsCount, 1 do
        self.platforms[i]  = Platform:new(Level1.platforms[i].x, Level1.platforms[i].y - (1080*2) ,Level1.platforms[i].w,Level1.platforms[i].h)
        self.platforms[i].type = "plateform"
        worldCollider:add(self.platforms[i], self.platforms[i].x,self.platforms[i].y,self.platforms[i].width,self.platforms[i].height)
    end
end

function World:Update(dt,player,worldCollider)
    self.pauseDelay = self.pauseDelay + dt

    player:Update(dt)
    local actualX, actualY, cols, len = worldCollider:move(player, player.x, player.y)
    player.x, player.y = actualX, actualY

    player.onGround = false
    for _, col in ipairs(cols) do
        if col.other.type == "plateform" then
            -- Si la collision est avec le bas du joueur, le joueur est sur la plateforme
            if player.y + player.height <= col.other.y then
                player.onGround = true
            end
        end
    end


    if player.changingState then
        self.stateCount = player.currentFeeling
        self.parallax:ChangeState(self.stateCount)
        player.changingState = false
        for i = 1,Level1.platformsCount, 1 do 
            self.platforms[i].state = self.stateCount
        end

    end
    local offsetY = player.y - self.camera.y
    local offsetX = player.x - self.camera.x
    self.camera.x = player.x
    self.parallax:Update(dt, offsetX,self.camera)
    
end


function World:Draw(player)
    self.camera:set()
    love.graphics.push("all")

    love.graphics.scale(6,6)
    self.parallax:Draw()
    love.graphics.pop()

    print(type(player))
    player:Draw()
    love.graphics.push("all")

    love.graphics.scale(3,3)
    for i = 1,Level1.platformsCount, 1 do 
        self.platforms[i]:draw()
    end
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
    -- if self.onPause then
    --     Menu:Draw()
    -- end
    self.camera:unset()
end

return World