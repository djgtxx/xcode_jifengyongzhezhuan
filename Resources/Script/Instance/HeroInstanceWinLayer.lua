-- ��������ʤ��ҳ��

HeroInstanceWinLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	

    rewardItems = {},
    factors = {0, 50, 100, 200, 500, 1000},

    -- ������
    delayTimes = {1, 1, 1, 1, 1, 1, 1},
    rollRoundNum = 2,
    rollSingleTime = 0.1,
    debugFlag = false,
}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if HeroInstanceWinLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(HeroInstanceWinLayer.notificationFunc);
	end

	HeroInstanceWinLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("HeroInstanceWinUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= HeroInstanceWinLayer.uiLayerInstance then
			if G_CurLayerInstance ~= HeroInstanceWinLayer.uiLayerInstance then
				HeroInstanceWinLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function HeroInstanceWinLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["HeroInstanceWinLayer"].tag
			parentNode:addChild(self.uiLayerInstance,10,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/HeroInstanceWinUI.plist",self.uiLayerInstance, "HeroInstanceWinUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function HeroInstanceWinLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil    
    self.rewardItems = {}
end

-- ɾ��UI
function HeroInstanceWinLayer:destroyed()
	CCLuaLog("--- HeroInstanceWinLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
end




-- ��ʼ��������Ʒͼ�꼰����
local function initRewardItems()
    for i = 1, 2 do
        if HeroInstanceWinLayer.rewardItems[i] ~= nil then
            local itemId = HeroInstanceWinLayer.rewardItems[i].id
            local itemCount = HeroInstanceWinLayer.rewardItems[i].count

            local itemSprite = ItemManager:Get():getIconSpriteById(itemId)
            HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemIcon"..i).__UIPicture__:setSprite(itemSprite,false)

            local itemCountStr = MainMenuLayer:GetNumByFormat(itemCount)
            if i == 2 then
                itemCountStr = " X "..itemCountStr
            end
            HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemNum"..i).__UILabel__:setString(itemCountStr)

            -- ��������Ʒ�͵ڶ�����Ʒ��ͬ������һ����ƷΪ��ֱ����ʾ�ڶ�����Ʒ
            if i == 2 then
                local itemSprite = ItemManager:Get():getIconSpriteById(itemId)
                HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemIcon3").__UIPicture__:setSprite(itemSprite, false)
                HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemNum3").__UILabel__:setString(itemCountStr)
            end
        end
        
    end
end

-- ���ĳ���������ڵ�index
local function getFactorIndex(factor)
    local index  = 1
    for i = 1, #HeroInstanceWinLayer.factors do
        if HeroInstanceWinLayer.factors[i] == factor then
            index = i
            break
        end       
    end
    return index
end

local function showRollFactor()
    local multLabel = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("multNum").__UILabel__
    multLabel:setVisible(true)
    multLabel:setString(" X "..MainMenuLayer:GetNumByFormat(HeroInstanceWinLayer.rewardItems[1].count * HeroInstanceWinLayer.rewardItems[1].factor))

    do return end
    -- ��������
    local multLabel = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("multNum").__UILabel__
    multLabel:setVisible(true)
    multLabel:setString("")

    local labelFrame = AspriteManager:getInstance():getOneFrame("UI/ui_inbattle.bin","map_ui_inbattle_FRAME_HERO_NUM_REWARD1MULT")
    local labelSize = labelFrame:getContentSize()

    local clipNode = CCClippingNode:create()
    clipNode:setInverted(false)
	clipNode:setAlphaThreshold(0)
    

    local stencilNode = CCNode:create()
    local clipArea = CCSprite:create("UI/ui_leadpic.png")

    local scale = TXGUI.UIManager:sharedManager():getScaleFactor()
    clipArea:setScaleX(labelSize.width * scale / 100)
    clipArea:setScaleY(labelSize.height * scale / 100)

    stencilNode:addChild(clipArea)
    clipNode:setStencil(stencilNode)

    local rollNode = CCNode:create()
    clipNode:addChild(rollNode)

    multLabel:getCurrentNode():addChild(clipNode)


    local factorLabels = {}
    for i = 1, #HeroInstanceWinLayer.factors do
        local factorLabel = TXGUI.UILabelTTF:create(""..(HeroInstanceWinLayer.factors[i] / 100), KJLinXin, 24, labelSize, kCCTextAlignmentCenter, kCCVerticalTextAlignmentCenter)
        factorLabel:setPosition(ccp(0, - labelSize.height * scale * (i-1) ))

        factorLabel:setScale(scale)
        factorLabel:setColor(ccc3(0, 255, 0))
        rollNode:addChild(factorLabel)

        factorLabels[i] = factorLabel
    end

    -- ĩβ��ӵ�һ�����ʱ�ǩ����ѭ��
    local factorLabel = TXGUI.UILabelTTF:create(""..(HeroInstanceWinLayer.factors[1] / 100), KJLinXin, 22, labelSize, kCCTextAlignmentCenter, kCCVerticalTextAlignmentCenter)
    factorLabel:setPosition(ccp(0, - labelSize.height * scale * #HeroInstanceWinLayer.factors ))
    factorLabel:setScale(scale)
    factorLabel:setColor(ccc3(0, 255, 0))
    rollNode:addChild(factorLabel)

    -- ��ʼ����������    
    local arrayOfActions = CCArray:create()

    for i = 1, HeroInstanceWinLayer.rollRoundNum do
        local moveRound = CCMoveTo:create(#HeroInstanceWinLayer.factors * HeroInstanceWinLayer.rollSingleTime, ccp(0, labelSize.height * scale * #HeroInstanceWinLayer.factors ))
        local resetMove = CCMoveTo:create(0, ccp(0, 0))

        arrayOfActions:addObject(moveRound)
        arrayOfActions:addObject(resetMove)
    end


    -- ���շ�����ָ������
    local finalFactorIndex = getFactorIndex(HeroInstanceWinLayer.rewardItems[1].factor)

    local finalMove = CCMoveTo:create((finalFactorIndex - 1) * HeroInstanceWinLayer.rollSingleTime, ccp(0, labelSize.height * scale * (finalFactorIndex - 1) ))
    arrayOfActions:addObject(finalMove)

    
    local function scaleAndResetFunc()
        local array = CCArray:create()

        local scaleBig = CCScaleTo:create(0.3, 2 * scale)
        local resetScale = CCScaleTo:create(0.3, 1 * scale)

        array:addObject(scaleBig)
        array:addObject(resetScale)

        local seq = CCSequence:create(array)
        factorLabels[finalFactorIndex]:runAction(seq)
    end    

    local scaleFunc = CCCallFunc:create(scaleAndResetFunc)
    arrayOfActions:addObject(scaleFunc)

    local sequence = CCSequence:create(arrayOfActions)
    rollNode:runAction(sequence)

end

-- ������һ�㻨��
local function hideNextCost()
    local nextSpendText1 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendText1")
    local nextCoinIcon = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextCoinIcon")
    local nextSpendNum1 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendNum1")

    local nextSpendText2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendText2")
    local nextSpendTicket2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendTicket2")
    local nextSpendNum2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendNum2")

    nextSpendText1:setVisible(false)
    nextCoinIcon:setVisible(false)
    nextSpendNum1:setVisible(false)
    nextSpendText2:setVisible(false)
    nextSpendTicket2:setVisible(false)
    nextSpendNum2:setVisible(false)
end

-- ��ʾ��һ�㻨��
local function showNextCost()
    local nextSpendText1 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendText1")
    local nextCoinIcon = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextCoinIcon")
    local nextSpendNum1 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendNum1")

    local nextSpendText2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendText2")
    local nextSpendTicket2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendTicket2")
    local nextSpendNum2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextSpendNum2")

    local costItemId, costItemCount = GetNextHeroInstanceCostData()
    if costItemId ~= nil then
        if costItemId == 416001 then
            nextSpendText1:setVisible(true)
            nextCoinIcon:setVisible(true)
            nextSpendNum1:setVisible(true)

            nextSpendNum1.__UILabel__:setString(" X "..MainMenuLayer:GetNumByFormat(costItemCount))
        else
            nextSpendText2:setVisible(true)
            nextSpendTicket2:setVisible(true)
            nextSpendNum2:setVisible(true)

            -- �ӱ���ֱ�Ӷ���Ʊ�ı���Ӧ˳���item id ��ϵ
            local index = costItemId - 476020 + 11
            nextSpendTicket2.__UILabel__:setString(GetLuaLocalization("M_HEROINSTANCE_TICKET"..index))
            nextSpendNum2.__UILabel__:setString(" X "..costItemCount)
        end
    end
end

-- ��˳����ʾ�����
local function showLayerInSequence()
    hideNextCost()
    -- ��ȡ�����
    local winBack = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("winBack")
    local winTitle = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("winTitle")

    local winText = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("winText")
    local rewardText = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("rewardText")

    local itemIcon1 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemIcon1")
    local itemNum1 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemNum1")

    local itemIcon2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemIcon2")
    local itemNum2 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemNum2")

    local itemIcon3 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemIcon3")
    local itemNum3 = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("itemNum3")

    local againBtn = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("againBtn")
    local againText = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("againText")

    local backBtn = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("backBtn")
    local backText = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("backText")

    local nextBtn = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextBtn")
    local nextText = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("nextText")

    -- �˺�
    local multMark = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("multMark")
    local multNum = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("multNum")

    -- ������
    local multText = HeroInstanceWinLayer.uiLayout:FindChildObjectByName("multText")  
    
    -- �����������
    winBack:setVisible(false)
    winTitle:setVisible(false)
    winText:setVisible(false)
    rewardText:setVisible(false)

    itemIcon1:setVisible(false)
    itemNum1:setVisible(false)

    itemIcon2:setVisible(false)
    itemNum2:setVisible(false)

    itemIcon3:setVisible(false)
    itemNum3:setVisible(false)

    againBtn:setVisible(false)
    againText:setVisible(false)

    backBtn:setVisible(false)
    backText:setVisible(false)

    nextBtn:setVisible(false)
    nextText:setVisible(false)

    multMark:setVisible(false)
    multNum:setVisible(false)
    multText:setVisible(false)

    local actionNode = CCNode:create()
    winBack:getCurrentNode():addChild(actionNode)

    -- �ӳ���ʾ����
    local function delayShowObj(delayTime, obj)
        local function showFunc()
            obj:setVisible(true)
        end

        local arrayOfActions = CCArray:create()

        local delay = CCDelayTime:create(delayTime)
        local show = CCCallFunc:create(showFunc)

        arrayOfActions:addObject(delay)
        arrayOfActions:addObject(show)

        local sequence = CCSequence:create(arrayOfActions)
        actionNode:runAction(sequence)
    end

    local function delayFunc(delayTime, func)
        local arrayOfActions = CCArray:create()

        local delay = CCDelayTime:create(delayTime)
        local ccfunc = CCCallFunc:create(func)

        arrayOfActions:addObject(delay)
        arrayOfActions:addObject(ccfunc)

        local sequence = CCSequence:create(arrayOfActions)
        actionNode:runAction(sequence)
    end

    local nowTotalDelay = 0

    nowTotalDelay = nowTotalDelay + HeroInstanceWinLayer.delayTimes[1] or 0
    delayShowObj(nowTotalDelay, winBack)
    delayShowObj(nowTotalDelay, winTitle)

    nowTotalDelay = nowTotalDelay + HeroInstanceWinLayer.delayTimes[2] or 0
    delayShowObj(nowTotalDelay, winText)

    nowTotalDelay = nowTotalDelay + HeroInstanceWinLayer.delayTimes[3] or 0
    delayShowObj(nowTotalDelay, rewardText)

    if HeroInstanceWinLayer.rewardItems[1].factor ~= 0 then
        nowTotalDelay = nowTotalDelay + HeroInstanceWinLayer.delayTimes[4] or 0
        delayShowObj(nowTotalDelay, itemIcon1)
        --delayShowObj(nowTotalDelay, itemNum1)
        --delayShowObj(nowTotalDelay, multMark)
        --delayShowObj(nowTotalDelay, multText)

        --nowTotalDelay = nowTotalDelay + HeroInstanceWinLayer.delayTimes[5] or 0
        delayFunc(nowTotalDelay, showRollFactor)
    end


    --local rollTime = #HeroInstanceWinLayer.factors * HeroInstanceWinLayer.rollSingleTime * HeroInstanceWinLayer.rollRoundNum
    --                 + (getFactorIndex(HeroInstanceWinLayer.rewardItems[1].factor) - 1) * HeroInstanceWinLayer.rollSingleTime
    
    --nowTotalDelay = nowTotalDelay + rollTime

    if HeroInstanceWinLayer.rewardItems[2] ~= nil then
        nowTotalDelay = nowTotalDelay + HeroInstanceWinLayer.delayTimes[6] or 0
        if HeroInstanceWinLayer.rewardItems[1].factor ~= 0 then
            delayShowObj(nowTotalDelay, itemIcon2)
            delayShowObj(nowTotalDelay, itemNum2)
        else
            delayShowObj(nowTotalDelay, itemIcon3)
            delayShowObj(nowTotalDelay, itemNum3)
        end        
    end    

    nowTotalDelay = nowTotalDelay + HeroInstanceWinLayer.delayTimes[7] or 0
    delayShowObj(nowTotalDelay, againBtn)
    delayShowObj(nowTotalDelay, againText)

    delayShowObj(nowTotalDelay, backBtn)
    delayShowObj(nowTotalDelay, backText)

    local nextInstanceId = GetNextHeroInstanceId()
    if nextInstanceId ~= 0 then 
        delayShowObj(nowTotalDelay, nextBtn)
        delayShowObj(nowTotalDelay, nextText)
        delayFunc(nowTotalDelay, showNextCost)
    end

end

local function sendHeroInstanceLeaveReq()
	CSBBBattleLeaveReq = {
		}
	local msgname="CSBBBattleLeaveReq"
	local ret = send_message(msgname, CSBBBattleLeaveReq, true)
	return ret;
end

-- ��������
local function onPressBackBtn(tag)
    CCLuaLog("--- onPressBackBtn ---")
	HeroInstanceWinLayer:destroyed()

    if not HeroInstanceWinLayer.debugFlag then
        XLogicManager:sharedManager():LeaveBattle()
    end    
    CCDirector:sharedDirector():getScheduler():setTimeScale(1.0)
end

-- ��սһ��
local function onPressAgainBtn(tag)
    CCLuaLog("--- onPressAgainBtn ---")
    sendHeroInstanceLeaveReq()

    local nowInstanceId = GetNowHeroInstanceId()
    SendHeroInstanceCreateReq(nowInstanceId)
    CCDirector:sharedDirector():getScheduler():setTimeScale(1.0)
end

-- ��һ��
local function onPressNextBtn(tag)
    CCLuaLog("--- onPressNextBtn ---")
    sendHeroInstanceLeaveReq()

    local nextInstanceId = GetNextHeroInstanceId()
    if nextInstanceId ~= 0 then
        SendHeroInstanceCreateReq(nextInstanceId)
        --SetNowHeroInstanceId(nextInstanceId)
    end    
    CCDirector:sharedDirector():getScheduler():setTimeScale(1.0)
end

function HeroInstanceWinLayer:InitLayer()
	CCLuaLog("--- HeroInstanceWinLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

    --ע��ص�����
	self.uiLayout:FindChildObjectByName("backBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressBackBtn)
    self.uiLayout:FindChildObjectByName("againBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressAgainBtn)
    self.uiLayout:FindChildObjectByName("nextBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressNextBtn)

    GameDataManager:Get():setHeroAutoAttack(false)

    HideOneLayerByTag(UITagTable["WorldBossHPLayer"].tag)
    HideOneLayerByTag(UITagTable["BattleUILayer"].tag)

    HSJoystick:sharedJoystick():setIsEnable(false)

    initRewardItems()
    showLayerInSequence()

    GameAudioManager:sharedManager():stopPlayBGM()
    GameAudioManager:sharedManager():playEffect(350007,false)
end

function HeroInstanceWinLayer:DebugInit()
    HeroInstanceWinLayer.debugFlag = true

    HeroInstanceWinLayer.factors = {0, 50, 100, 200, 500, 1000}
    HeroInstanceWinLayer.rewardItems[1] = {id = 416001, count = 20000, factor = 200}
    HeroInstanceWinLayer.rewardItems[2] = {id = 416002, count = 200, factor = 100}
end