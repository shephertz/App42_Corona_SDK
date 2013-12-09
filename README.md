App42_Corona_SDK
================

App42 Lua SDK files and Corona application samples.

* __[Getting Started](https://apphq.shephertz.com/register) with App42 Platform.__
* __[Prerequisites for running the samples](https://github.com/shephertz/App42_Corona_SDK/tree/master/sample#app42_corona_sdk_sample).__

__Following samples are provided__

 
![!User Profile](https://raw.github.com/shephertz/App42_Corona_SDK/master/sample/App42-LeaderBoard-Sample/images/Lua-UserProfile.png)

* This illustrates simple create profile operation 
* Users login and from menu he/she can see profile.
* On the backend we just uses the createOrUpdateProfile Function from lua SDK

```
App42API:initialize("<Enter_your_APIKey>","<Enter_your_secret_key>")
local userService =  App42API:buildUserService()
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
  -- Handle here for App42 Response success.
end
function profileCallBack:onException(exception)
  -- Handle here for App42 exception.
end
```
 
![LeaderBoard](https://raw.github.com/shephertz/App42_Corona_SDK/master/sample/App42-LeaderBoard-Sample/images/Lua-leaderBoard.png)


* This illustrates leaderBoard operation 
* Users login and from menu he/she can see Leader board for his game.
* On the backend we just uses the getTopNRankers Function from lua SDK

```
App42API:initialize("<Enter_your_APIKey>","<Enter_your_secret_key>")
local scoreBoardService = App42API:buildScoreBoardService()
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
