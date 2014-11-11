require("Script/GameConfig/uiTagDefine")

BestFighterQueueRemainLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	endTime = 0,
	updateStateFunc = 0,
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	BestFighterQueueRemainLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("BestFighterQueueRemainUI")
end

function BestFighterQueueRemainLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["BestFighterQueueRemainLayer"].tag
			parentNode:addChild(self.uiLayerInstance,0,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/BestFighterQueueRemainUI.plist",self.uiLayerInstance, "BestFighterQueueRemainUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function BestFighterQueueRemainLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
	self.endTime = 0
	self.updateStateFunc = 0
end

-- ɾ��UI
function BestFighterQueueRemainLayer:destroyed()
	CCLuaLog("--- BestFighterQueueRemainLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if BestFighterQueueRemainLayer.updateStateFunc ~= 0 then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(BestFighterQueueRemainLayer.updateStateFunc)
		BestFighterQueueRemainLayer.updateStateFunc = 0
	end

	TimeManager:Get():stopTimer(TIMER_BESTFIGHTER_QUEUE_REMAIN)

	self:resetValue()
end

local function onUpdateRemainTime(remainTime)
	if remainTime <= 0 then
		remainTime = 0
	end

	local remainStr = TimeManager:Get():secondsToString(remainTime)
	local remainTimeLabel = BestFighterQueueRemainLayer.uiLayout:FindChildObjectByName("timeNum").__UILabel__

	if	remainTimeLabel ~= nil then
		remainTimeLabel:setString(remainStr)
	end
end

function BestFighterQueueRemainLayer:InitLayer()
	self:RefreshLayer()
end

function BestFighterQueueRemainLayer:RefreshLayer()

	if self.uiLayerInstance == nil then
		self:CreateLayer()
	end

	if self.endTime > 0 then
		--����ƥ����
		local nowTime = TimeManager:Get():getCurServerTime()
		
		if(TimeManager:Get():hasTimer(TIMER_BESTFIGHTER_QUEUE_REMAIN)) then
			TimeManager:Get():renewTimer(TIMER_BESTFIGHTER_QUEUE_REMAIN, self.endTime)
		else
			TimeManager:Get():registerLuaTimer(onUpdateRemainTime, TIMER_BESTFIGHTER_QUEUE_REMAIN, self.endTime)
		end

		local remainStr = TimeManager:Get():secondsToString(self.endTime - nowTime)
		local remainTimeLabel = self.uiLayout:FindChildObjectByName("timeNum").__UILabel__
		if	remainTimeLabel ~= nil then
			remainTimeLabel:setString(remainStr)
		end
		
		self.uiLayout:FindChildObjectByName("unopenText").__UILabel__:setVisible(false)
		self.uiLayout:FindChildObjectByName("timeText").__UILabel__:setVisible(true)
		self.uiLayout:FindChildObjectByName("timeNum").__UILabel__:setVisible(true)

		--ֹͣ��ѯ
		if self.updateStateFunc ~= 0 then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateStateFunc)
			self.updateStateFunc = 0
		end
	else
		--�δ����
		self.uiLayout:FindChildObjectByName("unopenText").__UILabel__:setVisible(true)
		self.uiLayout:FindChildObjectByName("timeText").__UILabel__:setVisible(false)
		self.uiLayout:FindChildObjectByName("timeNum").__UILabel__:setVisible(false)

		--������ѯ
		if self.updateStateFunc == 0 then
			self.updateStateFunc =  CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(SendBestFighterJoinReq, 3, false)
		end
	end
end