#pragma once

extern "C" {
#	include "lua.h"
#	include "lualib.h"
#	include "lauxlib.h"
}

class TaskConfigFromLuaManager
{
public :	
	virtual ~TaskConfigFromLuaManager();
	static TaskConfigFromLuaManager* getInstance(void);
	static void Destroy();

	virtual void initLuaState();

	bool checkTaskDataCotent();
	bool IsTaskWaitForGetReward(unsigned int task_id,unsigned int task_step);
	unsigned int GetTaskAttachNpcId(unsigned int task_id);
	const char*  GetOneTaskName(unsigned int task_id);
	bool GetOneTaskRewardMoney(unsigned int task_id,unsigned int &moneyNum);
	bool GetOneTaskRewardExp(unsigned int task_id,unsigned int &expNum);
	/**
	* Instruction : 
	* @param 
	*/
	unsigned int GetOneTaskStepNums(unsigned int task_id);
	/**
	* Instruction : ��ȡ��������ʱNPC�Ի�ʱ˵������
	* @param 
	*/
	const char* GetRecieveTextFromNpc(unsigned int task_id,unsigned int talk_index);
	/**
	* Instruction : ��ȡ��������ʱHero�Ի�ʱ˵������
	* @param 
	*/
	const char* GetRecieveTextFromHero(unsigned int task_id,unsigned int talk_index);
	/**
	* Instruction : ��ȡ����ı�
	* @param 
	*/
	const char* GetCommonCompleteContent();
	/**
	* Instruction : �жϽ�������Ի��Ƿ����
	* @param 
	*/
	bool TellIsRecieveTalkOver(unsigned int task_id,unsigned int talk_index);
	/**
	* Instruction : ��ȡ��ȡ����ʱNPC�Ի�ʱ˵������
	* @param 
	*/
	const char* GetCompleteTextFromNpc(unsigned int task_id,unsigned int talk_index);
	/**
	* Instruction : ��ȡ��ȡ����ʱHero�Ի�ʱ˵������
	* @param 
	*/
	const char* GetCompleteTextFromHero(unsigned int task_id,unsigned int talk_index);
	/**
	* Instruction : �ж���ȡ�����Ի��Ƿ����
	* @param 
	*/
	bool TellIsCompleteTalkOver(unsigned int task_id,unsigned int talk_index);
	/**
	* Instruction : ��ȡNpc���õĶԻ�
	* @param 
	*/
	const char* GetCommonNpcTalkFlagString();
	/**
	* Instruction : ��ȡHero���õĶԻ�
	* @param 
	*/
	const char* GetCommonHeroTalkFlagString();
	/**
	* Instruction : ��ȡ��������� 1 �Ի� 2ͨ�� 3ɱ�� 4�ռ�
	* @param 
	*/
	unsigned int GetOneTaskType(unsigned int task_id);
	/**
	* Instruction : ��ȡĳ������Ҫ�Ի���Npc��id
	* @param 
	*/
	unsigned int GetOneTaskTalkToNpcId(unsigned int task_id);
	/**
	* Instruction : ��ȡĳһ��������icon
	* @param 
	*/
	const char* GetOneTaskClearanceIconName(unsigned int task_id,unsigned int step);
	/**
	* Instruction : ��ȡ������صĸ������id
	* @param 
	*/
	unsigned int GetOneTaskInstanceId(unsigned int task_id,unsigned int step);
	/**
	* Instruction : ��ȡ��������
	* @param 
	*/
	const char* GetOneTaskDescription(unsigned int task_id);
	/**
	* Instruction : ��ȡ�������
	* @param 
	*/
	const char* GetOneTaskProgress(unsigned int task_id,int value,bool bWaitForReward);
	/**
	* Instruction : ��ȡĳ�����õĽ�������ID
	* @param 
	*/
	unsigned int GetOneTaskRewardElfID(unsigned int task_id);
private:
	TaskConfigFromLuaManager();

	lua_State *m_configLuaState;

	bool m_isLoadTaskData;
};