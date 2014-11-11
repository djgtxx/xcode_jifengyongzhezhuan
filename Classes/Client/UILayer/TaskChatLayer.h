#pragma once

#include "ASprite.h"
#include "UILayout.h"
#include "UIContainer.h"
#include "UIButton.h"
#include "UILabel.h"
#include "UIPicture.h"
#include "TaskData.h"
#include "vector"
using namespace std;
using namespace cocos2d;

class TaskChatLayer : public cocos2d::CCLayer
{
public:
	TaskChatLayer();
	virtual ~TaskChatLayer();

	CREATE_FUNC(TaskChatLayer);
	virtual bool init();

	void closeBtnClick(CCObject* sender);
	void ShowTaskChatLayer(unsigned int npc_id);
	void closeLayerCallBack(void);
protected:
	virtual void registerWithTouchDispatcher();
	virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);

	/**
	* Instruction : ��ʾ���ͷ��
	* @param 
	*/	
	void ShowLeftRightNpcIcon(std::string iconName);
	/**
	* Instruction : ��ʾ���������
	* @param 
	*/	
	void ShowTaskNameOrNpc(std::string task_name);
	/**
	* Instruction : ��ʾNpc˵�������ݣ�������+�Ի����ݣ�
	* @param 
	*/	
	void ShowTaskTalkContentOrMotto(std::string task_cotent);
	/**
	* Instruction : ��ҶԻ�������
	* @param 
	*/	
	void ShowHeroTalkContent(std::string task_cotent);
	/**
	* Instruction : ��ʾ�����б�
	* @param 
	*/
	void ShowTaskList(unsigned int npc_id);
	/**
	* Instruction : 
	* @param 
	*/
	void HideAllTaskList();
	/**
	* Instruction : ��ʾһ��������Ϣ
	* @param index 0-2 ���� 1-3 task item
	*/
	void ShowOneTaskItem(unsigned int task_id,int index);
	/**
	* Instruction : ��ʾ��������
	* @param 
	*/	
	void ShowRewardContent(unsigned int icon_reward,unsigned int exp_reward);
	/**
	* Instruction : ��ʾ����״̬ δ�� ������ ��ȡ����
	* @param 
	*/
	void ShowTaskItemWithFlagStateAndName(int itemIndex,eTaskState taskState,std::string content);

	/**
	* Instruction : ��������Ľ���
	* @param 
	*/
	void ShowTaskReward(unsigned int money,unsigned int exp);

	// Note: ����Item�����Ļص�����
	void OnTaskItemClickEvent_01(CCObject* sender);
	void OnTaskItemClickEvent_02(CCObject* sender);
	void OnTaskItemClickEvent_03(CCObject* sender);
    void OnTaskshopExchangeBtnClick(CCObject* sender);
	void OnOneTaskItemClick(unsigned int index);
    void OnTaskCityDefendBtnClick(CCObject* sender);
    void OnTaskItemExchangeBtnClick(CCObject* sender);

	// Note: ��ʼ�Ի�����
	/**
	* Instruction : ��������ʱ�ĶԻ�
	* @param 
	*/	
	void TrackAcceptTaskWork(bool bClear = false,unsigned int task_id = 0);
	/**
	* Instruction : �������ʱ�ĶԻ�
	* @param 
	*/
	void TrackAcceptRewardWork(bool bClear = false,unsigned int task_id = 0);
	/**
	* Instruction : ����������ʱ�ĶԻ�
	* @param 
	*/
	void TrackAcceptRunningWork(bool bClear = false,unsigned int task_id = 0);

	/**
	* Instruction : ������ʾListItem
	* @param 
	*/
	void ShowOneTaskItemOrHideOnly(int index,bool bShow){
		m_taskContainerItem[index]->getCurrentNode()->setVisible(bShow);
	}
    
    void processExchangeShopFunc(int type, bool visible);
    void processItemExchangeFunc(bool visible);
    void processGuildChat(int type, bool visible);
private:
	std::vector<unsigned int> mVecTaskIds;

	TXGUI::UILayout *taskChatLayout;
	TXGUI::UIContainer* m_taskChatContainer;
	TXGUI::UIContainer* m_taskRewardContainer;
	TXGUI::UIPicture* m_leftHeroLogoPic;
	TXGUI::UILabel* m_taskNameLabel;
	TXGUI::UILabel* m_npcTaskTalkLabel;

	// Note: 3�� task item ��ص�����
	TXGUI::UIContainer* m_taskContainerItem[3];

	// Note: �������
	TXGUI::UILabel* m_rewardMoneyLabel;
	TXGUI::UILabel* m_rewardExpLabel;

	// Note: ����Ի����
	bool m_bStartAcceptTaskWork;
	bool m_bStartAcceptRewardWork;
	bool m_bStartRunningTaskWork;

	unsigned int mCurTaskId;
    
    int mShopType;
};