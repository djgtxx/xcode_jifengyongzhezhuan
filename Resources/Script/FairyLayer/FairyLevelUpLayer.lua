-- ��������ҳ��
require("Script/Fairy/FairySelectLayer")

FairyLevelUpLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	

	fairyPos = 0,
	selectFairysPos = {},

	nowExpSprite = nil,
	nextExpSprite = nil,

	selectTab = 1,
	lastLayer = 0, -- ��һ�����棬��Ҫ�رպ�� 1�� ���ﱳ�� 2�����鱳��
}

local FRIRY_SER_COUNT = 6

local fairyElementCount = 0
local nextNeedElementCount = 0
local nextFiveNeedCount = 0
local scaleSpeed = 2

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if FairyLevelUpLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(FairyLevelUpLayer.notificationFunc);
	end

	FairyLevelUpLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("FairyLevelUpUI")
end

-- ����ѡ������Ϣ
local function refreshSelectFairyPanel()
	local fairys = FairyLevelUpLayer.selectFairysPos
	for i = 1, FRIRY_SER_COUNT do
		if fairys[i] ~= nil then
			local userFairyInfo = getUserFairyByPos(fairys[i])
			local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId)

			local fairySprite = fairyBasicInfo:getFairyIcon()
			FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairySerIcon"..i).__UIPicture__:setSprite(fairySprite)            
		else
			local addMarkIcon = AspriteManager:getInstance():getOneFrame("UI/ui_system_icon.bin","map_ui_system_icon_FRAME_ICON_ADDFAIRY")
			FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairySerIcon"..i).__UIPicture__:setSprite(addMarkIcon)           
		end
	end
end

-- ���;�����������
local function sendFairyLevelupReq(selectFairyTable, elementCount, view)

	CSFairyAddExpReq = {
		fairy_pos = FairyLevelUpLayer.fairyPos,
		del_fairy_poss = selectFairyTable,
		fairy_elem = elementCount,
		req_info = view,
		}
	local msgname="CSFairyAddExpReq"
	local ret = send_message(msgname, CSFairyAddExpReq, true)
	return ret
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= FairyLevelUpLayer.uiLayerInstance then
			if G_CurLayerInstance ~= FairyLevelUpLayer.uiLayerInstance then
				FairyLevelUpLayer:destroyed()
				ret = 1
			end
		end
	elseif message == GM_FAIRY_SELECT_DONE then
		if FairyLevelUpLayer.uiLayerInstance ~= nil then
			FairyLevelUpLayer.selectFairysPos = FairySelectLayer:getSelectedFairys()
			refreshSelectFairyPanel()
			if FairyLevelUpLayer.selectTab == 1 then
				sendFairyLevelupReq(FairyLevelUpLayer.selectFairysPos, 0, true)
                PushOneWaitingLayer("CSFairyAddExpReq")
			end	
		end		
	end

	return ret
end

function FairyLevelUpLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["FairyLevelUpLayer"].tag
			parentNode:addChild(self.uiLayerInstance,0,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/FairyLevelUpUI.plist",self.uiLayerInstance, "FairyLevelUpUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
local expGrowing = false
function FairyLevelUpLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil

	self.fairyPos = 0
	self.selectFairysPos = {}

	self.nowExpSprite = nil
	self.nextExpSprite = nil

	self.selectTab = 1
    expGrowing = false
end

-- ɾ��UI
function FairyLevelUpLayer:destroyed()
	CCLuaLog("--- FairyLevelUpLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
	SetChatBar(true,-1)
end

local function initExpBar()

	local function blinkSprite(sprite)
		local arrayOfActions = CCArray:create()
		local fade1 = CCFadeTo:create(1, 0)
		local fade2 = CCFadeTo:create(1, 255)

		arrayOfActions:addObject(fade1)
		arrayOfActions:addObject(fade2)

		local sequence = CCSequence:create(arrayOfActions)
		local repeatAct =  CCRepeatForever:create(tolua.cast(sequence, 'CCActionInterval'))

		sprite:stopAllActions()
		sprite:runAction(repeatAct)
	end

	local scale = TXGUI.UIManager:sharedManager():getScaleFactor()

	-- ����������ɫ������ê��
	local nextExpPic = FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyExpNext").__UIPicture__

	local nextExpSprite = AspriteManager:getInstance():getOneFrame("UI/ui.bin","map_ui_FRAME_FAIRY_LU_EXPERIENCE1")
	nextExpPic:setSprite(nextExpSprite, false)

	nextExpSprite:setAnchorPoint(ccp(0, 0.5))
	local oldPosX, oldPosY = nextExpSprite:getPosition()	
	nextExpSprite:setPosition(ccp(oldPosX - scale * nextExpSprite:getContentSize().width/2, oldPosY));

	-- ����������ɫ������ê��
	local nowExpPic = FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyExpNow").__UIPicture__

	local nowExpSprite = AspriteManager:getInstance():getOneFrame("UI/ui.bin","map_ui_FRAME_FAIRY_LU_EXPERIENCE2")
	nowExpPic:setSprite(nowExpSprite, false)

	nowExpSprite:setAnchorPoint(ccp(0, 0.5))
	oldPosX, oldPosY = nowExpSprite:getPosition()
	nowExpSprite:setPosition(ccp(oldPosX - scale * nowExpSprite:getContentSize().width/2, oldPosY));

	-- �������ڵ�������
	FairyLevelUpLayer.nowExpSprite = nowExpSprite
	FairyLevelUpLayer.nextExpSprite = nextExpSprite

	blinkSprite(nextExpSprite)
end

-- ���¾��������� -1��ʾ������
local function updateExpBar(nowRate, nextRate)
	local scale = TXGUI.UIManager:sharedManager():getScaleFactor()

	if nowRate >= 0 then
        if nowRate > 1 then
            nowRate = 1
        end
		FairyLevelUpLayer.nowExpSprite:setScaleX(scale * nowRate)
	end

	if nextRate >= 0 then
        if nextRate > 1 then
            nextRate = 1
        end
		FairyLevelUpLayer.nextExpSprite:setScaleX(scale * nextRate)
	end	
end

-- ��ʼ������Ļ�����Ϣ
local useFairyEatBtnPos = nil
local useMarrowEatBtnPos = nil

local function initFairyLevelUpBasicInfo()
	if FairyLevelUpLayer.fairyPos == 0 or FairyLevelUpLayer.uiLayout == nil then
		return
	end

	local userFairyInfo = getUserFairyByPos(FairyLevelUpLayer.fairyPos)
	local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId)

	-- ��ǰ�ȼ�
	local level = userFairyInfo.fairyLevel
	local levelStr = "Lv."..level

	FairyLevelUpLayer.uiLayout:FindChildObjectByName("masterLevelText").__UILabel__:setString(levelStr)
    FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyLevel").__UILabel__:setString(levelStr)

	-- ����ͷ��
	local fairySprite = fairyBasicInfo:getFairyIcon()
	FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyMasterIcon").__UIPicture__:setSprite(fairySprite)

    -- ��������
    local fairyName = fairyBasicInfo.name
	local fairyGrade = userFairyInfo.fairyGrade

	local nameStr = fairyName.." + "..fairyGrade

	FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyName").__UILabel__:setString(nameStr)
    FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyName").__UILabel__:setColor(ItemManager:Get():getFairyLabelColorByQuality(fairyBasicInfo.quality))

    -- ���鶯��
	local fairyId = userFairyInfo.fairyId

	local fairyFrame = FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyFrame").__UIPicture__
	local size = fairyFrame:getCurrentNode():getContentSize()		
	local px = size.width / 2
	local py = size.height / 2
	local modePt = CCPoint(px,py)								
	SpriteFactory:sharedFactory():ShowElfOnLayerAtPoint(fairyFrame:getCurrentNode(), fairyId, modePt)
	
    -- ��ʼ��������ǩ�����ɰ�ťλ��
    useFairyEatBtnPos = FairyLevelUpLayer.uiLayout:FindChildObjectByName("eatBtn"):getPosition()
    useMarrowEatBtnPos = FairyLevelUpLayer.uiLayout:FindChildObjectByName("midEatFrame"):getPosition()
end

local lastExpInfo = {} -- ������̬������Чʹ��
local nowExpInfo = {}
local nextExpInfo = {}

local function refreshExpInfo()
	local userFairyInfo = getUserFairyByPos(FairyLevelUpLayer.fairyPos)
	local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId) 
	if fairyBasicInfo ~= nil then
		-- ��һ������һ���ľ����
		local nowLevelExpDelta = getExpFairyLevelUpNeed(nowExpInfo.level + 1,fairyBasicInfo.quality) - getExpFairyLevelUpNeed(nowExpInfo.level,fairyBasicInfo.quality)
		local nextLevelExpDelta = getExpFairyLevelUpNeed(nextExpInfo.level + 1,fairyBasicInfo.quality) - getExpFairyLevelUpNeed(nextExpInfo.level,fairyBasicInfo.quality)

		local nowRate = nowExpInfo.exp / nowLevelExpDelta

		local nextRate = nowRate
		if nextExpInfo.level > nowExpInfo.level then
			nextRate = 1
		else
			nextRate = nextExpInfo.exp / nextLevelExpDelta
		end

		updateExpBar(nowRate, nextRate)
		lastExpInfo.exp = nowExpInfo.exp
		lastExpInfo.level = nowExpInfo.level
	end
end


local function onFairyEatSuccess()
	-- ���µ�ǰ�ȼ�
	local level = nextExpInfo.level
	local levelStr = "Lv."..level

	FairyLevelUpLayer.uiLayout:FindChildObjectByName("masterLevelText").__UILabel__:setString(levelStr)
    FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyLevel").__UILabel__:setString(levelStr)

    -- ����������Ч
    for i = 1, #FairyLevelUpLayer.selectFairysPos do
        local serIcon = FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairySerIcon"..i).__UIPicture__

        particle = ParticleManagerX:sharedManager():getParticles_uieffect("particle_effect_upgradesuccess")
        if nil ~= particle then
            particle:setPosition(ccp(serIcon:getCurrentNode():getContentSize().width * 0.5, serIcon:getCurrentNode():getContentSize().height * 0.5));
            serIcon:getCurrentNode():removeChildByTag(1001, true)
            serIcon:getCurrentNode():addChild(particle, 10, 1001)
        end
    end

	-- �������ӵľ���
	FairyLevelUpLayer.selectFairysPos = {}

    -- �ӳ�һ��ʱ����վ���
    local delayAction =	CCDelayTime:create(1.0)
	local callback = CCCallFunc:create(refreshSelectFairyPanel)
	local action = CCSequence:createWithTwoActions(delayAction,callback)

    local masterIcon = FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyMasterIcon").__UIPicture__
	masterIcon:getCurrentNode():runAction(action)

	--��������һ����ʾ
	updateExpBar(-1, 0)

    -- ����������������ˢ����Ϣ
    local function onExpUpdateFinish()
        if FairyLevelUpLayer.selectTab == 2 then
            if fairyElementCount < nextNeedElementCount then
		        sendFairyLevelupReq({}, fairyElementCount, true)
                PushOneWaitingLayer("CSFairyAddExpReq")
	        else
		        sendFairyLevelupReq({}, nextNeedElementCount, true)
                PushOneWaitingLayer("CSFairyAddExpReq")
	        end
        end
        expGrowing = false
    end

	
	local scale = TXGUI.UIManager:sharedManager():getScaleFactor()

	local function scaleOnce(sprite, nowScale, nextScale)
		CCLuaLog("--- scaleOnce ---")
        expGrowing = true
		local arrayOfActions = CCArray:create()

		local scale1 = CCScaleTo:create((nextScale * scale - nowScale * scale)/scaleSpeed , nextScale * scale, 1)
        local scaleEnd = CCCallFunc:create(onExpUpdateFinish)

		arrayOfActions:addObject(scale1)
        arrayOfActions:addObject(scaleEnd)

		local sequence = CCSequence:create(arrayOfActions)

		sprite:stopAllActions()
		sprite:runAction(sequence)
	end

	local function scaleTwice(sprite, nowScale, nextScale)
		CCLuaLog("--- scaleTwice ---")
        expGrowing = true
		local arrayOfActions = CCArray:create()

		--local scale1 = CCScaleTo:create(-0.5/scaleSpeed , scale, 1)
		local scale1 = CCScaleTo:create((1 - nowScale) * scale /scaleSpeed , scale, 1)
		local scale2 = CCScaleTo:create(0 , 0, 1)
		local scale3 = CCScaleTo:create(nextScale * scale / scaleSpeed , nextScale * scale, 1)
        local scaleEnd = CCCallFunc:create(onExpUpdateFinish)

		arrayOfActions:addObject(scale1)
		arrayOfActions:addObject(scale2)
		arrayOfActions:addObject(scale3)
        arrayOfActions:addObject(scaleEnd)

		local sequence = CCSequence:create(arrayOfActions)

		sprite:stopAllActions()
		sprite:runAction(sequence)

	end

	local userFairyInfo = getUserFairyByPos(FairyLevelUpLayer.fairyPos)
	local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId) 

	local lastLevelExpDelta = getExpFairyLevelUpNeed(lastExpInfo.level + 1,fairyBasicInfo.quality) - getExpFairyLevelUpNeed(lastExpInfo.level,fairyBasicInfo.quality)
	local lastRate = lastExpInfo.exp / lastLevelExpDelta

	local nextLevelExpDelta = getExpFairyLevelUpNeed(nextExpInfo.level + 1,fairyBasicInfo.quality) - getExpFairyLevelUpNeed(nextExpInfo.level,fairyBasicInfo.quality)
	local nextRate = nextExpInfo.exp / nextLevelExpDelta

	local expSprite = FairyLevelUpLayer.nowExpSprite
	if lastExpInfo.level == nextExpInfo.level then
		scaleOnce(expSprite, lastRate, nextRate)
	else
		scaleTwice(expSprite, lastRate, nextRate)

		-- ����ͷ����Ч
		local fairyIcon = FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyMasterIcon").__UIPicture__
		local frameSprite = AspriteManager:getInstance():getOneFrame("UI/ui.bin","map_ui_FRAME_FAIRY_LU_MASTER_FRAME")
		local frameSize = frameSprite:getContentSize()

		local particle = ParticleManager:Get():createEffectSpriteAndPlay(442,"", 100000, 1, false);
		particle:setPosition(ccp(frameSize.width/2, frameSize.height/2))
		fairyIcon:getCurrentNode():addChild(particle)
	end

	GameApi:showMessage(GetLuaLocalization("M_AD_TEXT3"))
	GameAudioManager:sharedManager():playEffect(320000,false)
end

-- �յ����������ذ�
local function onMsgFairyLevelRsp(msg)
	CCLuaLog("--- onMsgFairyLevelRsp ---")

	if msg ~= nil then
		
		-- ���Ľ����Ϣ
		if msg.cost_coin ~= nil then
			FairyLevelUpLayer.uiLayout:FindChildObjectByName("coinNum").__UILabel__:setString(""..msg.cost_coin)
		else
			FairyLevelUpLayer.uiLayout:FindChildObjectByName("coinNum").__UILabel__:setString("0")
		end

		if msg.succ then
			CCLuaLog("--- onMsgFairyLevelRsp : SUCCESS ---")
		end
		
		
		if msg.fairy_info ~= nil then
			CCLuaLog("--- msg.fairy_info ~= nil ---")
			--������Ϣ
			local nextAttrs = {}
			for _ , attr in pairs(msg.fairy_info.fairy_attrs) do
				--CCLuaLog("nextAttrs")
				nextAttrs[attr.key] = attr.value			
			end

			-- ��õ�ǰ�����б�
			local userFairyInfo = getUserFairyByPos(FairyLevelUpLayer.fairyPos)

			RefreshAttrPanel(FairyLevelUpLayer.uiLayout, userFairyInfo.fairyAttr , nextAttrs)

			-- ����ȼ�δ������������������Ϊ��
			local nowLevel = userFairyInfo.fairyLevel
			CCLuaLog("--- nowLevel : "..nowLevel)

			local nextLevel = msg.fairy_info.fairy_basic.fairy_lv

			nowExpInfo.level = nowLevel
			nextExpInfo.level = nextLevel
			CCLuaLog("--- nextLevel : "..nextLevel)
			if nowLevel == nextLevel then
				for i = 1, 6 do
					FairyLevelUpLayer.uiLayout:FindChildObjectByName("attrUpNum"..i).__UILabel__:setString("")
				end
			end

			-- ����������ȼ�
			local levelStr = "Lv."..nextLevel
			FairyLevelUpLayer.uiLayout:FindChildObjectByName("masterLevelUpText").__UILabel__:setString(levelStr)

			-- ���¾�����Ϣ
			local nowExp = userFairyInfo.fairyExp
			local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId) 
			local nowBasicExp = getExpFairyLevelUpNeed(nowLevel,fairyBasicInfo.quality)

			local nextExp = msg.fairy_info.fairy_basic.fairy_exp
			local nextBasicExp = getExpFairyLevelUpNeed(nextLevel,fairyBasicInfo.quality)

			CCLuaLog("--- nowExp : "..nowExp)
			CCLuaLog("--- nextExp : "..nextExp)
            CCLuaLog("--- nowBasicExp : "..nextBasicExp)

			nowExpInfo.exp = nowExp
			nextExpInfo.exp = nextExp

			-- ��þ�������
			FairyLevelUpLayer.uiLayout:FindChildObjectByName("masterExpNum").__UILabel__:setString(""..(nextExp + nextBasicExp - nowExp - nowBasicExp))

			-- �������辫Ԫ��Ϣ
			FairyLevelUpLayer.uiLayout:FindChildObjectByName("costMarrowNum").__UILabel__:setString(""..userFairyInfo.fairyNextLvExp)
			nextNeedElementCount = userFairyInfo.fairyNextLvExp
            nextFiveNeedCount = nextNeedElementCount + getExpFairyLevelUpNeed(nowLevel + 5,fairyBasicInfo.quality) - getExpFairyLevelUpNeed(nowLevel + 1,fairyBasicInfo.quality)
			
			if msg.succ then
				onFairyEatSuccess()
			else
				-- ���¾�����
				refreshExpInfo()
			end
		end
	end
	
end

--�ر�ҳ��
local function onPressCloseBtn(tag)
	RemoveOneLayer(FairyLevelUpLayer.uiLayerInstance)
	FairyLevelUpLayer:destroyed()

	if FairyLevelUpLayer.lastLayer == 1 then
		showUILayerByTag(UITagTable["BackPackLayer"].tag,true)
	elseif FairyLevelUpLayer.lastLayer == 2 then
		showUILayerByTag(UITagTable["FairyBagLayer"].tag,true)
	end
end

--���ʹ�þ���
local function onPressUseFairyBtn(tag)
	FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyContainer").__UIContainer__:setVisible(true)
	FairyLevelUpLayer.uiLayout:FindChildObjectByName("marrowContainer").__UIContainer__:setVisible(false)

	FairyLevelUpLayer.uiLayout:FindChildObjectByName("useFairyBtn").__UIButton__:getMenuItemSprite():selected()
	FairyLevelUpLayer.uiLayout:FindChildObjectByName("useMarrowBtn").__UIButton__:getMenuItemSprite():unselected()

	FairyLevelUpLayer.selectTab = 1

    -- �������ɰ�ťλ��
    if  useFairyEatBtnPos ~= nil then
        FairyLevelUpLayer.uiLayout:FindChildObjectByName("eatText"):setPosition(useFairyEatBtnPos)
        FairyLevelUpLayer.uiLayout:FindChildObjectByName("eatBtn"):setPosition(useFairyEatBtnPos)
    end    

	sendFairyLevelupReq(FairyLevelUpLayer.selectFairysPos, 0, true)
    PushOneWaitingLayer("CSFairyAddExpReq")
end

--���ʹ�þ�Ԫ
local function onPressUseMarrowBtn(tag)
	FairyLevelUpLayer.uiLayout:FindChildObjectByName("fairyContainer").__UIContainer__:setVisible(false)
	FairyLevelUpLayer.uiLayout:FindChildObjectByName("marrowContainer").__UIContainer__:setVisible(true)

	FairyLevelUpLayer.uiLayout:FindChildObjectByName("useFairyBtn").__UIButton__:getMenuItemSprite():unselected()
	FairyLevelUpLayer.uiLayout:FindChildObjectByName("useMarrowBtn").__UIButton__:getMenuItemSprite():selected()

	FairyLevelUpLayer.selectTab = 2

    -- �������ɰ�ťλ��
    if  useMarrowEatBtnPos ~= nil then
        FairyLevelUpLayer.uiLayout:FindChildObjectByName("eatText"):setPosition(useMarrowEatBtnPos)
        FairyLevelUpLayer.uiLayout:FindChildObjectByName("eatBtn"):setPosition(useMarrowEatBtnPos)
    end

	if fairyElementCount < nextNeedElementCount then
		sendFairyLevelupReq({}, fairyElementCount, true)
        PushOneWaitingLayer("CSFairyAddExpReq")
	else
		sendFairyLevelupReq({}, nextNeedElementCount, true)
        PushOneWaitingLayer("CSFairyAddExpReq")
	end

end

--����������
local function onPressQuickAddBtn(tag)
	CCLuaLog("--- onPressQuickAddBtn ---")
	local fairyList = getUserFairyList()

	--local userFairyInfo = getUserFairyByPos(FairyLevelUpLayer.fairyPos)
	--local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId)

	if fairyList ~= nil then
		local sortTable = {}
		for k,v in pairs(fairyList) do
			local fairyBasicInfo = getFairyBasicInfo(v.fairyId)
			local quality = fairyBasicInfo.quality

			-- ֻ������Ϊ1��2�Ĳ�������
			if quality == 1 or quality == 2 then
	            -- �ǳ�ս��սС����������                
				if v.pos ~= FairyLevelUpLayer.fairyPos and isNormalFairy(v.pos) then
					table.insert(sortTable,v)
				end				
			end			
		end

        local function expSort(a, b)
            local quality1 = getFairyQualityById(a.fairyId)
		    local quality2 = getFairyQualityById(b.fairyId)

            local exp1 = getExpFairyApply(a.fairyLevel, quality1, a.fairyId)
            local exp2 = getExpFairyApply(b.fairyLevel, quality2, b.fairyId)

            return exp1 < exp2
        end

		table.sort(sortTable, expSort)

		FairyLevelUpLayer.selectFairysPos = {}
		CCLuaLog("--- #sortTable ---"..#sortTable)
		for i = #sortTable - FRIRY_SER_COUNT + 1, #sortTable do
			if sortTable[i] ~= nil then	
				CCLuaLog("--- sortTable[i].pos ---"..sortTable[i].pos)			
				table.insert(FairyLevelUpLayer.selectFairysPos, sortTable[i].pos)
			end
		end

        if #FairyLevelUpLayer.selectFairysPos == 0 then
            GameApi:showMessage(GetLuaLocalization("M_FAIRY_LU_MORE"))
        else
            refreshSelectFairyPanel()
		    if FairyLevelUpLayer.selectTab == 1 then
			    sendFairyLevelupReq(FairyLevelUpLayer.selectFairysPos, 0, true)
                PushOneWaitingLayer("CSFairyAddExpReq")
		    end	
        end
	end

	
end

-- ����ǿ��������Ϣ
local function sendLevelUpTimesReq(count)
    CSFairyAddExpReq = {
		fairy_pos = FairyLevelUpLayer.fairyPos,
		req_info = false,
        times = count,
		}
	local msgname="CSFairyAddExpReq"
	local ret = send_message(msgname, CSFairyAddExpReq, true)
	return ret
end

-- ���ǿ����ǿ��5��
local function onPressTimes(count)
    local needCount = nextNeedElementCount
    if count == 5 then 
        needCount = nextFiveNeedCount
    end
    if fairyElementCount < needCount then
        -- ��Ԫ������ʾ
        local function onPressGetFairy()
            RemoveOneLayer(FairyLevelUpLayer.uiLayerInstance)
	        FairyLevelUpLayer:destroyed()
            MainMenuLayer:getMainMenuLayer():ShowMarketLayer(true, 1)
        end

        local function onPressDecFairy()
            RemoveOneLayer(FairyLevelUpLayer.uiLayerInstance)
	        FairyLevelUpLayer:destroyed()
            G_OpenFairyDecomposeLayer()
        end

        MessageBox:Show(GetLuaLocalization("M_FAIRY_LU_ERROR_2"),onPressGetFairy,onPressDecFairy,MB_OKCANCELCLOSE,ccc3(255,255,255),26)
        MessageBox:AdjustStyle(GetLuaLocalization("M_GET_FAIRY"), GetLuaLocalization("M_DECOMPOSE_FAIRY"))
	else
		sendLevelUpTimesReq(count)
        PushOneWaitingLayer("CSFairyAddExpReq")
	end
end

--������ɰ�ť
local function onPressEatBtn(tag)
	CCLuaLog("--- onPressEatBtn ---")
    if expGrowing then
        return
    end

	if FairyLevelUpLayer.selectTab == 1 then
		if #FairyLevelUpLayer.selectFairysPos ~= 0 then
			sendFairyLevelupReq(FairyLevelUpLayer.selectFairysPos, 0, false)
            PushOneWaitingLayer("CSFairyAddExpReq")
        else
            GameApi:showMessage(GetLuaLocalization("M_FAIRYLU_NONE"))
		end 		
	else
        onPressTimes(1)
    end
end

-- ���ǿ��5��
local function onPressFiveEatBtn(tag)
    if expGrowing then
        return
    end

    onPressTimes(5) 
end

-- ���ĳ�����鰴ť����Ӿ���
local function onPressFairyBtn(tag)
	CCLuaLog("--- onPressFairyBtn ---")
	FairySelectLayer:createLayer()
	FairySelectLayer:setSelectModle(true, false, FRIRY_SER_COUNT, FairyLevelUpLayer.fairyPos,3,true)
    FairySelectLayer:setDefaultSelectPos(FairyLevelUpLayer.selectFairysPos)
end

function FairyLevelUpLayer:InitLayer()
	CCLuaLog("--- FairyLevelUpLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--ע�ᰴť�ص�����
	self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCloseBtn)
	self.uiLayout:FindChildObjectByName("useFairyBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressUseFairyBtn)
	self.uiLayout:FindChildObjectByName("useMarrowBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressUseMarrowBtn)
	self.uiLayout:FindChildObjectByName("quickAddBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressQuickAddBtn)
	self.uiLayout:FindChildObjectByName("eatBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressEatBtn)
    self.uiLayout:FindChildObjectByName("eatFiveBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressFiveEatBtn)

	-- ���鰴ť�Ļص�
	for i = 1, FRIRY_SER_COUNT do
		self.uiLayout:FindChildObjectByName("fairyBtn"..i).__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressFairyBtn)
	end

	--�ܾ�Ԫ����
	self.uiLayout:FindChildObjectByName("nowMarrowNum").__UILabel__:setString(""..fairyElementCount)




	--��ʼ��������
	initExpBar()
	initFairyLevelUpBasicInfo()

	refreshSelectFairyPanel()

    --��ʼ����ʾʹ�þ������
	onPressUseFairyBtn(nil)
	

	--��Ϣ�ص�ע��
	addMsgCallBack("CSFairyAddExpRsp", onMsgFairyLevelRsp)



	PushOneLayer(self.uiLayerInstance,"","")
	SetChatBar(false, -1)
end

function FairyLevelUpLayer:DebugExpSpeed(speed)
	scaleSpeed = speed / 50000
	GameApi:showMessage("Set Exp Speed "..speed)
end

----------------------------- ����ȫ�ֺ��� ----------------------------
function RefreshFairyElementCount(count)
	fairyElementCount = count

	if FairyLevelUpLayer.uiLayout ~= nil then
		FairyLevelUpLayer.uiLayout:FindChildObjectByName("nowMarrowNum").__UILabel__:setString(""..count)
	end
end