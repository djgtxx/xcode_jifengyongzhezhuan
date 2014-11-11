#pragma once

#include "Singleton_t.h"
#include "string"
#include "map"
#include "cocos2d.h"
#include "tinyxml.h"
#include "ATLObjectInfo.h"
#include "ATLObjectLayer.h"

USING_NS_CC;

struct NpcBasicInfo
{
	CCPoint pos;
	bool bFlip;

	NpcBasicInfo(){
		pos = CCPointZero;
		bFlip = false;
	}
};

struct CityBasicInfo
{
	std::string city_name;
	unsigned int map_id;
	CCPoint heroBornPoint;
	unsigned int backgroundMusicID;
	CCPoint normalRaidTransmissionGate;
	CCPoint eliteRaidTransmissionGate;
	int unlockTaskId;
	int type;

	std::map<unsigned int,NpcBasicInfo> *mapNpcIdAndPos;

	CityBasicInfo(){
		city_name = "";
		map_id = 0;
		backgroundMusicID = 0;
		heroBornPoint = normalRaidTransmissionGate = eliteRaidTransmissionGate = CCPointZero;

		mapNpcIdAndPos = new std::map<unsigned int,NpcBasicInfo>();
	}

	~CityBasicInfo(){
		mapNpcIdAndPos->clear();
		CC_SAFE_DELETE(mapNpcIdAndPos);
	}
};

/*
*   ����������Ϣ
*/
class MainLandManager : public TSingleton<MainLandManager>
{
public:
	MainLandManager();
	virtual ~MainLandManager();

	/**
	* Instruction : �������ļ��ж�ȡ��������
	* @param 
	*/	
	bool LoadData();
	/**
	* Instruction : ��ȡĳ������npc����Ϣ
	* @param 
	*/	
	std::map<unsigned int,NpcBasicInfo>* GetOneCityNpcInfos(unsigned int city_id);

	//��ǰ����
	void setCurCityId(int id){
		this->curCityId = id;
	}
	int getCurCityId(){return this->curCityId;}

	//��ȡĳ���ǵĳ�����
	//born : ������
	//normalGate: ��ͨ������
	//eliteGate: ��Ӣ������
	CCPoint getCityCell(int mapId, std::string typeName);

	//��������
	std::string getCityName(int mapId);

	vector<int> getCityIdList();
	bool isCityUnlock(int mapId);

	//�ж�һ����ͼ�ǲ�������
	bool isMainLand(int mapId);
	bool isMainLandType(int mapId);
	void onEventTaskUnlock(int taskId);

	void sendGetTaskStatus();

	/**
	* Instruction : 
	* @param 
	*/
	int GetCityIdByMapId(int map_id);

	bool GetCityIdByNpcId(int npc_id,int &cityId,int &mapId);
	bool GetOneCityNpcPos(int cityId,int npcId, CCPoint &targetPos);
	
	//�õ����ǵı�������
	int GetCityBGM(int cityId);

	//bool IsCityCanGo(int cityId);
	void resetData();

	CATLObjectInfo* getAllLevelInfo() { return m_pAllLevelInfo; }

private:
	CCPoint getPointAttribute(TiXmlElement *element, std::string attStr);

	std::map<unsigned int,CityBasicInfo*> *mapCityIdAndBasicInfo;
	map<int, int> taskCityMap;
	set<int> unlockCityList;
	set<int> defaultOpenCityList;

	int curCityId;
	bool mIsDataLoad;

	CATLObjectInfo* m_pAllLevelInfo;
};