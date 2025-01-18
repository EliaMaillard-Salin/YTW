-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local Player = require "Player"
local Platform = require "Platform"

local player
local platform

function love.load()
  
  player = Player:New(200, 100)
  player:Load()

  platform = Platform:new(0, love.graphics.getHeight() - 50, love.graphics.getWidth(), 50)

end

function love.update(dt)
    player:Update(dt, platform)
end

function love.draw()
    platform:draw()
    player:Draw()
end
