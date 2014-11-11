require("Script/GameConfig/uiTagDefine")
require("Script/Chat/ChatPlayerOption")

BestFighterRankListLayer = {
	uiLayerInstance = nil,
	uiLayout = nil,

	notificationFunc = nil,	

	heroRankInfo = {},
	allRankInfo = {},

	rankItems = {},
}

--[[
allRankInfo.curType 1:�������� 2����������
allRankInfo.curPage
allRankInfo.totalTodayCount
allRankInfo.totalWeekCount

allRankInfo.todayRank = {}
allRankInfo.weekRank = {}

allRankInfo.todayRank[1] = {
	userId,
	regTime,
	channelId,
	rank,
	name,
	point,	
}
--]]

-- layer����ʱ��֪ͨ��Ϣ(layer�Ѿ�������)����ʱ�������ݣ�ɾ��UILayout.
local function onReceiveDestructorHandler()
	if BestFighterRankListLayer.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(BestFighterRankListLayer.notificationFunc);
	end

	BestFighterRankListLayer:destroyed()
	TXGUI.UIManager:sharedManager():removeUILayout("BestFighterRankListUI")
end

-- ��Ϸ�ڹ㲥֪ͨ���պ���
local function updateNotification(message)
	local ret = 0;
	if message == GM_LUA_LAYER_CLOSE then
		if nil ~= BestFighterRankListLayer.uiLayerInstance then
			if G_CurLayerInstance ~= BestFighterRankListLayer.uiLayerInstance then
				BestFighterRankListLayer:destroyed()
				ret = 1
			end
		end
	end

	return ret
end

function BestFighterRankListLayer:CreateLayer()
	if self.uiLayerInstance == nil then 
		self.uiLayerInstance = CCLayer:create()
		local parentNode = MainMenuLayer:getMainMenuLayer()
		if parentNode ~= nil then
			local tag = UITagTable["BestFighterRankListLayer"].tag
			parentNode:addChild(self.uiLayerInstance,0,tag)
			self.uiLayerInstance:registerDestructorScriptHandler(onReceiveDestructorHandler)
			self.uiLayout = TXGUI.UIManager:sharedManager():createUILayoutFromFile("UIplist/BestFighterRankListUI.plist",self.uiLayerInstance, "BestFighterRankListUI", true)
			self:InitLayer()
		end
	end

	return self.uiLayerInstance
end

-- ���ò���
function BestFighterRankListLayer:resetValue()
	self.uiLayerInstance = nil
	self.uiLayout = nil
	self.notificationFunc = nil
	self.heroRankInfo = {}
	self.allRankInfo = {}
	self.rankItems = {}
end

-- ɾ��UI
function BestFighterRankListLayer:destroyed()
	CCLuaLog("--- BestFighterRankListLayer:destroyed() ---")
	if self.uiLayerInstance ~= nil then
		self.uiLayerInstance:removeFromParentAndCleanup(true)
	end

	if self.notificationFunc ~= nil then
		NotificationCenter:defaultCenter():unregisterScriptObserver(self.notificationFunc);
	end

	self:resetValue()
	SetChatBar(true,-1)
end

local function onPressCloseBtn(tag)
	RemoveOneLayer(BestFighterRankListLayer.uiLayerInstance)
	BestFighterRankListLayer:destroyed()
end

local function setRankButtonState(state)
	local todayNormalBtn = BestFighterRankListLayer.uiLayout:FindChildObjectByName("todayNormalBtn").__UIButton__
	local todayClickedBtn = BestFighterRankListLayer.uiLayout:FindChildObjectByName("todayClickedBtn").__UIButton__
	local weekNormalBtn = BestFighterRankListLayer.uiLayout:FindChildObjectByName("weekNormalBtn").__UIButton__
	local weekClickedBtn = BestFighterRankListLayer.uiLayout:FindChildObjectByName("weekClickedBtn").__UIButton__

	if state == 1 then
		--��������
		todayNormalBtn:setVisible(false)
		todayClickedBtn:setVisible(true)
		weekNormalBtn:setVisible(true)
		weekClickedBtn:setVisible(false)

		BestFighterRankListLayer.allRankInfo.curType = 1
		BestFighterRankListLayer.allRankInfo.curPage = 1

	elseif state == 2 then
		--��������
		todayNormalBtn:setVisible(true)
		todayClickedBtn:setVisible(false)
		weekNormalBtn:setVisible(false)
		weekClickedBtn:setVisible(true)

		BestFighterRankListLayer.allRankInfo.curType = 2
		BestFighterRankListLayer.allRankInfo.curPage = 1

	end

	BestFighterRankListLayer:RefreshRankInfo()

end

local function onPressTodayRankBtn(tag)
	setRankButtonState(1)
end

local function onPressWeekRankBtn(tag)
	setRankButtonState(2)
end

local function getTotalPage(curType)
	local totalPageCount = 1
	if curType == 1 then
		totalPageCount = math.ceil(BestFighterRankListLayer.allRankInfo.totalTodayCount / 5)
	elseif curType == 2 then
		totalPageCount = math.ceil(BestFighterRankListLayer.allRankInfo.totalWeekCount / 5)
	end
	return totalPageCount
end

---��ѯ����������Ϣ
local function sendQueryRankReq(rankType, rankStart, rankEnd)
	CCLuaLog("------------------------------ sendQueryRankReq--")
	CSQueryRankReq = {
		rank_name = 1,
		rank_type = rankType,
		rank_start = rankStart,
		rank_end = rankEnd,
		}
	local msgname="CSQueryRankReq"
	local ret = send_message(msgname, CSQueryRankReq, true)
	return ret
end

local function onPressPreBtn(tag)
	local curPage = BestFighterRankListLayer.allRankInfo.curPage

	if curPage <= 1 then
		curPage = 1
		return
	end

	BestFighterRankListLayer.allRankInfo.curPage = curPage - 1
	BestFighterRankListLayer:RefreshRankInfo()
end

local function onPressNextBtn(tag)
	local curPageCount = getTotalPage(BestFighterRankListLayer.allRankInfo.curType)
	local curPage = BestFighterRankListLayer.allRankInfo.curPage

	if curPage >= curPageCount then
		BestFighterRankListLayer.allRankInfo.curPage = curPageCount
		return
	end	

	BestFighterRankListLayer.allRankInfo.curPage = curPage + 1

	--�����������ͻ�ȡ��ǰ���б�
	local rankType = BestFighterRankListLayer.allRankInfo.curType
	if rankType == 1 then
		rankList = BestFighterRankListLayer.allRankInfo.todayRank
	elseif rankType == 2 then
		rankList = BestFighterRankListLayer.allRankInfo.weekRank
	end

	local nowStartId = (BestFighterRankListLayer.allRankInfo.curPage - 1) * 5 + 1	

	--ͨ���ж��׸���Ŀ�Ƿ�Ϊ�����жϴ�ҳ�Ƿ��Ѿ���ȡ
	if rankList[nowStartId] == nil then
		sendQueryRankReq(rankType + 1, nowStartId, nowStartId + 9)
	else
		BestFighterRankListLayer:RefreshRankInfo()
	end	
end

local function onPressViewBtn(tag)
	
	--�����������ͻ�ȡ��ǰ���б�
	local rankType = BestFighterRankListLayer.allRankInfo.curType
	if rankType == 1 then
		rankList = BestFighterRankListLayer.allRankInfo.todayRank
	elseif rankType == 2 then
		rankList = BestFighterRankListLayer.allRankInfo.weekRank
	end

	local curPage = BestFighterRankListLayer.allRankInfo.curPage

	--֮ǰ���������ȷ�����а����
	local preCount = (curPage - 1) * 5

	local playerId = PlayerIdMake(rankList[preCount + tag].userId, rankList[preCount + tag].regTime, rankList[preCount + tag].channelId)
	local playerName = rankList[preCount + tag].name

	showUILayerByTag(UITagTable["ChatPlayerOption"].tag,true)
	ChatPlayerOption:setSelectedPlayer(playerId, playerName)
end

--ˢ�¸�����Ϣ
function BestFighterRankListLayer:RefreshHeroInfo()
	CCLuaLog("--- BestFighterRankListLayer:RefreshHeroInfo() ---")

	if self.uiLayout == nil or self.heroRankInfo.todayPoint == nil or self.heroRankInfo.weekPoint == nil then
		return
	end

	self.uiLayout:FindChildObjectByName("todayPointNum").__UILabel__:setString(""..self.heroRankInfo.todayPoint)
	self.uiLayout:FindChildObjectByName("todayRankNum").__UILabel__:setString(""..self.heroRankInfo.todayRank)
	self.uiLayout:FindChildObjectByName("weekPointNum").__UILabel__:setString(""..self.heroRankInfo.weekPoint)
	self.uiLayout:FindChildObjectByName("weekRankNum").__UILabel__:setString(""..self.heroRankInfo.weekRank)
	self.uiLayout:FindChildObjectByName("winTimesNum").__UILabel__:setString(""..self.heroRankInfo.todayMaxWin)
	self.uiLayout:FindChildObjectByName("todayCoinNum").__UILabel__:setString(""..MainMenuLayer:GetNumByFormat(self.heroRankInfo.todayTotalCoin))

end



local function onMsgQueryRankRsp(msg)
	CCLuaLog("--- onMsgQueryRankRsp ---")
	if msg.rank_name == 1 then
		if BestFighterRankListLayer.allRankInfo == nil then
			BestFighterRankListLayer.allRankInfo = {}
		end

		CCLuaLog("rankType .."..msg.rank_type)
		if msg.rank_type == 2 then
			--��������Ϣ
			if BestFighterRankListLayer.allRankInfo.todayRank == nil then
				BestFighterRankListLayer.allRankInfo.todayRank = {}
			end

			if msg.rank_info ~= nil then
				CCLuaLog("msg.rank_info ~= nil")		
				for _ , info in pairs(msg.rank_info) do		
					CCLuaLog("......")					
					BestFighterRankListLayer.allRankInfo.todayRank[info.rank] = {
							userId = info.userid,
							regTime = info.reg_time,
							channelId = info.channel_id,
							rank = info.rank,
							name = info.name,
							point = info.score,	
					}
					CCLuaLog("todayRank "..info.rank)
				end
			end

		elseif msg.rank_type == 3 then
			--��������Ϣ
			if BestFighterRankListLayer.allRankInfo.weekRank == nil then
				BestFighterRankListLayer.allRankInfo.weekRank = {}
			end

			if msg.rank_info ~= nil then		
				for _ , info in pairs(msg.rank_info) do							
					BestFighterRankListLayer.allRankInfo.weekRank[info.rank] = {
							userId = info.userid,
							regTime = info.reg_time,
							channelId = info.channel_id,
							rank = info.rank,
							name = info.name,
							point = info.score,	
					}
					CCLuaLog("weekRank "..info.rank)
				end
			end

		end

		BestFighterRankListLayer:RefreshRankInfo()
	end
end

--ˢ��������Ϣ
function BestFighterRankListLayer:RefreshRankInfo()
	CCLuaLog("--- BestFighterRankListLayer:RefreshRankInfo() ---")

	if self.allRankInfo.totalTodayCount == nil then
		self.allRankInfo.totalTodayCount = 0
	end

	if self.allRankInfo.totalWeekCount == nil then
		self.allRankInfo.totalWeekCount = 0
	end

	local rankType = self.allRankInfo.curType
	local curPage = self.allRankInfo.curPage
	local totalPageCount = 0
	local rankList = nil

	--֮ǰ���������ȷ�����а����
	local preCount = (curPage - 1) * 5

	if rankType == 1 then
		rankList = self.allRankInfo.todayRank
		totalPageCount = math.ceil(self.allRankInfo.totalTodayCount / 5)
		CCLuaLog("totalPageCount .."..totalPageCount)
		CCLuaLog("math.ceil(5).."..(math.ceil(5)))
	elseif rankType == 2 then
		rankList = self.allRankInfo.weekRank
		totalPageCount = math.ceil(self.allRankInfo.totalWeekCount / 5)
	end

	for i = 1, 5 do
		if rankList == nil or rankList[preCount + i] == nil then
			self.rankItems.framePlayer[i]:setVisible(false)
			self.rankItems.iconPlayerRank[i]:setVisible(false)
			self.rankItems.iconSelfMark[i]:setVisible(false)

			self.rankItems.viewBtn[i]:setVisible(false)

			self.rankItems.viewText[i]:setVisible(false)
			self.rankItems.playerRank[i]:setVisible(false)
			self.rankItems.playerName[i]:setVisible(false)
			self.rankItems.playerPoint[i]:setVisible(false)
		else
			self.rankItems.framePlayer[i]:setVisible(true)
			self.rankItems.iconPlayerRank[i]:setVisible(true)
			self.rankItems.iconSelfMark[i]:setVisible(true)

			self.rankItems.viewBtn[i]:setVisible(true)

			self.rankItems.viewText[i]:setVisible(true)
			self.rankItems.playerRank[i]:setVisible(true)
			self.rankItems.playerName[i]:setVisible(true)
			self.rankItems.playerPoint[i]:setVisible(true)

			self.rankItems.playerRank[i]:setString(""..rankList[preCount + i].rank)
			self.rankItems.playerName[i]:setString(""..rankList[preCount + i].name)
			self.rankItems.playerPoint[i]:setString(""..rankList[preCount + i].point)

			--������
			if UserData:getUserName() == rankList[preCount + i].name then
				self.rankItems.iconSelfMark[i]:setVisible(true)
					
				self.rankItems.viewBtn[i]:setVisible(false)
				self.rankItems.viewText[i]:setVisible(false)
			else
				self.rankItems.iconSelfMark[i]:setVisible(false)
					
				self.rankItems.viewBtn[i]:setVisible(true)
				self.rankItems.viewText[i]:setVisible(true)
			end
		end
	end	

    if totalPageCount == 0 then
        totalPageCount = 1
    end
	self.rankItems.bottomSheet:setString(""..self.allRankInfo.curPage.."/"..totalPageCount)

	--ǰ����������ͼ��
	for i = 1, 3 do
        if rankList == nil or rankList[preCount + i] == nil then
            self.rankItems.iconPlayerRank[i]:setVisible(false)
			self.rankItems.playerRank[i]:setVisible(false)
        elseif preCount == 0 then
            self.rankItems.iconPlayerRank[i]:setVisible(true)
			self.rankItems.playerRank[i]:setVisible(false)
        else
            self.rankItems.iconPlayerRank[i]:setVisible(false)
			self.rankItems.playerRank[i]:setVisible(true)
        end
	end	

end

function BestFighterRankListLayer:InitLayer()
	CCLuaLog("--- BestFighterRankListLayer:InitLayer() ---")
	self.notificationFunc = NotificationCenter:defaultCenter():registerScriptObserver(updateNotification)

	--��ʼ���洢����Ԫ�أ���ֹ�������ң����Ч��
	self.rankItems.framePlayer = {}
	self.rankItems.iconPlayerRank = {}
	self.rankItems.iconSelfMark = {}

	self.rankItems.viewBtn = {}

	self.rankItems.viewText = {}
	self.rankItems.playerRank = {}
	self.rankItems.playerName = {}
	self.rankItems.playerPoint = {}

	for i = 1, 5 do
		self.rankItems.framePlayer[i] = self.uiLayout:FindChildObjectByName("framePlayer"..i).__UIPicture__
		self.rankItems.iconPlayerRank[i] = self.uiLayout:FindChildObjectByName("iconPlayerRank"..i).__UIPicture__
		self.rankItems.iconSelfMark[i] = self.uiLayout:FindChildObjectByName("iconSelfMark"..i).__UIPicture__

		--���ø��˱��ͼƬ
		local selfMarkPic = AspriteManager:getInstance():getOneFrame("UI/ui_system_icon.bin","map_ui_system_icon_FRAME_ICON_MYMARK")
		self.rankItems.iconSelfMark[i]:setSprite(selfMarkPic)

		self.rankItems.viewBtn[i] = self.uiLayout:FindChildObjectByName("viewBtn"..i).__UIButton__

		self.rankItems.viewText[i] = self.uiLayout:FindChildObjectByName("viewText"..i).__UILabel__
		self.rankItems.playerRank[i] = self.uiLayout:FindChildObjectByName("playerRank"..i).__UILabel__
		self.rankItems.playerName[i] = self.uiLayout:FindChildObjectByName("playerName"..i).__UILabel__
		self.rankItems.playerPoint[i] = self.uiLayout:FindChildObjectByName("playerPoint"..i).__UILabel__
	end

	self.rankItems.bottomSheet = self.uiLayout:FindChildObjectByName("bottomSheetText").__UILabel__

	--ע�ᰴť�ص�
	local closeBtnMenu = self.uiLayout:FindChildObjectByName("closeBtn").__UIButton__:getMenuItemSprite()
	closeBtnMenu:registerScriptTapHandler(onPressCloseBtn)

	local todayNormalBtnMenu = self.uiLayout:FindChildObjectByName("todayNormalBtn").__UIButton__:getMenuItemSprite()
	todayNormalBtnMenu:registerScriptTapHandler(onPressTodayRankBtn)

	local todayClickedBtnMenu = self.uiLayout:FindChildObjectByName("todayClickedBtn").__UIButton__:getMenuItemSprite()
	todayClickedBtnMenu:registerScriptTapHandler(onPressTodayRankBtn)

	local weekNormalBtnMenu = self.uiLayout:FindChildObjectByName("weekNormalBtn").__UIButton__:getMenuItemSprite()
	weekNormalBtnMenu:registerScriptTapHandler(onPressWeekRankBtn)

	local weekClickedBtnMenu = self.uiLayout:FindChildObjectByName("weekClickedBtn").__UIButton__:getMenuItemSprite()
	weekClickedBtnMenu:registerScriptTapHandler(onPressWeekRankBtn)

	local preBtnMenu = self.uiLayout:FindChildObjectByName("preBtn").__UIButton__:getMenuItemSprite()
	preBtnMenu:registerScriptTapHandler(onPressPreBtn)

	local nextBtnMenu = self.uiLayout:FindChildObjectByName("nextBtn").__UIButton__:getMenuItemSprite()
	nextBtnMenu:registerScriptTapHandler(onPressNextBtn)

	for i = 1, 5 do
		self.rankItems.viewBtn[i]:getMenuItemSprite():setTag(i)
		self.rankItems.viewBtn[i]:getMenuItemSprite():registerScriptTapHandler(onPressViewBtn)
	end

	--��ʼ������ͷ���ǳ���Ϣ
	local function getHeadIcon(character)	
		local frameResTable =  {
			"map_ui_character_select_FRAME_CHARACTER_SELECT_SWORDSMAN",
			"map_ui_character_select_FRAME_CHARACTER_SELECT_SWORDSWOMAN",
			"map_ui_character_select_FRAME_CHARACTER_SELECT_WIZARDMAN",
			"map_ui_character_select_FRAME_CHARACTER_SELECT_WIZARDWOMAN",
			"map_ui_character_select_FRAME_CHARACTER_SELECT_ASSASINMAN",
			"map_ui_character_select_FRAME_CHARACTER_SELECT_ASSASINWOMAN",
			"map_ui_character_select_FRAME_CHARACTER_SELECT_HUNTERMAN",
			"map_ui_character_select_FRAME_CHARACTER_SELECT_HUNTERWOMAN",
		}
		return AspriteManager:getInstance():getOneFrame("UI/ui_character_select.bin", frameResTable[character])	 
	end


	local userHeadIconObj = self.uiLayout:FindChildObjectByName("playerPic")
	if userHeadIconObj ~= nil then
		local userHeadIcon = userHeadIconObj.__UIPicture__
		local userType = UserData:GetUserType()
		local userHeadIconRes = getHeadIcon(userType)
		if userHeadIconRes ~= nil then
			userHeadIcon:setSprite(userHeadIconRes)
		end
	end

	--�ǳ���Ϣ
	self.uiLayout:FindChildObjectByName("myNameText").__UILabel__:setString(""..UserData:getUserName())	

	--ǰ������ͼ��
	for i = 1, 3 do
		local rankIcon = AspriteManager:getInstance():getOneFrame("UI/ui_system_icon.bin", "map_ui_system_icon_FRAME_ICON_PAY_RANK"..i)	 
		self.rankItems.iconPlayerRank[i]:setSprite(rankIcon)			
	end


	--��ʼ��������ť״̬Ϊ��������
	setRankButtonState(1)	

	PushOneLayer(self.uiLayerInstance,"","")
	SetChatBar(false,-1)

	self:RefreshHeroInfo()
	self:RefreshRankInfo()

	sendQueryRankReq(2, 1, 10)
	sendQueryRankReq(3, 1, 10)
	addMsgCallBack("CSQueryRankRsp", onMsgQueryRankRsp)
end