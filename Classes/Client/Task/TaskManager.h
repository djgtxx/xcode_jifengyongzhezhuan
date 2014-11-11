#pragma  once
#include "cocos2d.h"
#include "Singleton_t.h"
#include "vector"
#include "map"
#include "TaskData.h"
#include "NPCDataDefine.h"
#include "vector"
#include "SimpleTaskEventNotification.h"

#include "AutoTaskSystem.h"

class TaskManager : public SimpleTaskEventNotification
{
public :	
	virtual ~TaskManager();
	static TaskManager* getInstance(void);
	static void Destroy();

	void RqsTaskFromServer();
	void RqsTaskLogFromServer();
	void SetOneTaskStepToServer(unsigned int task_id,unsigned int step_id,unsigned int step_value);

	void AddOneAcceptableTask(unsigned int task_id){m_vecAcceptableTask->push_back(task_id);}
	void AddOneAcceptedTask(unsigned int task_id,tTaskStepData data){
		m_mapAcceptedTask->insert(std::make_pair(task_id,data));
	}

	void ClearTaskData();
	/**
	* Instruction : �õ������״̬ ������m_mapTaskData
	* @param 
	*/	
	void GetTasksMoreData();
	/**
	* Instruction : ��ȡ���ȼ���ߵ�����
	* @param 
	*/	
	void GetFirstLevelTaskID();
	/**
	* Instruction : 
	* @param 
	*/
	unsigned int OnlyGetFirstLevelTaskID(){return mCurFirstLevelTaskID;}
	/**
	* Instruction : �õ������״̬
	* @param 
	*/	
	eTaskState GetTaskState(unsigned int task_id);
	/**
	* Instruction : �������Ǻ�õ���������
	* @param 
	*/
	void UpdateTaskData();

	void SendAutoTaskSystemState();
	bool IsTaskBelongAutoTaskSystem(unsigned int taskId);
	/**
	* Instruction : ��ʾ����������Ϣ
	* @param 
	*/
	void ShowRewardTaskMessage(std::vector<unsigned int> &vecTaskIds);
	/**
	* Instruction : ��ȡNPC��ص�����
	* @param 
	*/
	void GetNpcTaskData();
	/**
	* Instruction : �õ�NPCͷ�Ϸ���
	* @param 
	*/
	NPCFlagSign GetNpcFlagIconState(unsigned int npcId);
	/**
	* Instruction : ����UI���
	* @param 
	*/
	void UpdateUI();
	/**
	* Instruction : ��������ͼ��
	* @param 
	*/
	void UpdateUpRightLogoIcon();
	/**
	* Instruction : ��������Ļ���Ͻ�ͼ���¼�
	* @param 
	*/
	void TackInstanceIconClickEvent();
	/**
	* Instruction : ��������id�Ƶ���Npc�򸱱����
	* @param 
	*/
	void MoveToOneTargetByTaskId(unsigned int task_id);
	/**
	* Instruction : �������ȼ���ȡĳNPC���е�����
	* @param 
	*/
	bool GetOneNpcTaskIdsByPriority(unsigned int npc_id,std::vector<unsigned int> &vecOut);
	/**
	* Instruction : ��ȡ��ĳNpc�жԻ����������id�б�
	* @param 
	*/
	std::vector<unsigned int> GetTalkTaskWithOneNpc(unsigned int npc_id);
	/**
	* Instruction : ��ȡ������ص�Npcͼ�꣨����ᷢ��ת�ƣ�
	* @param 
	*/
	unsigned int GetTaskAttachNpcId(unsigned int task_id);
	/**
	* Instruction : �ڸ����б�����ʾ��̾��ͼ��
	* @param 
	*/
	void ShowOneInstanceIconOnLayer(unsigned int instance_id,bool bShowTip = false);
	/**
	* Instruction : ����Զ�Ѱ·������
	* @param 
	*/
	void InterruptAutoGoToInstanceEvent();
	/**
	* Instruction : ��ȡĳ����������ʾLogo����
	* @param 
	*/
	std::string GetOneTaskUpRightLogoImage(unsigned int task_id);
	/**
	* Instruction : ��ȡ�ɽ�����
	* @param 
	*/
	std::vector<unsigned int> * GetAcceptableTasks(){
		return m_vecAcceptableTask;
	}
	/**
	* Instruction : ��ȡ�ѽ�����
	* @param 
	*/
	std::map<unsigned int,tTaskStepData> * GetAcceptedTasks(){
		return m_mapAcceptedTask;
	}
	/**
	* Instruction : ��ȡĳ����Ľ���
	* @param 
	*/
	std::string GetOneTaskProgreess(unsigned int task_id);

	void DisplayOneNpcChatLayer(int npcId);
	bool IsNpcHasWaitAcceptTask(int npcId);
	bool IsNpcHasWaitRewardTask(int npcId);
	void ResetValue();
private:
	TaskManager();

	// Note: First Data from server
	std::vector<unsigned int> *m_vecAcceptableTask;
	std::map<unsigned int,tTaskStepData> *m_mapAcceptedTask;

	// Note: ���������������
	std::map<unsigned int,TaskData> *m_mapTaskData;

	// Note: ÿ��NPC��ص���������
	std::map<unsigned int,std::vector<unsigned int> > *m_mapNpcIdAndTaskIds;

	unsigned int mCurFirstLevelTaskID;

	CC_SYNTHESIZE(unsigned int, mDialogNpcId, DialogNpcId);
	CC_SYNTHESIZE(eTaskGlobleState, mTaskState, TaskState);

	AutoTaskSystem* m_autoTaskSystem;
};