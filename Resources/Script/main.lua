require("Script/GameConfig/vip")
require("Script/GameConfig/DebugConfig")
require("Script/GameConfig/ExchangeItem")
require("Script/Language")

if kTargetAndroid == CCApplication:sharedApplication():getTargetPlatform() then 
	--����luaJavaBridge�Ļ���������
	CCLuaLoadChunksFromZip("framework_precompiled.zip")
	require("framework.init")
end

--��ȡLuaJavaBridge
local luaj = nil
function GetLuaJavaBridge()
	if kTargetAndroid == CCApplication:sharedApplication():getTargetPlatform() then 
		if luaj == nil then
			--����luaJavaBridge�Ļ���������
			CCLuaLoadChunksFromZip("framework_precompiled.zip")
			require("framework.init")

			luaj = require("Script/luaj")
		end
	end
	return luaj
end

--==============================
--��luaJavaBridge���ش�����롿
--==============================
--	-1 	��֧�ֵĲ������ͻ򷵻�ֵ����
--	-2 	��Ч��ǩ��
--	-3 	û���ҵ�ָ���ķ���
--	-4 	Java ����ִ��ʱ�׳����쳣
--	-5 	Java ���������
--	-6 	Java ���������

--==============================
--��luaJavaBridgeʵ����
--==============================
--[[
if kTargetAndroid == CCApplication:sharedApplication():getTargetPlatform() then 

	--���ز��������ַ�ʽ��ͬ�����첽
	--ͬ�����ڵ�����callStaticMethod������������óɹ�����Java�����ķ���ֵ
	--�첽����Ҫ�ڵ���Java����ʱ����һ��lua�ص��������÷�������һ��string���͵ķ���ֵ

    local javaClassName = "com.taomee.adventure.adventure"				--����
    local javaMethodName = "showAlertDialog"							--������
    local javaParams = {												--�������뷽��ǩ��һ�£�Lua Function������ID��int���ͣ���ʽ����
        "How are you ?",
        "I'm great !",
        function(event)
            --�ص�������eventΪ�ص�ʱ���ݵķ���ֵ��string���ͣ�
			--ʵ���з���ֵΪ"CLICKED"
        end
    }
    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;I)I"	--����ǩ���������һ�£�Lua Function������ID��int���ͣ���ʽ����

	--ok��true/false �����Ƿ�ɹ�
	--ret: okΪtrueʱ��retΪJava�����ķ���ֵ
		   okΪfalseʱ��retΪ������루�������������luaJavaBridge���ش�����롿��
    local ok, ret = GetLuaJavaBridge().callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

	if ok then
		--���óɹ���retΪJava����ֵ
		--ʵ���з���ֵΪ123
	else
		--����ʧ�ܣ�retΪ�������
		--�������������luaJavaBridge���ش�����롿
	end

end
--]]

local visionNum = "1.3.0";
function getVisionNum()
	return LanguageLocalization:GetLocalization("M_VERSION")..visionNum;
end


local nowPowerBuyCount = 0
function RefreshPowerBuyCount(count)
	nowPowerBuyCount = count
end

function getNowPowerBuyCount()
	return nowPowerBuyCount
end

function getRemainPowerBuyCount()
	local vipLevel = UserData:GetVipLevel()
	local maxPowerBuyCount = Vip[vipLevel].Power

	return maxPowerBuyCount - nowPowerBuyCount
end

-- �����Զ�ս������غ���
local canAutoFight = false
local autoFightVIP = 0
local autoFightLevel = 0

function GetAutoFightState()
    if GetEnableAutoFight() then
        return true
    end
	return canAutoFight
end

function GetAutoFightText()
	return ""..autoFightLevel..GetLuaLocalization("M_FINDENEMY_2")
end

local function sendAutoFightCheckReq()
	CSAutoBattleCheckReq = {
		}
	local msgname="CSAutoBattleCheckReq"
	local ret = send_message(msgname, CSAutoBattleCheckReq, true)
	return ret
end
	
local function onMsgAutoFightCheckRsp(msg)
	canAutoFight = (msg.on_or_off == 1)
	autoFightVIP = msg.vip_lv
	autoFightLevel = msg.lv
end

function InitAutoFightInfo()
	CCLuaLog("---- InitAutoFightInfo ---")

	sendAutoFightCheckReq()
	addMsgCallBack("CSAutoBattleCheckRsp", onMsgAutoFightCheckRsp)

	return true
end

--ˢ�¿�����ʯ����
local refreshCardCount = 0
local soulStoneCount = 0

function UpdateRefreshCardCount(count)
	refreshCardCount = count
end

function UpdateSoulStoneCount(count)
	soulStoneCount = count
end

function GetRefreshCardCount()
	return refreshCardCount
end

function GetSoulStoneCount()
	return soulStoneCount
end

-- �����̵꼰��ǿ���߻��ֶһ��̵��������
local exchangeItemTimes = {}
function UpdateExchangeTimes(attrId, value)
    local exchangeId = attrId - PB_ATTR_EXCHANGE_TIMES_BEGIN + 250

    CCLuaLog("------------------------------- UpdateExchangeTimes : exchangeId "..exchangeId)
    exchangeItemTimes[exchangeId] = value
end

-- ���ⷵ�ضһ����� �� exchangeType : 0 ���޴Σ�1 ÿ�죬 2 �ܹ�
function GetItemExchangeRemainTime(exchangeId)
    CCLuaLog("GetItemExchangeRemainTime : exchangeId "..exchangeId)
    local itemTable = ExchangeItems[exchangeId]

    local exchangeType = 0
    if tonumber(itemTable.Restriction) ~= 0 then
        exchangeType = 1
    elseif tonumber(itemTable.Lifelong_Restriction) ~= 0 then
        exchangeType = 2
    end

    local maxTime = -1
    if exchangeType == 1 then
        maxTime = tonumber(itemTable.Restriction)
    elseif exchangeType == 2 then
        maxTime = tonumber(itemTable.Lifelong_Restriction)
    end
    local nowTime = exchangeItemTimes[exchangeId] or 0

    return maxTime - nowTime, exchangeType
end

function ResetReputationExchangeTime()
    exchangeItemTimes = {}
end