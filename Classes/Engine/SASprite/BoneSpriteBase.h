#pragma once

#include "cocos2d.h"
#include "SpriteBase.h"
#include "BoneAnimSprite.h"
#include "AreaItemNode.h"

class BoneAnimSprite;
class ABoxAnimation;
class EffectSprite;

//////////////////////////////////////////////////////////////////////////
//the base class for all level object
//////////////////////////////////////////////////////////////////////////
class BoneSpriteBase :public SpriteBase,public AreaItemNode
{
public: 
	BoneSpriteBase(int type);
	virtual ~BoneSpriteBase();

	//position and rect
	virtual void setPosition(const CCPoint &position);
	virtual cocos2d::CCPoint	getPosition();

	virtual cocos2d::CCRect		getRelativeParentColliderRect(void);	
	virtual cocos2d::CCRect		getRelativeParentAttackBox(void);
	virtual cocos2d::CCRect		getRelativeParentViewRect(void);

	void						attachBoneAnimToRootSprite(int depth);

	/// set box animation data
	void SetBoxAnimation(ABoxAnimation* boxAnimation);

	/// get box animation data
	const ABoxAnimation* GetBoxAnimation();

	///
	virtual void SetAnim(int animId, int nloop, bool isLoop = true,BoneSpriteBase *listerner = NULL);
	virtual void SetAnim(int animId, int nloop, bool isLoop ,CCAnimationEventListener *listerner);

	void	PauseAllArmatureAnim();
	///
	virtual void SetAnimFlipX(bool bFlipsX /* = false */);

	/// 
	virtual void SetAnimPauseOnOver(bool bPause = false);

	/************************************************************************
	* param:
	* _aniType: start , complete , loopComplete , inFrame
	* _aniID: ������
	* _frameID: ֡ID	
	************************************************************************/
	virtual void animationHandler(const char* _aniType, const char* _aniID, const char* _frameID);

	virtual void resetParentRole(BoneSpriteBase *parent);

	virtual int getCurAnimationFrameID();
	virtual ANIMATION_STATE getCurAnimationState();

	virtual bool getAttachPoint(int pointPosType,cocos2d::CCPoint &point);

	void drawEditorRect();
	
	/**
	* Instruction : 
	* @param 
	*/
	virtual void retainAllUsedTextureFrames();

	/**
	* Instruction : 
	* @param 
	*/
	virtual void releaseAllUsedTextureFrames();

	/**
	* Instruction : ��ɫͨ����ɫ
	* @param 
	*/
	virtual bool playBecomeRedEffect(bool isMonster);

	/**
	* Instruction : ��ԭ����ʼ��ɫ
	* @param 
	*/
	virtual void revertToOriginColor();

	/**
	* Instruction : �ػ�
	* @param 
	*/	
	virtual void draw();

	/**
	* Instruction : ��ȡ��ɫ����󶨵��λ��
	* @param 
	*/
	cocos2d::CCPoint getAttachPoint(ATTACH_POINT_TYPE type);

	/**
	* Instruction : ����������ϵ�װ������װʹ��
	* @param 
	*/
	void SetEquipItemsData(unsigned int id);
	unsigned int GetEquipWeaponId();

	unsigned int GetAnimID(void);
	bool IsAnimFlipX(void);

	virtual void SetRoleOpacity(GLubyte var);
	virtual GLubyte GetRoleOpacity(void);

	CCPoint GetItemPosition();
	//float GetHideDistance();
	void SetUpdateOrNot(bool bUpdate);
	virtual CCRect GetABBox();

	virtual void unscheduleAllAnimationUpdate();
    
    virtual void setVisible(bool visible);
protected:

	//check touch event
	virtual bool				canDealWithTouch(cocos2d::CCTouch* touch);
	virtual bool				containsTouchLocation(cocos2d::CCTouch* touch);	
	virtual bool				isTouchSelf(cocos2d::CCPoint pt);
public:
	CC_SYNTHESIZE(bool ,mShadowVisible,	ShadowVisible);
protected:
	bool	m_bInRedState;
	float	m_InRedTime;
	bool	m_bShowColliderBox;
	bool	m_bShowAttackBox;
	bool	m_bShowViewBox;
	bool    m_isAnimLoop;
	BoneAnimSprite*		m_animBone;
	EffectSprite* m_effectSprite;
	ABoxAnimation* m_boxAnimation; 
	ANIMATION_STATE m_animationState;	

	GLubyte m_alpha;
	unsigned int weaponId;

};