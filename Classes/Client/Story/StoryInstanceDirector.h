#pragma once

/// <summary>
//	������
/// </summary>

#include "cocos2d.h"
#include "SpriteSeer.h"
#include "InstanceDialogLayer.h"
#include "CameraController.h"
#include "StoryDataCenter.h"
#include "TaskData.h"

class StoryInstanceDirector
{
public:
	StoryInstanceDirector();
	static StoryInstanceDirector* Get();
	static void Destroy();
public:
	/// <summary>
	//	���̿��Ʋ��ֽӿ�
	/// </summary>	
	void Begin(unsigned int id,unsigned int map_id,int nWhen,bool bTaskStory = false);	
	void End();
	void Update(float dt);
	void Resume();

	/**
	* Instruction : ��������
	* @param 
	*/	
	bool IsStart();
	void ResetValue();		
	void ResetAllData();
	void DarkEffectOver();

	/**
	* Instruction : �������Ǿ��鲥��״̬
	* @param 
	*/	
	void SendReqCheckPlayedStory();
	void PushUsedItemId(int id);
	bool IsOneItemUsed(int id);

	/**
	* Instruction : ���������״̬������
	* @param 
	*/	
	void UpdateByTaskState(unsigned int taskId,eTaskState taskState);

	void SetConfigDataReGetOrNot(bool bGet);
protected:
	void ShowBattleUILayer(bool bShow);
	void ShowMainLandUILayer(bool bShow);
	void ShowOtherPlayers(bool bShow);
	void ShowOtherElf(bool bShow);
	void ShowHeroElf(bool bShow);
	void LoadAllNeedRcs();
	void RemoveAndClearRcs();
	bool TrackDialogAnim(unsigned int frame);
	bool TrackPlayerAnim(unsigned int frame);
	bool TrackDisplayPicAnim(unsigned int frame);	
	SpriteSeer* GetOneRole(unsigned int indexId);
	void LoadAllRoles();
	void PlayBecomeDarkEffect();
	bool InitOnBegin();	
	void CheckStoryType();	
	void HideMainLandThings();
	void HideFBThings();
	void ShowMainLandThings();
	void ShowFBThings();
	void CreateChildLayers();
	void ClearChildLayers();
	void SetCameraFollowType(CameraController::CameraFollowType eFollowType);
	SpriteSeer* InsertOneRole(unsigned int indexId,unsigned int roleId,SpriteSeer *pDefaultSeer = 0,CCPoint pt = ccp(-1,-1));
public:
	CC_SYNTHESIZE(bool, m_IsFirstComeInInstance, IsFirstComeInInstance);
private:	
	int  m_cutAnimHappendWhen;	// Note: m_cutAnimHappendWhen ��������ʱ�� 0 ���븱�� 1 ������ 2 3 
	unsigned int mID;
	unsigned int mMapId;
	bool m_isHSJoystickEnable;
	bool m_isStart;
	bool m_isPause;
	bool m_isTaskStory;
	float m_curFrame;
	float m_preFrame;
	float m_totalFrames;
	unsigned int m_curKeyID;
	int m_heroIndex;
	CCLayerColor* m_pColorLayer;
	InstanceDialogLayer* m_dialogLayer;
	bool m_isWaitForBegin;
	bool m_isHeroAutoFight;
	float m_waitForBeginTotalTime;
	float m_waitFromBeginLastTime;
	std::set<int> m_usedStoryInstance;
	EStoryType m_eStoryType;
	std::map<unsigned int,SpriteSeer*> m_mapRoleIdAndInstance;

	SpriteSeer* cloneHero;
	bool bSendData;
};