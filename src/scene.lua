-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local vjoy = require "com.ponywolf.vjoy"
local joykey = require "com.ponywolf.joykey"

-- include Corona's "physics" library
local physics = require "physics"
local newBall = require("src.classes.ball").newBall
local newField = require("src.classes.field").newField

--------------------------------------------

local player = display.newCircle( display.contentCenterX, display.contentCenterY, 10, 10 )
player:setFillColor( 0.90, 0.44, 0.32 )

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()

    -- Remove gravity
    physics.setGravity( 0, 0 )

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 0.15, 0.27, 0.33 )

    local ball = newBall( halfW, halfH )
	local field = newField()

    -- 
    -- ACTION BUTTON
    --
    local actionButton = vjoy.newButton( 32, "actionButton" )
    actionButton.x = display.actualContentWidth - 64
    actionButton.y = display.actualContentHeight - 128

    actionButton:addEventListener( "tap", function()
		ball:throw(1.5, 10) 
	end)

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( player )
	sceneGroup:insert( field )
	sceneGroup:insert( ball )

	-- 
	-- PLAYER
	-- 
    physics.addBody( player, { density=3, friction=0.3, bounce=0 } )

	createStick()
end

-- Called when an event from the joystick has been reveived
local function onAxisEvent( event )
	local velocityMultiplier = 200

	if ( event.axis.number == 1 ) then
	    -- x value
    	local vx, vy = player:getLinearVelocity()
    	player:setLinearVelocity( event.normalizedValue * velocityMultiplier, vy)
	end
	if ( event.axis.number == 2 ) then
	    -- y value
    	local vx, vy = player:getLinearVelocity()
    	player:setLinearVelocity( vx, event.normalizedValue * velocityMultiplier)
	end

    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        if ( system.getInfo("platform") == "android" ) then
            return true
        end
    end

    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end

function createStick()
	local innerRadius = 20
	local outerRadius = 62
    local stick = vjoy.newStick( 1, innerRadius, outerRadius )

    stick.x = display.screenOriginX + 80
    stick.y = screenH - 120
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "axis", onAxisEvent )

-----------------------------------------------------------------------------------------

return scene