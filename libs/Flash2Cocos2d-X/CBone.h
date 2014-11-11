#pragma once

#include "CBaseNode.h"
#include "CTweenNode.h"
#include "CTween.h"

using namespace cocos2d;

#define  ANGLE_TO_RADIAN  (M_PI / 180)

class CCArmature;

class CCBone : public CCObject
{
public:
	/**
	* ����Boneʵ����Bone ��Ϊ���õ�ʵ�����ö���ع���������
	* @param _isRadian ������ת�Ƕ��Ƿ���û����ƣ����� Starling ʹ�õ��ǻ�����
	* @return ���� Bone ʵ��
	*/
	static CCBone* create(bool _isRadian = false,CCArmature *pArmature = NULL);

	static void	removePoolObject();

protected:

	//static CCArray	*sObjectPool;

	//static int		sPoolIndex;

	static void		recycle(CCBone* _bone);
	
	// �����������������!!!!
	CCBone();

public:
	~CCBone(void);

	virtual bool init(bool _isRadian,CCArmature *pArmature);

	
	/* ɾ�������� */
	void	remove();

	/* ����ӹ��� */
	void	addBoneChild(CCBone* _child);
	/* �����ڸ������еİ�λ�ã�����ӵ�� parent ʱ������ */
	void	setLockPosition(float _x, float _y, float _skewX = 0, float _skewY = 0);
	/* ����λ�� */
	void	update( float dt );
	/* ��ȡ�� Armatur.display �е�ȫ�� x ���� */
	float	 getGlobalX();
	/* ��ȡ�� Armatur.display �е�ȫ�� y ���� */
	float	getGlobalY();
	/* ��ȡ�� Armatur.display �е�ȫ�� rotation */
	float	getGlobalR();
	float	getGlobalSkewX();
	float	getGlobalSkewY();

	/* �жϹ����Ƿ�Ϊ����֡����*/
	bool    isBoneFrames();

	void	setTween(CCTween *_tween)
	{
		mAttachTweenNode = _tween;
	}

	CCTween*	getTween()
	{
		return mAttachTweenNode;
	}

	CCPoint& CreateBoneAnchorPt(std::string boneImageName);
public:

	/* ���� display */
	void updateDisplay();

	void reset();

public:

	/* �������� Armature ͨ������������ Bone��Animation ͨ������������ Bone �� Tween �Ĺ��� */	
	CC_SYNTHESIZE(const char *, mName, Name);
	
	/* �����󶨵���ʾ���󣬲����Ǳ���ģ����Բ�����ʾ���� */
	CC_SYNTHESIZE(CCNode	*, mDisplay, Display);

	/* �����ܿ��ƵĹؼ��� */
	CC_SYNTHESIZE(CCBaseNode	*, mNode, Node);

	/* �� Tween ���ƵĹؼ��㣬������ Tween ������ node �ĺ�ֵ���� */
	CC_SYNTHESIZE(CCTweenNode *, mTweenNode, TweenNode);

	CC_SYNTHESIZE(CCBone *, mParent, Parent);
	CC_SYNTHESIZE_PASS_BY_REF(std::string, mParentName, ParentName);

	/* �����Ƿ�Ϊ����֡����*/
	CC_SYNTHESIZE(bool, mIsFrames, IsFrames);

    /* ��Դ���� */
    CC_SYNTHESIZE(std::string, m_imageName, ImageName)

protected:
	
	bool	mIsRadian;
	float	mTransformX;
	float	mTransformY;
	float	mTransformSkewX;
	float	mTransformSkewY;
	float	mTransformRotation;
	float	mLockX;
	float	mLockY;
	float	mLockR;
	float	mLockSkewX;
	float	mLockSkewY;
	float	mParentX;
	float	mParentY;
	float	mParentR;
	float	mParentSkewX;
	float	mParentSkewY;

private:
	CCTween *mAttachTweenNode;
	CCArmature *mDependArmature;

	std::map<std::string,CCPoint> m_boneAttachAnchorPt;
};

