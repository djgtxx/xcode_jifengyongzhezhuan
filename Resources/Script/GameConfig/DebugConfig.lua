 --������������
local unlockAllCity = false

--��ʾ���Կ�
local showDebugBox = {
	["all"] = false,
	["attack"] = false,
	["collider"] = false,
	["view"] = false,
}

--Note: �ر�UI��ѧϵͳ
local disableUITutorial = false

--Note: �ر����˵���ť��ʾϵͳ
local disableMainMenuControlsManager = false

-- �����Զ�ս��
local enableAutoFight = false

--Note: ���MIMI��
local userId = 0

--ʹ��ָ�������׺ŵ���
local useDebugUser = true

local debugPlatform = true
--local debugUserId = 18018663
--local debugUserId = 1356
--local debugUserId = 5689
local debugUserId = 51511
local debugUserSession = "99123456nnapsj12e6syR"
local debugChannel	= 93
local gameID = 23

function IsUnlockAllCity()
	return unlockAllCity
end

function ShowDebugBox(type)
	if	showDebugBox["all"] == false then
		return showDebugBox[type]
	end
	return showDebugBox["all"]
end

function IsDisableUITutorial()
	if nil == disableUITutorial then
		return true
	end
	return disableUITutorial
end

function IsDisableMainMenuControlsManager()
	if nil == disableMainMenuControlsManager then
		return true
	end
	return disableMainMenuControlsManager
end

function GetUserIDFromLua()
	if nil == userId then
		return 0
	end
	return userId
end

function GetEnableAutoFight()
    return enableAutoFight
end

--ָ���û�����
function UseDebugUser()
	return useDebugUser
end

function GetDebugUserId()
	return debugUserId
end

function GetDebugUserSession()
	return debugUserSession
end

function GetDebugChannel()
	return debugChannel
end

function GetDebugGameID()
	return gameID
end

function GetDebugPlatform()
	return debugPlatform
end

local enable_niu_bi_fu_ben=false

function GetenableNiuBiFuBen()
	return enable_niu_bi_fu_ben
end
