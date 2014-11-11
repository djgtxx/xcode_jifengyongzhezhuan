#pragma once

#include "SASpriteDefine.h"
#include "RoleBase.h"
#include "RoleActorBase.h"
#include "string"
#include "tinystr.h"
#include "tinyxml.h"

class SkeletonAnimRcsManager
{
public:	
	~SkeletonAnimRcsManager();
	static SkeletonAnimRcsManager* getInstance(void);
	static void Destroy();
	
	void LoadSourceDataFromXML();
	void LoadAllData();
	void ClearAllRoleConnectionData();
	void clearAllData();
	void LoadOneMapRcs(int levelID,int mapId,bool bInOtherLand);
	void LoadCommonRcs(bool bInOtherLand);
	void LoadOneHeroRcs(int roleId,bool bInOtherLand);
	void LoadOneRoleAttachEffectRcs(int roleId);
	void LoadOneLevelNPCRcs(int levelId);
	void ClearSpriteElfVecIds(){
		vecLoadedElfIds.clear();
	}
	/**
	* Instruction : ��������һ����ɫ����Դ
	* @param 
	*/	
	void LoadOneRoleRcsOnly(int roleId);
	/**
	* Instruction : ���ؾ�����Դ
	* @param 
	*/	
	void LoadOneSpriteElfRcs(unsigned int elfId,bool bInOtherLand);
	std::map<std::string,RoleActorBase*>* createOneRoleArmatures(int role_id);
	ArmatureActionData * getOneRoleArmatureActionData(int id);
	bool IsOneActorRcsExist(int typeId);

	/**
	* Instruction : ��ȡĳһ����ɫ ĳ�����Ĳ�����֡��
	* @param 
	*/
	int getOneAnimationDurationTween(int roleId,int animId);
	/**
	* Instruction : ��ȡ����ʱ��s
	* @param 
	*/
	float getOneAnimationDuration(int roleId,int animId);
	/**
	* Instruction : 
	* @param 
	*/
	void addOneRoleTypeIdToMap(std::vector<unsigned int> vecIn);
	/**
	* Instruction : 
	* @param 
	*/
	void LoadRoleRcsOneMap(bool bMainLand);
//protected:
	void LoadOneRcs(std::string rcsPath);
private:
	SkeletonAnimRcsManager();
	/// <summary>
	//	Init param for use
	/// </summary>
	bool init();
	/// <summary>
	/// read role animation info from out file
	/// </summary>
	TiXmlElement * initXML(const char * filePath);
	bool readMapAttachedRcsDataFromFile(TiXmlElement *root);
	bool readRcsDataFromFile(TiXmlElement *root);
	bool readArmatureDataFromFile(TiXmlElement *root);
	bool readArmatureRcsDataFromeFile(TiXmlElement *root);
	/// <summary>
	//	get action type
	/// </summary>
	RoleActionType getActionType(const char* actionTypeStr);
	
private:
	RoleArmatureRcsData *roleArmatureRcsData;
	RoleArmatureActionData *roleArmatureActionData;
	MapAttachedData *mapAttachData;
	std::vector<unsigned int> vecLoadedElfIds;
	bool m_isLoadAllData;
	std::vector<unsigned int> vecLoadNeedRoleTypes;
	std::set<unsigned int> setLoadRolesConnectionData;
	std::set<std::string> setLoadRcsFileNames;

	std::set<unsigned int > m_loadedHeroAnims;
};