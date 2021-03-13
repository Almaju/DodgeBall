local physics = require('physics')

local startX, startY, endX, endY, halfX, halfY = display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY

local _M = {}

function _M.newField()
    local field = display.newGroup()

    local topBorder = display.newRect( halfX, startY, endX, 5 )
    local bottomBorder = display.newRect( halfX, endY, endX, 5 )
    local leftBorder = display.newRect( startX, halfY, 5, endY )
    local rightBorder = display.newRect( endX, halfY, 5, endY )

    topBorder:setFillColor( 1, 0, 0 ) -- red
    bottomBorder:setFillColor( 0, 1, 0 ) -- green
    leftBorder:setFillColor( 0, 0, 1 ) -- blue
    rightBorder:setFillColor( 1, 1, 1 ) -- white

    physics.addBody( topBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )
    physics.addBody( bottomBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )
    physics.addBody( leftBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )
    physics.addBody( rightBorder, "static", { bounce=0.8, filter=floorCollisionFilter } )

    field:insert(topBorder)
    field:insert(bottomBorder)
    field:insert(leftBorder)
    field:insert(rightBorder)

    return field
end

return _M