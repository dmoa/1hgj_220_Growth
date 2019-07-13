function love.load()

    WW, WH = love.graphics.getDimensions()

    collision = require("Collision")
    
    player = {
        x = 0,
        y = 0,
        xv = 450,
        yv = 0,
        acceleration = 1000,
        width = 30,
        height = 50,
        jumping = false
    }

    player.draw = function()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    end
    
    player.update = function(dt)

        player.jumping = true

        player.oldX = player.x
        player.oldY = player.y

        player.yv = player.yv + player.acceleration * dt
        player.y = player.y + player.yv * dt

        if love.keyboard.isDown("left") then
            player.x = player.x - player.xv * dt
        end
        if love.keyboard.isDown("right") then
            player.x = player.x + player.xv * dt
        end

        if player.y + player.height > WH then
            player.y = WH - player.height
            player.yv = 0
            player.jumping = false
        end

        if player.x < 0 then
            player.x = 0
        end

        if player.x + player.width > WW then
            player.x = WW - player.width
        end

        for index, obstacle in ipairs(obstacles) do
            if collision.areColliding(obstacle, player) 
            and player.oldY >= obstacle.y + obstacle.height then
                player.y = obstacle.y + obstacle.height
                player.yv = 0
            end
            if collision.areColliding(obstacle, player) 
            and player.oldX + player.width <= obstacle.x then
                player.x = obstacle.x - player.width
            end
            if collision.areColliding(obstacle, player) 
            and player.oldX >= obstacle.x + obstacle.width then
                player.x = obstacle.x + obstacle.width
            end
        end

        for index, enemy in ipairs(enemies) do
            if collision.areColliding(enemy, player) then
                if player.oldY + player.height < enemy.y then
                    table.remove(enemies, index)
                    player.height = player.height + 25
                else
                    enemies = {}
                    player.height = 50
                end
            end
        end

    end

    player.jump = function()
        if not player.jumping then
            player.yv = -450
        end
    end

    obstacles = {
        {
            x = 100,
            y = 100, 
            width = 50,
            height = 350
        },
        {
            x = 300,
            y = 125, 
            width = 75,
            height = 250
        },
        {
            x = 450,
            y = 450, 
            width = 100,
            height = 50
        },
        {
            x = 650,
            y = 25, 
            width = 50,
            height = 300
        }
    }

    enemies = {}
    timer = 3
end

function love.draw()
    player.draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    for index, obstacle in ipairs(obstacles) do
        love.graphics.rectangle("fill", obstacle.x, obstacle.y, 
        obstacle.width, obstacle.height)
    end
    love.graphics.setColor(0.7, 0.1, 0.1)
    for index, enemy in ipairs(enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, 
        enemy.width, enemy.height)
    end
end

function love.update(dt)
    player.update(dt)
    for index, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.xv * dt
        if enemy.x < 0 then
            enemy.xv = 200
        end
        if enemy.x + enemy.width > WW then
            enemy.xv = -200
        end
    end
    timer = timer - dt
    if timer < 0 then
        timer = 3
        local enemy = {}
        if love.math.random() > 0.5 then
            enemy.x = -50
            enemy.xv = 200
        else
            enemy.x = WW
            enemy.xv = -200
        end
        enemy.height = 50
        enemy.width = 50
        enemy.y = WH - enemy.height
        table.insert(enemies, enemy)
    end
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" then player.jump() end
end