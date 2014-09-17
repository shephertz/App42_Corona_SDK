local App42Log = require("App42-Lua-API.App42Log")
local App42API = require("App42-Lua-API.App42API")
local User  = require("App42-Lua-API.User")
local Util = require("App42-Lua-API.Util")
local JSON = require("App42-Lua-API.JSON")
local storyboard = require( "storyboard" )
local widget = require("widget")
require("Constant")
local image, statusText,exceptionText ,signUpButton,loginButton,nameField,passwordField,emailField,updateField,loginNameField,loginPasswordField ,userNameTextField,passTextField,emailTextField,loginUserNameTextField,loginPassTextField
local userResponseCallBack = {}
local authUserResponseCallBack = {}
local userService = App42API:buildUserService()
local loginScene = storyboard.newScene()
local loginCallBack = {}
local userSessionId = nil

local function fieldHandler( event )    
  if ( "began" == event.phase ) then
    elseif ( "ended" == event.phase ) then
      elseif ( "submitted" == event.phase ) then
    if (event.target.name == "nameField") then
        userNameTextField = nameField.text
      elseif (event.target.name == "passwordField") then
        passTextField = passwordField.text
      elseif (event.target.name == "emailField") then
        emailTextField = emailField.text
      elseif (event.target.name == "loginNameField") then
        loginUserNameTextField = loginNameField.text
      elseif (event.target.name == "loginPasswordField") then
        loginPassTextField = loginPasswordField.text
    end
    native.setKeyboardFocus( nil )
  end  
return true
end     
  local nameLabel = display.newText ( "Name:", 80, 80, native.systemFontBold, 14)
  local passwordLabel = display.newText ( "Password:", 80, 120, native.systemFontBold, 14)
  local emailLabel = display.newText ( "Email:", 80, 160, native.systemFontBold, 14)
  local locginNameLabel = display.newText ( "Name:", 30, 240, native.systemFontBold, 14)
  local loginPasswordLabel = display.newText ( "Password:", 210, 240, native.systemFontBold, 14)

  loginNameField = native.newTextField( 80, 270, 140, 30)
  loginNameField:addEventListener("userInput", fieldHandler)
  loginNameField.inputType = "default"
  loginNameField.name = "loginNameField"

  loginPasswordField = native.newTextField( 240, 270, 140, 30)
  loginPasswordField:addEventListener("userInput", fieldHandler)
  loginPasswordField.inputType = "default"
  loginPasswordField.isSecure = true
  loginPasswordField.name = "loginPasswordField"
  
  nameField = native.newTextField( 220, 80, 180, 30)
  nameField:addEventListener("userInput", fieldHandler)
  nameField.inputType = "default"
  nameField.name = "nameField"

  passwordField = native.newTextField( 220, 120, 180, 30)
  passwordField:addEventListener("userInput", fieldHandler)
  passwordField.inputType = "default"
  passwordField.isSecure = true
  passwordField.name = "passwordField"

  emailField = native.newTextField( 220, 160, 180, 30)
  emailField:addEventListener("userInput", fieldHandler)
  emailField.inputType = "email"
  emailField.name = "emailField"
  
function userResponseCallBack:onSuccess(object)
  userSessionId = object:getSessionId()
  if userSessionId ~=nil then
    App42API:setLoggedInUser(object:getUserName())
    storyboard.gotoScene("play", "slideLeft", 800)
  end
end
function userResponseCallBack:onException(object)
  if object:getAppErrorCode() == 2001 then
    statusText.text = "User Name already exist."
  elseif object:getAppErrorCode() == 2002 then
    statusText.text = "The username or password you entered is incorrect."
  elseif object:getAppErrorCode() == 1401 then
    exceptionText.text = " Please check your credentials."
  elseif object:getMessage() == "Please check your network connection" then
    statusText.text = "Please check your network connection"
  elseif object:getMessage() == emailTextField.." is not valid email address." then
    statusText.text = emailTextField.." is not valid email address."
  elseif object:getMessage() == "UserName parameter can not be blank." or object:getMessage() == "UserName parameter can not be null." then
    statusText.text ="User Name parameter can not be null/blank."
    elseif object:getMessage() == "Password parameter can not be null." or object:getMessage() == "Password parameter can not be blank." then
    statusText.text ="Password parameter can not be null/blank."
      elseif object:getMessage() == "EmailId parameter can not be null." or object:getMessage() == "EmailId parameter can not be blank." then
    statusText.text ="Email parameter can not be null/blank."
  end
end

function authUserResponseCallBack:onSuccess(object)
  userSessionId = object:getSessionId()
  if userSessionId ~=nil then
    App42API:setLoggedInUser(object:getUserName())
    storyboard.gotoScene("play", "slideLeft", 800)
  end
end
function authUserResponseCallBack:onException(object)
  if object:getAppErrorCode() == 2001 then
    statusText.text = "User Name already exist."
  elseif object:getAppErrorCode() == 2002 then
    statusText.text = "The username or password you entered is incorrect."
  elseif object:getAppErrorCode() == 1401 then
    exceptionText.text = " Please check your credentials."
  elseif object:getMessage() == "Please check your network connection" then
    statusText.text = "Please check your network connection"
  elseif object:getMessage() == emailTextField.." is not valid email address." then
    statusText.text = emailTextField.." is not valid email address."
  elseif object:getMessage() == "UserName parameter can not be blank." or object:getMessage() == "UserName parameter can not be null." then
    statusText.text ="User Name parameter can not be null/blank."
    elseif object:getMessage() == "Password parameter can not be null." or object:getMessage() == "Password parameter can not be blank." then
    statusText.text ="Password parameter can not be null/blank."
      elseif object:getMessage() == "EmailId parameter can not be null." or object:getMessage() == "EmailId parameter can not be blank." then
    statusText.text ="Email parameter can not be null/blank."
  end
end
function loginScene:createScene( event )
	local screenGroup = self.view	
  image = display.newImage( "images/background.png" )
	screenGroup:insert( image )
	exceptionText = display.newText("", 0, 0, native.systemFontBold, 16 )
	statusText = display.newText("", 0, 0, native.systemFontBold, 16 )
	statusText:setTextColor( 250, 20, 0 )
	--statusText:setReferencePoint( display.CenterReferencePoint )
	statusText.x, statusText.y = display.contentWidth * 0.5, 220
	exceptionText.x, exceptionText.y = display.contentWidth * 0.5, 50
  local headerTitle = display.newText("App42 + Space Monkey",0,0,native.systemFontBold,25)
	headerTitle.x, headerTitle.y = display.contentWidth * 0.5, 25
	screenGroup:insert( statusText )
	screenGroup:insert( headerTitle )
	screenGroup:insert( exceptionText )
  signUpButton =  require("widget").newButton
  {
    left = (display.contentWidth-100)/1,
    top = display.contentHeight - 165,
    label = "Sign Up",
    width = 100, height = 40,
    cornerRadius = 4,
    onEvent = function(event) 
      if "ended" == event.phase then
       userService:createUser(userNameTextField,passTextField,emailTextField,userResponseCallBack)
      end
    end
  }
  loginButton =  require("widget").newButton
  {
    left = (display.contentWidth-100)/1,
    top = display.contentHeight - 60,
    label = "Login",
    width = 100, height = 40,
    cornerRadius = 2,
    onEvent = function(event) 
      if "ended" == event.phase then
        userService:authenticate(loginUserNameTextField,loginPassTextField,authUserResponseCallBack)
      end
    end
  }
end
function loginScene:enterScene( event )
  signUpButton.isVisible = true
  loginButton.isVisible = true
  statusText.text = ""
  exceptionText.text = ""
end
function loginScene:exitScene( event )
  signUpButton.isVisible = false
  loginButton.isVisible = false
  statusText.text = ""
  exceptionText.text = ""
  loginNameField:removeSelf()
  loginNameField = nil
  loginPasswordField:removeSelf()
  loginPasswordField = nil
  nameField:removeSelf()
  nameField = nil
  passwordField:removeSelf()
  passwordField = nil
  emailField:removeSelf()
  emailField = nil
  nameLabel.isVisible = false
  passwordLabel.isVisible = false
  emailLabel.isVisible = false
  locginNameLabel.isVisible = false
  loginPasswordLabel.isVisible = false
end
function loginScene:destroyScene( event )
	display.remove(signUpButton)
	display.remove(loginButton)
end
loginScene:addEventListener( "createScene", loginScene )
loginScene:addEventListener( "enterScene", loginScene )
loginScene:addEventListener( "exitScene", loginScene )
loginScene:addEventListener( "destroyScene", loginScene )
return loginScene
