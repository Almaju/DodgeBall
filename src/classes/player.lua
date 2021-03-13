local physics = require('physics')

local _M = {}

function _M.newPlayer(posX, posY)
	local player = display.newCircle( posX, posY, 10, 10 )
	player:setFillColor( 0.90, 0.44, 0.32 )

    physics.addBody( player, { density=3, friction=0.3, bounce=0, filter={ categoryBits=2, maskBits=11 } } )

	-- 
	-- VELOCITY
	-- 
	local velocityMultiplier = 200

    function player:setXVelocity(x)
    	local vx, vy = player:getLinearVelocity()
    	player:setLinearVelocity( x * velocityMultiplier, vy)
	end

    function player:setYVelocity(y)
    	local vx, vy = player:getLinearVelocity()
    	player:setLinearVelocity( vx, y * velocityMultiplier)
	end

    return player
end

return _M
