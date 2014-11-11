-- ��������Ѫ��ҳ��
-- ��ʱ��������������bossѪ��

HeroInstanceHPLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if HeroInstanceHPLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(HeroInstanceHPLayer.notificationFunc);
	end

	HeroInstanceHPLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("HeroInstanceHPUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= HeroInstanceHPLayer.uiLayerInstance then
			if G_CurLayerInstance ~= HeroInstanceHPLayer.uiLayerInstance then
				HeroInstanceHPLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function HeroInstanceHPLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["HeroInstanceHPLayer"].tag
			parentNode:addChild(self.uiLayerInstance,10,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/HeroInstanceHPUI.plist",self.uiLayerInstance, "HeroInstanceHPUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function HeroInstanceHPLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
end

-- ɾ��UI
function HeroInstanceHPLayer:destroyed()
	CCLuaLog("--- HeroInstanceHPLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
end

function HeroInstanceHPLayer:InitLayer()
	CCLuaLog("--- HeroInstanceHPLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

end