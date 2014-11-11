require("Script/DailyReward/dailyreceive")
require("Script/OsCommonMethod")
require("Script/Language")
require("Script/CommonDefine")

dailyRewardOneItem = {
	id = 0,
	--Note: ���ڱ�ʾ��ڰ�ť��״̬��1 ��ʾ����ȡ�Ϳɽ��ܣ���ȡ�Ժ����ظ����� 2 ��״̬�����ظ����룬��ʾ����ȡ��
	type = 0,
	--Note: ״̬ 1 ����ȡ 2 ����ȡ ��Ĭ��Ϊ����ȡ״̬��
	state = 0,
}

function dailyRewardOneItem:New()
	local oneTable = {}
	setmetatable(oneTable,self);
	self.__index = self;
	return oneTable
end

dailyRewardMainLayerDataCenter = {
	Items = {} ,
	IsInitData = false ,

	--Note: ���ڼ�������ID��Χ
	IsCalTaskIdRange = false ,
	MinItemId = 0,
	MaxItemId = 0,
}

function dailyRewardMainLayerDataCenter:ClearData()
	self.IsInitData = false
	self.Items = {}
end

function dailyRewardMainLayerDataCenter:InitAllData()
	if self.IsInitData then
		return
	end
	for index,value in pairs(dailyreceive) do
		local newItem = dailyRewardOneItem:New()
		newItem.id = index
		newItem.type = tonumber(value.Dailyreceive_types)
		newItem.state = 1
		self.Items[index] = newItem
	end

	self.IsInitData = true
end

function dailyRewardMainLayerDataCenter:GetDailyRewardIdRange()
	if false == self.IsCalTaskIdRange then
		for index,value in pairs(dailyreceive) do			
			if 0 == self.MinItemId then
				self.MinItemId = index
			elseif index < self.MinItemId then
				self.MinItemId = index
			end

			if 0 == self.MaxItemId then
				self.MaxItemId = index
			elseif index > self.MaxItemId then
				self.MaxItemId = index
			end
		end

		self.IsCalTaskIdRange = true
	end
end

function dailyRewardMainLayerDataCenter:TrackOneDailyRewardStateChangeEvent(id,value)
	local oneItem = self.Items[id]
	if nil ~= oneItem then
		if value == 0 then
			oneItem.state = 2 --Note: ����ȡ
		else
			oneItem.state = 1 --Note: ����ȡ
		end		
	end

	--Note: ˢ���û�����
	if nil ~= DailyRewardMainLayer then
		DailyRewardMainLayer:FlushOneListItem(id)
	end	
end

--Note: ������

function dailyRewardMainLayerDataCenter:ResetValue()
	self.Items = {}
end

--Note: ������Ϣ��ѯ����
--Note: ����
function dailyRewardMainLayerDataCenter:GetOneDailyRewardItemName(id)
	local oneItem = dailyreceive[id]
	if nil == oneItem then
		return nil
	end
	local languageFlag = oneItem.Dailyreceive_name
	local content = LanguageLocalization:GetLocalization(languageFlag)
	return content
end
function dailyRewardMainLayerDataCenter:GetOneDailyRewardItemStartTime(id ,key)
	local oneItem = dailyreceive[id]
	if nil == oneItem then
		return nil
	end
	local _start1Str = nil
	if key == 1  then
		_start1Str = oneItem.start_time_1
	elseif  key ==2 then
		_start1Str = oneItem.end_time_1
	elseif key == 3 then
		_start1Str = oneItem.start_time_2
	elseif key == 4 then
		_start1Str = oneItem.end_time_2
	end

	local timeNumber = 0
	
	for a=1 ,3  do
		 local i ,j = string.find(_start1Str ,"/")
		 if i == nil then
			  local hour = _start1Str 
			   timeNumber =timeNumber*60 + tonumber(hour)
			   break
		 else
			local hour = string.sub(_start1Str ,1,i-1)
			 timeNumber =timeNumber*60 + tonumber(hour)
			 _start1Str=string.sub(_start1Str ,i+1)
		 end
	end
	--print(timeNumber)
	return timeNumber 
end
function dailyRewardMainLayerDataCenter:GetOneDailyRewardItemIcon(id)
	local oneItem = dailyreceive[id]
	if nil == oneItem then
		return nil
	end

	local binName = KICON_BIN
	local iconName = "map_ui_system_icon_FRAME_" .. string.upper(oneItem.Dailyreceive_icon)
	return iconName,binName
end

function dailyRewardMainLayerDataCenter:GetOneDailyRewardItemType(id)
	local oneItem = self.Items[id]
	if nil == oneItem then
		return nil
	end
	return oneItem.type
end


function dailyRewardMainLayerDataCenter:GetOneDailyRewardItemState(id)
	local oneItem = self.Items[id]
	if nil == oneItem then
		return nil
	end
	return oneItem.state
end

--Note: �жϵ�ǰ����ID
--function dailyGoalsDataCenter:GetTaskIDByIndex(_index)
	--local count = 1
	--for index,value in pairsByKeys(self.TaskItems) do
		--if _index == count then
			--return value.taskID
		--end 
		--count = count + 1
	--end
	--return nil
--end

-------------------------------------------------��¶��c++ʹ�ô���--------------------------

function IsOneKeyContainsDailyRewardId(id,value)
	dailyRewardMainLayerDataCenter:GetDailyRewardIdRange()
	if dailyRewardMainLayerDataCenter.MaxItemId >= id and dailyRewardMainLayerDataCenter.MinItemId <= id then
		print("------------------ IsOneKeyContainsDailyRewardId " .. id .. " value " .. value)
		dailyRewardMainLayerDataCenter:InitAllData()
		dailyRewardMainLayerDataCenter:TrackOneDailyRewardStateChangeEvent(id,value)
		--Note: �Ƿ���ʾ��ʾIcon
		if nil ~= DailyRewardMainLayer then
			DailyRewardMainLayer:ShowRewardTipIconOrNot()
		end
		return true
	end
	return false
end