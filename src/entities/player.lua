local anim8 = require "res.lib.anim8"

love.graphics.setDefaultFilter("nearest", "nearest")

Player = {}

function Player:create(collider)
    self.__index = self

    self.x = 45
    self.y = 640
    self.accelereration = 300

    self.collider = collider
    self.collider:setFixedRotation(true)

    self.spriteSheet = love.graphics.newImage("res/sprites/player-sheet.png")
    self.grid = anim8.newGrid(12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animations = {}
    self.animations.up = anim8.newAnimation(self.grid("1-4", 4), 0.1)
    self.animations.left = anim8.newAnimation(self.grid("1-4", 2), 0.1)
    self.animations.down = anim8.newAnimation(self.grid("1-4", 1), 0.1)
    self.animations.right = anim8.newAnimation(self.grid("1-4", 3), 0.1)
    self.anim = self.animations.down

    return self
end

function Player:update(dt)
    local isMoving = false

    local vx = 0
    local vy = 0

    if love.keyboard.isDown("w") then
        vy = -1 * self.accelereration
        self.anim = self.animations.up
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        vx = -1 * self.accelereration
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        vy = self.accelereration
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("d") then
        vx = self.accelereration
        self.anim = self.animations.right
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        self.anim:gotoFrame(2)
    end

    self.anim:update(dt)

    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Player:moveTo(x, y)
    self.x, self.y = x, y
end

function Player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
end
