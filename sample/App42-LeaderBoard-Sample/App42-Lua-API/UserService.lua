--author Himanshu Sharma
local RestConnector = require("App42-Lua-API.RestConnector")
local App42Service = require("App42-Lua-API.App42Service")
local App42API = require("App42-Lua-API.App42API")
local App42Log = require("App42-Lua-API.App42Log")
local Util  = require("App42-Lua-API.Util")
local JSON = require("App42-Lua-API.JSON")
local UserService =  {}
local orderByDescending = "" 
local orderByAscending = ""
local pageOffset = -1
local pageMaxRecords = -1
local aclList = {}
local adminKey = ""
local fbAccessToken = ""
local sessionId = ""
local selectKeys = {}
local otherMetaHeaders = {} 
local queryParams =  {}    
local userJson ={}
local app42 = {}    
local user =  {}  
local resource = "user"
local version = "1.0"
--Create a User with userName, password & emailAddress in async mode
--userName - Name of the User
--password - Password for the User
--emailId - Email address of the user
--callback - Callback object for success/exception result
function UserService:createUser(userName,password,emailId,callBack)
  if userName == nil or userName == "" or Util:trim(userName) == "" or password == nil or password == "" or 
    Util:trim(password) == "" or emailId == nil or emailId == "" or Util:trim(emailId) == "" then
      Util:throwExceptionIfNullOrBlank(userName,"UserName", callBack)
      Util:throwExceptionIfNullOrBlank(password,"Password", callBack)
      Util:throwExceptionIfNullOrBlank(emailId,"EmailId", callBack)  
  elseif Util:isValidEmailAddress(emailId, callBack) == false then
      Util:throwExceptionIfEmailIsNotValid(emailId,"EmailId", callBack)
  else
      local signParams =App42Service:populateSignParams()
      local metaHeaderParams = App42Service:populateMetaHeaderParams()
      local headerParams = App42Service:merge(signParams,metaHeaderParams)
      -- Creating the user JSON
      userJson.userName = userName    
      userJson.email = emailId
      userJson.password = password
      user.user = userJson
      app42.app42 = user
      local jsonBody  = JSON:encode(app42)
      App42Log:debug("jsonBody is : "..jsonBody)
      signParams.body =  jsonBody
      local signature =  Util:sign(App42API:getSecretKey(),signParams)
      App42Log:debug("signature is : "..signature)
      headerParams.signature = signature
      headerParams.resource = resource
      local resourceURL = version .."/".. resource
      RestConnector:executePost(resourceURL,queryParams,jsonBody,headerParams,callBack) 
  end
end
--Gets the User details based on userName
--userName - Name of the User to retrieve
--callback - Callback object for success/exception result
function UserService:getUser(userName,callBack)
  if userName == nil or userName == "" or Util:trim(userName) == "" then
    Util:throwExceptionIfNullOrBlank(userName,"UserName", callBack)
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    signParams.userName = userName 
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version.."/"..resource .."/" .. userName
    RestConnector:executeGet(resourceURL,queryParams,headerParams,callBack)
  end
end
--Updates the User's Email Address based on userName. Note: Only email can be updated. User name cannot be updated.
--userName - UserName which should be unique for the App
--emailId - Email address of the user
--callback - Callback object for success/exception result
function UserService:updateEmail(userName,emailId,callBack)
  if userName == nil or userName =="" or Util:trim(userName)=="" or emailId==nil or emailId == "" or Util:trim(emailId) == "" then
    Util:throwExceptionIfNullOrBlank(userName,"UserName", callBack)
    Util:throwExceptionIfNullOrBlank(emailId,"EmailId", callBack)    
  elseif Util:isValidEmailAddress(emailId, callBack) == false then
    Util:throwExceptionIfEmailIsNotValid(emailId,"emailId", callBack)
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    userJson.userName = userName    
    userJson.email = emailId
    user.user = userJson
    app42.app42 = user
    local jsonBody  = JSON:encode(app42)
    App42Log:debug("jsonBody is : "..jsonBody)
    signParams.body =  jsonBody
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version.."/"..resource
    RestConnector:executePut(resourceURL,queryParams,jsonBody,headerParams,callBack)  
  end
end
--Deletes a particular user based on userName.
--userName - UserName which should be unique for the App
--callback- Callback object for success/exception result
function UserService:deleteUser(userName,callBack)
  if userName == nil or userName =="" or Util:trim(userName)=="" then
    Util:throwExceptionIfNullOrBlank(userName,"UserName", callBack)
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    signParams.userName = userName 
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version.."/"..resource .."/" .. userName
    RestConnector:executeDelete(resourceURL,queryParams,headerParams,callBack)
  end
end
--Authenticate user based on userName and password
--userName - UserName which should be unique for the App
--password - Password for the User
--callback - Callback object for success/exception result
function UserService:authenticate(userName,password,callBack)
  if userName == nil or userName=="" or Util:trim(userName) == "" or password == nil or password=="" or Util:trim(password)=="" then
    Util:throwExceptionIfNullOrBlank(userName,"UserName", callBack)
    Util:throwExceptionIfNullOrBlank(password,"Password", callBack)
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    -- Creating the user JSON
    userJson.userName = userName  
    userJson.password = password
    user.user = userJson
    app42.app42 = user
    local jsonBody  = JSON:encode(app42)
    App42Log:debug("jsonBody is : "..jsonBody)
    signParams.body =  jsonBody
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version.."/"..resource.."/authenticateAndCreateSession"
    RestConnector:executePost(resourceURL,queryParams,jsonBody,headerParams,callBack)  
  end
end
function UserService:changeUserPassword(userName,oldPassword,newPassword,callBack)
  if userName==nil or userName=="" or Util:trim(userName)=="" or newPassword== nil or newPassword=="" or 
    Util:trim(newPassword)=="" or oldPassword==nil or oldPassword=="" or Util:trim(oldPassword)=="" then
      Util:throwExceptionIfNullOrBlank(userName,"UserName", callBack)
      Util:throwExceptionIfNullOrBlank(oldPassword,"OldPassword", callBack)
      Util:throwExceptionIfNullOrBlank(newPassword,"NewPassword", callBack)
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    userJson.userName = userName  
    userJson.oldPassword = oldPassword  
    userJson.newPassword = newPassword
    user.user = userJson
    app42.app42 = user
    local jsonBody  = JSON:encode(app42)
    App42Log:debug("jsonBody is : "..jsonBody)
    signParams.body =  jsonBody
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version.."/"..resource.."/changeUserPassword"
    RestConnector:executePut(resourceURL,queryParams,jsonBody,headerParams,callBack) 
  end
end

function UserService:resetUserPassword(userName,password,callBack)
  if userName==nil or userName=="" or Util:trim(userName)=="" or password== nil or password=="" or Util:trim(password)=="" then
    Util:throwExceptionIfNullOrBlank(userName,"UserName", callBack)
    Util:throwExceptionIfNullOrBlank(password,"Password", callBack)
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    -- Creating the user JSON
    userJson.userName = userName
    userJson.password = password
    user.user = userJson
    app42.app42 = user
    local jsonBody  = JSON:encode(app42)
    App42Log:debug("jsonBody is : "..jsonBody)
    signParams.body =  jsonBody
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version.."/"..resource.."/resetUserPassword"
    RestConnector:executePut(resourceURL,queryParams,jsonBody,headerParams,callBack)  
  end
end

function UserService:getAllUsers(callBack)
  local signParams =App42Service:populateSignParams()
  local metaHeaderParams = App42Service:populateMetaHeaderParams()
  local headerParams = App42Service:merge(signParams,metaHeaderParams)
  local signature =  Util:sign(App42API:getSecretKey(),signParams)
  App42Log:debug("signature is : "..signature)
  headerParams.signature = signature
  local resourceURL = version.."/"..resource
  headerParams.isArray = "true"
  headerParams.resource = resource
  RestConnector:executeGet(resourceURL,queryParams,headerParams,callBack)
end
function UserService:getUserByEmailId(emailId,callBack)
  if emailId == nil or emailId == "" or Util:trim(emailId) == "" then
    Util:throwExceptionIfNullOrBlank(emailId,"EmailId", callBack)    
  elseif Util:isValidEmailAddress(emailId, callBack) ==  false then
    Util:throwExceptionIfEmailIsNotValid(emailId,"emailId", callBack)
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    signParams.emailId = emailId 
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version.."/"..resource .."/".."email".."/"..emailId
    RestConnector:executeGet(resourceURL,queryParams,headerParams,callBack)
  end
end
function UserService:logOut(sessionId,callBack)
  if sessionId == nil or sessionId == "" or Util:trim(sessionId) == "" then
    Util:throwExceptionIfNullOrBlank(sessionId,"SessionId", callBack)    
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    local sessionJson = {}
    local session = {}
    sessionJson.userName = sessionId
    session.session = sessionJson
    app42.app42 = session
    local jsonBody  = JSON:encode(app42)
    App42Log:debug("jsonBody is : "..jsonBody)
    signParams.body =  jsonBody
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    local resourceURL = version .."/".. "session"
    RestConnector:executePost(resourceURL,queryParams,jsonBody,headerParams,callBack) 
  end
end
function UserService:createOrUpdateProfile(userObj,callBack)
  if userObj == nil or userObj == "" then
    Util:throwExceptionIfNullOrBlank(userObj,"User", callBack)    
  else
    local signParams =App42Service:populateSignParams()
    local metaHeaderParams = App42Service:populateMetaHeaderParams()
    local headerParams = App42Service:merge(signParams,metaHeaderParams)
    local profile  = userObj:getProfile()
    local profileObj= {}
    profileObj.firstName =  profile:getFirstName();
    profileObj.lastName=profile:getLastName();
    profileObj.sex = profile:getSex();
    profileObj.mobile= profile:getMobile();
    profileObj.line1= profile:getLine1();
    profileObj.line2= profile:getLine2();
    profileObj.city= profile:getCity();
    profileObj.state= profile:getState();
    profileObj.country= profile:getCountry();
    profileObj.pincode= profile:getPincode();
    profileObj.homeLandLine= profile:getHomeLandLine();
    profileObj.officeLandLine= profile:getOfficeLandLine();
    profileObj.dateOfBirth= profile:getDateOfBirth();
    userJson.profileData =  profileObj
    userJson.userName= userObj:getUserName()
    user.user = userJson
    app42.app42 = user
    local jsonBody  = JSON:encode(app42)
    App42Log:debug("jsonBody is : "..jsonBody)
    signParams.body =  jsonBody
    local signature =  Util:sign(App42API:getSecretKey(),signParams)
    App42Log:debug("signature is : "..signature)
    headerParams.signature = signature
    headerParams.resource = resource
    local resourceURL = version .."/"..resource.."/profile"
    RestConnector:executePut(resourceURL,queryParams,jsonBody,headerParams,callBack) 
  end
end
function UserService:getFbAccessToken()
  return fbAccessToken
end		
function UserService:setFbAccessToken(_fbAccessToken)
  App42Service:setFbAccessToken(_fbAccessToken)
  fbAccessToken =  _fbAccessToken
end		
function UserService:getSessionId()
  return sessionId
end		
function UserService:setSessionId(_sessionId)
  App42Service:setSessionId(_sessionId)
  sessionId =  _sessionId
end		
function UserService:getAdminKey()
  return adminKey
end		
function UserService:setAdminKey(_adminKey)
  App42Service:setAdminKey(_adminKey)
  adminKey =  _adminKey
end		
function UserService:getOtherMetaHeaders()
  return otherMetaHeaders
end		
function UserService:setOtherMetaHeaders(_otherMetaHeaders)
  App42Service:setOtherMetaHeaders(_otherMetaHeaders)
  otherMetaHeaders =  _otherMetaHeaders
end		
function UserService:getSelectKeys()
  return selectKeys
end		
function UserService:setSelectKeys(_selectKeys)
  App42Service:setSelectKeys(_selectKeys)
  selectKeys = _selectKeys
end		
function App42Service:getOrderByDescending()
  return orderByDescending
end		
function UserService:setOrderByDescending(_orderByDescending)
   App42Service:setOrderByDescending(_orderByDescending)
  orderByDescending = _orderByDescending
end		
function UserService:getOrderByAscending()
  return orderByAscending
end		
function UserService:setOrderByAscending(_orderByAscending)
   App42Service:setOrderByAscending(_orderByAscending)
  orderByAscending = _orderByAscending
end		
function UserService:getAclList()
  return aclList
end		
function UserService:setAclList(_aclList)
  App42Service:setAclList(_aclList)
  aclList = _aclList
end
function UserService:getPageMaxRecords()
  return pageMaxRecords
end		
function UserService:setPageMaxRecords(_pageMaxRecords)
  App42Service:setPageMaxRecords(_pageMaxRecords)
  pageMaxRecords = _pageMaxRecords
end		
function UserService:getPageOffset()
  return pageOffset
end		
function UserService:setPageOffset(_pageOffset)
  App42Service:setPageOffset(_pageOffset)
  pageOffset = _pageOffset
end
return UserService