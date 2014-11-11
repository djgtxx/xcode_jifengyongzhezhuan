#pragma once

#include "cocos2d.h"
#include "cocos-ext.h"
#include "string"
#include "UILayout.h"
#include "TutorialBase.h"
#include "TutorialLayer.h"
#include "TutorialsDataCenter.h"
#include "UIButton.h"
#include "IconButton.h"

USING_NS_CC;
USING_NS_CC_EXT;

class UITutorial : public TutorialBase
{
public:
	enum
	{
		kType_Tutorail_UnKnow = 0,
		kType_Tutorial_Normal ,
		kType_Tutorial_Drag,
		kType_Tutorial_TaskLead,
	};

	enum
	{
		kType_Event_UnKnow = 0,
		kType_Event_Click ,
		kType_Event_DoubleClick,
		kType_Event_ContinueClick,
	};
public:
	UITutorial();
	UITutorial(unsigned int id,TutorialDataCenter* pDataCenter);
	virtual ~UITutorial();

	void Reset();

	void Start(const char * attachStartControlName = "");
	void End();
	void Update(float dt);

	// Note: ������ ˫�� �����¼�
	bool HandleOneEvent(const char* name,unsigned int type);
	// Note: �����û���ק�¼�
	bool HandleDragEventOver(int type = 0,int pos = 0,bool bInEmptyUI = false);
	// Note: �жϵ�ǰ�Ƿ�����ק�̳���
	bool IsInDragTutorial();
	// Note: �ж��Ƿ��ڽ̳���
	bool IsInTutorial();
protected:
	void HandleOneTutorialItem();
	void HandleOneTutorialItemWithDelay(unsigned int numFrames = 2);
	void HightLightControls();
	void HightLightOneControl(TXGUI::UIButton *pBtn,unsigned int id);
	void HightLightOneControl(TXGUI::IconButton *pBtn,unsigned int id);
    void HightLightOneControl(CCControlButton*, unsigned int id);
	void ResetOneControl(TXGUI::UIButton* pBtn);
	void ResetOneControl(TXGUI::IconButton* pBtn);
	void ResetAllControl();

	void HandleOneTutorialItemWithExpandMenuOver();
	void ShowFlagIconWithOneContorl(TXGUI::UIButton *pBtn,unsigned int id);
	void ShowFlagIconWithOneContorl(TXGUI::IconButton *pBtn,unsigned int id);
    void ShowFlagIconWithOneContorl(CCControlButton* pBtn, unsigned int id);

	void InitNextTutorial();
	void MoveNextTutorial();	

	bool IsLayoutVisiable(TXGUI::UILayout* pLayout);
	void ResetTutorialValue();

	void GetLayerControls(std::string name,int id,unsigned int type);
	/**
	* Instruction : ��ʼһ����ѧ��ʱ�� ������а�ť��״̬ 
	* @param 
	*/	
	void FirstCheckAllReleaseControls(const char * attachStartControlName = "");

	void SetTutorailType(unsigned int type);
private:
	TutorialDataCenter* mDataCenter;
	TutorialLayer* mTutorialLayer;
	TXGUI::UILayout* mCurLayout;
	TXGUI::UILayout* mDstLayout;

	std::string mCurLayoutName;
	std::string mDstLayoutName;
	unsigned int mDelayFrames;
	unsigned int mRunningFrames;	
	bool mIsStartFrameCount;
	unsigned int mControlItemOldPripority;

	// Note: ��ǰ�̳����� 1 ��� 2 ��ק 3 ��������
	unsigned int mCurUITutorialType;

	// Note: ��קUI����
	int mDragUIType;
	// Note: ��ק��Ŀ��pos
	unsigned int mDragToUIPos;
	// Note: 1 ���� 2 ˫�� 3 ����
	unsigned int mEventType;
	// Note: ��ǰ��ť����
	std::string mCurActiveControlName;

	// Note: ���ڼ���Flagͼ���λ��
	bool mIsStartCalControlPos;
	CCPoint mOldButtonPoint;
	CCPoint mOldButtonPoint_2;

	// Note: ��ǰ�ؼ�
	TXGUI::UIButton* mCurActiveUIButton;
	TXGUI::IconButton* mCurActiveIconButton;
	TXGUI::UIButton* mCurActiveUIButton_2;
	TXGUI::IconButton* mCurActiveIconButton_2;
    CCControlButton* mCurActiveControlButton;
    CCControlButton* mCurActiveControlButton_2;

	// Note: �ؼ�����
	std::string mControlName;
	std::string mControlName_2;
	unsigned int mControlType;
	unsigned int mControlType_2;

	bool mIsNextTutorialNewWnd;
	bool mIsAllowInEmptyArea;
	bool mIsCareDstPos;

	enum ETutorialLayout {FIRTST_LAYOUT = 1,SECOND_LAYOUT = 2};
	enum EControlType {UIBUTTON_TYPE = 1,ICONBUTTON_TYPE = 2};	

	bool mIsEndWithSpecialControl;
};