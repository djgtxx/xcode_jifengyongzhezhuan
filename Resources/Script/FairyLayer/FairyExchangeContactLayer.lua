-- ����һ���Яҳ��

require("Script/GameConfig/EquipmentItem")

FairyExchangeContactLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	

	fairyId = 0,
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if FairyExchangeContactLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(FairyExchangeContactLayer.notificationFunc);
	end

	FairyExchangeContactLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("FairyExchangeContactUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= FairyExchangeContactLayer.uiLayerInstance then
			if G_CurLayerInstance ~= FairyExchangeContactLayer.uiLayerInstance then
				FairyExchangeContactLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function FairyExchangeContactLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["FairyExchangeContactLayer"].tag
			parentNode:addChild(self.uiLayerInstance,10,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/FairyExchangeContactUI.plist",self.uiLayerInstance, "FairyExchangeContactUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function FairyExchangeContactLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil

end

-- ɾ��UI
function FairyExchangeContactLayer:destroyed()
	CCLuaLog("--- FairyExchangeContactLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
	--SetChatBar(true,-1)
end



--�ر�ҳ��
local function onPressCloseBtn(tag)
	--RemoveOneLayer(FairyExchangeContactLayer.uiLayerInstance)
	FairyExchangeContactLayer:destroyed()
end

local itemDatas = {}
local itemBtns = {}

-- ���ĳ�����飨��װ������ť
local function onPressFairyBtn(tag)
	local fetterIndex = math.floor(tag / 10)
	local fairyIndex = tag % 10

	local itemId = itemDatas[fetterIndex].fairyList[fairyIndex]


	if EquipmentItems[itemId] ~= nil then
		local menu = itemBtns[tag]:getMenuNode()
		local pos = menu:getTouchPoint()

		ItemManager:Get():showItemTipsById(itemId, pos)
	else
		FairyInfoLayer.fairyId = tonumber(itemId)
		FairyInfoLayer.buttonState = 0
		FairyInfoLayer.infoState = 2
		FairyInfoLayer:CreateLayer(nil)
	end	


end

-- ˢ�¾�����Я��Ϣ
local function refreshFairyContactInfo()

	local fairyId = FairyExchangeContactLayer.fairyId

	CCLuaLog("fairyId : "..fairyId)

	itemDatas = {}
	
	local fetters = getFettersByFairyId(fairyId)
	for i = 1, #fetters do
		local fetterId = fetters[i]

		CCLuaLog("fetterId : "..fetterId)

		local itemData = {}

		itemData.fetterName = getFetterNameById(fetterId)
		itemData.fetterDes = getFetterDescribeById(fetterId)
		itemData.fairyList = getFairyListByFetterId(fetterId)

		table.insert(itemDatas, itemData)

	end


	local function addSingleItem(itemList, index, itemData)
		local itemBg, bgPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_GROUP_FAIRY_FRAME_GROUP_BACKGROUND")
		local bgListItemSize = itemBg:getContentSize()		
		local ListItemNode = CCNode:create()

		local bgControl = itemList:AddBaseItem(bgListItemSize, ListItemNode)

		local function addPic(bgControl, bgPos, resName, frameName, sprite)
			local icon, iconPos = AspriteManager:getInstance():getOneFrameAndPosition(resName,frameName)

			if sprite then 
				sprite:setPosition(ccpSub(iconPos, bgPos))
				bgControl:getCurrentNode():addChild(sprite, 10)
				return sprite
			else 
				icon:setPosition(ccpSub(iconPos, bgPos))
				bgControl:getCurrentNode():addChild(icon, 10)
				return icon
			end
	    	    
		end

		local function addLabel(bgControl, bgPos, resName, frameName, contentStr, fontSize, color, alignment)
			local labelFrame, labelPos = AspriteManager:getInstance():getOneFrameAndPosition(resName,frameName)
			local alignmentSetting = kCCTextAlignmentCenter
			if alignment ~= nil and alignment == 0 then
				alignmentSetting = kCCTextAlignmentLeft        
			end

			local label = TXGUI.UILabelTTF:create(contentStr, KJLinXin, fontSize,labelFrame:getContentSize(), alignmentSetting,kCCVerticalTextAlignmentCenter)
			label:setPosition(ccpSub(labelPos, bgPos))
			label:setColor(color)
			bgControl:getCurrentNode():addChild(label, 11)
			return label
		end

		local function addBtn(bgControl, bgPos, resName, normalName, clickedName,priority, tag, tapFunc)
			local normalSprite, btnPos = AspriteManager:getInstance():getOneFrameAndPosition(resName, normalName)
			local clickedSprite = AspriteManager:getInstance():getOneFrameAndPosition(resName, clickedName)

			local iconBtn = IconButton:create(normalSprite, nil, clickedSprite, priority)
			iconBtn:setPosition(ccpSub(btnPos, bgPos))   

			local btnMenuItem = iconBtn:getMenuItem()
			btnMenuItem:setTag(tag)

			btnMenuItem:registerScriptTapHandler(tapFunc)
	
			bgControl:getCurrentNode():addChild(iconBtn, 10)
			return iconBtn
		end

		-- ����ͼ
		addPic(bgControl, bgPos, "UI/ui.bin", "map_ui_FRAME_GROUP_FAIRY_FRAME_GROUP_BACKGROUND")

		local fetterActive = true

		-- �ĸ���ť��ͼ��
		for i = 1, #itemData.fairyList do
			local fairyId = itemData.fairyList[i]

			itemBtns[index * 10 + i] = addBtn(bgControl, bgPos, "UI/ui.bin", "map_ui_FRAME_GROUP_FAIRY_FRAME_GROUP_ICON"..i.."FRAME", "map_ui_FRAME_GROUP_FAIRY_FRAME_GROUP_ICON"..i.."FRAME", -135, index * 10 + i, onPressFairyBtn)

			local itemSprite = nil

			if EquipmentItems[fairyId] ~= nil then			

				itemSprite = ItemManager:Get():getIconSpriteById(fairyId)

				local itemCount = ItemManager:Get():getItemNumberById(fairyId)
				if itemCount == 0 then
					itemSprite = graylightWithCCSprite(itemSprite, false)
					fetterActive = false
				end
			else
				local fairyBasicInfo = getFairyBasicInfo(tonumber(fairyId))
				itemSprite = fairyBasicInfo:getFairyIcon()

				local fairyCount = GetFairyCountById(fairyId)
				if fairyCount == 0 then
					itemSprite = graylightWithCCSprite(itemSprite, false)
					fetterActive = false
				end				
			end	

			if itemSprite ~= nil then
				addPic(bgControl, bgPos, "UI/ui.bin", "map_ui_FRAME_GROUP_FAIRY_FRAME_GROUP_ICON"..i, itemSprite)
			else 
				CCLuaLog("can't find fairy icon, id : "..fairyId)
			end

		end

		local nameColor = ccc3(251,158,38)
		local contentColor = ccc3(255,195,118)
		if not fetterActive then
			nameColor = ccc3(255, 255, 255)
			contentColor = ccc3(255, 255, 255)
		end


		-- ��Я����
		addLabel(bgControl, bgPos, "UI/ui.bin", "map_ui_FRAME_GROUP_FAIRY_FRAME_GROUP_NAME", ""..itemData.fetterName, 24, nameColor, 1)

		-- ��Я��ϸ����
		addLabel(bgControl, bgPos, "UI/ui.bin", "map_ui_FRAME_GROUP_FAIRY_FRAME_GROUP_TEXT", ""..itemData.fetterDes, 20, contentColor, 0)
	end

	local contactList = FairyExchangeContactLayer.uiLayout:FindChildObjectByName("contactScrollList").__UIScrollList__
	contactList:clearChildrens()

    for i = 1, #itemDatas do
        addSingleItem(contactList, i, itemDatas[i])
    end   


end

function FairyExchangeContactLayer:InitLayer()
	CCLuaLog("--- FairyExchangeContactLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--ע��ص�����
	self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCloseBtn)

	refreshFairyContactInfo()
	--PushOneLayer(self.uiLayerInstance,"","")
	--SetChatBar(false,-1)
end