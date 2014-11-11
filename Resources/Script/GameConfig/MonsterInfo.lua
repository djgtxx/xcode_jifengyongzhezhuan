--��¼���������Լ������ͷż����������Ϣ
--AttackType : 1��ʾ��ս������2��ʾԶ�̹�����3��ʾ���㹥��,4��ʾ��̹���,5��ʾ�ٻ���6��ʾ����������7��ʾbuff��8��ʾ˲��,9��ʾ��ת, 10��ʾ����,11��ʾ��Ծ����,12�ǻ�Ѫ,13����Զ�̷��䣬14Ϊ�̶�·�߹���
Monsters={}

--������Ч����Ҫ��ʾ���������
BackEffect={118, 165, 181}

--����ǰ���buff��Ч
FrontBuffEffect={158, 182, 192,194,196, 221,223,230, 135}

--�����п����ƶ�, 9
AttackCanMove={19005, 19009, 19015}

--�����ǰҡ�Ĺ��� 4
RushOnly={10024, 10054, 10084}

--˲�Ƽ��� 8
BlinkStart={1901006,1901007, 1902110,1902111, 1950402,1950403, 1950804,1950805, 1951200,1951201}
BlinkEnd=  {1901008,1901009, 1902112,1902113, 1950404,1950405, 1950806,1950807, 1951208,1951209}

--���������е����� 6
ShakeStart={1900402,1900403, 1901300,1901301, 1901402,1901403, 1902004,1902005, 
            1950202,1950203, 1951004,1951005, 1902400,1902401, 1951206,1951207,}

--���������Լ���ת 6 9
DelayIdle={1900402,1900403, 1900502,1900503, 1900904,1900905, 1901300,1901301, 
		   1901402,1901403, 1902004,1902005, 1901500,1901501, 1950202,1950203,
           1950800,1950801, 1951004,1951005, 1902400,1902401, 1951206,1951207,}

--������ 10
HideStart = {1901202,1901203, 1901902,1901903}

--��Ծ���� 11
---[[
JumpStart = {1900902,1900903, 1901802,1901803, 1950408,1950409}
JumpDown  = {1900907,1900908, 1901804,1901805, 1950410,1950411}
--]]

--buff 7
BuffAnimEnd = {1900804,1900805, 1900400,1900401, 1901004,1901005, 1901304,1901305, 1901410,1901411, 
			   1901504,1901505, 1901704,1901705, 1902006,1902007, 1902106,1902107, 1902206,1902207,
			   1950106,1950107, 1950206,1950207, 1950306,1950307, 1950406,1950407, 1950808,1950809,
               1950900,1950901, 1902308,1902309,}

--�����ν� ��������  ��ת  ˲�� 6 8 9
AnimLinkStart={1900402,1900403, 1900502,1900503, 1900904,1900905, 1901006,1901007,
			   1901300,1901301, 1901402,1901403, 1902004,1902005, 1901500,1901501,
			   1950202,1950203, 1950402,1950403, 1950800,1950801, 1950804,1950805,
               1951004,1951005, 1902400,1902401, 1951206,1951207, 1951200,1951201,}

--�������ӱ�
AnimLinkTable={}
AnimLinkTable[1900402] = {Down='1900404',Up='1900405'}
AnimLinkTable[1900403] = {Down='1900404',Up='1900405'}
AnimLinkTable[1900502] = {Down='1900504',Up='1900505'}
AnimLinkTable[1900503] = {Down='1900504',Up='1900505'}
AnimLinkTable[1900904] = {Down='1900906',Up='1900906'}
AnimLinkTable[1900905] = {Down='1900906',Up='1900906'}
AnimLinkTable[1901006] = {Down='1901008',Up='1901009'}
AnimLinkTable[1901007] = {Down='1901008',Up='1901009'}
AnimLinkTable[1901300] = {Down='1901302',Up='1901303'}
AnimLinkTable[1901301] = {Down='1901302',Up='1901303'}
AnimLinkTable[1901402] = {Down='1901404',Up='1901405'}
AnimLinkTable[1901403] = {Down='1901404',Up='1901405'}
AnimLinkTable[1901500] = {Down='1901502',Up='1901502'}
AnimLinkTable[1901501] = {Down='1901502',Up='1901502'}
AnimLinkTable[1902004] = {Down='1902010',Up='1902011'}
AnimLinkTable[1902005] = {Down='1902010',Up='1902011'}
AnimLinkTable[1950202] = {Down='1950204',Up='1950205'}
AnimLinkTable[1950203] = {Down='1950204',Up='1950205'}
AnimLinkTable[1950402] = {Down='1950404',Up='1950405'}
AnimLinkTable[1950403] = {Down='1950404',Up='1950405'}
AnimLinkTable[1950800] = {Down='1950802',Up='1950803'}
AnimLinkTable[1950801] = {Down='1950802',Up='1950803'}
AnimLinkTable[1950804] = {Down='1950806',Up='1950807'}
AnimLinkTable[1950805] = {Down='1950806',Up='1950807'}
AnimLinkTable[1951004] = {Down='1951006',Up='1951007'}
AnimLinkTable[1951005] = {Down='1951006',Up='1951007'}
AnimLinkTable[1902400] = {Down='1902402',Up='1902403'}
AnimLinkTable[1902401] = {Down='1902402',Up='1902403'}
AnimLinkTable[1951206] = {Down='1951204',Up='1951205'}
AnimLinkTable[1951207] = {Down='1951204',Up='1951205'}
AnimLinkTable[1951200] = {Down='1951208',Up='1951209'}
AnimLinkTable[1951201] = {Down='1951208',Up='1951209'}

local function nameToTable(tableName)
	local nameTable = {}
	nameTable["AttackCanMove"] = AttackCanMove
	nameTable["BlinkStart"] = BlinkStart
	nameTable["BlinkEnd"] = BlinkEnd
	nameTable["ShakeStart"] = ShakeStart
	nameTable["DelayIdle"] = DelayIdle
	nameTable["AnimLinkStart"] = AnimLinkStart
	nameTable["RushOnly"] = RushOnly
	nameTable["BackEffect"] = BackEffect
	nameTable["HideStart"] = HideStart
	nameTable["JumpStart"] = JumpStart
	nameTable["JumpDown"] = JumpDown
	nameTable["BuffAnimEnd"] = BuffAnimEnd
	nameTable["FrontBuffEffect"] = FrontBuffEffect
	return nameTable[tableName]
end

function isIdInTable(tableName, animId)
	local realTable = nameToTable(tableName)
	if realTable == nil then
		print("MonsterInfo.lua : can't find table")
		return false
	end

	local ret = false
	for i = 1, #realTable do
		if animId == realTable[i] then
			ret = true
		end
	end		
	return ret
end