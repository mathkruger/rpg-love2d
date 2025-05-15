require "constants"
local sti = require "res.lib.sti"

local function getLayerWithClass(map, class)
    for i, obj in pairs(map.layers) do
        if obj.class == class then
            return obj
        end
    end
    return nil
end

GameMap = {}

function GameMap:create(mapName, world)
    self.__index = self

    self:setMap(mapName, world)

    return self
end

function GameMap:drawLayers()
    for _, v in ipairs(self.map.layers) do
        if v.type == constants.tileLayerType then
            self.map:drawLayer(v)
        end
    end
end

function GameMap:drawHidePlayerLayer()
    local hidePlayerLayer = getLayerWithClass(self.map, constants.hidePlayerLayerClass)
    self.map:drawLayer(hidePlayerLayer)
end

function GameMap:setMap(file, world)
    self.mapFile = file
    self.map = sti(self.mapFile)
    self.walls = {}

    local collisionLayer = getLayerWithClass(self.map, constants.collisionLayerClass)

    if collisionLayer then
        for i, obj in pairs(collisionLayer.objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(self.walls, wall)
        end
    end
end
