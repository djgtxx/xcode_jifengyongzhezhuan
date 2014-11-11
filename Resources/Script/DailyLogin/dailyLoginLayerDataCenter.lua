require("Script/DailyGoals/AwardDaily")
require("Script/OsCommonMethod")
require("Script/Language")
require("Script/CommonDefine")
require("Script/GameConfig/Item")

dailyLoginOneItem = {
	itemId = 0,
	--Note: ��ǰ״̬ 1 ����ȡ�������� 2 ����ȡ����ɫ�� 3 ����ȡ����ɫ��
	itemState = 0,
	--Note: ���ͷ���
	itemType = 0,
	rewardIdArray = {},
	rewardNumArray = {},
}

function dailyLoginOneItem:New()
	local oneTable = {}
	setmetatable(oneTable,self);
	self.__index = self;
	return oneTable
end

dailyLoginLayerDataCenter = {
	Items = {} ,
	IsInitData = false ,
	VipItemID = 0,

	ContinueLoginDays = 0,
	VipRewardHasGetOrNot = false,
	LoginRewardHasGetOrNot = false,
}

function dailyLoginLayerDataCenter:SetLoginDaysNum(num)
	self.ContinueLoginDays = num

	--Note:������������ôˢ�¸Ľ���
	if nil ~= DailyLoginLayer then
		DailyLoginLayer:FlushLoginRewardLayer();
	end
end

function dailyLoginLayerDataCenter:SetVipRewardGetOrNot(bGet)
	self.VipRewardHasGetOrNot = bGet

	--Note:������������ôˢ�¸Ľ���
	if nil ~= DailyLoginLayer then
		DailyLoginLayer:FlushLoginRewardLayer();
	end
end

function dailyLoginLayerDataCenter:SetLoginRewardGetOrNot(bGet)
	self.LoginRewardHasGetOrNot = bGet

	--Note:������������ôˢ�¸Ľ���
	if nil ~= DailyLoginLayer then
		DailyLoginLayer:FlushLoginRewardLayer();
	end
end

function dailyLoginLayerDataCenter:InitAllData()
	if self.IsInitData then
		return
	end

	for index,value in pairs(AwardDaily) do
		local type = tonumber(value.Type1)
		if type == 2 then
			local item = dailyLoginOneItem:New()
			item.itemId = index
			local type_2 = tonumber(value.Type2)
			if self.ContinueLoginDays > type_2 then
				item.itemState = 3 -- ����ȡ����ɫ��
			elseif self.ContinueLoginDays == type_2 then
				if self.LoginRewardHasGetOrNot then
					item.itemState = 3 -- ����ȡ����ɫ��
				else
					item.itemState = 1 -- ����ȡ��������
				end				
			elseif self.ContinueLoginDays < type_2 then
				item.itemState = 2 -- ����ȡ����ɫ��
			end
			item.itemType = type
			item.rewardIdArray = {}
			item.rewardNumArray = {}
			self:GetOneItemRewards(value,item)
			self.Items[index] = item
		else
			 local vipNum = UserData:GetUserInfo().m_vip
			 if type == 4 then
				local type_2 = tonumber(value.Type2)
				if 0 == vipNum then
					if type_2 == 1 then
						local item = dailyLoginOneItem:New()
						item.itemId = index
						item.itemType = type
						item.itemState = 2 -- ����ȡ��������
						item.rewardIdArray = {}
						item.rewardNumArray = {}						
						self:GetOneItemRewards(value,item)
						self.Items[index] = item

						self.VipItemID = index
					end
				elseif vipNum == type_2 then
						local item = dailyLoginOneItem:New()
						item.itemId = index
						item.itemType = type
						if self.VipRewardHasGetOrNot then
							item.itemState = 3 -- ����ȡ����ɫ��
						else
							item.itemState = 1 -- ����ȡ��������
						end				
						item.rewardIdArray = {}
						item.rewardNumArray = {}						
						self:GetOneItemRewards(value,item)
						self.Items[index] = item

						self.VipItemID = index
				end
			end
		end
	end

	self.IsInitData = true
end

function dailyLoginLayerDataCenter:GetOneItemRewards(value,item)
	local count = 20
	for indx = 1,count,1 do
		local flag = "RaidDrops" .. indx
		local str = value[flag]
		if str ~= nil and str ~= "0" and str ~= "" then
			local beganPos = string.find(str,"/") + 1
			local endPos = string.len(str)
			rewardId = tonumber(string.sub(str,1,beganPos-2));
			rewardNum = tonumber(string.sub(str,beganPos,endPos));

			local rewardCount = GetTableCount(item.rewardIdArray)
			item.rewardIdArray[rewardCount+1] = rewardId
			item.rewardNumArray[rewardCount+1] = rewardNum

			--print("----------------- reward id " .. rewardId)
			--print("----------------- reward num " .. rewardNum)
		end
	end
end

function dailyLoginLayerDataCenter:TrackOneStateChangeEvent(id,value)
	--local oneItem = self.Items[id]
	--if nil ~= oneItem then
		--if value == 0 then
			--oneItem.state = 2 --Note: ����ȡ
		--else
			--oneItem.state = 1 --Note: ����ȡ
		--end		
	--end
--
	----Note: ˢ���û�����
	--if nil ~= DailyRewardMainLayer then
		--DailyRewardMainLayer:FlushOneListItem(id)
	--end	
end

--Note: ������

function dailyLoginLayerDataCenter:ResetValue()
	self.Items = {}
	self.IsInitData = false
	self.VipItemID = 0
end

--Note: ������Ϣ��ѯ����
--Note: ����
function dailyLoginLayerDataCenter:GetOneItemName(id)
	local oneItem = AwardDaily[id]
	if nil == oneItem then
		return nil
	end
	local languageFlag = oneItem.Task_Text
	local content = LanguageLocalization:GetLocalization(languageFlag)
	return content
end

function dailyLoginLayerDataCenter:GetOneItemIcon(id)
	local oneItem = AwardDaily[id]
	if nil == oneItem then
		return nil
	end

	local binName = KICON_BIN
	local iconName = "map_ui_system_icon_FRAME_" .. string.upper(oneItem.Task_LookFace)
	return iconName,binName
end

function dailyLoginLayerDataCenter:GetOneTypeRewardIcon(id)
	local item = Items[id]
	if nil ~= item then
		local iconName = "map_ui_system_icon_FRAME_" .. item.LookFace
		return iconName
	end
	return nil
end

--function dailyRewardMainLayerDataCenter:GetOneDailyRewardItemType(id)
	--local oneItem = self.Items[id]
	--if nil == oneItem then
		--return nil
	--end
	--return oneItem.type
--end


function dailyLoginLayerDataCenter:GetOneItemState(id)
	local oneItem = self.Items[id]
	if nil == oneItem then
		return nil
	end
	return oneItem.itemState
end

function dailyLoginLayerDataCenter:SetOneItemState(id,state)
	local oneItem = self.Items[id]
	if nil == oneItem then
		return nil
	end
	oneItem.itemState = state
end

function dailyLoginLayerDataCenter:TellOneItemIsVip(id)
	--print("+++++++++++++++++ TellIsVip " .. self.VipItemID)
	if id == self.VipItemID then
		return true
	end
	return false
end

-------------------------------------------------��¶��c++ʹ�ô���--------------------------
function DailyLoginTimesChangeEvent(num)
	dailyLoginLayerDataCenter:SetLoginDaysNum(num)
	return true
end

function DailyLoginVipRewardGetStateChangeEvent(num)
	local bGet = false
	if num ~= 1 then
		bGet = true
	end
	dailyLoginLayerDataCenter:SetVipRewardGetOrNot(bGet)
	return true
end

function DailyLoginLoginRewardGetStateChangeEvent(num)
	local bGet = false
	if num ~= 1 then
		bGet = true
	end
	dailyLoginLayerDataCenter:SetLoginRewardGetOrNot(bGet)
	return true
end