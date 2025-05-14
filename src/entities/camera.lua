local camera = require "res.lib.camera"

GameCamera = {}

function GameCamera:create()
    self.__index = self

    self.cam = camera()

    return self
end

function GameCamera:update(player, gameMap)
    self.cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if self.cam.x < w/2 then
        self.cam.x = w/2
    end

    if self.cam.y < h/2 then
        self.cam.y = h/2
    end

    local mapW = gameMap.map.width * gameMap.map.tilewidth
    local mapH = gameMap.map.height * gameMap.map.tileheight

    if self.cam.x > (mapW - w/2) then
        self.cam.x = (mapW - w/2)
    end

    if self.cam.y > (mapH - h/2) then
        self.cam.y = (mapH - h/2)
    end
end