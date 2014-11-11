-- װ����Ƕ��
PlayerEquipHole = {
	holeIndex		= 0,	-- �ױ��
	gemId			= 0,	-- ��ʯID
	attrKey			= 0,	-- ����Key
	attrValue		= 0,	-- ����value
	attrValueMin	= 0,	-- ������Сvalue
	attrValueMax	= 0,	-- �������value
}

function PlayerEquipHole:create(extension)
	local info = setmetatable(extension or {},self)
	self.__index = self
	return info
end

-- ����csEquipHole �ɲο�����Э���е�CSEquipHole
function PlayerEquipHole:init(csEquipHole)
	self.holeIndex = csEquipHole.hole_index
	self.gemId = csEquipHole.item_gem_id
	self.attrKey = csEquipHole.attr_key
	self.attrValue = csEquipHole.attr_value
	if csEquipHole.attr_min_v ~= nil then
		self.attrValueMin = csEquipHole.attr_min_v
	end

	if csEquipHole.attr_max_v ~= nil then
		self.attrValueMax = csEquipHole.attr_max_v
	end
end