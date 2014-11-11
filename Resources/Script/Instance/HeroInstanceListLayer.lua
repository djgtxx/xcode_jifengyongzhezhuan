-- �������������б�ҳ��
require("Script/GameConfig/InstanceList")
require("Script/GameConfig/ExchangeParameter")

HeroInstanceListLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	
}

local nowCompleteInstanceId = 0
function SetNowCompleteInstanceId(id)
    nowCompleteInstanceId = id
end

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if HeroInstanceListLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(HeroInstanceListLayer.notificationFunc);
	end

	HeroInstanceListLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("HeroInstanceListUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= HeroInstanceListLayer.uiLayerInstance then
			if G_CurLayerInstance ~= HeroInstanceListLayer.uiLayerInstance then
				HeroInstanceListLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function HeroInstanceListLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["HeroInstanceListLayer"].tag
			parentNode:addChild(self.uiLayerInstance,10,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/HeroInstanceListUI.plist",self.uiLayerInstance, "HeroInstanceListUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function HeroInstanceListLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
end

-- ɾ��UI
function HeroInstanceListLayer:destroyed()
	CCLuaLog("--- HeroInstanceListLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
    SetChatBar(true,-1)
end



local instanceDatas = nil
-- ��ʼ������������������
local function initInstanceData()
    instanceDatas = {}

    local function sortFunc(a, b)
        return a.id < b.id
    end

    -- ��ʼ������������Ϣ
    for k, v in pairs(instances) do
        if tonumber(v.Type) == 14 then
            local instanceData = {}
            instanceData.id = k
            instanceData.name = GetLuaLocalization(v.RaidName)
            instanceData.icon = v.Icon

            table.insert(instanceDatas, instanceData)
        end
    end

    table.sort(instanceDatas, sortFunc)

    -- ��ʼ������������Ϣ����һ�����Ʊ��
    for i = 1, #instanceDatas do
        local exchangeTable = ExchangeParameter[20059 + i]
        instanceDatas[i].costItemId , instanceDatas[i].costCount = string.match(exchangeTable.FromItems, "(%d+)/(%d+)")
    end

end



-- ���������ť
local function onPressInstanceBtn(tag)
	CCLuaLog("--- onPressInstanceBtn ---"..tag)
    CCLuaLog("instanceId : "..instanceDatas[tag].id)
    SendHeroInstanceCreateReq(instanceDatas[tag].id)
    PushOneWaitingLayer("CSCancelWaitingRsp")

    --SetNowHeroInstanceId(instanceDatas[tag].id)
end

-- ���������б�
local function setupInstanceList()
    local page = HeroInstanceListLayer.uiLayout:FindChildObjectByName("instanceListScrollPage").__UIScrollPage__

    local _, bgPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_LIST_AREA")

    local scale =  TXGUI.UIManager:sharedManager():getScaleFactor()

    local function addSingleInstance(page, index, instanceData)

        -- pageIndex ��0��ʼ
        local pageIndex = math.floor((index - 1) / 6)
        local pageCount = page:getPageCount()
        if pageIndex > pageCount - 1 then
           local layer = CCLayer:create()
           layer:setAnchorPoint(ccp(0, 0))
           page:addPage(layer, false)            
        end

        local nowLayer = page:getPageLayer(pageIndex)
        local nowLayerPos = ccp(nowLayer:getPosition())
        CCLuaLog("------------------------- nowLayerPos.x, nowLayerPos.y-------------"..nowLayerPos.x.." "..nowLayerPos.y)

        -- ���������ڵ�
        local curInstanceNode = CCNode:create()
        nowLayer:addChild(curInstanceNode)

        -- λ��ƫ��
        local deltaX = 150 * ((index - 1) % 6)

        local function getRealPos(orgPos)
            local deltaPos = ccpMult(ccpSub(orgPos, bgPos), scale)
            local offsetPos = ccpMult(ccp(deltaX, 0), scale)
            local realPos = ccpAdd(deltaPos, offsetPos)
            return realPos
        end

        -- ��������
		local instanceNameLabel = TXGUI.UILabelTTF:create(instanceData.name, KJLinXin, 22)
		local _, instanceNameLabelPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_TEXT_INSTANCENAME")
        local realPos = getRealPos(instanceNameLabelPos)
        CCLuaLog("------------------------- realPos.x, realPos.y-------------"..realPos.x.." "..realPos.y)

		instanceNameLabel:setPosition(getRealPos(instanceNameLabelPos))
        instanceNameLabel:setScale(scale)
        instanceNameLabel:setColor(ccc3(255,184,0))

        nowLayer:addChild(instanceNameLabel)

        -- ������ť
		local normalSprite, instanceBtnPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_GRID1")
		local clickedSprite = AspriteManager:getInstance():getOneFrame("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_GRID1_CLICKED")
 
		local instanceBtn = IconButton:create(normalSprite, nil, clickedSprite, -130)
		instanceBtn:setPosition(getRealPos(instanceBtnPos))

		local btnMenuItem = instanceBtn:getMenuItem()
		btnMenuItem:setTag(index)

		btnMenuItem:registerScriptTapHandler(onPressInstanceBtn)

        instanceBtn:setScale(scale)
        nowLayer:addChild(instanceBtn)

        -- ����ͼ��
        local instanceIconResStr = "map_ui_system_icon_FRAME_"..string.upper(instanceData.icon)
        local instanceIcon = AspriteManager:getInstance():getOneFrame("UI/ui_system_icon.bin",instanceIconResStr)

        if nowCompleteInstanceId - instanceDatas[1].id + 1 < index and index <= 10 and index ~= 1 then
            instanceIcon = graylightWithCCSprite(instanceIcon, false)
        end

        --instanceBtn:AddExternalSprite(instanceIcon, ccp(0, 0))
        instanceBtn:addChild(instanceIcon)

        -- �����ı� 
        local spendTextLabel = TXGUI.UILabelTTF:create(GetLuaLocalization("M_HEROINSTANCE_SPEND"), KJLinXin, 22)
		local _, spendTextLabelPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_TEXT_SPEND")
		spendTextLabel:setPosition(getRealPos(spendTextLabelPos))
        spendTextLabel:setColor(ccc3(255,195,118))

        spendTextLabel:setScale(scale)
        nowLayer:addChild(spendTextLabel)

        -- ������Ʒicon
        local costItemIcon, costItemPos
        if tonumber(instanceData.costItemId) == 416001 then
            costItemIcon, costItemPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_ICON_COIN")
        else
            costItemIcon, costItemPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_ICON_TICKET")  
        end
        costItemIcon:setPosition(getRealPos(costItemPos))

        costItemIcon:setScale(scale)
        nowLayer:addChild(costItemIcon)

        -- ������Ʒ����
        
        
        local spendCountLabel = nil
		
        if tonumber(instanceData.costItemId) == 416001 then
            local coinCountFrame, coinCountLabelPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_NUM_SPEND1")
            spendCountLabel = TXGUI.UILabelTTF:create(" X "..MainMenuLayer:GetNumByFormat(instanceData.costCount), KJLinXin, 22, 
                                                    coinCountFrame:getContentSize(), kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter)
            spendCountLabel:setPosition(getRealPos(coinCountLabelPos))
        else
            local ticketCountFrame, ticketCountLabelPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_NUM_SPEND2")
            spendCountLabel = TXGUI.UILabelTTF:create(" X "..instanceData.costCount, KJLinXin, 22, 
                                    ticketCountFrame:getContentSize(), kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter)
            spendCountLabel:setPosition(getRealPos(ticketCountLabelPos))
        end

        spendCountLabel:setScale(scale)
        nowLayer:addChild(spendCountLabel)

        -- ��Ʊ�ı�
        if tonumber(instanceData.costItemId) ~= 416001 then
            local ticketTextLabel = TXGUI.UILabelTTF:create(GetLuaLocalization("M_HEROINSTANCE_TICKET"..index), KJLinXin, 22)
		    local _, ticketTextLabelPos = AspriteManager:getInstance():getOneFrameAndPosition("UI/ui.bin","map_ui_FRAME_HEROINSTANCE_TEXT_TICKET")
		    ticketTextLabel:setPosition(getRealPos(ticketTextLabelPos))
            ticketTextLabel:setColor(ccc3(255,195,118))

            ticketTextLabel:setScale(scale)
            nowLayer:addChild(ticketTextLabel)
        end

    end

    for i = 1, #instanceDatas do
        addSingleInstance(page, i, instanceDatas[i])
    end    

    page:moveToPage(0)
end

-- ���̵�
local function onPressShopBtn(tag)
	CCLuaLog("--- onPressShopBtn ---")
    MainMenuLayer:getMainMenuLayer():ShowMarketLayer(true, 2)
    RemoveOneLayer(HeroInstanceListLayer.uiLayerInstance)
	HeroInstanceListLayer:destroyed()
end

--�ر�ҳ��
local function onPressCloseBtn(tag)
    CCLuaLog("--- onPressCloseBtn ---")
    RemoveOneLayer(HeroInstanceListLayer.uiLayerInstance)
	HeroInstanceListLayer:destroyed()
end

function HeroInstanceListLayer:InitLayer()
	CCLuaLog("--- HeroInstanceListLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--ע��ص�����
	self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCloseBtn)
    self.uiLayout:FindChildObjectByName("shopBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressShopBtn)

    if instanceDatas == nil then
        initInstanceData()
    end
    
    setupInstanceList()

    PushOneLayer(self.uiLayerInstance,"","")
    SetChatBar(false,-1)
end

------------------------------------------------ �������� -----------------------------
local nowInstanceId = 0
function SetNowHeroInstanceId(instanceId)
    nowInstanceId = instanceId
end

function GetNowHeroInstanceId()
    return nowInstanceId
end

function GetNextHeroInstanceId()
    CCLuaLog("--- GetNextHeroInstanceId ---")
    if instanceDatas == nil then
        initInstanceData()
    end

    for k, instanceData in pairs(instanceDatas) do
        if instanceData.id == nowInstanceId then
            if instanceDatas[k+1] ~= nil then
                return instanceDatas[k+1].id
            else
                CCLuaLog("--- next == nil ---")
                return 0
            end
        end
    end
end

function GetNextHeroInstanceCostData()
    if instanceDatas == nil then
        initInstanceData()
    end

    for k, instanceData in pairs(instanceDatas) do
        if instanceData.id == nowInstanceId then
            if instanceDatas[k+1] ~= nil then
                return tonumber(instanceDatas[k+1].costItemId) , tonumber(instanceDatas[k+1].costCount)
            else
                CCLuaLog("--- next == nil ---")
                return nil
            end
        end
    end
end