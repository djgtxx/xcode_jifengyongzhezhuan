-- ��Ʒ����������Ϣ
PlayerItemAttr = {
	attrKey			= 0,	-- ����key
	basicValue		= 0,	-- ��������
	intensifyValue	= 0,	-- ǿ������
	genValue		= 0,	-- ��ʯ����
}

function PlayerItemAttr:create(extension)
	local info = setmetatable(extension or {},self)
	self.__index = self
	return info
end

-- ����equipmentBase �ɲο�����Э���е�CSItemAttr
function PlayerItemAttr:init(csItemAttr)
	self.attrKey = csItemAttr.attr_key
	self.basicValue = csItemAttr.attr_basic_value
	if csItemAttr.attr_intensify_value ~= nil then
		self.intensifyValue = csItemAttr.attr_intensify_value
	end
	if csItemAttr.attr_gem_value ~= nil then
		self.genValue = csItemAttr.attr_gem_value
	end
end