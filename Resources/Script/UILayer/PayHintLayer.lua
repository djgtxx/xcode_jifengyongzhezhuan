-- ��ֵ����ҳ��
require("Script/GameConfig/vip")
require("Script/GameConfig/ExchangeItem")

PayHintLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if PayHintLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(PayHintLayer.notificationFunc);
	end

	PayHintLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("PayHintUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= PayHintLayer.uiLayerInstance then
			if G_CurLayerInstance ~= PayHintLayer.uiLayerInstance then
				PayHintLayer:destroyed()
				ret = 1
			end
		end
	elseif message == GM_ATTR_REPUTATION_UPDATE then
		PayHintLayer:RefreshReputation()
	end

	return ret
end

function PayHintLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["PayHintLayer"].tag
			parentNode:addChild(self.uiLayerInstance,60,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/PayHintUI.plist",self.uiLayerInstance, "PayHintUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function PayHintLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
end

-- ɾ��UI
function PayHintLayer:destroyed()
	CCLuaLog("--- PayHintLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
end

--�ر�ҳ��
local function onPressCloseBtn(tag)
	PayHintLayer:destroyed()
end

-- ��ֵ��ť
local function onPressPayBtn(tag)
    PayHintLayer:destroyed()
    MainMenuLayer:getMainMenuLayer():ShowChargeLayer(true)
end

-- ��ʼ��VIP��Ϣ����Ʒ��Ϣ
local function initVipInfo()
    -- ��ǰVIP�ȼ�
    local nowVipLevel =  UserData:GetVipLevel()
    local nowVipSprite = AspriteManager:getInstance():getOneFrame("UI/ui2.bin", "map_ui2_FRAME_PAYHINT_ICON_VIP"..nowVipLevel)
    PayHintLayer.uiLayout:FindChildObjectByName("vipNowPic").__UIPicture__:setSprite(nowVipSprite)

    -- ��һ����ʾ
    if Vip[nowVipLevel + 1] ~= nil then
        local alreadyPayCount = UserData:GetUserInfo().m_diamond_acc
        local nextPayCount = Vip[nowVipLevel + 1].Diamond

        local needCount = nextPayCount - alreadyPayCount
        PayHintLayer.uiLayout:FindChildObjectByName("vipNextNum").__UILabel__:setString(""..needCount)

        local nextVipSprite = AspriteManager:getInstance():getOneFrame("UI/ui2.bin", "map_ui2_FRAME_PAYHINT_ICON_VIP"..(nowVipLevel + 1))
        PayHintLayer.uiLayout:FindChildObjectByName("vipNextPic").__UIPicture__:setSprite(nextVipSprite)
        PayHintLayer.uiLayout:FindChildObjectByName("title3").__UILabel__:setString(GetLuaLocalization("M_PAYHINT_VIP"..(nowVipLevel+1).."REWARD"))
    else
        PayHintLayer.uiLayout:FindChildObjectByName("vipTopText").__UILabel__:setString(GetLuaLocalization("M_PAYHINT_VIPTOP"))
        PayHintLayer.uiLayout:FindChildObjectByName("vipNextNum"):setVisible(false)
        PayHintLayer.uiLayout:FindChildObjectByName("vipNextText1"):setVisible(false)
        PayHintLayer.uiLayout:FindChildObjectByName("vipNextText2"):setVisible(false)
        PayHintLayer.uiLayout:FindChildObjectByName("title3").__UILabel__:setString(GetLuaLocalization("M_PAYHINT_VIP"..(nowVipLevel).."REWARD"))
    end
    
    -- ר����Ʒ
    local vipItems = {}
    for i = 1, 4 do
        vipItems[i] = {}
    end

    local itemTable = ExchangeItems[1700 + nowVipLevel + 1] or ExchangeItems[1700 + nowVipLevel]
    local rewardStr = itemTable.ToItems

    --��������
    local function matchCost(exchangeStr, count)
        local rexStr = "(%d+)/(%d+)"
        for i = 1, count - 1 do
            rexStr = rexStr .. ";(%d+)/(%d+)"
        end
        return string.match(exchangeStr, rexStr)
    end

    if matchCost(rewardStr, 4) ~= nil then
        vipItems[1].id, vipItems[1].count, vipItems[2].id, vipItems[2].count, vipItems[3].id, vipItems[3].count, vipItems[4].id, vipItems[4].count =  matchCost(rewardStr, 4)
    elseif matchCost(rewardStr, 3) ~= nil then
        vipItems[1].id, vipItems[1].count, vipItems[2].id, vipItems[2].count, vipItems[3].id, vipItems[3].count =  matchCost(rewardStr, 3)
    elseif matchCost(rewardStr, 2) ~= nil then
        vipItems[1].id, vipItems[1].count, vipItems[2].id, vipItems[2].count =  matchCost(rewardStr, 2)
    elseif matchCost(rewardStr, 1) ~= nil then
        vipItems[1].id, vipItems[1].count =  matchCost(rewardStr, 1)
    end
    

    local function onPressItemBtn(tag)
        local menu = PayHintLayer.uiLayout:FindChildObjectByName("rewardBtn"..tag).__UIButton__:getMenuNode()
        local pos = menu:getTouchPoint()

	    ItemManager:Get():showItemTipsById(vipItems[tag].id, pos)
    end

    local buttonSize = AspriteManager:getInstance():getOneFrame("UI/ui2.bin", "map_ui2_FRAME_PAYHINT_FRAME_REWARD1"):getContentSize()
    for i = 1, 4 do
        if vipItems[i].id ~= nil then
            PayHintLayer.uiLayout:FindChildObjectByName("rewardBtn"..i):setVisible(true)
            PayHintLayer.uiLayout:FindChildObjectByName("rewardIcon"..i):setVisible(true)

            itemSprite = ItemManager:Get():getIconSpriteById(vipItems[i].id)
            --PayHintLayer.uiLayout:FindChildObjectByName("rewardIcon"..i).__UIPicture__:setSprite(itemSprite)

            PayHintLayer.uiLayout:FindChildObjectByName("rewardBtn"..i).__UIButton__:setIconSprite(itemSprite)
            PayHintLayer.uiLayout:FindChildObjectByName("rewardBtn"..i).__UIButton__:setTextLabel(""..vipItems[i].count,18,ccc3(255, 255, 255),KJLinXin, ccp(buttonSize.width * 0.4,buttonSize.height * -0.4),ccp(1,0));
        else
            PayHintLayer.uiLayout:FindChildObjectByName("rewardBtn"..i):setVisible(false)
            PayHintLayer.uiLayout:FindChildObjectByName("rewardIcon"..i):setVisible(false)
        end

        PayHintLayer.uiLayout:FindChildObjectByName("rewardBtn"..i).__UIButton__:getMenuItemSprite():setTag(i)
        PayHintLayer.uiLayout:FindChildObjectByName("rewardBtn"..i).__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressItemBtn)
    end
     

end

function PayHintLayer:InitLayer()
	CCLuaLog("--- PayHintLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--ע��ص�����
	self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCloseBtn)
    self.uiLayout:FindChildObjectByName("payBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressPayBtn)

    initVipInfo()
end

--------------------- �������� ----------------------------

local requireDiamondCount = 0
function SetRequireDiamondCount(count)
    requireDiamondCount = tonumber(count)
end

function CheckPayHint()
    local diamondCount = UserData:GetDiamond()
    if diamondCount < requireDiamondCount then
        PayHintLayer:CreateLayer()
    end
end