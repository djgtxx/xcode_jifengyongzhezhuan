#ifndef COMBO_LAYER_H
#define COMBO_LAYER_H

#include "cocos2d.h"
using namespace cocos2d; 

#define MAX_COMBO_NUMBER 999

class ComboLayer : public cocos2d::CCLayer
{
	enum ComboState
	{
		NONO_COMBO,
		COMBO_COME_IN,
		COMBO_COME_OUT,
		COMBO_SHOWING,
	};

public:
	ComboLayer();
	virtual ~ComboLayer();
	CREATE_FUNC(ComboLayer);

	virtual bool init();

	void HandleComboIncrease(unsigned int incremental);
	void onComboMoveInOver(CCNode* sender);
	void onComboMoveOutOver(CCNode* sender);
	void onComboScaleOver(CCNode* sender);
	unsigned int GetMaxComboNumber(){return m_maxComboNumber;}
protected:
	virtual void update(float time);

private:
	// combo������Ļ
	void comboComeIn();
	
	// combo��ʾ�и�������
	void updateComboNum();

	// combo������Ļ
	void comboComeOut();

	const char* getFontName(unsigned int num);
private:
	CCNode* m_comboNode;
	CCLabelAtlas* m_comboLabel;
	CCLabelAtlas* m_comboFrontLabel;
	unsigned int m_comboNumber; // ������
	unsigned int m_comboShow;	// ��ʾ��������
	long long m_lastHitTime;
	ComboState m_comboState;

	CCPoint m_hidingPoint;	// combo������ʼλ��
	CCPoint m_ExtraPoint;   // combo����ʱ����ͻ����λ��
	CCPoint m_showingPoint;	// combo��ʾʱͣ��λ��

	unsigned int m_maxComboNumber; // ���������
};

#endif