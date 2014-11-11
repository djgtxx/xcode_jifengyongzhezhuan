require("Script/GameConfig/uiTagDefine")
require("Script/GameConfig/ExchangeParameter")

WorldBossFailLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,
}

WorldBossFailData = {}


-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if WorldBossFailLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(WorldBossFailLayer.notificationFunc);
	end

	WorldBossFailLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("WorldBossFailUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= WorldBossFailLayer.uiLayerInstance then
			if G_CurLayerInstance ~= WorldBossFailLayer.uiLayerInstance then
				WorldBossFailLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function WorldBossFailLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["WorldBossFailLayer"].tag
			parentNode:addChild(self.uiLayerInstance,80,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/WorldBossFailUI.plist",self.uiLayerInstance, "WorldBossFailUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function WorldBossFailLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
end

-- ɾ��UI
function WorldBossFailLayer:destroyed()
	CCLuaLog("--- WorldBossFailLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	TimeManager:Get():stopTimer(TIMER_WORLDBOSS_REVIVE_COUNTDOWN)

	self:resetValue()
end

--���¸���ʱ��
local function onUpdateReviveTime(remainTime)
	if remainTime <= 0 then
		remainTime = 0
	end

	local remainStr = TimeManager:Get():secondsToString(remainTime)
	local remainTimeLabel = WorldBossFailLayer.uiLayout:FindChildObjectByName("bossFailReviveTimeNum").__UILabel__
	remainTimeLabel:setString(remainStr)

	--�����ʱ����
	if remainTime == 0 then
		WorldBossFailLayer.uiLayout:FindChildObjectByName("bossFailReviveBtn").__UIButton__:setVisible(true)
		WorldBossFailLayer.uiLayout:FindChildObjectByName("bossFailBackBtn").__UIButton__:setVisible(true)
		WorldBossFailLayer.uiLayout:FindChildObjectByName("bossFailReviveNowForbidBtn").__UIButton__:setVisible(true)
		WorldBossFailLayer.uiLayout:FindChildObjectByName("bossFailReviveWaitBtn").__UIButton__:setVisible(false)
		WorldBossFailLayer.uiLayout:FindChildObjectByName("bossFailBackWaitBtn").__UIButton__:setVisible(false)
		WorldBossFailLayer.uiLayout:FindChildObjectByName("bossFailReviveNowBtn").__UIButton__:setVisible(false)
	end
end

--��ø���������ʯ��
local function getReviveDiamondCost()
	local exchangeId = 20510
	local str = ExchangeParameter[exchangeId]["FromItems"]
	local beganPos = string.find(str,"/") + 1
	local endPos = string.len(str)
	local num = string.sub(str,beganPos,endPos)
	if num == nil then
		num = 0
	end

	return 0 + num
end

local function sendWorldBossReviveNowReq()
	CSBattlePlayerRevivalReq = {
		}
	local msgname="CSBattlePlayerRevivalReq"
	local ret = send_message(msgname, CSBattlePlayerRevivalReq, true)
	return ret;
end

--�������ť��Ӧ 
local function onPressReviveNowBtn(tag)
	local num = getReviveDiamondCost()

	local diamondCount = UserData:GetDiamond()
	if diamondCount < num then
		GameApi:showMessage(GetLuaLocalization("S_Gh_Diamond_Content"))
		return
	end

	sendWorldBossReviveNowReq()
end

local function sendWorldBossNormalReviveReq()
	CSWBBtlPlayerRevivalReq = {
		}
	local msgname="CSWBBtlPlayerRevivalReq"
	local ret = send_message(msgname, CSWBBtlPlayerRevivalReq, true)
	return ret;
end

--�������ť��Ӧ
local function onPressNormalReviveBtn(tag)
	sendWorldBossNormalReviveReq()
end

--�˳�������ť��Ӧ
local function onPressBackBtn(tag)
	XLogicManager:sharedManager():LeaveBattle()
end

function WorldBossFailLayer:InitLayer()
	CCLuaLog("--- WorldBossFailLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	local reviveNowBtnMenu = self.uiLayout:FindChildObjectByName("bossFailReviveNowBtn").__UIButton__:getMenuItemSprite()
	reviveNowBtnMenu:registerScriptTapHandler(onPressReviveNowBtn)

	--���ذ�ť
	local reviveBtn = self.uiLayout:FindChildObjectByName("bossFailReviveBtn").__UIButton__
	reviveBtn:setVisible(false)

	local backBtn = self.uiLayout:FindChildObjectByName("bossFailBackBtn").__UIButton__
	backBtn:setVisible(false)

	local reviveNowForbidBtn = self.uiLayout:FindChildObjectByName("bossFailReviveNowForbidBtn").__UIButton__
	reviveNowForbidBtn:setVisible(false)

	--ע����Ӧ����
	local reviveBtnMenu = reviveBtn:getMenuItemSprite()
	reviveBtnMenu:registerScriptTapHandler(onPressNormalReviveBtn)

	local backBtnMenu = backBtn:getMenuItemSprite()
	backBtnMenu:registerScriptTapHandler(onPressBackBtn)

	

	--��ʼ������
	local rewardCoinLabel = self.uiLayout:FindChildObjectByName("bossFailRewardCoinNum").__UILabel__
	rewardCoinLabel:setString(""..MainMenuLayer:GetNumByFormat(WorldBossFailData.coin))

	local rewardReputationLabel = self.uiLayout:FindChildObjectByName("bossFailRewardReputationNum").__UILabel__
	rewardReputationLabel:setString(""..WorldBossFailData.reputation)

	local diamondCount = UserData:GetDiamond()
	local diamondCountLabel = self.uiLayout:FindChildObjectByName("bossFailDiamondTotalNum").__UILabel__
	diamondCountLabel:setString(""..diamondCount)

	local num = getReviveDiamondCost()
	local reviveCountLabel = self.uiLayout:FindChildObjectByName("bossFailReviveDiamondNum").__UILabel__
	reviveCountLabel:setString(""..num)

	--�����ʱʱ��
	local nowTime = TimeManager:Get():getCurServerTime()
	TimeManager:Get():registerLuaTimer(onUpdateReviveTime, TIMER_WORLDBOSS_REVIVE_COUNTDOWN, WorldBossFailData.revival_time)

	local remainStr = TimeManager:Get():secondsToString(WorldBossFailData.revival_time - nowTime)
	local remainTimeLabel = self.uiLayout:FindChildObjectByName("bossFailReviveTimeNum").__UILabel__
	remainTimeLabel:setString(remainStr)

	GameDataManager:Get():setHeroAutoAttack(false)

	HideOneLayerByTag(UITagTable["BattleUILayer"].tag)
	HSJoystick:sharedJoystick():setIsEnable(false)
end