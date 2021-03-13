local physics = require('physics')

local _M = {}

function _M.newBall(posX, posY)
    local ball = display.newCircle( posX, posY, 5, 5 )
    ball:setFillColor( 1, 1, 1 )

    physics.addBody( ball, { density=0.5, friction=0.3, bounce=0.3, radius=ball.width / 2 } )

    function ball:throw(dir, force)
		dir = math.rad(dir)
		ball:applyLinearImpulse(force * math.cos(dir), force * math.sin(dir), ball.x, ball.y)
		ball.isLaunched = true
	end

    return ball
end

return _M