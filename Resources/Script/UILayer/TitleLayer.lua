-- �ƺ�ҳ��

TitleLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if TitleLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(TitleLayer.notificationFunc);
	end

	TitleLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("TitleLayer")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= TitleLayer.uiLayerInstance then
			if G_CurLayerInstance ~= TitleLayer.uiLayerInstance then
				TitleLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function TitleLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["TitleLayer"].tag
			parentNode:addChild(self.uiLayerInstance,10,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/TitleLayer.plist",self.uiLayerInstance, "TitleLayer", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function TitleLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
end

-- ɾ��UI
function TitleLayer:destroyed()
	CCLuaLog("--- TitleLayer:destroyed() ---")
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
    RemoveOneLayer(TitleLayer.uiLayerInstance)
	TitleLayer:destroyed()
end

function TitleLayer:InitLayer()
	CCLuaLog("--- TitleLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--ע��ص�����
	self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCloseBtn)
    self.uiLayout:FindChildObjectByName("detailLayer"):setVisible(false)


    PushOneLayer(self.uiLayerInstance,"","")
    SetChatBar(false,-1)
end
