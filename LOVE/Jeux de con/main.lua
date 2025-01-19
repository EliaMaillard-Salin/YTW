Platform = require ("Platform")
Player = require ("Player")
World = require ("World")

love.window.setMode(1920, 1080)

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

local world

if arg[#arg] == "-debug" then require("mobdebug").start() end
local Player = require ("Player")
local Platform = require ("Platform")

local player
local platform

function love.load()

    world = World:Create()
    world:Load()
    player = Player:New(0, love.graphics.getHeight() - 300)
    player:Load()
        
end

function love.update(dt)
    world:Update(dt, player, platform)
end

function love.draw()
    world:Draw(player)
end