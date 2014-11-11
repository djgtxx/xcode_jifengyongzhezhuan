require("Script/GameConfig/uiTagDefine")
require("Script/GameConfig/npc")
require("Script/Instance/CityDefendRoomListLayer")
require("Script/client_version")

CityDefendChatLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,
	CityDefendNpcId = 0,
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if CityDefendChatLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(CityDefendChatLayer.notificationFunc);
	end

	CityDefendChatLayer:resetValue()
	TXGUI.UIManager:sharedManager():removeUILayout("CityDefendChatUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= CityDefendChatLayer.uiLayerInstance then
			if G_CurLayerInstance ~= CityDefendChatLayer.uiLayerInstance then
				CityDefendChatLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

-- �رձ���ҳ�水ť�ص�
local function onCloseBtClicked(tag)
	RemoveOneLayer(CityDefendChatLayer.uiLayerInstance)
	CityDefendChatLayer:destroyed()
end

--�����������Ƿ��ط����б�
function SendGetCityDefendRoomListMsg()
	CSCDEFQueryRoomReq = {
		}
	local msgname="CSCDEFQueryRoomReq"
	local ret = send_message(msgname, CSCDEFQueryRoomReq, true)
	return ret;
end

--�յ����Ƿ��ط����б�
local function onMsgCityDefendRoomListData(msg)
	--���·����б�����
	CityDefendRoomListData = {}
	if msg ~= nil and msg.rooms ~= nil then
		for _, room in pairs(msg.rooms) do
			CityDefendRoomListData[#CityDefendRoomListData + 1] = {
				room_id=room.room_id,
				top_level=room.top_level, 
				current_online=room.current_online, 
				max_online=room.max_online
			}
		end
	end	

	CityDefendRoomListLayer.refreshRoomListLayer()
	return true
end

-- ����ǰ�ť
local function onYesBtClicked(tag)
	local isOpen = GetCityDefendStartState()
	if not isOpen then
		GameApi:showMessage(GetLuaLocalization("M_CITYDEFEND_TIMEISUP"))
		return
	end
	--GameApi:showMessage(GetLuaLocalization("M_FUNCTION_NOTOPEN"))
	SendGetCityDefendRoomListMsg()
	--��ȡʣ�����
	XLogicManager:sharedManager():reqPlayerAttributes(PB_ATTR_PLAYER_CDEF_TIMES)

	showUILayerByTag(UITagTable["CityDefendRoomListLayer"].tag,true)
end

-- �����ť
local function onNoBtClicked(tag)
	onCloseBtClicked(tag)
end

function CityDefendChatLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["CityDefendChatLayer"].tag
			parentNode:addChild(self.uiLayerInstance,0,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/CityDefendChatUI.plist",self.uiLayerInstance, "CityDefendChatUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function CityDefendChatLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
end

-- ɾ��UI
function CityDefendChatLayer:destroyed()
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
end

function CityDefendChatLayer:InitLayer()
	local closeBt = self.uiLayout:FindChildObjectByName("closeBt").__UIButton__:getMenuItemSprite();
	closeBt:registerScriptTapHandler(onCloseBtClicked);

	local yesBt = self.uiLayout:FindChildObjectByName("yesBt").__UIButton__:getMenuItemSprite();
	yesBt:registerScriptTapHandler(onYesBtClicked);

	local noBt = self.uiLayout:FindChildObjectByName("noBt").__UIButton__:getMenuItemSprite();
	noBt:registerScriptTapHandler(onNoBtClicked);

	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)
	PushOneLayer(self.uiLayerInstance,"","")

	
end

--ˢ��ҳ��
function RefreshCityDefendChatLayer()
	--����λ��
	local npcImageName = "UI/"..npcs[CityDefendChatLayer.CityDefendNpcId]["BodyIcon"]..".png"
	local imagePath = GameResourceManager:sharedManager():storedFullPathFromRelativePath(npcImageName);
	local npcSprite = CCSprite:create(imagePath)
    local npcPic = CityDefendChatLayer.uiLayout:FindChildObjectByName("npcPic").__UIPicture__

	local lastPt = CCPointZero
	local widthOffset = 0;
	local heightOffset = 0;

	-- chensy note
	
	if getClientVersion() == "hq" then
		npcSprite:setScale(1.667)
	end

	if getClientVersion() == "nq" then
		npcSprite:setScale(2.0)
	end

	local anchorPoint = npcPic:getCurrentNode():getAnchorPoint();
	widthOffset = widthOffset - anchorPoint.x * npcPic:getSpriteSize().width
	heightOffset = heightOffset - anchorPoint.y * npcPic:getSpriteSize().height
	lastPt = ccp(npcPic:getCurrentNode():getPosition())
	
	npcSprite:setAnchorPoint(ccp(0,0))
	npcPic:setSprite(npcSprite)
	npcSprite:setPosition(ccp(lastPt.x + widthOffset,lastPt.y + heightOffset))

	--npc����
	--local npcName = GetLuaLocalization("NPC_"..CityDefendChatLayer.CityDefendNpcId.."_name")
    local npcName = GetLuaLocalization("NPC_518_name")
	local npcNameLabel = CityDefendChatLayer.uiLayout:FindChildObjectByName("npcName").__UILabel__
	npcNameLabel:setString(npcName)
end

-- ֱ�Ӵ����Ƿ��ط����б�
function OpenCityDefenceRoomList()
    addMsgCallBack("CSCDEFQueryRoomRsp", onMsgCityDefendRoomListData)

    SendGetCityDefendRoomListMsg()
	--��ȡʣ�����
	XLogicManager:sharedManager():reqPlayerAttributes(PB_ATTR_PLAYER_CDEF_TIMES)

	showUILayerByTag(UITagTable["CityDefendRoomListLayer"].tag,true)
end