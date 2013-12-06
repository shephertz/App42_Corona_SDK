-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local menuButton
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view	

	-- Insert a background into the game
	local background = display.newImageRect("images/background.png", 480, 320)
		background.x = halfW
		background.y = halfH
		group:insert(background)

	-- Insert the game title
	local gameTitle = display.newText("Space Monkey",0,0,native.systemFontBold,32)
		gameTitle.x = halfW
		gameTitle.y = halfH - 80
		group:insert(gameTitle)

	local function onPlayBtnRelease()	
		storyboard.gotoScene( "game", "fade", 500 )
		return true
	end

	-- Create a widget button that will let the player start the game
	local playBtn = widget.newButton{
		label="Play Now",
		onRelease = onPlayBtnRelease
	}
	playBtn.x = halfW
	playBtn.y = halfH
	group:insert( playBtn )
  
  menuButton =  require("widget").newButton
  {
    left = (display.contentWidth-290)/1,
    top = display.contentHeight - 120,
    label = "Menu",
    width = 100, height = 40,
    cornerRadius = 2,
    onEvent = function(event) 
      if "ended" == event.phase then
          storyboard.gotoScene( "menu" )
      end
    end
  }
	group:insert( menuButton )
end

function scene:enterScene(event)
	local group = self.view
  menuButton.isVisible = true
	if(storyboard.getPrevious() ~= nil) then
		storyboard.purgeScene(storyboard.getPrevious())
		storyboard.removeScene(storyboard.getPrevious())
	end
end
function scene:exitScene( event )
  menuButton.isVisible = false
end
function scene:destroyScene( event )
	display.remove(menuButton)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene