#include "Localization.h"
#include "LuaTinkerManager.h"

//bool Localizatioin::m_bCheckLanguageEnv = false;
//LANGUAGE_TYPE Localizatioin::m_languageType = kType_Language_SimpleChinese;

Localizatioin::Localizatioin()
{
}

Localizatioin::~Localizatioin()
{
}

const char* Localizatioin::getLocalization(const char* szFlag)
{
	if (szFlag == 0)
	{
		return "";
	}
	
	const char* rst = LuaTinkerManager::Get()->callLuaFunc<char *>("Script/Language.lua", "GetLuaLocalization", szFlag);
	if (NULL == rst)
	{
		rst = "";

		std::string title = "Localizatioin Notification";
		char buffer[100];
		sprintf(buffer,"Localizatioin Not Found %s ",szFlag);

		CCMessageBox(buffer, title.c_str());
	}

	return rst;
}

// Note: ���ݲ�ͬ��ƽ̨ʵ�ֻ�ȡ��ǰ�������͵Ĵ���
//�Ժ����û�����lua����ȡ
//void Localizatioin::CheckLanguageEnv()
//{
//#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID 
//	m_languageType = kType_Language_SimpleChinese;
//#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
//	m_languageType = kType_Language_SimpleChinese;
//#else
//	m_languageType = kType_Language_SimpleChinese;
//#endif	
//}