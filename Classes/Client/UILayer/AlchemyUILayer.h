#ifndef ALCHEMY_UI_LAYER_H
#define ALCHEMY_UI_LAYER_H

#include "cocos2d.h"
#include "TXGUIHeader.h"
#include "ItemManager.h"
#include "cs_core.pb.h"
#include <vector>
using namespace cocos2d;
using namespace TXGUI;

typedef struct stAlchemyExchangeInfo
{
	stAlchemyExchangeInfo(){memset(this, 0x00, sizeof(stAlchemyExchangeInfo));}
	unsigned int ss_id;				// ��ʯid
	unsigned int consume;				// �������ľ�������
	unsigned int convert;				// �һ��ɾ�������
	unsigned int need_chip;			// ��Ҫ����Ƭ����
	unsigned int key;					// ��ʯ��Ӧ����key
	unsigned int value;				// ��ʯ��Ӧ����value
}AlchemyExInfo;

class AlchemyUILayer : public cocos2d::CCLayer,
					   public TXGUI::ObserverProtocol
{
public:
	AlchemyUILayer();
	virtual ~AlchemyUILayer();
	CREATE_FUNC(AlchemyUILayer);
	virtual bool init(); 

	// button callback 
	virtual void onClosedBtClicked(CCObject* sender);
	virtual void onClosedEquipBtClicked(CCObject* sender);
	virtual void onItemClicked(CCObject* sender);
	virtual void onEnterAlchemyBagClicked(CCObject* sender);
	virtual void onClosedExchangeBtClicked(CCObject* sender);
	virtual void onAlchemyExchangeClicked(CCObject* sender);
	virtual void onExchangeListItemClicked(CCObject* sender);
	virtual void onDragInAlchemyBtClicked(CCObject* sender);
	//void onClickHeroEquip(CCObject* sender);
	//void onClickFairyEquip(CCObject* sender);
	void onClickFindSoul(CCObject* sender);
	void onClickTopFind(CCObject* sender);
	void onClickAutoFind(CCObject* sender);
	void onClickTransAllStoneEnergy(CCObject* sender);
	void onClickUpgradeStone(CCObject* sender);
	void onClickExchangeBt(CCObject* sender);
	void onHelpButtonClicked(CCObject* sender);

	void onEquipClicked(CCObject* sender);
	//void onEquipmentTapped(CCObject* sender);
	//void onTapCancel(CCObject* sender);
	//void onItemTapped(CCObject* sender);
	//void onItemDoubleClicked(CCObject* sender);

	void onFairyListItemClicked(CCObject* sender);

	void setItemIcon(BackPackItem* item,unsigned int index);
	void selectUpgradeItem(unsigned int position,bool isEffect = false);
	void unselectUpgradeItem();
	int getCurrentAlchemyIndex(){return m_currentEquipPage;}
	void setNpcSelected(unsigned int index,bool isEffect = false);
	void onReceivedSearchResult(unsigned int coin,unsigned int npcIndex,unsigned int itemId);
	void onReceivedSearchError(unsigned err);
	void onReceivedUpgradeSuccess();
	void onReceivedExchangeInfo(CSGetExchangeSSInfoRsp* msg);
	void onReceivedEquipPageChanged();
	void onReceivedTopSearch();

	virtual void closeLayerCallBack(void);
	void onReceiveSpriteTrans();

	virtual void setVisible(bool visible);

	// ���������񵯿�ص�����s
	void onReceivedConfirmBagItemUnlock(CCObject* sender);
	void onReceivedCancellBagItemUnlock(CCObject* sender);
	void onReceivedConfirmTopSearch(CCObject* sender);

	void onMoveToBagCallback(CCObject* sender);
	void onUnEquipCallback(CCObject* sender);
	void onEquipOnCallback(CCObject* sender);

	// ȷ��ת��ȫ����ʯ
	void onReceivedConfirmTransAllStones(CCObject* sender);
protected:
	/// ��Ϣ��Ӧ����
	virtual void onBroadcastMessage(BroadcastMessage* msg);
	virtual void updateAutoSearch(float dt);
private:
	virtual bool initAlchemistStone();
	virtual bool initAlchemistStorage();
	virtual bool initAlchemistExchange();
	virtual void initNpcIcon();
	void initEquipFairyList();
	virtual void initAlchemyExItemInfo();
	void initTopSearchCost();
	virtual void setNpcHeadIcon(const char* name,const char* resoureName);

	virtual void addExchangeItem(unsigned int itemId,unsigned int index);
	void showSelectecdExchangeItem(unsigned int index);

	virtual void hideAlchemyLayer();
	virtual void showAlchemyLayer();
	virtual void hideAlchemyEquipLayer();
	virtual void showAlchemyEquipLayer();
	virtual void hideAlchemyExchangeLayer();
	virtual void showAlchemyExchangeLayer();

	void setBagItemIcon(BackPackItem* item,unsigned int position);
	void setStorageItemIcon(BackPackItem* item,unsigned int position);
	void setEquipItemIcon(BackPackItem* item,unsigned int position);
	void showEquipItems(bool isHero);
	void showHeroEquipItems();
	//void showFairyEquipItems();

	void setStoneEnergyLabel();
	void setSpiritChipLabel();
	void showSpriteParticleEffect(CCNode* parent,unsigned int id,CCPoint pt = CCPointZero);
	void setEnergyIconVisible(bool isVisible);

	void updateBottomDiamondLabel();
	void updateBottomCoinLabel();
	void updateBottomPieceLabel();
	void updateBottomSpLabel();
	void setUnlockEqiupLabel(int index,bool isVisible);

	void playTransEffect(UIButton* parentPt);

	void setNpcBigPic(unsigned int index);

	void reqToUnlockBagItem(unsigned int pos); // �������������
	void unselectAllBagItem(); // ȡ������item��ѡ��Ч��

	void setAutoSearchStatus(bool status);
	void setFairyListIcon(unsigned int index,CCSprite* icon,unsigned int lockLevel = 0);
	void setFairyIcon(unsigned int index,unsigned int pos);
	bool isFairyPosLocked(unsigned int pos);
	void showPlayerModle(UIScrollPage* modlePage);
	void showFairyModle(unsigned int fairyPos,unsigned int index);
	void resetFairyListPostion(int currentPage);
private:
	UILayout* m_uiLayout;
	UILayout* m_alchemyEquipLayout;
	UILayout* m_alchemyExchangeLayout;
	CCLayer* m_alchemistStoneLayer;
	CCLayer* m_alchemistStorageLayer;
	UIScrollList* m_exchangeList;
	std::map<unsigned int,unsigned int>* m_exchangeItemList;
	std::map<unsigned int,AlchemyExInfo> m_exchangeItemInfo;
	std::map<unsigned int,TXGUI::UIButton*>* m_fairyBtMap; 
	int m_lastClickedFairyIndex; // ��һ�ε���ľ����ǩ
	int m_currentEquipPage;
	unsigned int m_selectedExchangeIndex;
	UIButton* m_selectedButton;
	unsigned int m_selectedUpgradeItemPos;	// ׼����������ʯ�ڱ����е�λ��
	std::vector<IconButton*> m_bagListButton; 
	std::vector<IconButton*> m_storageListButton;
	//bool m_equipLayoutIndex; // װ���б���ʾ������һ��߾���ı�ǩ: true ���, false ����

	//UIButtonToggle* m_heroEquipToggle;
	//UIButtonToggle* m_fairyEquipToggle;
	UIPicture* m_heroEquipPic;
	UIPicture* m_fairyEquipPic;
	unsigned int m_selectedNpcIndex; // Ѱ���NPC

	unsigned int m_unLockExchangeId; // ����exchangeId
	unsigned int m_TopSearchCost;
	bool autoSearchFlag;
	unsigned int m_tipPos;
};

#endif