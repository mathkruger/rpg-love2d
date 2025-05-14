local sti = require "res.lib.sti"

GameMap = {}

function GameMap:create(mapName, world)
    self.__index = self

    self:setMap(mapName, world)

    return self
end

function GameMap:drawLayers()
    for _, v in ipairs(self.map.layers) do
        if v.type == "tilelayer" then
            self.map:drawLayer(v)
        end
    end
end

function GameMap:setMap(file, world)
    self.mapFile = file
    self.map = sti(self.mapFile)
    self.walls = {}

    print(self.map.layers["Walls"].objects)

    if self.map.layers["Walls"] then
        for i, obj in pairs(self.map.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(self.walls, wall)
        end
    end
end