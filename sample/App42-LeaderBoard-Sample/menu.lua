local App42API = require("App42-Lua-API.App42API")
local App42Log = require("App42-Lua-API.App42Log")
local Util = require("App42-Lua-API.Util")
local JSON = require("App42-Lua-API.JSON")
local storyboard = require( "storyboard" )
require("App42-Lua-API.UserGender")
local image, statusText, saveUserScoreButton,statusHeaderText,leaderBoardButton,logOutButton,userProfileButton
local scene = storyboard.newScene()
local widget = require("widget")
local scoreBoardService = App42API:buildScoreBoardService()
local userService =  App42API:buildUserService()
local logoutUserCallBack = {}
local leaderBoardCallBack ={}
local getUserCallBack ={}
local profileCallBack = {}
local userProfileObject = {}
function leaderBoardCallBack:onSuccess(object)
  if object:getName() ~= nil then
    statusHeaderText.text =  "Rank ".."    User Name ".. "        Score    "
    statusText.text =  "1         "..object:getScoreList()[1]:getUserName().. "          "..object:getScoreList()[1]:getValue()..       "\n"..
   "2         "..object:getScoreList()[2]:getUserName().. "               "..object:getScoreList()[2]:getValue().."\n"..
   "3         "..object:getScoreList()[3]:getUserName().. "              "..object:getScoreList()[3]:getValue().."\n"..
   "4         "..object:getScoreList()[4]:getUserName().. "       "..object:getScoreList()[4]:getValue().."\n"..
   "5         "..object:getScoreList()[5]:getUserName().. "           "..object:getScoreList()[5]:getValue()
  end
end
function leaderBoardCallBack:onException(object)
  if object:getAppErrorCode() ==3002 then
    statusText.text  = "App42 AppErrorCode is :          "..object:getAppErrorCode().."\n"..
    "Message is :                         "..object:getMessage().."\n"..
    "App42 Details is  : ".."Game '"..Constant.gameName.."' does not exist."
  elseif object:getAppErrorCode() == 1401 then
    statusText.text  = "App42 AppErrorCode is :           "..object:getAppErrorCode().."\n"..
    "Message is :                         "..object:getMessage().."\n"..
    "App42 Details is  : ".." Please check your credentials."
  end
end
function getUserCallBack:onSuccess(object)
  userProfileObject = object
end
function getUserCallBack:onException(exception)
  App42Log.debug("Exception message is : "..exception:getMessage())
end
function profileCallBack:onSuccess(object)
  if object:getUserName() ~= nil then
    statusText.text =  "First Name        :      "..object:getProfile():getFirstName().. "\n"..
    "Last Name        :      "..object:getProfile():getLastName().. "\n"..
    "Sex                   :      "..object:getProfile():getSex().. "\n"..
    "City                   :      "..object:getProfile():getCity().. "\n"..
    "State                 :      "..object:getProfile():getState().. "\n"..
    "Counrty             :      "..object:getProfile():getCountry().. "\n"..
    "Mobile               :      "..object:getProfile():getMobile()
  end
end
function logoutUserCallBack:onSuccess(object)
  if object.app42.response.success == true then
    storyboard.gotoScene( "login", "slideLeft", 800)
  end
end
function scene:createScene( event )
	local screenGroup = self.view	
	image = display.newImage( "images/background.png" )
	screenGroup:insert( image )
	statusText = display.newText("", 0, 0, native.systemFontBold, 16 )
	statusText:setTextColor( 255 )
	--statusText:setReferencePoint( display.CenterReferencePoint )
	statusText.x, statusText.y = display.contentWidth * 0.5, 100
	statusHeaderText = display.newText("", 0, 0, native.systemFontBold, 16 )
	statusHeaderText:setTextColor( 255 )
	--statusHeaderText:setReferencePoint( display.CenterReferencePoint )
	statusHeaderText.x, statusText.y = display.contentWidth * 0.45, 100
	screenGroup:insert( statusHeaderText )
	screenGroup:insert( statusText )
  leaderBoardButton =  require("widget").newButton
  {
    left = (display.contentWidth-460)/1,
    top = display.contentHeight - 70,
    label = "Leader Board",
    width = 170, height = 40,
    cornerRadius = 2,
    onEvent = function(event) 
      if "ended" == event.phase then
        scoreBoardService:getTopNRankers(Constant.gameName,Constant.max,leaderBoardCallBack)
      end
    end
  }
  userProfileButton =  require("widget").newButton
  {
    left = (display.contentWidth-70)/2,
    top = display.contentHeight - 70,
    label = "User Profile",
    width = 150, height = 40,
    cornerRadius = 4,
    onEvent = function(event) 
      if "ended" == event.phase then
        statusHeaderText.text= ""
        local profileObj = userProfileObject:getProfile();
        profileObj:setFirstName(Constant.firstName);
        profileObj:setLastName(Constant.lastName);
        profileObj:setMobile(Constant.mobile);
        profileObj:setCountry(Constant.country);
        profileObj:setState(Constant.state);
        profileObj:setCity(Constant.city);
        profileObj:setSex(UserGender.MALE);
        userService:createOrUpdateProfile(userProfileObject,profileCallBack);
      end
    end
  }
  logOutButton =  require("widget").newButton
  {
    left = (display.contentWidth-100)/1,
    top = display.contentHeight - 70,
    label = "Log Out",
    width = 100, height = 40,
    cornerRadius = 2,
    onEvent = function(event) 
      if "ended" == event.phase then
        userService:logout(userSessionId,logoutUserCallBack)
      end
    end
  }
end
function scene:enterScene( event )
  userService:getUser(App42API:getLoggedInUser(),getUserCallBack)
  statusHeaderText.text = ""
  statusText.text = ""
  leaderBoardButton.isVisible = true  
  logOutButton.isVisible = true
  userProfileButton.isVisible = true
end
function scene:exitScene( event )
  leaderBoardButton.isVisible = false
  userProfileButton.isVisible = false
  logOutButton.isVisible = false
  statusHeaderText.text = ""
  statusText.text = ""
end
function scene:destroyScene( event )
	display.remove(saveUserScoreButton)
	display.remove(userProfileButton)
	display.remove(leaderBoardButton)
	display.remove(logOutButton)
end
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
return scene