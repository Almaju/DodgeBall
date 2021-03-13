local physics = require('physics')

local startX, startY, endX, endY, halfX, halfY = display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY

local _M = {}

function _M.newField(params)
    local field = display.newGroup()

    local thickness = params.thickness or 5
    local startX = params.posX
    local startY = params.posY
    local endX = startX + params.width - thickness
    local endY = startY + params.height - thickness
    local halfX = (endX - startX) / 2
    local halfY = (endY - startY) / 2

    local topBorder = display.newRect( startX, startY, endX, thickness )
    topBorder.anchorX = 0 
	topBorder.anchorY = 0
    local bottomBorder = display.newRect( startX, endY, endX, thickness )
    bottomBorder.anchorX = 0 
	bottomBorder.anchorY = 0
    local leftBorder = display.newRect( startX, startY, thickness, endY )
    leftBorder.anchorX = 0 
	leftBorder.anchorY = 0
    local rightBorder = display.newRect( endX, startY, thickness, endY )
    rightBorder.anchorX = 0 
	rightBorder.anchorY = 0

    topBorder:setFillColor( 1, 0, 0 ) -- red
    bottomBorder:setFillColor( 0, 1, 0 ) -- green
    leftBorder:setFillColor( 0, 0, 1 ) -- blue
    rightBorder:setFillColor( 1, 1, 1 ) -- white

    function field:addBody(args)
        physics.addBody( topBorder, "static", args )
        physics.addBody( bottomBorder, "static", args )
        physics.addBody( leftBorder, "static", args )
        physics.addBody( rightBorder, "static", args )
    end
    
    field:insert(topBorder)
    field:insert(bottomBorder)
    field:insert(leftBorder)
    field:insert(rightBorder)

    return field
end

return _M