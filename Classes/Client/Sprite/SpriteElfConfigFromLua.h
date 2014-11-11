#pragma once

extern "C" {
#	include "lua.h"
#	include "lualib.h"
#	include "lauxlib.h"
}

#include "cocos2d.h"
#include "UserData.h"

class SpriteElfConfigFromLuaManager
{
public :	
	virtual ~SpriteElfConfigFromLuaManager();
	static SpriteElfConfigFromLuaManager* getInstance(void);
	static void Destroy();

	virtual void initLuaState();

	// Note: Check and Get Functions

	/**
	* Instruction : ��ȡ�������Ӣ�۵Ĺ̶�����ƫ�Ƶ�
	* @param 
	*/	
	bool GetElfToHeroFixedDistance(float &posx,float &posy);

	/**
	* Instruction : ��ȡ���ж�����
	* @param 
	*/	
	float GetOuterCircleRadius();

	/**
	* Instruction : ��ȡ���ж�����
	* @param 
	*/	
	float GetInnerCircleRadius();

	/**
	* Instruction : ��ȡ����ʱ��
	* @param 
	*/	
	float GetTotalAccTimer();
	/**
	* Instruction : ��ȡ��ʼ�ٶ�ϵ��
	* @param 
	*/	
	float GetStartSpeedCoefficient();
	/**
	* Instruction : ��ȡ��󿿽��ٶ�ϵ��
	* @param 
	*/	
	float GetMaxMoveSpeedCoefficient();
	/**
	* Instruction : 
	* @param 
	*/
	//void PushElfIdToLuaTable();
	/**
	* Instruction : ������ص���©��Lua
	* @param 
	*/
	bool PushElfStateMessageToLua(int elfId,int stateId);
	/**
	* Instruction : �����б���Ϣ��©��Lua
	* @param 
	*/
	bool PushElfListMessageToLua(PLAYER_ID roleId,int elfId,int stateId, int grade);
	/**
	* Instruction : 
	* @param 
	*/
	void GetElfListMessageOver();
	/**
	* Instruction : 
	* @param 
	*/
	bool CallLuaStartFunction();
	/**
	* Instruction : ��ȡ����ս������ID
	* @param 
	*/
	unsigned int GetHeroFightElfID();
	/**
	* Instruction : �󶨾���Ǳ����嵽����Layer
	* @param 
	*/
	bool EquipElfPotientionPanelToBackPackLayer(cocos2d::CCLayer* pLayer);
	/**
	* Instruction : �رվ���Ǳ�����
	* @param 
	*/
	bool CloseElfPotientionPanel();
	/**
	* Instruction : 
	* @param 
	*/
	void ResetValue();
	/**
	* Instruction : 
	* @param 
	*/
	bool ClearElfLayerAllData();
	/**
	* Instruction : 
	* @param 
	*/
	bool CreateSpriteElfLayer();

	void HandleSaveAwakeResultMessage();
	void HandleAwakeSuccessMessage(int courage,int deltaCharm,int deltaTrick,bool bSuc);

	void PushExploreMapIdToData(unsigned int type,unsigned int mapId);
	void PushExploreBasicRewardInfo(unsigned int map_id,unsigned int add_coin,unsigned int add_exp,unsigned int add_exploit);
	void PushExploreOtherRewardInfo(unsigned int item_id,unsigned int item_level,unsigned int item_num);
	void PushExploreLeftNums(unsigned int leftNums);
	void PushExploreNums(unsigned int Nums);
	void ExploreRewardCommit();

	//void PushElfStrengthData(unsigned int num_1,unsigned int num_2,unsigned int num_3,unsigned int num_4);

	bool TellIsElfId(unsigned int roleId);
	void PushExchangeElfRet(unsigned int elfId);

	void CheckWhetherNewElfReleaseByReputation();
protected:
	bool checkElfConfigCotent();
	bool checkElfLogicContent();
	bool checkElfExploreContent();
	bool checkElfStrengthContent();
private:
	SpriteElfConfigFromLuaManager();
	lua_State *m_configLuaState;

	bool mIsLoadElfConfigContent;
	bool mIsLoadElfLogicContent;
	bool mIsLoadElfExploreContent;
	bool mIsLoadElfStrengthContent;
};