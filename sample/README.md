App42_Corona_SDK_Sample
=======================

App42 Lua SDK files and Corona application samples.


__Getting Started With App42 Corona SDK sample :-__

1. Register with App42 platform.
2. Create your App once you are on Quick Start page, and get your API Key and Secret Key
3. If you are already registered, login to AppHQ console and get your API Key and Secret Key from **App Manager –>Application Keys section**.
4. Create a new game in AppHQ console by clicking Add Game button in the Game panel **(AppHQ Left Menu/Business Service Manager/Game Service/Game)**.
5. [Download](https://github.com/shephertz/App42_Corona_SDK/archive/master.zip) the SDK
6. Unzip downloaded file on your system.
7. Copy the App42-Lua-API folder from the latest version and put it in the Sample's folder that you want to run
8. Initialize App42 SDK by putting the APIKey & SecretKey in Constant.lua file **(sample/App42-LeaderBoard-Sample/Constant.lua)** and add your game name which you have created in the above steps.
9. Save your project and run.

__Design Details :-__

Below are the API calls from App42 Corona SDK that has been used for social engagement and user management feature in this sample:

__Initialize App42 Corona SDK :-__

```
App42API:initialize("<YOUR_API_KEY>","<YOUR_SECRET_KEY>")
local scoreBoardService = App42API:buildScoreBoardService()
local userService = App42API:buildUserService()
local gameName = "<YOUR_GAME/LEVEL_NAME>" -- Created in Step #4
local App42ScoreBoardCallBack = {}
local App42UserCallBack = {}
local profileCallBack = {}
```

__Following samples are provided__

 
![!User Profile](https://raw.github.com/shephertz/App42_Corona_SDK/master/sample/App42-LeaderBoard-Sample/images/Lua-UserProfile.png)

* This illustrates simple create profile operation 
* Users login and from menu he/she can see profile.
* On the backend we just uses the createOrUpdateProfile Function from lua SDK

```
local profileObj = userObject:getProfile(); -- userObject, User Object for which you have to create the profile.
profileObj:setFirstName(Constant.firstName);
profileObj:setLastName(Constant.lastName);
profileObj:setMobile(Constant.mobile);
profileObj:setCountry(Constant.country);
profileObj:setState(Constant.state);
profileObj:setCity(Constant.city);
profileObj:setSex(UserGender.MALE);
userService:createOrUpdateProfile(userObject,profileCallBack);

function profileCallBack:onSuccess(object)
	print("User Name is : "..object:getUserName())
	print("First Name is : "..object:getProfile():getFirstName())
	print("Last Name is : "..object:getProfile():getLastName())
end
function profileCallBack:onException(object)
	print("Message is : "..object:getMessage())
	print("App Error Code is : "..object:getAppErrorCode())
	print("Http Error Code is : "..object:getHttpErrorCode())
	print("Error Detail is : "..object:getDetails())
end
```
 
![LeaderBoard](https://raw.github.com/shephertz/App42_Corona_SDK/master/sample/App42-LeaderBoard-Sample/images/Lua-leaderBoard.png)


* This illustrates leaderBoard operation 
* Users login and from menu he/she can see Leader board for his game.
* On the backend we just uses the getTopNRankers Function from lua SDK

```
local gameName = "<Your_Game/Level_Name>" -- Created in Step #4
local max = 5
scoreBoardService:getTopNRankers(gameName,max, App42ScoreBoardCallBack)

function App42ScoreBoardCallBack:onSuccess(object)
	print("Game Name is : "..object:getName())
	for l=1, table.getn(object:getScoreList()) do
		print("User Name is : "..object:getScoreList()[l]:getUserName())
		print("Score is : "..object:getScoreList()[l]:getValue())
	end
end
function App42ScoreBoardCallBack:onException(object)
	print("Message is : "..object:getMessage())
	print("App Error Code is : "..object:getAppErrorCode())
	print("Http Error Code is : "..object:getHttpErrorCode())
	print("Error Detail is : "..object:getDetails())
end
```

__Saving user score on the cloud :-__

```
local userName = "<User_Name>" -- Name of the user for which you want to save score.
local gameName = "<Your_Game/Level_Name>" -- Created in Step #4
local gameScore = 1000
scoreBoardService:saveUserScore(gameName,userName,gameScore, App42ScoreBoardCallBack)

function App42ScoreBoardCallBack:onSuccess(object)
	print("Game Name is : "..object:getName())
	for l=1, table.getn(object:getScoreList()) do
		print("User Name is : "..object:getScoreList()[l]:getUserName())
		print("Score is : "..object:getScoreList()[l]:getValue())
	end
end
function App42ScoreBoardCallBack:onException(object)
	print("Message is : "..object:getMessage())
	print("App Error Code is : "..object:getAppErrorCode())
	print("Http Error Code is : "..object:getHttpErrorCode())
	print("Error Detail is : "..object:getDetails())
end
```

__User Authentication :-__

```
local userName = "<Enter_your_user_name>"
local password = "<Enter_your_password>"
userService:authenticate(userName,password,App42UserCallBack)
function App42UserCallBack:onSuccess(object)
	print("User Name is : "..object:getUserName())
	print("Session Id is : "..object:getSessionId())
end
function App42UserCallBack:onException(object)
	print("Message is : "..object:getMessage())
	print("App Error Code is : "..object:getAppErrorCode())
	print("Http Error Code is : "..object:getHttpErrorCode())
	print("Error Detail is : "..object:getDetails())
end
```

__Game physics has been created by [Daniel Williams](http://mobile.tutsplus.com/tutorials/corona/corona-sdk-build-a-monkey-defender/)__


___For detail documentation [click] (http://api.shephertz.com/app42-docs/user-management-service/)___
