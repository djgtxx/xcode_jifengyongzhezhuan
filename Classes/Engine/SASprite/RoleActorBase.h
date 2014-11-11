#pragma once

#include "cocos2d.h"
#include "iostream"

#include "SASpriteDefine.h"
#include "CArmature.h"
#include "BoneSpriteBase.h"

class BoneSpriteBase;

using namespace cocos2d;

/*�Ǽܶ�����ι���*/
class RoleActorBase : public CCArmature,
					  public CCAnimationEventListener
{
	
public:
	virtual ~RoleActorBase(void);


	/************************************************************************
	* param:
	* _name: �Ǽ���
	* _animationName: ������
	* _plistPath: pList·��
	* _imagePath: png·��
	* png_file_name: ��Դ�ļ���
	* _index: ��
	************************************************************************/
	static RoleActorBase *create(std::string _name, std::string _animationName, 
								 std::string png_file_name, int _index = 0);

	// ��ʼ����������
	virtual bool init(std::string _name, std::string _animationName,
					  CCSpriteBatchNode * _batchNodeL, int _index = 0);
	/************************************************************************
	* param:
	* _aniType: start , complete , loopComplete , inFrame
	* _aniID: ������
	* _frameID: ֡ID	
	************************************************************************/
	virtual void animationHandler(const char* _aniType, const char* _aniID, const char* _frameID);

	/************************************************************************
	* ���ö��������Ľ�ɫ
	************************************************************************/
	bool setParentRole(BoneSpriteBase *parent);
	bool setParentAnimListerner(CCAnimationEventListener* pListerner);

	CCSpriteBatchNode *getBatchNode(){return mBatchNode;}

	static CCSpriteBatchNode * createBatchNode(std::string png_file_name);

protected:
	RoleActorBase();
	
private:
	BoneSpriteBase *mParentSpriteBase;
	CCSpriteBatchNode *mBatchNode;	
	CCAnimationEventListener* m_pAnimationEventListerner;
};