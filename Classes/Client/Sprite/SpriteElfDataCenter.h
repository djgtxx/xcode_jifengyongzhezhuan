#pragma once

#include "UserData.h"

//#include "vector"

//enum ElfState
//{
//	kType_Elf_WAITING = 1,
//	kType_Elf_NEW,
//	kType_Elf_FIGHT,
//	kType_Elf_UnKnow,
//};

// Note: �������ֵ
//class ElfAttachData
//{
//public:
//	ElfAttachData();
//
//	void SetElfId(int elfId);
//	void SetStateId(int stateId);
//public:
//	unsigned int nElfId;
//	int nState;
//};

// Note: �����������
class SpriteElfDataCenter
{
public:    	
	SpriteElfDataCenter();
	virtual ~SpriteElfDataCenter(); 

	static SpriteElfDataCenter* Get();
	static void Destroy();

	/**
	* Instruction : ���һ������ 1 ��������ȡ 2 �����Ȼ�ȡ
	* @param 
	*/	
	//void AddOneAttachData(ElfAttachData data);
	/**
	* Instruction : װ��ĳһ����
	* @param 
	*/	
	void EquipOneElf(unsigned int elfId);	
	/**
	* Instruction : ���ͻ�ȡ�����б�
	* @param 
	*/
	void SendGetElfListMessage(PLAYER_ID roleId,const char* name);
	/**
	* Instruction : ���þ����״̬
	* @param 
	*/
	void SendSetElfStateMessage(unsigned int elfId,int state);
	/**
	* Instruction : ����ĳ������״̬
	* @param 
	*/	
	//void SetOneElfState(unsigned int elfId,int state);
	/**
	* Instruction : ��ȡĳ�����״̬
	* @param 
	*/
	//unsigned int GetOneElfState(unsigned int elfId);

	//std::vector<ElfAttachData> GetElfData()
	//{
	//	return m_vecElfData;
	//}

	/**
	* Instruction : ��ȡ���ǵ�ID
	* @param 
	*/
	PLAYER_ID GetHeroUserId();
	/**
	* Instruction : 
	* @param 
	*/
	void ResetValue();
protected:	

private:	
	//unsigned int m_nEquipElfId;
	////std::map<unsigned int,ElfAttachData> m_mapElfIdAndValue;
	//std::vector<ElfAttachData> m_vecElfData;

	bool m_bHeroHasSendMessage;
};