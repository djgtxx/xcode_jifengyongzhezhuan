-- ���츳ҳ��

NewTalentLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if NewTalentLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(NewTalentLayer.notificationFunc);
	end

	NewTalentLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("NewTalentLayer")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= NewTalentLayer.uiLayerInstance then
			if G_CurLayerInstance ~= NewTalentLayer.uiLayerInstance then
				NewTalentLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function NewTalentLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["NewTalentLayer"].tag
			parentNode:addChild(self.uiLayerInstance,10,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/NewTalentLayer.plist",self.uiLayerInstance, "NewTalentLayer", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function NewTalentLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
end

-- ɾ��UI
function NewTalentLayer:destroyed()
	CCLuaLog("--- NewTalentLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
    SetChatBar(true,-1)
end

--�ر�ҳ��
local function onPressCloseBtn(tag)
    CCLuaLog("--- onPressCloseBtn ---")
    RemoveOneLayer(NewTalentLayer.uiLayerInstance)
	NewTalentLayer:destroyed()
end

function NewTalentLayer:InitLayer()
	CCLuaLog("--- NewTalentLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--ע��ص�����
	self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCloseBtn)


    PushOneLayer(self.uiLayerInstance,"","")
    SetChatBar(false,-1)
end
