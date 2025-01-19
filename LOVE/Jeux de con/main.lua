Platform = require ("Platforms")
Player = require ("Player")
World = require ("World")

love.window.setMode(1920, 1080)

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

local world = World:Create()

local player = Player:new(10,10)

if arg[#arg] == "-debug" then require("mobdebug").start() end
local Player = require ("Player")
local Platform = require ("Platform")

local player
local platform

function love.load()
    
    player = Player:New(200, 100)
    player:Load()
    
    platform = Platform:new(0, love.graphics.getHeight() - 50, love.graphics.getWidth(), 50)
    
end

function love.update(dt)
    world:Update(dt, platform)
end

function love.draw()
    platform:draw()
    world:Draw(player)
end