--������صĸ�������
require("Script/Fairy/FairyDataCenter")
require("Script/Fairy/FairyConfigTable")

--[[

	PB_ITEM_ATTR_PHYATK        =   1;  // ������(1)
    PB_ITEM_ATTR_MAGATK        =   2;  // ħ������(2)
    PB_ITEM_ATTR_SKIATK        =   3;  // ���ܹ���(3)
    PB_ITEM_ATTR_PHYDEF        =   4;  // �������(4)
    PB_ITEM_ATTR_MAGDEF        =   5;  // ħ������(5)
    PB_ITEM_ATTR_SKIDEF        =   6;  // ���ܷ���(6)
    PB_ITEM_ATTR_HP            =   7;  // ����ֵ(7)
    PB_ITEM_ATTR_ACCU          =   8;  // ��׼(8)
    PB_ITEM_ATTR_DODG          =   9;  // ����(9)
]]

--[[
��ǩ����˳��:
1. �﹥��ħ����
2. ���
3. ħ��
4. ����
5. ����
6. ����

]]

function RefreshAttrPanel(layout, nowAttrTable, nextAttrTable)
	if layout == nil then
		return
	end

	-- �����﹥��ħ����ʾ
	local userType = UserData:GetUserType()

	--ħ��ʦ��ʾħ����ǩ
	if userType == 3 or userType == 4 then
		layout:FindChildObjectByName("attrName1").__UILabel__:setString(GetLuaLocalization("M_FAIRY_LU_ATTRIBUTE7"))
	else
		layout:FindChildObjectByName("attrName1").__UILabel__:setString(GetLuaLocalization("M_FAIRY_LU_ATTRIBUTE1"))
	end

	-- ���µ�ǰ����
	if nowAttrTable ~= nil then
		CCLuaLog("--- nowAttrTable size : "..#nowAttrTable)

		for key, value in pairs(nowAttrTable) do
			CCLuaLog("key : "..key.." value : "..value)
		end

		local normalAttackNum = 0
		if userType == 3 or userType == 4 then
			normalAttackNum = nowAttrTable[2]
		else
			normalAttackNum = nowAttrTable[1]
		end

		layout:FindChildObjectByName("attrNum1").__UILabel__:setString(""..(normalAttackNum or 0))
		layout:FindChildObjectByName("attrNum2").__UILabel__:setString(""..(nowAttrTable[4] or 0))
		layout:FindChildObjectByName("attrNum3").__UILabel__:setString(""..(nowAttrTable[5] or 0))
		layout:FindChildObjectByName("attrNum4").__UILabel__:setString(""..(nowAttrTable[3] or 0))
		layout:FindChildObjectByName("attrNum5").__UILabel__:setString(""..(nowAttrTable[6] or 0))
		layout:FindChildObjectByName("attrNum6").__UILabel__:setString(""..(nowAttrTable[7] or 0))
	end

	-- ��������������
	if nextAttrTable ~= nil then
		CCLuaLog("--- nextAttrTable size : "..#nextAttrTable)
		for key, value in pairs(nextAttrTable) do
			CCLuaLog("key : "..key.." value : "..value)
		end

		local normalAttackNum = 0
		if userType == 3 or userType == 4 then
			normalAttackNum = nextAttrTable[2]
		else
			normalAttackNum = nextAttrTable[1]
		end

		layout:FindChildObjectByName("attrUpNum1").__UILabel__:setString(""..(normalAttackNum or 0))
		layout:FindChildObjectByName("attrUpNum2").__UILabel__:setString(""..(nextAttrTable[4] or 0))
		layout:FindChildObjectByName("attrUpNum3").__UILabel__:setString(""..(nextAttrTable[5] or 0))
		layout:FindChildObjectByName("attrUpNum4").__UILabel__:setString(""..(nextAttrTable[3] or 0))
		layout:FindChildObjectByName("attrUpNum5").__UILabel__:setString(""..(nextAttrTable[6] or 0))
		layout:FindChildObjectByName("attrUpNum6").__UILabel__:setString(""..(nextAttrTable[7] or 0))
	end
end