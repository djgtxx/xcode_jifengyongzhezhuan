-- ������ѵҳ��
require("Script/GameConfig/Fairy_Parameter")
require("Script/UILayer/PayHintLayer")

FairyTrainLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	

	fairyPos = 0,

	trainIndex = 1,
	lastLayer = 0, -- ��һ�����棬��Ҫ�رպ�� 1�� ���ﱳ�� 2�����鱳��
}

local drugCount = 0
function RefreshTrainDrugCount(count)
	CCLuaLog(" ---- RefreshTrainDrugCount : "..count)
	drugCount = count
	if FairyTrainLayer.uiLayout ~= nil then
		FairyTrainLayer.uiLayout:FindChildObjectByName("totalDrugNum").__UILabel__:setString("" .. drugCount)
	end
end

local diamondCosts = {}

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if FairyTrainLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(FairyTrainLayer.notificationFunc);
	end

	FairyTrainLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("FairyTrainUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= FairyTrainLayer.uiLayerInstance then
			if G_CurLayerInstance ~= FairyTrainLayer.uiLayerInstance then
				FairyTrainLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function FairyTrainLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["FairyTrainLayer"].tag
			parentNode:addChild(self.uiLayerInstance,0,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/FairyTrainUI.plist",self.uiLayerInstance, "FairyTrainUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function FairyTrainLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
	self.fairyPos = 0
	self.trainIndex = 1
end

-- ɾ��UI
function FairyTrainLayer:destroyed()
	CCLuaLog("--- FairyTrainLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
	SetChatBar(true,-1)
end

--ˢ���Ҳ����״̬
-- state : 1 δ��ѵ 2 ����ѵ
local rightPanelState = 1

local function updateRightPanel()

	-- ��ʾ����״̬
	for i = 1, 6 do
		FairyTrainLayer.uiLayout:FindChildObjectByName("attrUpNum"..i).__UILabel__:setVisible(rightPanelState == 2)
	end

	FairyTrainLayer.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:setVisible(rightPanelState == 1)

	FairyTrainLayer.uiLayout:FindChildObjectByName("trainBtn").__UIButton__:setVisible(rightPanelState == 1)
	FairyTrainLayer.uiLayout:FindChildObjectByName("trainText").__UILabel__:setVisible(rightPanelState == 1)

	FairyTrainLayer.uiLayout:FindChildObjectByName("saveBtn").__UIButton__:setVisible(rightPanelState == 2)
	FairyTrainLayer.uiLayout:FindChildObjectByName("saveText").__UILabel__:setVisible(rightPanelState == 2)

	FairyTrainLayer.uiLayout:FindChildObjectByName("cancelBtn").__UIButton__:setVisible(rightPanelState == 2)
	FairyTrainLayer.uiLayout:FindChildObjectByName("cancelText").__UILabel__:setVisible(rightPanelState == 2)
end

local nowTrainAttr = {}
local nextTrainAttr = {}

local function updateTrainData()
	for i = 1, 6 do
		nowTrainAttr[i] = nowTrainAttr[i] or 0

		if nowTrainAttr[i] ~= nil then
			local nowAttrStr = ""
			if nowTrainAttr[i] >= 0 then
				nowAttrStr = "(+"..nowTrainAttr[i]..")"
			else
				nowAttrStr = "("..nowTrainAttr[i]..")"
			end

			FairyTrainLayer.uiLayout:FindChildObjectByName("attrNum"..i).__UILabel__:setString(nowAttrStr)
		end

		if nextTrainAttr[i] ~= nil then
			local nextAttrStr = ""
			if nextTrainAttr[i] >= 0 then
				nextAttrStr = "(+"..nextTrainAttr[i]..")"
			else
				nextAttrStr = "("..nextTrainAttr[i]..")"
			end

			FairyTrainLayer.uiLayout:FindChildObjectByName("attrUpNum"..i).__UILabel__:setString(nextAttrStr)
		end

		if nowTrainAttr[i] ~= nil and nextTrainAttr[i] ~= nil then
			if nowTrainAttr[i] < nextTrainAttr[i] then
				FairyTrainLayer.uiLayout:FindChildObjectByName("attrUpNum"..i).__UILabel__:setColor(ccc3(0,255,0))
			elseif nowTrainAttr[i] > nextTrainAttr[i] then
				FairyTrainLayer.uiLayout:FindChildObjectByName("attrUpNum"..i).__UILabel__:setColor(ccc3(255,0,0))
			else
				FairyTrainLayer.uiLayout:FindChildObjectByName("attrUpNum"..i).__UILabel__:setColor(ccc3(255,255,255))
			end
		end
	end
end

local function updateFightNumChange(num)

	local textColor = ccc3(56,221,7)
	if num < 0 then
		textColor = ccc3(250,30,25)
		FairyTrainLayer.uiLayout:FindChildObjectByName("fightChangeNum").__UILabel__:setString("-"..(-num))
	else
		FairyTrainLayer.uiLayout:FindChildObjectByName("fightChangeNum").__UILabel__:setString("+"..num)
	end
	FairyTrainLayer.uiLayout:FindChildObjectByName("fightChangeNum").__UILabel__:setColor(textColor)

end

-- �Ѵ洢������table ӳ�䵽�������ʾΪ˳���table ��
local function convertTable(attrTable)
	local uiTable = {}

	local userType = UserData:GetUserType()

	if userType == 3 or userType == 4 then
		uiTable[1] = attrTable[2]
	else
		uiTable[1] = attrTable[1]
	end
	uiTable[2] = attrTable[4]
	uiTable[3] = attrTable[5]
	uiTable[4] = attrTable[3]
	uiTable[5] = attrTable[6]
	uiTable[6] = attrTable[7]

	return uiTable
end

--�ر�ҳ��
local function onPressCloseBtn(tag)
	RemoveOneLayer(FairyTrainLayer.uiLayerInstance)
	FairyTrainLayer:destroyed()

	if FairyTrainLayer.lastLayer == 1 then
		showUILayerByTag(UITagTable["BackPackLayer"].tag,true)
	elseif FairyTrainLayer.lastLayer == 2 then
		showUILayerByTag(UITagTable["FairyBagLayer"].tag,true)
	end
end

--������ѵ����
local function sendTrainReq(trainIndex)
	CSFairyTrainReq = {
		fairy_pos = FairyTrainLayer.fairyPos,
		train_lv = trainIndex,
		}
	local msgname="CSFairyTrainReq"
	local ret = send_message(msgname, CSFairyTrainReq, true)
	return ret
end

-- ȷ����ѵ����
local function sendTrainConfirmReq(confirm)
	CSFairyTrainDetermineReq = {
		fairy_pos = FairyTrainLayer.fairyPos,
		save = confirm,
		}
	local msgname="CSFairyTrainDetermineReq"
	local ret = send_message(msgname, CSFairyTrainDetermineReq, true)
	return ret
end

-- �յ���ѵ�ذ�
local function onMsgFairyTrainRsp(msg)
	if msg ~= nil then
		CCLuaLog("--- onMsgFairyTrainRsp ---")
		if msg.fairy_pos ~= FairyTrainLayer.fairyPos then
			return
		end

		local trainAttrs = {}
		for _ , attr in pairs(msg.fairy_train_attrs) do
			trainAttrs[attr.key] = attr.value			
		end

		nextTrainAttr = convertTable(trainAttrs)
		updateTrainData()

		if msg.eff_diff ~= nil then
			updateFightNumChange(msg.eff_diff)
		end	

		rightPanelState = 2
		updateRightPanel()
	end
end

-- �յ�ȷ����ѵ�ذ�
local function onMsgFairyTrainConfirmRsp(msg)
	if msg ~= nil then
		CCLuaLog("--- onMsgFairyTrainConfirmRsp ---")
		if msg.fairy_pos ~= FairyTrainLayer.fairyPos then
			return
		end

		if msg.succ then
			nowTrainAttr = nextTrainAttr
			updateTrainData()
		end

		rightPanelState = 1
		updateRightPanel()
	end
end



--������水ť
local function onPressSaveBtn(tag)
	CCLuaLog("--- onPressSaveBtn ---")
	sendTrainConfirmReq(true)
end

--���ȡ����ť
local function onPressCancelBtn(tag)
	CCLuaLog("--- onPressCancelBtn ---")
	sendTrainConfirmReq(false)
end

--���ĳ��ѡ��
local function onPressSelectBtn(tag)
	CCLuaLog("--- onPressSelectBtn ---"..tag)

	local function changeBtnState(index)
		for	i = 1, 4 do
			FairyTrainLayer.uiLayout:FindChildObjectByName("selectIcon"..i).__UIPicture__:setVisible(index == i)
		end
	end

	changeBtnState(tag)
    if tag == 2 then
        FairyTrainLayer.trainIndex = 3
    elseif tag == 3 then
        FairyTrainLayer.trainIndex = 2
    else
        FairyTrainLayer.trainIndex = tag
    end
end

local function getAdvanceConfigTable(quality, grade)
    for k, v in pairs(Fairy_Parameter) do
        if tonumber(v.Quality) == tonumber(quality) and tonumber(v.Phase) == tonumber(grade) then
            return v
        end
    end
    return Fairy_Parameter[1]
end

-- ��ʼ����ѵ�������
local function initFairyTrainAttr()
	local trainMaxTable = {}

	local userFairyInfo = getUserFairyByPos(FairyTrainLayer.fairyPos)
    local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId)
    local quality = fairyBasicInfo.quality
	local grade = userFairyInfo.fairyGrade

	local configTable = getAdvanceConfigTable(quality, grade)

	-- �����﹥��ħ����ʾ
	local userType = UserData:GetUserType()

	--ħ��ʦ��ʾħ����ǩ
	if userType == 3 or userType == 4 then
		FairyTrainLayer.uiLayout:FindChildObjectByName("attrName1").__UILabel__:setString(GetLuaLocalization("M_FAIRY_LU_ATTRIBUTE7"))
	else
		FairyTrainLayer.uiLayout:FindChildObjectByName("attrName1").__UILabel__:setString(GetLuaLocalization("M_FAIRY_LU_ATTRIBUTE1"))
	end

	-- ��ʼ����������
	local basicAttrs = convertTable(userFairyInfo.fairyAttr)
	for i = 1, 6 do
		CCLuaLog("--- i ---"..i)
		CCLuaLog("--- basicAttrs[i] ---"..basicAttrs[i])
		FairyTrainLayer.uiLayout:FindChildObjectByName("attrBasicNum"..i).__UILabel__:setString(""..basicAttrs[i])
	end


	-- ��ʼ����ѵǰ����
	local trainAttrs = userFairyInfo.fairyTrainAttr

	nowTrainAttr = convertTable(trainAttrs)
	updateTrainData()

	--��ȡ��ѵ���ֵ����
	if userType == 3 or userType == 4 then
		trainMaxTable[1] = configTable.Potential_MagAttack
	else
		trainMaxTable[1] = configTable.Potential_PhyAttack
	end

	trainMaxTable[2] = configTable.Potential_PhyDefense
	trainMaxTable[3] = configTable.Potential_MagDefense
	trainMaxTable[4] = configTable.Potential_SkiAttack
	trainMaxTable[5] = configTable.Potential_SkiDefense
	trainMaxTable[6] = configTable.Potential_HP

	for i = 1, 6 do
		FairyTrainLayer.uiLayout:FindChildObjectByName("attrMaxNum"..i).__UILabel__:setString("(+"..trainMaxTable[i]..")")
	end



end

--���¾��������Ϣ
local function initFairyTrainBasicInfo()
	if FairyTrainLayer.fairyPos == 0 or FairyTrainLayer.uiLayout == nil then
		return
	end

	-- ����
	local userFairyInfo = getUserFairyByPos(FairyTrainLayer.fairyPos)
	local fairyBasicInfo = getFairyBasicInfo(userFairyInfo.fairyId)

	local fairyName = fairyBasicInfo.name
	local fairyGrade = userFairyInfo.fairyGrade

	-- ����
	local nameStr = fairyName.." + "..fairyGrade

	FairyTrainLayer.uiLayout:FindChildObjectByName("fairyName").__UILabel__:setString(nameStr)
    FairyTrainLayer.uiLayout:FindChildObjectByName("fairyName").__UILabel__:setColor(ItemManager:Get():getFairyLabelColorByQuality(fairyBasicInfo.quality))

	--�ȼ�	
	local level = userFairyInfo.fairyLevel
	local levelStr = "Lv."..level

	FairyTrainLayer.uiLayout:FindChildObjectByName("fairyLevel").__UILabel__:setString(levelStr)

	--���鶯��
	local fairyId = userFairyInfo.fairyId

	local fairyFrame = FairyTrainLayer.uiLayout:FindChildObjectByName("fairyFrame").__UIPicture__
	local size = fairyFrame:getCurrentNode():getContentSize()		
	local px = size.width / 2
	local py = size.height / 2
	local modePt = CCPoint(px,py)								
	SpriteFactory:sharedFactory():ShowElfOnLayerAtPoint(fairyFrame:getCurrentNode(), fairyId, modePt)

	initFairyTrainAttr()

end

-- ��ʼ����ѵ����
local costItemOneNum = {}
local costItemTwoNum = {}
local function initCostData()
	--��������
	local function matchSingleCost(exchangeStr)
		return string.match(exchangeStr, "/(%d+)")
	end

	--��������
	local function matchDoubleCost(exchangeStr)
		return string.match(exchangeStr, "%d+/(%d+);%d+/(%d+)")
	end	

	

	for	i = 1, 2 do
		local exchangeStr = ExchangeParameter[21298 + i]["FromItems"]
		CCLuaLog(exchangeStr)
		if i == 1 then
			costItemOneNum[i] = matchSingleCost(exchangeStr)
			costItemTwoNum[i] = 0
		else
			costItemOneNum[i],  costItemTwoNum[i]= matchDoubleCost(exchangeStr)
		end
	end

 
    diamondCosts[1] = 0
    diamondCosts[2] = costItemTwoNum[2]
    diamondCosts[3] = 0
    diamondCosts[4] = costItemTwoNum[2] * 10


	FairyTrainLayer.uiLayout:FindChildObjectByName("trainCostDrug1").__UILabel__:setString(""..costItemOneNum[1])
	FairyTrainLayer.uiLayout:FindChildObjectByName("trainCostDrug2").__UILabel__:setString(""..costItemOneNum[1] * 10)

	FairyTrainLayer.uiLayout:FindChildObjectByName("trainCostDrug3").__UILabel__:setString(""..costItemOneNum[2])
	FairyTrainLayer.uiLayout:FindChildObjectByName("trainCostDiamond3").__UILabel__:setString(""..costItemTwoNum[2])

	FairyTrainLayer.uiLayout:FindChildObjectByName("trainCostDrug4").__UILabel__:setString(""..costItemOneNum[2] * 10)
	FairyTrainLayer.uiLayout:FindChildObjectByName("trainCostDiamond4").__UILabel__:setString(""..costItemTwoNum[2] * 10)

	FairyTrainLayer.uiLayout:FindChildObjectByName("totalDrugNum").__UILabel__:setString("" .. drugCount)
	
end	

--�����ѵ��ť
local function onPressTrainBtn(tag)
	CCLuaLog("--- onPressTrainBtn ---")
    SetRequireDiamondCount(diamondCosts[FairyTrainLayer.trainIndex])
    CheckPayHint()

    local nowDrug = drugCount
    local index = FairyTrainLayer.trainIndex
    local drugCost = {
        costItemOneNum[1],        
        costItemOneNum[2],
        costItemOneNum[1] * 10,
        costItemOneNum[2] * 10
    }

    if nowDrug < tonumber(drugCost[index]) then
        GameApi:showMessage(GetLuaLocalization("M_POTENTIAL_GET"))
    else
        sendTrainReq(FairyTrainLayer.trainIndex)
    end	
end

function FairyTrainLayer:InitLayer()
	CCLuaLog("--- FairyTrainLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--ע��ص�����
	self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCloseBtn)
	self.uiLayout:FindChildObjectByName("trainBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressTrainBtn)
	self.uiLayout:FindChildObjectByName("saveBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressSaveBtn)
	self.uiLayout:FindChildObjectByName("cancelBtn").__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressCancelBtn)

	-- 4��ѡ��ť
	for i = 1, 4 do
		self.uiLayout:FindChildObjectByName("selectBtn"..i).__UIButton__:getMenuItemSprite():setTag(i)
		self.uiLayout:FindChildObjectByName("selectBtn"..i).__UIButton__:getMenuItemSprite():registerScriptTapHandler(onPressSelectBtn)
	end

	initFairyTrainBasicInfo()
	initCostData()

	onPressSelectBtn(1)

	updateRightPanel()

	--��Ϣע��ص�
	addMsgCallBack("CSFairyTrainRsp", onMsgFairyTrainRsp)
	addMsgCallBack("CSFairyTrainDetermineRsp", onMsgFairyTrainConfirmRsp)

	PushOneLayer(self.uiLayerInstance,"","")
	SetChatBar(false,-1)
end