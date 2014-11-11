//
//  PPVELayer.h
//  iSeer
//
//  Created by arthurgong on 11-12-8.
//  Copyright 2011�� __MyCompanyName__. All rights reserved.
//
#pragma once

#include "AspriteManager.h"
#include "cocos2d.h"
#include "UIButton.h"
#include "UILayout.h"
#include "TXGUIHeader.h"

using namespace std;
using namespace cocos2d;
using namespace TXGUI;
//
// ������Ϸ�еĿ�ݹ����������칤����
//
class ChatToolbar : public CCLayer
{    
public:
	ChatToolbar();
	virtual ~ChatToolbar();

	CREATE_FUNC(ChatToolbar);
	virtual bool init();	

	void updateChatArea(float dt);

	void setChatBarVisible(bool isChatVisible,bool isFunctionVisible,bool isExtraVisible);
	// ��ʾ�����صײ��������isChatVisibleΪ���������isFunctionVisibleΪ�Ҳ�Ĺ�����,isExtraVisibleΪ����Ĺ��ܼ�
protected:
	/// callback of close button

private:
	UILayout* m_layout;
	UIContainer* m_chatContainer;
	UIContainer* m_functionContainer;
	UIContainer* m_extraContainer;
};