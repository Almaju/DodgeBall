-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local vjoy = require "com.ponywolf.vjoy"

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

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

    local player = display.newCircle( display.contentCenterX, display.contentCenterY, 10, 10 )
    player:setFillColor( 0.90, 0.44, 0.32 )

    -- 
    -- BALL
    --
    local ball = display.newCircle( display.contentCenterX, display.contentCenterY + 20, 5, 5 )
    ball:setFillColor( 1, 1, 1 )
    physics.addBody( ball, { density=0.5, friction=0.3, bounce=0.3, radius=25 } )

    --
    -- CONTAINER
    --
    local topBorder = display.newRect( halfW, display.screenOriginY, screenW, 5 )
    local bottomBorder = display.newRect( halfW, screenH - 45, screenW, 5 )
    local leftBorder = display.newRect( display.screenOriginX, halfH, 5, screenH )
    local rightBorder = display.newRect( screenW, halfH, 5, screenH )
    topBorder:setFillColor( 1, 0, 0 ) -- red
    bottomBorder:setFillColor( 0, 1, 0 ) -- green
    leftBorder:setFillColor( 0, 0, 1 ) -- blue
    rightBorder:setFillColor( 1, 1, 1 ) -- white
    physics.addBody( topBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )
    physics.addBody( bottomBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )
    physics.addBody( leftBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )
    physics.addBody( rightBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )

    -- 
    -- ACTION BUTTON
    --
    local actionButton = vjoy.newButton( 32, "actionButton" )
    actionButton.x = display.actualContentWidth - 64
    actionButton.y = display.actualContentHeight - 128
    
    local function onBallTap( event )
        ball:setLinearVelocity( 2, 4 )
        ball:applyForce( 500, 2000, ball.x, ball.y )
        return true
    end

    actionButton:addEventListener( "tap", onBallTap )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( player )
	sceneGroup:insert( ball )

	createStick()
end

function createStick()
    local stick = vjoy.newStick( 1, 20, 62 )
    stick.x = 100
    stick.y = 440
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

-----------------------------------------------------------------------------------------

return scene