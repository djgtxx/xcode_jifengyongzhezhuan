#ifndef CARD_UI_LAYER_H
#define CARD_UI_LAYER_H

#include "cocos2d.h"
#include "TXGUIHeader.h"
#include "ItemManager.h"
#include "CardMixLayer.h"
#include <vector>
using namespace cocos2d;
using namespace TXGUI;

#define CONTELLATION_NUMBER 12

class CardUILayer : public cocos2d::CCLayer,
					public TXGUI::ObserverProtocol
{
public: 
	CardUILayer();
	virtual ~CardUILayer();
	CREATE_FUNC(CardUILayer);
	virtual bool init();

	void reOrderBagItems(CCObject* obj);
	void onCloseBtClicked(CCObject* obj);
	void onConstellationItemClicked(CCObject* obj);

	void onBagItemClicked(CCObject* obj);
	void onShopItemCLicked(CCObject* obj);

	//void onBagItemDoubleClicked(CCObject* obj);
	//void onBagItemTapped(CCObject* obj);
	//void onBagItemTapCancell(CCObject* obj);
	//void onEquipmentTapped(CCObject* obj);

	void onShopBtClicked(CCObject* obj);
	//void onShopItemDoubleClicked(CCObject* obj);
	// װ�����Ƶ��
	void onEquipCardBtClicked(CCObject* obj);

	void onReceiveConfirmBuyCard(CCObject* obj);
	void onReceiveConfirmUnlock(CCObject* obj);
	void onHelpButtonClicked(CCObject* sender);

	virtual void closeLayerCallBack(void);

	void onCardMixCallBack(CCObject* sender);
	void onCardMultiMixCallBack(CCObject* sender);
	void onCardSellCallBack(CCObject* sender);
	void onCardByeClicked(CCObject* sender);

	void onCardAttrPanelBtClicked(CCObject* sender);

	void setCardItem(BackPackItem* item, unsigned int pos);

	void setCardBagItem(BackPackItem* item, unsigned int pos,bool isInit = false);

	// ����
	void reqBuyCard(unsigned int exchangeId);

	// ����װ����
	void reqUnlockEquipCard(unsigned int pos,bool firstLock,bool secondLock);

	// ���ƺϳɻص�
	void onReceivedCardComposeSuccess(int error);

	virtual void setVisible(bool visible);
protected:
	/// ��Ϣ��Ӧ����
	virtual void onBroadcastMessage(BroadcastMessage* msg);

private:
	// ��ʾ�ײ���ʯ����
	void showDiamondLabel();
	// ��ʾ�ײ��������
	void showGoldLabel();

	// ��ʾ�̵�, ����װ��
	void showCardShop(bool isShowShop);

	void showConstelationName(unsigned int index);

	void initCardBagItem();
	void initConstellationItem();
	void initCardShop();
	void setConstellationDefaultSelect();
	void showSelectConstellation(unsigned int index);
	
	void showConstellationCard(BackPackItem* item,unsigned int index,bool isAnim = false);
	void showConstellationItem(unsigned int index,CCSprite* icon,bool isLock,bool isDrag,const char* attrText,bool isAnim = false);
	void setConstellationCardLock(bool isLock,unsigned int index,bool isAnim = false);

	CCSprite* getBagCardSprite(CCSprite* icon,unsigned int cardNum,const char* cardName);
	CCSprite* getCardSprite(unsigned int itemID,unsigned int key,unsigned int level);
	CCSprite* getCardNumSprite(unsigned int num);
	CCSprite* getCardIconById(unsigned int itemID);
	CCSprite* getCardBackPicByKey(unsigned int key);
	CCSprite* getCardFrontPicByKey(unsigned int key);
	//const char* getCardAttrText(unsigned int key,unsigned int num);
	// ��̬�����̵�
	void addShopItem(ExchangeItem* item);

	// �ϳɿ���
	void reqToMixCard(unsigned int cardId,ExchangeItem* item,bool isMultiMix = false);

	unsigned int getSingleUnlockCost(unsigned int index);
private:
	unsigned int m_bagItemPos;
	unsigned int m_shopItemPos;

	UILayout* m_uiLayout;
	UIScrollPage* m_bagScrollPage;
	CardMixLayer* m_mixLayer;

	unsigned int m_constellationIndex; // �������
	UIButton* m_selectedListButton;

	bool initShopFlag;
	unsigned int m_currentShopIndex;

	unsigned int m_shopSelectedItem; // ѡ���������Ʒ
	unsigned int m_unLockIndex; // �����ĸ���
	unsigned int m_unLockExchangeId;
};

#endif