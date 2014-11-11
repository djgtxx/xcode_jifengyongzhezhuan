//
//  MainMenuLayer.h
//  iSeer
//
//  Created by arthurgong on 11-12-8.
//  Copyright 2011�� __MyCompanyName__. All rights reserved.
//

#ifndef _MAIN_MENU_LAYER_
#define _MAIN_MENU_LAYER_

#include "AspriteManager.h"
#include "cocos2d.h"
#include "UIButton.h"
#include "DamageValueEffect.h"
#include "TaskChatLayer.h"
#include "UIMessageLayer.h"
#include "TaskListLayer.h"
#include "SpriteElfLayer.h"
#include "BattleCoverLayer.h"
#include "GameManager.h"
#include "SceneLayer.h"
#include "vector"

#include "cocos-ext.h"

using namespace std;
using namespace cocos2d;
USING_NS_CC_EXT;


class ItemDragLayer;
class BattleUILayer;
class GameUILayer;
class BackPackLayer;
class TaskChatLayer;
class TaskListLayer;
class InstanceListLayer;
class CityListLayer;
class BattleCoverLayer;
class EquipmentUpgradeUILayer;
class EquipMixLayer;
class AlchemyUILayer;
class PPVELayer;
class PVPLayer;
class TalentLayer;
class AutoOnHook;
class CardUILayer;

class SpriteElfLayer;
class ChatToolbar;

class WaitingLayer;
class LoadingLayer;

class MainMenuLayer : public cocos2d::CCLayer, public TXGUI::ObserverProtocol
{    
public:
    enum Z_MAINMENU
    {
        Z_ITEM_BACK,
        Z_ITEM_TOUCH,
        Z_ITEM_TOUCH2,
        Z_ITEM_BACK2,        
    };

public:
	MainMenuLayer();
	virtual ~MainMenuLayer();
   
	CREATE_FUNC(MainMenuLayer);
    virtual bool init();

	virtual void addChild(CCNode * child);
	virtual void addChild(CCNode * child, int zOrder);
	virtual void addChild(CCNode * child, int zOrder, int tag);
    
	static int getLayerTagByName(const char* name);
    
	virtual CCLayer* findUILayerByTag(int tag);
    
	template<class T>
	T* findUILayerByTag(int tag)
	{
		CCNode* node = this->getChildByTag(tag);
		if (dynamic_cast<T*>(node) != NULL)
		{
			return static_cast<T*>(node);
		}
		return NULL;
	}

	// ��ʾĳ��UI. isAutoCreate��ʾ��UI��û����������Ƿ��Զ�����.true �Զ�����δ��ʾ.false ����������NULL
	virtual CCLayer* showUILayerByTag(int tag,bool isAutoCreate = true);
    
	// ��ʾĳ��UI. isAutoCreate��ʾ��UI��û����������Ƿ��Զ�����.true �Զ�����δ��ʾ.false ����������NULL
	template<class T>
	static T* showUILayerByTag(int tag,bool isAutoCreate = true)
	{
		if(GameManager::Get()->GetSceneLayer())
		{
			MainMenuLayer * mLayer = GameManager::Get()->GetSceneLayer()->getMainMenuLayer();
			if (mLayer)
			{
				CCLayer* layer = mLayer->showUILayerByTag(tag,isAutoCreate);
				if (dynamic_cast<T*>(layer) != NULL)
				{
					return static_cast<T*>(layer);
				}
			}
		}
		return NULL;
	}
    
	// �õ�ĳ��UI. isAutoCreate��ʾ��UI��û����������Ƿ��Զ�����.true �Զ�����δ��ʾ.false ����������NULL
	virtual CCLayer* getUILayerByTag(int tag,bool isAutoCreate = true);

	// �õ�ĳ��UI. isAutoCreate��ʾ��UI��û����������Ƿ��Զ�����.true �Զ�����δ��ʾ.false ����������NULL
	template<class T>
	static T* getUILayerByTag(int tag,bool isAutoCreate = true)
	{
		if(GameManager::Get()->GetSceneLayer())
		{
			MainMenuLayer * mLayer = GameManager::Get()->GetSceneLayer()->getMainMenuLayer();
			if (mLayer)
			{
				CCLayer* layer = mLayer->getUILayerByTag(tag,isAutoCreate);
				if (dynamic_cast<T*>(layer) != NULL)
				{
					return static_cast<T*>(layer);
				}
			}
		}

		return NULL;
	}
	
	// ����UI�����ݸ�ϵͳ����ȷ�������ػ���ɾ��
	virtual void hideLayerByTag(int tag);

	static void hideUILayerByTag(int tag)
	{
		if(GameManager::Get()->GetSceneLayer())
			{
				MainMenuLayer * mLayer = GameManager::Get()->GetSceneLayer()->getMainMenuLayer();
				if (mLayer)
				{
					mLayer->hideLayerByTag(tag);
				}
			}
	}
    
	/// get gaming ui layer
	virtual GameUILayer* GetGameUILayer();
    
	//virtual BackPackLayer* GetBackPackLayer();

	virtual TaskChatLayer* GetTaskChatLayer();

	virtual TaskListLayer* GetTaskListLayer();
	/// change current UI to according to the current Map config
	virtual void ChangeMapUI(int mapID);

	void HandleDamageNumberEffect(CCPoint parentPt,unsigned int damage,bool isCrit,bool isHarmful = true,bool isFairyAttack = false);
	// �˺�����UI��damage �˺�,isCrit �Ƿ񱬻�,isHarmful �Ƿ�ж�Ŀ��
    
	void HandleAddBloodNumberEffect(CCPoint parentPt,unsigned int blood);

	void HandleAttackMissEffect(CCPoint parentPt);
	// ����miss
    
	void HandleAttackBlockEffect(CCPoint parentPt);
	// ��������

	void HandleComboIncrease(unsigned int incremental = 1);
	// ��������ʾ incremental����

	void HandleCritBurst(CCPoint pt,unsigned int effectType = 0);
	// �����ٶ���

	virtual UIMessageLayer* getUIMessageLayer();
	virtual WaitingLayer*  getWaitingLayer();
    
	//////////////////////////////
	///   ppve 
	/////////////////////////////
	virtual PPVELayer* ShowPPVELayer();
	virtual void HidePPVELayer(bool bShowGameUI);
	virtual PPVELayer* GetPPVELayer() {return m_pPPVELayer;}
	virtual bool IsInPPVEModule();

	virtual void HideGuildInstanceLayer(bool bShowGameUI);

    //pvp
    virtual PVPLayer* ShowPVPLayer();
    virtual void HidePVPLayer(bool bShowGameUI);
    
    virtual PVPLayer* getPVPLayer() { return m_pPVPLayer;}
    virtual bool IsInPVPModule();
    
    virtual TalentLayer* ShowTalentLayer();
    virtual void HideTalentLayer(bool bShowGameUI);
    
    virtual TalentLayer* getTalentLayer() { return m_pTalentLayer; }
    virtual bool IsInTalentModule();
    
    virtual AutoOnHook* ShowAutoOnHook(bool fromInstancePanel=false);
    virtual void HideAutoOnHook(bool bShowGameUI);

    void ShowMarketLayer(bool flag, int layerTag = 0,bool popFlag = true);
    void ShowSpriteExtractResultLayer(bool flag,bool popFlag = true);
    void ShowChargeLayer(bool flag, int layerTag = 0);
    void ShowFirstChargeLayer(bool flag);
    void HideFirstChargeEffect();
    void ShowBatchShoppingLayer(bool flag);
    void ShowPlatActivityLayer(bool flag);
    void ShowGuildListLayer(bool flag);
    void ShowGuildInfoLayer(bool flag);
    void ShowGuildInfoEditLayer(bool flag);
    void ShowGuildCreateLayer(bool flag);
    void ShowGuildContributeLayer(bool flag);
    void ShowGuildRequestLayer(bool flag);
    void ShowGuildRequestSettingLayer(bool flag);
    void ShowGuildBlessLayer(bool flag);
    void ShowGuildMemberLayer(bool flag);
    void ShowGuildNoticeLayer(bool flag);
    void ShowGuildAppointLayer(bool flag);
    void ShowGuildShopLayer(bool flag,bool popFlag = true);
	void ShowGuildRecordLayer(bool flag);
	void ShowGuildInstanceListLayer(bool flag,bool popFlag = true);
	void ShowGuildInstanceHelpLayer(bool flag);
	void ShowGuildRedEnvolopeLayer(bool flag);
	void ShowGuildRedEnvolopeNoteLayer(bool flag);
	void ShowGuildSendRedEnvoLayer(bool flag);
	void ShowGuildGetRedEnvoLayer(bool flag);
	void ShowGuildRedEnvoRecordLayer(bool flag);

    virtual AutoOnHook* getAutoOnHook() { return m_pAutoOnHook; }
    virtual bool IsInAutoOnHookModule();

	int  getSelectedCellOfLeft();
    
    
    bool IsNotice2Load();
    bool IsAutoAppear() ;
    
    void valueChanged(CCObject *sender, CCControlEvent controlEvent);
    
	// Note: Sprite Elf
	virtual SpriteElfLayer* ShowSpriteElfLayer();

	////////////////////////////
	///   chat toolbar
	////////////////////////////
	virtual ChatToolbar* GetChatToolbar();
	virtual void  setChatToolbar(bool isChatVisible,bool isFunctionVisible,bool isExtraVisible = false,int order = -1);

	static const char* GetNumByFormat(unsigned int num);
	// �õ��̶���ʽ������.����100000��XXXk����ʽ��ʾ,����100000k��xxxm����ʽ��ʾ

	static const char* GetNumByFormatK(unsigned int num);

	static MainMenuLayer* getMainMenuLayer();
	/**
	* Instruction : ��������ʾ����layer
	* @param 
	*/
	void CreateTaskListLayer();
	/**
	* Instruction : ��������layer
	* @param 
	*/
	void DestroyTaskListLayer();

	/**
	* Instruction : ����һ��Layer��������
	* @param 
	*/
	static void PushOneLayer(CCLayer *pLayer,std::string param_1 = "",std::string param_2 = "");
    
    static void CreateSliderCtrl(CCNode* layer, int tag, int width, int height);
	/**
	* Instruction : �ر������ڶ�ջ�е�Layer
	* @param 
	*/
	static void CloseAllInStackLayer();

	/**
	* Instruction : ɾ��ĳLayer
	* @param 
	*/
	static void RemoveOneLayer(CCLayer *pLayer);

	void DarkEffectOver();

	virtual void keyBackClicked();//����Android ���ؼ�
	virtual void keyMenuClicked();//����Android �˵���

	void OkBtnClick(CCObject* obj);
	void CancelBtnClick(CCObject* obj);	

	static void ClearLayersInQueneData();
    
    void resetMailUIMsg();

	void showMagicShop();

	void onReceivedElfStrengthLayerClosed();

	void setFairyMovedIcon(unsigned int changedPos);

	void setFairySelectStatus(bool isSelected);

	void showPreOpenLayer();
protected:
	/// ��Ϣ��Ӧ����
	virtual void onBroadcastMessage(BroadcastMessage* msg);

	
protected:
	ItemDragLayer* m_pDragLayer;

	BattleUILayer * m_pBattleUI;

	GameUILayer * m_pGameUI;

	DamageValueEffect* damageValueLable;

	BackPackLayer* m_pBackPackUI;

	TaskChatLayer* m_pTaskChatUI;
    
    LoadingLayer* m_pLoadingLayer;

	TaskListLayer* m_pTaskListUI;

	InstanceListLayer* m_pInstanceListUI;

	CityListLayer * m_pCityListUI;

	BattleCoverLayer * m_pBattleCoverUI;

	EquipmentUpgradeUILayer* m_equipmentUpgradeLayer;

	PPVELayer*	m_pPPVELayer;

    PVPLayer*   m_pPVPLayer;
    
    TalentLayer* m_pTalentLayer;
    
    AutoOnHook* m_pAutoOnHook;
            
	ChatToolbar* m_pChatToolbar;
    
	UIMessageLayer* m_pUIMessage;
    WaitingLayer* m_pUIWaiting;
    
	EquipMixLayer* m_equipMixLayer;
	AlchemyUILayer* m_pAlchemyUILayer;
    CardUILayer* m_cardUILayer;

    CC_SYNTHESIZE_RETAIN(CCLayer*, m_marketLayer, MarketLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_spriteExtractResultLayer, SpriteExtractResultLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_chargeLayer, ChargeLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_firstChargeLayer, FirstChargeLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_batchShoppingLayer, BatchShoppingLayer)
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_ucActivityLayer, UCActivityLayer)
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildListLayer,  GuildListLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildInfoLayer,  GuildInfoLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildInfoEditLayer, GuildInfoEditLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildCreateLayer, GuildCreateLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildContributeLayer, GuildContributeLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildRequestLayer, GuildRequestLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildRequestSettingLayer, GuildRequestSettingLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildBlessLayer,   GuildBlessLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildMemberLayer,  GuildMemberLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildNoticeLayer,  GuildNoticeLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildAppointLayer, GuildAppointLayer);
    CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildShopLayer,    GuildShopLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildRecordLayer,  GuildRecordLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildInstanceListLayer,	GuildInstanceListLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildInstanceHelpLayer,	GuildInstanceHelpLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildRedEnvolopeLayer,  GuildRedEnvolopeLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildRedEnvolopeNoteLayer,  GuildRedEnvolopeNoteLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildSendRedEnvoLayer,  GuildRedEnvolopeSendLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildGetRedEnvoLayer,  GuildGetRedEnvolopeLayer);
	CC_SYNTHESIZE_RETAIN(CCLayer*, m_guildRedEnvoRecordLayer,  GuildRedEnvolopeRecordLayer);

	/**
	* Instruction : ��ʾ�����е�Layer
	* @param 
	*/
	static std::vector<CCLayer*> *sVecLayersInQuene;
};

MainMenuLayer*  GetMainMenuLayer();

GameUILayer*	GetGameUILayer();

/// ppve UI 
PPVELayer*      GetPPVELayer();
PVPLayer*       GetPVPLayer();
TalentLayer*    GetTalentLayer();
AutoOnHook*     GetAutoOnHook();

void  RemovePPVELayer(bool showGameUI);
void  RemovePVPLayer(bool showGameUI);
void  RemoveTalentLayer(bool showGameUI);
void  RemoveAutoHook(bool showGameUI);

/// charToolbar 
ChatToolbar*    GetChatToolbar();

void	ShowChatBar(bool isExtrVisible,int order = -1);
// ��ʾ����� isExtrVisible �ײ��Ĺ��ܰ����Ƿ���ʾ��order�������Ĳ㼶��Ĭ����-1.

void	ShowMessage(const char* message,const ccColor3B& color = KMessageDefaultColor ,unsigned int  type = 0);
/// WaitingLayer
void   ShowWaitingLayer(bool bShowRightNow = true,float sumTimer = 0.3f);
void   HideWaitingLayer();

// ��ӡ��ǰ��ϵͳʱ�䣬������ʹ��
void   LogCurrentSystem(const char* msg);

#endif // _MAIN_MENU_LAYER_





