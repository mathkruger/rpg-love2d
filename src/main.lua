require "constants"
require "entities.player"
require "entities.map"
require "entities.camera"

local wf = require "res.lib.windfield"

function love.load()
    world = wf.newWorld(0, 0)

    gameMap = GameMap:create("res/maps/testMap.lua", world)
    gameCamera = GameCamera:create()

    player = Player:create(world, gameMap)
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
    gameCamera:update(player, gameMap)
end

function love.draw()
    gameCamera.cam:attach()

    gameMap:drawLayers()
    player:draw()
    GameMap:drawHidePlayerLayer()
    world:draw()

    gameCamera.cam:detach()
end
