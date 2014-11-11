-- ��Ҹ���ʤ��ҳ��

CoinBossWinLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	

	winData = {},
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if CoinBossWinLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(CoinBossWinLayer.notificationFunc);
	end

	CoinBossWinLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("CoinBossWinLayer")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= CoinBossWinLayer.uiLayerInstance then
			if G_CurLayerInstance ~= CoinBossWinLayer.uiLayerInstance then
				CoinBossWinLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function CoinBossWinLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["CoinBossWinLayer"].tag
			parentNode:addChild(self.uiLayerInstance,10,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/CoinBossWinUI.plist",self.uiLayerInstance, "CoinBossWinLayer", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

local nowFactor = 0
-- ���ò���
function CoinBossWinLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil

	nowFactor = 0
end

-- ɾ��UI
function CoinBossWinLayer:destroyed()
	CCLuaLog("--- CoinBossWinLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
    SetChatBar(true,-1)
end

-- �뿪����
local function onPressLeaveBtn(tag)
    CCLuaLog("--- onPressShowRewardLayer ---")
	XLogicManager:sharedManager():LeaveBattle()
end

-- ��������
local function onPressDoubleBtn(tag)
    CCLuaLog("--- onPressShowRewardLayer ---")

	local function sendDoubleReq()
		local msgBody = {
		}
		send_message("CSCBDoubleReq", msgBody, true)
	end

	sendDoubleReq()
	PushOneWaitingLayer("CSCBDoubleReq")
end

-- �յ���������
local function onMsgDoubleRsp(msg)
	CCLuaLog("--------------- onMsgDoubleRsp-----------")
	local data = {}
	data.factor = msg.factor

	CCLuaLog("factor : "..msg.factor)
	data.nextNum = msg.next_item_num
	data.nextCost = msg.next_cost_num
	RefreshRewardFactor(data)
end


function CoinBossWinLayer:InitLayer()
	CCLuaLog("--- CoinBossWinLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	local winData = self.winData

	-- ����˺�
	self.uiLayout:FindChildObjectByName("maxHurtNum").__UILabel__:setString(""..winData.maxHurt)

	-- �����˺�
	self.uiLayout:FindChildObjectByName("nowHurtNum").__UILabel__:setString(""..winData.nowHurt)

	-- ��ǰ����
	self.uiLayout:FindChildObjectByName("rankNum").__UILabel__:setString(""..winData.rankNum)

	-- ������������
	if winData.rankChange > 0 then
		self.uiLayout:FindChildObjectByName("rankChangeNum").__UILabel__:setString(""..winData.rankChange)
		local upIcon = AspriteManager:getInstance():getOneFrame("UI/ui_system_icon.bin","map_ui_system_icon_FRAME_497023")
		self.uiLayout:FindChildObjectByName("changeIcon").__UIPicture__:setSprite(upIcon)
	else
		self.uiLayout:FindChildObjectByName("rankChangeNum").__UILabel__:setString("")
	end

	-- �ж��Ƿ��¼�¼
	if winData.maxHurt == winData.nowHurt then
		local newRecordIcon = AspriteManager:getInstance():getOneFrame("UI/ui_system_icon.bin","map_ui_system_icon_FRAME_NEWRECORD")
		local newRecordPic = self.uiLayout:FindChildObjectByName("newrecordPic").__UIPicture__
		newRecordPic:setSprite(newRecordIcon)

		local arrayOfActions = CCArray:create()

		local scale1 = CCScaleTo:create(0.5, 2)
		local scale2 = CCScaleTo:create(0.5, 1)

		arrayOfActions:addObject(scale1)
		arrayOfActions:addObject(scale2)

		local sequence = CCSequence:create(arrayOfActions)
		--local repeatAct =  CCRepeatForever:create(tolua.cast(sequence, 'CCActionInterval'))
		newRecordPic:getCurrentNode():runAction(sequence)
	end

	-- ������Ʒ
	local itemIcon = ItemManager:Get():getIconSpriteById(winData.itemId)
	self.uiLayout:FindChildObjectByName("rewardIcon").__UIPicture__:setSprite(itemIcon)	

	-- ��ť�ص�
	self.uiLayout:FindChildObjectByName("leaveBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressLeaveBtn)
	self.uiLayout:FindChildObjectByName("againBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressDoubleBtn)

	local rewardBtn = self.uiLayout:FindChildObjectByName("rewardFrameBtn").__UIButton__

    local function onPressRewardFrame(tag)
        
        local menu = rewardBtn:getMenuNode()
        local pos = menu:getTouchPoint()

        ItemManager:Get():showItemTipsById(winData.itemId, pos)
    end

	rewardBtn:getMenuItemSprite():registerScriptTapHandler(onPressRewardFrame)

	addMsgCallBack("CSCBDoubleRsp", onMsgDoubleRsp)

    PushOneLayer(self.uiLayerInstance,"","")
    SetChatBar(false,-1)
end



function RefreshRewardFactor(data)
	-- ����
	local label = CCLabelAtlas:create(""..data.factor, "UI/ui_numble_4.png", 41, 43, 48)
	CoinBossWinLayer.uiLayout:FindChildObjectByName("numberIcon1").__UIPicture__:getCurrentNode():removeAllChildrenWithCleanup(true)
	CoinBossWinLayer.uiLayout:FindChildObjectByName("numberIcon1").__UIPicture__:getCurrentNode():addChild(label)
	
	if nowFactor ~= data.factor then
		local arrayOfActions = CCArray:create()

		local scale1 = CCScaleTo:create(0.1, 2)
		local scale2 = CCScaleTo:create(0.1, 1)
		local scale3 = CCScaleTo:create(0.1, 2)
		local scale4 = CCScaleTo:create(0.1, 1)

		arrayOfActions:addObject(scale1)
		arrayOfActions:addObject(scale2)
		arrayOfActions:addObject(scale3)
		arrayOfActions:addObject(scale4)

		local sequence = CCSequence:create(arrayOfActions)
		label:runAction(sequence)
	end
	
	nowFactor = data.factor

	-- ����X���ı�
	local str = GetLuaLocalization("M_AGAIN_GET1")..data.nextNum..GetLuaLocalization("M_AGAIN_GET2")
	CoinBossWinLayer.uiLayout:FindChildObjectByName("againText").__UILabel__:setString(str)

	-- ��ʯ��
	CoinBossWinLayer.uiLayout:FindChildObjectByName("diaNum").__UILabel__:setString(""..data.nextCost)
end