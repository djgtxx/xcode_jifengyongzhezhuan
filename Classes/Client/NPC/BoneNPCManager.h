#pragma once

#include "NpcSprite.h"
#include "NPCDataDefine.h"
#include "map"

class BoneNPCManager
{
public:	
	~BoneNPCManager();
	static BoneNPCManager* getInstance(void);
	static void Destroy();
	void Init();
	std::map<int,NPCData *> * LoadNPCConfigInfoFromLua(int level);
	void LoadOneLevelNPC(int levelID,CCNode *parentNode);
	/**
	* Instruction : ����ĳһ��NPCͷ�ϱ�ʾ��
	* @param 
	*/
	void UpdateOneNpcFlagIcon(unsigned int npcId);
	/**
	* Instruction : ��������NPC��ʾ��
	* @param 
	*/
	void UpdateAllNpcFlagIcon();
	/**
	* Instruction : ��ȡNPC��
	* @param 
	*/
	NPCData * GetOneNpcBasicData(unsigned int npc_id,bool bFromLua = false);
	/**
	* Instruction : ��ȡĳһ��NPC
	* @param 
	*/
	SpriteNPC* GetOneNpc(unsigned int npc_id);
	/**
	* Instruction : ��ȡNpc��صĽ�ɫ
	* @param 
	*/
	std::map<int,SpriteNPC *> * GetNpcTypeIdAndSprites(){
		return mMapNpcTypeIdAndSprites;	
	}

	void ResetValue();

	void ShowAllNpc(bool bShow);
private:
	BoneNPCManager();
	std::map<int,SpriteNPC *> *mMapNpcTypeIdAndSprites;
};