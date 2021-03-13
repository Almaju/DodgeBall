local physics = require('physics')

local _M = {}

function _M.newBall(params)
    local ball = display.newCircle( params.posX, params.posY, 5, 5 )
    ball:setFillColor( 1, 1, 1 )

    function ball:addBody(args)
        args.bounce = args.density or 0.3
        args.density = args.density or 0.5
        args.friction = args.friction or 0.3
        args.radius = args.radius or ball.width / 2 

        physics.addBody( ball, args )
    end

    function ball:throw(dir, force)
		dir = math.rad(dir)
		ball:applyLinearImpulse(force * math.cos(dir), force * math.sin(dir), ball.x, ball.y)
		ball.isLaunched = true
	end

    return ball
end

return _M