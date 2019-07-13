local Collision = {}

Collision.areColliding = function(obj1, obj2)
    return obj1.x + obj1.width > obj2.x and obj1.x < obj2.x + obj2.width 
    and obj1.y + obj1.height > obj2.y and obj1.y < obj2.y + obj2.height
end

Collision.onHover = function(obj)
    return love.mouse.getPosition().x > obj.x and love.mouse.getPosition().x < obj.x + obj.width
    and love.mouse.getPosition().y > obj.y and love.mouse.getPosition().y < obj.y + obj.width
end

return Collision