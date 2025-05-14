require "constants"

function love.conf(t)
    t.window.title = constants.windowTitle
    -- t.window.icon = constants.windowIcon
    t.window.width = constants.windowWidth
    t.window.height = constants.windowHeight

    t.window.vsync = 1
end