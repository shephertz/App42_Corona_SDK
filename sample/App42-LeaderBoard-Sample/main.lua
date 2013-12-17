-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local App42API = require("App42-Lua-API.App42API")
local App42Log = require("App42-Lua-API.App42Log")
App42Log:setDebug(true)
require("Constant")
display.setStatusBar( display.HiddenStatusBar )
screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

App42API:initialize(Constant.apiKey,Constant.secretKey)
-- include the Corona "storyboard" module
local storyboard = require("storyboard")
-- load login screen
storyboard.gotoScene( "login" )
