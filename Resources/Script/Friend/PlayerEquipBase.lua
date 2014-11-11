require("Script/Friend/PlayerEquipNextAttr")
require("Script/Friend/PlayerEquipHole")
-- װ����Ϣ(�����¼�����Ҫ�Ļ��ѡ���һ�ȼ���������������Ƕ��ʯ)
PlayerEquipBase = {
	nextAttrTable	= nil,	-- װ������
	holeTable		= nil,  -- ��ʯ���
	leverUpCost		= 0,	-- ��һ��ǿ������
	suitActivationTable = nil, -- ��װ����״̬
}

function PlayerEquipBase:create(extension)
	local info = setmetatable(extension or {},self)
	self.__index = self
	return info
end

-- ����equipmentBase �ɲο�����Э���е�EquipmentBase
function PlayerEquipBase:init(equipmentBase)
	self.cost_levelup = equipmentBase.cost_levelup
	if equipmentBase.incr_attr_next_lv ~= nil then
		if self.nextAttrTable == nil then
			self.nextAttrTable = {}
			setmetatable(self.nextAttrTable,{})
		end

		for k,v in pairs(equipmentBase.incr_attr_next_lv) do
			local nextAttr = PlayerEquipNextAttr:create()
			nextAttr:init(equipmentBase.incr_attr_next_lv[k])
			self.nextAttrTable[k] = nextAttr
		end
	end

	if equipmentBase.equip_holes ~= nil then
		if self.holeTable == nil then
			self.holeTable = {}
			setmetatable(self.holeTable,{})
		end

		for k,v in pairs(equipmentBase.equip_holes) do
			local hole = PlayerEquipHole:create()
			hole:init(equipmentBase.equip_holes[k])
			self.holeTable[k] = hole
		end
	end

	if equipmentBase.rel_ids ~= nil then
		if self.suitActivationTable == nil then
			self.suitActivationTable = {}
			setmetatable(self.suitActivationTable,{})
		end

		for k,v in pairs(equipmentBase.rel_ids) do
			self.suitActivationTable[v] = true
		end
	end
end