local storyboard = require( "storyboard" )
local widget = require("widget")
local image, statusText ,playAgainButton,menuButton
local gameOverScene = storyboard.newScene()
local userTextField,passTextField,emailTextField,loginUserTextField,loginPassTextField

function gameOverScene:createScene( event )
	local screenGroup = self.view	
	image = display.newImage( "images/background.png" )
	screenGroup:insert( image )
	statusText = display.newText("", 0, 0, native.systemFontBold, 16 )
	statusText:setTextColor( 255 )
	--statusText:setReferencePoint( display.CenterReferencePoint )
	statusText.x, statusText.y = display.contentWidth * 0.5, 50
	screenGroup:insert( statusText )
  playAgainButton =  require("widget").newButton
  {
    left = (display.contentWidth-330)/1,
    top = display.contentHeight - 180,
    label = "Play Again",
    width = 180, height = 50,
    cornerRadius = 4,
    onEvent = function(event) 
      if "ended" == event.phase then
        storyboard.gotoScene( "play" )
      end
    end
  }
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
end
function gameOverScene:enterScene( event )
  playAgainButton.isVisible = true
  menuButton.isVisible = true
end
function gameOverScene:exitScene( event )
  playAgainButton.isVisible = false
  menuButton.isVisible = false
end
function gameOverScene:destroyScene( event )
	display.remove(playAgainButton)
	display.remove(menuButton)
end
gameOverScene:addEventListener( "createScene", gameOverScene )
gameOverScene:addEventListener( "enterScene", gameOverScene )
gameOverScene:addEventListener( "exitScene", gameOverScene )
gameOverScene:addEventListener( "destroyScene", gameOverScene )
return gameOverScene