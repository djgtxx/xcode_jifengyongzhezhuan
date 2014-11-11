#pragma once

#include "SpriteElf.h"
#include "Singleton_t.h"
#include "SpriteSeer.h"
#include <map>
#include "vector"

class ElfAssistSkillObserver;

class SpriteElfManager : public TSingleton<SpriteElfManager>
{
	//friend class SpriteElf;
public:
	enum EFairyPos
	{
		E_Fight_Left = 0,
		E_Fight_Right,
		E_Assist_Pos_1,
		E_Assist_Pos_2
	};
public:    
	SpriteElfManager();
	virtual ~SpriteElfManager(); 

	/**
	* Instruction : �����������
	* @param 
	*/	
	SpriteElf*	CreateInstance(PLAYER_ID s_id,int type, int grade = 0);

	// Note: ��������ս������
	SpriteElf* CreateAssistInstance(PLAYER_ID s_id,int type);

	/**
	* Instruction : ����һ���������
	* @param 
	*/
	SpriteElf* CreateInstance(int type, int grade = 0);
	bool IsHasElf(PLAYER_ID s_id,unsigned int elfTypeId);
	SpriteElf* GetOneInstanceFromPos(PLAYER_ID s_id,unsigned int pos);
	/**
	* Instruction : ����Id��ȡһ���������
	* @param 
	*/	

	SpriteElf* GetOneInstance(PLAYER_ID s_id,unsigned int elfTypeId);
	bool GetInstances(PLAYER_ID s_id,std::map<unsigned int,SpriteElf*>& elfs);
	bool IsHasElfAtPos(PLAYER_ID s_id,unsigned int pos);

	/**
	* Instruction : ��ȡ���еľ���ʵ��
	* @param 
	*/	
	const std::map<PLAYER_ID, std::map<unsigned int,SpriteElf*> >& GetAllInstance(void) const 
	{
		return m_mapElfIdAndInstances;
	}

	/**
	* Instruction : ���ݾ���Idɾ������
	* @param 
	*/	
	bool RemoveOneElf(PLAYER_ID s_id,unsigned int elfTypeId,bool bDeleteElf  = true);

	// Note: ɾ��Ӣ�۰󶨵����о���
	bool RemoveElfFromHero(PLAYER_ID s_id,bool bDeleteElf  = true);
    bool RemovePosElfFromHero(PLAYER_ID s_id);
	/**
	* Instruction : �󶨾��鵺��������
	* @param 
	*/
	void AttachElfToOneHero(unsigned int elfTypeId, PLAYER_ID heroId, unsigned int grade, SpriteSeer* parent = 0);

	/**
	* Instruction : ��վ���
	* @param 
	*/
	void ClearAllData();

	/**
	* Instruction : ɾ�����еľ���
	* @param 
	*/
	void RemoveAllElfInstance();

	/**
	* Instruction : ����һ��׷��״̬
	* @param 
	*/
	void PushOneElfChaseState(SpriteSeer* pHero,int skillId,BaseElfAttachData* pData = 0);

	/**
	* Instruction : ����һ������״̬
	* @param 
	*/
	void PushOneElfCloseToState(SpriteSeer* pHero,int skillId,BaseElfAttachData* pData = 0);

	/**
	* Instruction : ����һ������״̬
	* @param 
	*/
	void PushOneElfAttackState(SpriteSeer* pHero,int skillId,BaseElfAttachData* pData = 0);

	/**
	* Instruction : ����Ƿ����������Խ�������
	* @param 
	*/
	void CheckWhetherNewElfReleaseByReputation();

	/**
	* Instruction : called by LevelLayer
	* @param 
	*/	
	void Update(float dt);

	void SetPlayerElfPos(PLAYER_ID id,unsigned int elfId,EFairyPos pos);
	bool GetPlayerElfPos(PLAYER_ID id,unsigned int elfId,EFairyPos& pos);

	unsigned int GetFairyIdByPos(PLAYER_ID id, EFairyPos pos);
	int GetFairyRageBasicByPos(PLAYER_ID id, EFairyPos pos);
	int GetFairyRageRateByPos(PLAYER_ID id, EFairyPos pos);

	const std::map<PLAYER_ID, std::map<unsigned int,EFairyPos> >& GetElfPosInfo(){
		return m_mapElfIdAndPos;
	}
	bool IsHasElfPlay(PLAYER_ID s_id);

	void DoObserverEvent(PLAYER_ID id,unsigned int elfId,unsigned int type);
	void AddAssistSkillStartObserver(ElfAssistSkillObserver* pObserver);
	void RemoveAssistSkillObserver(ElfAssistSkillObserver* pObserver);\

	// Note: ������������
	void CreateAssistElfs();
protected:
	/**
	* Instruction : ���һ��ʵ��
	* @param 
	*/	
	bool Add(PLAYER_ID id,SpriteElf * instance,unsigned int elfTypeId);
	bool AddAssistElf(PLAYER_ID id,SpriteElf * instance,unsigned int elfTypeId);
public:
	// Note: ��������
	static cocos2d::CCPoint s_fixDistanceToHero;
protected:
	std::map<PLAYER_ID, std::map<unsigned int,SpriteElf*> > m_mapElfIdAndInstances;
	std::map<PLAYER_ID, std::map<unsigned int,EFairyPos> > m_mapElfIdAndPos;

	std::vector<ElfAssistSkillObserver*> m_vecAssistSkillEventObserver;	

	std::map<PLAYER_ID, std::map<unsigned int,SpriteElf*> > m_mapAssistElfIdAndInstances;
};
