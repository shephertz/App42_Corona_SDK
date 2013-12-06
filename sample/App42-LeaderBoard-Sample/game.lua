-----------------------------------------------------------------------------------------
--
-- game.lua
-- Background graphic from http://opengameart.org/content/starfield-background, courtesy of Sauer2
-- Monkey, enemy, and bullet graphics are from http://www.vickiwenderlich.com/2013/05/free-game-art-space-monkey/
--
-----------------------------------------------------------------------------------------

-- Require in some of Corona's 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local App42API = require("App42-Lua-API.App42API")
local App42Log = require("App42-Lua-API.App42Log")
local Util = require("App42-Lua-API.Util")
local JSON = require("App42-Lua-API.JSON")
require("App42-Lua-API.UserGender")
-- include Corona's "physics" library
local physics = require("physics")
physics.start(); physics.pause()

local numberOfLives = 3
local bulletSpeed = 0.35
local badGuyMovementSpeed = 1500
local badGuyCreationSpeed = 1000
local image, statusText, saveUserScoreButton,statusHeaderText,leaderBoardButton,logOutButton,userProfileButton
-- forward declarations and other locals
local background, tmr_createBadGuy, monkey, bullet, txt_score
local tmr_createBadGuy
local lives = {}
local badGuy = {}
local badGuyCounter = 1
local score = 0

local scoreBoardService = App42API:buildScoreBoardService()
local saveUserScoreCallBack =  {}
function saveUserScoreCallBack:onSuccess(object)
  if object:getResponseSuccess() == true then
      storyboard.gotoScene("gameOver", "slideLeft", 800)
  end
end
function saveUserScoreCallBack:onException(object)
  if object:getAppErrorCode() ==3002 then
    statusText.text  = "App42 AppErrorCode is :           "..object:getAppErrorCode().."\n"..
    "Message is :                         "..object:getMessage().."\n"..
    "App42 Details is  : ".."Game '"..Constant.gameName.."' does not exist."
  elseif object:getAppErrorCode() == 1401 then
    statusText.text  = "App42 AppErrorCode is :           "..object:getAppErrorCode().."\n"..
    "Message is :                         "..object:getMessage().."\n"..
    "App42 Details is  : ".." Please check your credentials."
  end
end

function alertComplete( event )
  if event.index == 1 then
    storyboard.gotoScene("gameOver", "slideLeft", 800)
  else
    scoreBoardService:saveUserScore(Constant.gameName,App42API:getLoggedInUser(),score,saveUserScoreCallBack)
  end
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view	

	function touched(event)		

		if(event.phase == "began") then

			angle = math.deg(math.atan2((event.y-monkey.y),(event.x-monkey.x)))            
            monkey.rotation = angle + 90

			bullet = display.newImageRect("images/grenade_red.png",12,16)
				bullet.x = halfW
				bullet.y = halfH				
				bullet.name = "bullet"
				physics.addBody( bullet, "dynamic", { isSensor=true, radius=screenH*.025} )
				group:insert(bullet)

			local farX = screenW*2
			local slope = ((event.yStart-screenH/2)/(event.xStart-screenW/2))			
			local yInt = event.yStart - (slope*event.xStart)

			if(event.xStart >= screenW/2)then
				farX = screenW*2
			else
				farX = screenW-(screenW*2)
			end

			local farY = (slope*farX)+yInt
			
			local xfactor = farX-bullet.x
			local yfactor = farY-bullet.y
			
			local distance = math.sqrt((xfactor*xfactor) + (yfactor*yfactor))

			bullet.trans = transition.to(bullet, { time=distance/bulletSpeed, y=farY, x=farX, onComplete=nil})
		end
	end

	-- Create a background for our game
	background = display.newImageRect("images/background.png", 480, 320)
		background.x = halfW
		background.y = halfH
		group:insert(background)
	
	-- Place our monkey in the center of screen
	monkey = display.newImageRect("images/spacemonkey-01.png",30,40)
		monkey.x = halfW
		monkey.y = halfH
		group:insert(monkey)

	txt_score = display.newText("Score: "..score,0,0,native.systemFont,22)
		txt_score.x = 430
		group:insert(txt_score)
	
	-- Insert our lives, but show them as bananas
	for i=1,numberOfLives do
		lives[i] = display.newImageRect("images/banana.png",45,34)
			lives[i].x = i*40-20
			lives[i].y = 18
			group:insert(lives[i])
	end

	-- This function will create our bad guy
	function createBadGuy()		

		-- Determine the enemies starting position
		local startingPosition = math.random(1,4)
		if(startingPosition == 1) then
			-- Send bad guy from left side of the screen
			startingX = -10
			startingY = math.random(0,screenH)
		elseif(startingPosition == 2) then
			-- Send bad guy from right side of the screen
			startingX = screenW + 10
			startingY = math.random(0,screenH)
		elseif(startingPosition == 3) then
			-- Send bad guy from the top of the screen
			startingX = math.random(0,screenW)
			startingY = -10
		else
			-- Send bad guy from the bototm of the screen
			startingX = math.random(0,screenW)
			startingY = screenH + 10
		end

		-- Start the bad guy according to starting position
		badGuy[badGuyCounter] = display.newImageRect("images/alien_1.png",34,34)
			badGuy[badGuyCounter].x = startingX
			badGuy[badGuyCounter].y = startingY
			physics.addBody( badGuy[badGuyCounter], "dynamic", { isSensor=true, radius=17} )
			badGuy[badGuyCounter].name = "badGuy"
			group:insert(badGuy[badGuyCounter])

		-- Then move the bad guy towards the center of the screen. Once the transition is done, remove the bad guy.
		badGuy[badGuyCounter].trans = transition.to(badGuy[badGuyCounter], { time=badGuyMovementSpeed, x=halfW, y=halfH, 			
		onComplete = function (self)			
			self.parent:remove(self); 
			self = nil;

			-- Since the bad guy has reached the monkey, we will want to remove a banana
			display.remove(lives[numberOfLives])
			numberOfLives = numberOfLives - 1			

			-- If the numbers of lives reaches 0 or less, it's game over!
			if(numberOfLives <= 0) then
          timer.cancel(tmr_createBadGuy)
          background:removeEventListener("touch", touched)
          native.showAlert( "Success", "Do you want to save score ?",{"No", "Yes" }, alertComplete )
        end
		end; })

		badGuyCounter = badGuyCounter + 1
	end

	-- This function handles the collisions. In our game, this will remove the bullet and bad guys when they collide. 
	function onCollision( event )		
		if(event.object1.name == "badGuy" and event.object2.name == "bullet" or event.object1.name == "bullet" and event.object2.name == "badGuy") then			
			
			-- Update the score
			score = score + 50
			txt_score.text = "Score: "..score

			-- Make the objects invisible
			event.object1.alpha = 0	
			event.object2.alpha = 0	

			-- Cancel the transitions on the object
			transition.cancel(event.object1.trans)
			transition.cancel(event.object2.trans)			

			-- Then remove the object after 1 cycle. Never remove display objects in the middle of collision detection. 
			local function removeObjects()				
				display.remove(event.object1)
				display.remove(event.object2)
			end
			timer.performWithDelay(1, removeObjects, 1)
		end
	end
end

function scene:enterScene( event )
	local group = self.view

	-- Actually start the game!	
	physics.start()
	
	tmr_createBadGuy = timer.performWithDelay(badGuyCreationSpeed, createBadGuy, 0)
	background:addEventListener("touch", touched)
	Runtime:addEventListener( "collision", onCollision )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )

return scene