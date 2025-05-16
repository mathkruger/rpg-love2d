local anim8 = require "res.lib.anim8"

love.graphics.setDefaultFilter("nearest", "nearest")

local function getBubble(size)
    local bubble = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(bubble)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, size, size)
    love.graphics.setCanvas()
    return bubble
end

local function getBubbleTrail(image)
    pSystem = love.graphics.newParticleSystem(image, 50)
    pSystem:setParticleLifetime(0.5, 0.5)
    pSystem:setSpeed(-10)
    pSystem:setColors(255, 255, 255, 200, 255, 255, 255, 100, 255, 255, 255, 0)
    pSystem:setSizes(0.2, 0.8)
    return pSystem
end

Player = {}

function Player:create(world, gameMap)
    self.__index = self

    self.x = 0
    self.y = 0
    self.accelereration = 300
    self.width = 12
    self.height = 18

    self.collider = world:newBSGRectangleCollider(gameMap.map.properties["playerStartX"],
        gameMap.map.properties["playerStartY"], 50, 100, 10)
    self.collider:setFixedRotation(true)

    self.spriteSheet = love.graphics.newImage("res/sprites/player-sheet.png")
    self.grid = anim8.newGrid(self.width, self.height, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animations = {
        up = anim8.newAnimation(self.grid("1-4", 4), 0.2),
        left = anim8.newAnimation(self.grid("1-4", 2), 0.2),
        down = anim8.newAnimation(self.grid("1-4", 1), 0.2),
        right = anim8.newAnimation(self.grid("1-4", 3), 0.2)
    }
    self.anim = self.animations.right

    self.walkParticles = getBubbleTrail(getBubble(30))
    self.walkSound = love.audio.newSource("res/sounds/footstep.ogg", "static")

    return self
end

local function handlePlayerMovement(self, dt)
    local isMoving = false

    local vx = 0
    local vy = 0

    if love.keyboard.isDown("w") then
        vy = -1 * self.accelereration
        self.anim = self.animations.up
        self.walkParticles:setDirection(math.rad(-90))
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        vx = -1 * self.accelereration
        self.anim = self.animations.left
        self.walkParticles:setDirection(math.rad(180))
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        vy = self.accelereration
        self.anim = self.animations.down
        self.walkParticles:setDirection(math.rad(270))
        isMoving = true
    end

    if love.keyboard.isDown("d") then
        vx = self.accelereration
        self.anim = self.animations.right
        self.walkParticles:setDirection(0)
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, vy)
    self.anim:update(dt)

    if isMoving == false then
        self.anim:gotoFrame(2)
        self.walkParticles:setEmissionRate(0)
        self.walkSound:stop()
    else
        self.walkParticles:setEmissionRate(4)

    end

    if self.anim.position == 1 or self.anim.position == 3 then
        self.walkSound:play()
    end

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.walkParticles:setPosition(self.x, self.y + self.height * 2)
    self.walkParticles:update(dt)
end

function Player:update(dt)
    handlePlayerMovement(self, dt)
end

function Player:moveTo(x, y)
    self.collider:setX(x)
    self.collider:setY(y)
end

function Player:draw()
    love.graphics.draw(self.walkParticles, 0, 0)
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 6, nil, self.width / 2, self.height / 2)
end
