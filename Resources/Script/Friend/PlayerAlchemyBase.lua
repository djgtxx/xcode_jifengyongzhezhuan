require("Script/Friend/PlayerEquipNextAttr")
require("Script/Friend/PlayerEquipHole")
-- ��ʯ��Ϣ
PlayerAlchemyBase = {
	consume		= 0 , --��ʯ������Ҫ�Ļ���(=0ʱ��ʾ�Ѿ��ﵽ��߼�����������)
	convert		= 0 , -- �һ��ɾ�������
}

function PlayerAlchemyBase:create(extension)
	local info = setmetatable(extension or {},self)
	self.__index = self
	return info
end

-- ����equipmentBase �ɲο�����Э���е�EquipmentBase
function PlayerAlchemyBase:init(ssBase)
	self.consume = ssBase.consume
	self.convert = ssBase.convert
end