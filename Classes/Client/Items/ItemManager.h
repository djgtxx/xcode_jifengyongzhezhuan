#ifndef ITEM_MANAGER_H
#define ITEM_MANAGER_H

#include "Singleton_t.h"
#include "cocos2d.h"
#include "EncodeValue.hpp"
#include <map>
#include <list>
#include "ItemBase.h"
#include "EquipmentItem.h"
#include "cs_core.pb.h"
using namespace cocos2d;
using namespace std;

#define AlCHEMYBAGCAPACITY	30
#define AlCHEMYSTORAGECAPACITY	18
#define FAIRYFRAGMENTBAGCAPACITY 200

/*
// id 0~999 ������ 1000~1999 �ֿ�� 2000~2999 װ���� 3000~3999 ��ʯ�� 4000~4999 ��ʯ�ֿ� 5000~5999 ��ʯװ���� 7000 ~ 7999 ��ʯ�� 8000 ~ 8999 ���Ʊ��� 9000 ~ 9999 ����װ��
	10001 ~ 10100 ׯ԰�� 50000+ ����վ
*/
enum
{
	kItemBag = 0,
	kItemStorage = 1000,
	kItemHeroEquip = 2000,
	kItemEnchaseEquip = 2050, //������ǶλΪװ��λ+50
	kItemFairyEquip = 2100,
	kAlchemyBag = 3000,
	kAlchemyStorage = 4000,
	kAlchemyHeroEquip = 5000,
	kAlchemyFairyEquip = 5100,
	kFairyStartId = 6000,
	kItemGemStone = 7000,
	kCardBag = 8000,
	kCardEquip = 9000,
	kItemManorId = 10000,
	kEquipFragmet = 11000,
	kFairyFragment = 12000,
	kItemRecycle = 50000,
};

typedef struct EquipmetHole
{
	// Note:  need
	EquipmetHole(){
		hole_index = 0;
		item_gem_id = 0;
		attr_key = 0;
		attr_value = 0;
		max_value = 0;
		min_value = 0;
	}
	EncodeValue<unsigned int> hole_index;		// �ױ��
	EncodeValue<unsigned int> item_gem_id;		// ��ʯid
	EncodeValue<unsigned int> attr_key;			// Ӱ�����Ե�key
	EncodeValue<unsigned int> attr_value;		// Ӱ�����Ե�value
	EncodeValue<unsigned int> max_value;			// ���Կ�����Сֵ
	EncodeValue<unsigned int> min_value;			// ���Կ������ֵ
}EQUIPHOLE;

typedef struct ItemAttribution
{
	ItemAttribution(){
		attr_key = 0;
		attr_basic_value = 0;
		attr_intensify_value = 0;
		attr_gem_value = 0;
	}
	EncodeValue<unsigned int> attr_key;					// ��Ʒ����key
	EncodeValue<unsigned int> attr_basic_value;			// ��Ʒ�������Զ�Ӧ��value
	EncodeValue<unsigned int> attr_intensify_value;		// ǿ��Ӱ����Ʒ����value����
	EncodeValue<unsigned int> attr_gem_value;			// ��ʯӰ����Ʒ����value����
}ITEMATTR;

typedef struct EquipNextAttribution
{
	EquipNextAttribution(){}
	unsigned int key;					// װ��ǿ����һ������key
	unsigned int value;					// װ��ǿ����һ������value
}EQUIPNEXTATTR;

typedef struct EquipmetInfo
{
	EquipmetInfo(){levelUpCost = 0;}
	unsigned int levelUpCost; // װ����������
	std::list<EQUIPNEXTATTR>	m_nextAttribution; // װ��ǿ����һ������
	std::vector<unsigned int> m_suitAttribution; // �������װ����
	std::map<unsigned int,EQUIPHOLE> m_equipHoles;	// װ����
}EQUIPINFO;

typedef struct SpriteStoneInfo
{
	SpriteStoneInfo()
	: levelUpCost(0)
	, convertSp(0)
	{}
	unsigned int levelUpCost; // ������Ҫ������
	unsigned int convertSp;	  // ת��������
}SPRITEINFO;

typedef struct ManorBaseInfo
{
	ManorBaseInfo()
		: hurtGetCoin(0)
		, pickGetExp(0)
	{
	}
	unsigned int hurtGetCoin; // ���Ի�ȡ���
	unsigned int pickGetExp;  // �ɼ���ȡ����
}MANORBASEINFO;

class BackPackItem
{
	// ������
public: 
	BackPackItem(unsigned int packType);
	~BackPackItem();
	ItemBase* getItemInfo();
	void setItemId(unsigned int id);
	void resetEquipInfo();
	void setEquipInfo(EquipmentBase base);
	unsigned int getItemId(){return itemId;}
	void setSpriteInfo(SpiritStoneBase base);
	void setManorInfo(const ManorBase &base);
	void resetItem();
public:
	bool isLocked;			// �Ƿ����
	bool isEmpty;			// �Ƿ�Ϊ��	
	bool b_isNew;				// �Ƿ�Ϊ�����
	unsigned int position;	// ��Ʒλ��
	unsigned int amount;	// ��Ʒ����
	unsigned int itemLevel;	// ��Ʒ�ȼ�
	EQUIPINFO* m_equipInfo;	// װ��ǿ������
	unsigned int packType; // �������ͣ� 0 ����; 1�ֿ� ; 2װ���� ;3 ��ʯ����;4 ��ʯ�ֿ� ; 5��ʯװ���� ;6 ����װ�� 7 ׯ԰ , 8������Ƭ
	std::list<ITEMATTR*>*	m_attribution;
	SPRITEINFO* m_spriteInfo; // ��ʯ��������
	MANORBASEINFO* m_manorBaseInfo; // ׯ԰��Ϣ

private:
	ItemBase* m_itemInfo;	    // ��Ʒ������������
	unsigned int itemId;		// ��ƷId	

};

class ExchangeItem
{
// ��Ʒ�������

public:
	ExchangeItem();
	~ExchangeItem();
	void setFromItems(std::string fromStr);
	void setToItems(std::string toStr);

	struct smaller
	{
		bool operator()(ExchangeItem* a,ExchangeItem* b)
		{
			return a->m_exchangeId < b->m_exchangeId;
		}
	};

private:
	std::list<std::pair<unsigned int ,unsigned int> >* initItemsByString(std::string str);
public:
	unsigned int m_exchangeType;
	unsigned int m_exchangeId;
	unsigned int m_requiredLevel;
	std::list<std::pair<unsigned int ,unsigned int> >* m_fromItems;
	std::list<std::pair<unsigned int ,unsigned int> >* m_toItems;
	/*std::map<unsigned int ,unsigned int>* m_fromItems;
	std::map<unsigned int ,unsigned int>* m_toItems;*/
};

typedef std::map<unsigned int ,BackPackItem*> BACKPACK_VECTOR;

class ItemManager : public TSingleton<ItemManager>
{
public:
	ItemManager();
	virtual ~ItemManager();

	void init();

	BackPackItem* findItemByPos(unsigned int pos);
	//bool addItem()	
	void resetItems();
	unsigned int getBackPackEmptyGridIndex();
	void setBackPackDefaultPos(unsigned int ownerPos);
	void setBackPackUnlockPos(unsigned int pos);
	void setStorageUnlockPos(unsigned int pos);
	void setEquipMaxTimes(unsigned int maxTimes);

	unsigned int getBackPackMaxPos(){return m_maxPackPos;}

	void openBackPack(bool withEquipment);
	void closeEquipment();

	void exchangeItemPos(unsigned int from, unsigned int to);
	void setItem(CSItemInfo info);

	void setStorageDefaultPos(unsigned int ownerPos);
	unsigned int getStorageEmptyGridIndex();
	unsigned int getAlchemyBagEmptyGridIndex();
	unsigned int getAlchemyEquipEmptyGridIndex(unsigned int index);

	unsigned int getStorageMaxPos(){return m_maxStoragePos;}

	void removeItem(unsigned int pos, unsigned int id);
	bool setEquipItemInfor(unsigned int pos,EquipmentBase equipmetInfo);
	void addExchangeItem(unsigned int exchangeId,std::string fromItems, std::string toItems,
						unsigned int type,unsigned int requiredLevel);

	bool checkEquipDrawingUseful(unsigned int drawingId);
	ItemBase* getItemInfoById(unsigned int id);
	ExchangeItem* getEquipDrawingById(unsigned int equipId); // ���ڲ��ҵ�from item���ҽ������
	ExchangeItem* getExchageItemById(unsigned int exchangeId);						 // ���ڱ��id���ұ��
	ExchangeItem* getExchageItemByIdWithType(unsigned int itemID,unsigned int type = 0);  // ���ڲ��ҵ�from item����ָ�����ͽ������,type Ϊ0��ʾ��������
	std::list<unsigned int>* getExchangeSpriteStones(int exchangeType);
	std::list<ExchangeItem*>* getExchangeItemsByType(unsigned int type); // �õ�����Ϊtype�����н�����Ϣ

	unsigned int getItemNumberInOnlyInBag(unsigned int id);
	unsigned int getItemNumberById(unsigned int id);

	// �����������õ����ƻ�ñ�������ʵbutton���ƣ�����ҳ
	string getItemButtonNameWithAjust(string turButtonName, bool ajust = true);
	string getTurEventNameByButtonName(string buttonName);

	CCSprite* getIconSpriteById(unsigned int ItemId);
	void loadExchangeItems();
	
	// ���������н����Ŀ�����
	void setConstellationCardNum(unsigned int card,unsigned int num);

	// alchemy
	
	void setAlchemyBagUnlockCapacity(unsigned int value);
	void setAlchemyStorageUnlockCapacity(unsigned int value);
	void setAlchemyBackDefaultCapacity(unsigned int pos);
	void setAlchemyStorageDefaultCapacity(unsigned int pos);
	void reqAlchemyUpgradeSelected(unsigned int pos);
	void reqAlchemyUpgradeUnselected();	
	int getCurrentAlchemyIndex();
	int getCurrentEquipmentIndex();
	bool checkPlayerEquipUnlock(int index);
	void checkAlchemyEquipUnlock();
	void showSpriteParticleEffect(CCNode* parent,unsigned int id,CCPoint pt);

	unsigned int getAlchemySearchNpcCost(unsigned int npcID);
	void showItemTipsByPos(unsigned int pos,CCPoint pt);
	void showItemTipsById(unsigned int itemId,CCPoint pt);
	void setTipDelegate(cocos2d::CCObject*	leftTarget,cocos2d::SEL_MenuHandler leftHandler,const char* leftText,bool isLeftVisible,
						cocos2d::CCObject*	rightTarget,cocos2d::SEL_MenuHandler rightHandler,const char* rightText,bool isRithtVisible);
	void setTipMiddleDelegate(cocos2d::CCObject*	leftTarget,cocos2d::SEL_MenuHandler leftHandler,const char* leftText,bool isLeftVisible);
	void setTipLuaHander(int leftHandler,const char* leftText,bool isLeftVisible,
						int rightHandler,const char* rightText,bool isRightVisible);
	void setMiddleLuaHander(int leftHandler,const char* leftText,bool isLeftVisible);
	// �����ļ� ��ʽ �� ����+����
	const char* getAttributionText(unsigned int key,unsigned int value);

	const char* getAttributionKeyText(unsigned int key);

	CCSprite* getIconFrame(unsigned int level);
	ccColor3B getLabelColorByQuality(unsigned int quality);
	ccColor3B getFairyLabelColorByQuality(unsigned int quality);

	// weapon id 
	unsigned int getHeroWeaponId();
	unsigned int getHeroDefautWeaponId(unsigned int heroTypeId);

	void checkBagEmptyItemNum();

	void clearItems();

	void setEquipNewNote(unsigned int pos,bool isNew);
	bool checkNewEquipInfo();
private: 
	// ��ʾ��Ʒ��Ϣ
	void showEquipmentTipByPos(BackPackItem* item,CCSprite* icon,CCPoint pt);
	void showEquipDrawingTipByPos(BackPackItem* item,CCSprite* icon,CCPoint pt);
	void showUnusedItemTipByPos(BackPackItem* item,CCSprite* icon,CCPoint pt);
	void showusedItemTipByPos(BackPackItem* item,CCSprite* icon,CCPoint pt);
	void showAlchemyItemTipByPos(BackPackItem* item,CCSprite* icon,CCPoint pt);
	void showCardItemTipByPos(BackPackItem* item,CCSprite* icon,CCPoint pt);

	void showEquipDrawingTipByItemid(ItemBase* item,CCSprite* icon,CCPoint pt);
	void showNormalItemTipByItemid(ItemBase* item,CCSprite* icon,CCPoint pt);
	void showCardTipByItemid(ItemBase* item,CCSprite* icon,CCPoint pt);
	void resetAlchemyBagPacks(unsigned int ownerPos);
	void resetAlchemyStoragePacks(unsigned int ownerPos);
	void resetBagPacks();
	void resetStoragePacks();

	unsigned int getEquipIdInDrawing(ExchangeItem* item);
	BackPackItem* getEquipmentByPos(unsigned int owner,unsigned int part);

	unsigned int getBagEmptyNum();
private:
	BACKPACK_VECTOR *m_backPackList;
	BACKPACK_VECTOR *m_storageList;
	BACKPACK_VECTOR *m_equipmentList;
	BACKPACK_VECTOR *m_equipEnchaseList;
	BACKPACK_VECTOR *m_fairyEquipmentList;
	BACKPACK_VECTOR *m_alchemyBagList;
	BACKPACK_VECTOR *m_alchemyStorageList;
	BACKPACK_VECTOR *m_alchemyEquipList;
	BACKPACK_VECTOR *m_alchemyFairyEquipList;
	BACKPACK_VECTOR *m_gemStoneList;
	BACKPACK_VECTOR *m_manorItemList;
	BACKPACK_VECTOR *m_recycleItemList;
	BACKPACK_VECTOR *m_cardBagList;
	BACKPACK_VECTOR *m_cardEquipList;
	BACKPACK_VECTOR *m_equipmentFragList;
	BACKPACK_VECTOR *m_fairyFragList;
	unsigned int m_maxPackPos;					// ������������
	unsigned int m_defaultPackPos;				//���Ĭ�ϵı���������
	unsigned int m_unlockPackPos;				//�ѽ����ı���������
	unsigned int m_maxStoragePos;				//�ֿ��������
	unsigned int m_defaultStoragePos;			//Ĭ�ϵĲֿ������
	unsigned int m_unlockStoragePos;			//�ѽ����Ĳֿ�ĸ�����
	unsigned int m_defaultAlchemyBagPos;		//Ĭ�ϵ�������������
	unsigned int m_unlockAlchemyBagPos;			//�ѽ�����������������
	unsigned int m_defaultAlchemyStoragePos;	//Ĭ�ϵ����𱳰�������
	unsigned int m_unlockAlchemyStroragePos;	//�ѽ��������𱳰�������
	unsigned int m_surplusGemRecastNum;			//Ĭ�ϱ�ʯ��������
	unsigned int m_defaultManorPackNum;			//Ĭ��ׯ԰����
	unsigned int m_defaultCardBagPos;			//Ĭ�Ͽ��Ʊ���������
	unsigned int m_defaultCardEquipPos;			//Ĭ�Ͽ���װ��������
	std::map<unsigned int ,unsigned int>* m_constellationCardNum;  // ��������������
	std::map<unsigned int ,unsigned int>* m_searchNpcCostMap;
	std::list<ExchangeItem*>* m_exchangeItemList;
	bool b_isLoadExchangeItems;
};

#endif	