-- ��һ��װ������ �� װ����ϢPlayerEquipBase�е�����,
PlayerEquipNextAttr = {
	attrKey			= 0,	-- ����key
	attrValue		= 0,	-- ��������
};

function PlayerEquipNextAttr:create(extension)
	local info = setmetatable(extension or {},self)
	self.__index = self
	return info
end

-- ����equipmentBase �ɲο�����Э���е�EquipmentBase:Item_Attr
function PlayerEquipNextAttr:init(itemAttr)
	self.attrKey = itemAttr.key
	self.attrValue = itemAttr.value
end