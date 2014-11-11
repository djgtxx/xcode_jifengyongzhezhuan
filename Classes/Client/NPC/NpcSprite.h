#pragma once

#include "string"
#include "cocos2d.h"
#include "NPCDataDefine.h"
#include "BoneSpriteMoveable.h"

USING_NS_CC;

// Note: NPCʵ����
class SpriteNPC :  public BoneSpriteMoveable
{
public:
	SpriteNPC(int type);
	virtual ~SpriteNPC();

	static SpriteNPC* NPCWithData(NPCData *pData);
	std::string GetName(){
		return mNpcDataInfo->mName;
	}

	virtual bool ccTouchBegan(cocos2d::CCTouch* touch, cocos2d::CCEvent* event);
	virtual void registerWithTouchDispatcher();
	virtual bool				isTouchSelf(cocos2d::CCPoint pt);
	virtual cocos2d::CCRect		getRect();

	void ShowFlagSignIcon(NPCFlagSign flag);
	void OneActorMoveEndEvent();
	NPCData* GetData(){return mNpcDataInfo;}
	/**
	* Instruction : �Ƶ���ĳ��
	* @param 
	*/
	void MoveToTarget(CCPoint pos,CCRect colliderRect = CCRectZero);
protected:
	virtual bool InitWithData(NPCData *pData);
	void PlayIdleAnimation();

	// Note: ��ȡNPC��ص�ͼ��
	void GetTaskFlagSignIcon();
	void GetUpLogoImageIcon();
	//void GetTaskIntroImageIcon();
	//void GetHeadImageIcon();
	void GetShadowImageIcon();

	// Note: ������Դ���ֵõ�CCSprite
	CCSprite* GetSpriteFromSystemIconByName(const char *rcs_name);

	// Note: ��NPC��ͼ��
	void AttachImageIcon();
private:
	std::string mName;
	NPCData*	mNpcDataInfo;

	// Note: Icon Asprite
	CCSprite *mTaskFlagSignIcon[3];
	CCSprite *mHeadImageIcon;
	ASprite *mShadowImageIcon;

	CCRect mSelfColliderRect;
};