// TAOMEE GAME TECHNOLOGIES PROPRIETARY INFORMATION
//
// This software is supplied under the terms of a license agreement or
// nondisclosure agreement with Taomee Game Technologies and may not 
// be copied or disclosed except in accordance with the terms of that 
// agreement.
//
//      Copyright (c) 2012-2015 Taomee Game Technologies. 
//      All Rights Reserved.
//
// Taomee Game Technologies, Shanghai, China
// http://www.taomee.com
//
#ifndef _USER_DATA_H_
#define _USER_DATA_H_

#pragma once
#include <stdlib.h>
#include <vector>
#include <map>
#include "cocos2d.h"

#include "Singleton_t.h"
#include "MonsterInfo.h"
#include "../../NetWork/cs_battle.pb.h"
#include "EncodeValue.hpp"

using namespace  std;

#define SESSION_LENGTH	24

//////////////////////////////////////////////////////////////////////////

class PLAYER_ID
{
public:
	PLAYER_ID();
	PLAYER_ID(unsigned int id,unsigned int regTime,unsigned int channel);
	PLAYER_ID(const PLAYER_ID& playId);
	//void setPlayerUUID(uint32_t id, uint32_t channel);
	void setPlayId(unsigned int id,unsigned int regTime,unsigned int channel);
	void setPlayId(const PLAYER_ID& playId);
	bool isEqual(const PLAYER_ID& playId);
	unsigned int getID() const{return m_uid;}
	unsigned int getRegTime() const{return m_regTime;}
	unsigned int getChannel() const{return m_channelId;}
	void setRegTime(unsigned int reg_time){m_regTime = reg_time;}

	PLAYER_ID& operator = (const PLAYER_ID& playId);
	bool operator < (const PLAYER_ID& player) const; 
	bool operator == (const PLAYER_ID& playId);
	bool operator != (const PLAYER_ID& playId);
private:
	unsigned int	m_uid; // ������׺�
	unsigned int	m_regTime; // �ʺ�ע��ʱ��
	unsigned int	m_channelId; // 
};

#define PlayerIdMake(id,regTime,channel) PLAYER_ID((unsigned int)id,(unsigned int)regTime,(unsigned int)channel)

class GUILD_ID
{
public:
	GUILD_ID();
	GUILD_ID(unsigned int high_id,unsigned int low_id);
	GUILD_ID(const GUILD_ID& guildId);
	void setGuildId(unsigned int high_id,unsigned int low_id);
	void setGuildId(const GUILD_ID& guildId);
	bool isEqual(const GUILD_ID& guildId);
	unsigned int getHighID() const{return m_highId;}
	unsigned int getLowID() const{return m_lowId;}

	GUILD_ID& operator = (const GUILD_ID& playId);
	bool operator < (const GUILD_ID& player) const; 
	bool operator == (const GUILD_ID& playId);
	bool operator != (const GUILD_ID& playId);
private:
	unsigned int m_highId;
	unsigned int m_lowId;
};

#define GuildIdMake(high_id,low_id) GUILD_ID((unsigned int)high_id,(unsigned int)low_id)

//typedef uint64_t PLAY_ID;

class INFOID
{
public:
	INFOID(void){}
	PLAYER_ID  id;
};

class BATTLEINFO
{
public:
	BATTLEINFO();
	BATTLEINFO operator + (const BATTLEINFO& info);
	const BATTLEINFO& operator = (const BATTLEINFO& info);

	EncodeValue<unsigned int> physical_attack;
	EncodeValue<unsigned int> magic_attack;
	EncodeValue<unsigned int> skill_attack;
	EncodeValue<unsigned int> physical_defence;
	EncodeValue<unsigned int> magic_defence;
	EncodeValue<unsigned int> skill_defence;
	EncodeValue<unsigned int> health_point;
	EncodeValue<unsigned int> accurate ; // ����
	EncodeValue<unsigned int> dodge;		// ����
	EncodeValue<unsigned int> wreck;		// �ƻ�
	EncodeValue<unsigned int> parry;		// ��
	EncodeValue<unsigned int> critical_strike;	// ����
	EncodeValue<unsigned int> tenacity;			// ����
	EncodeValue<unsigned int> slay;				// ��ɱ
	EncodeValue<unsigned int> proficiency;
	EncodeValue<unsigned int> speed;				// ����
	EncodeValue<unsigned int> total_hp;
	EncodeValue<unsigned int> courage; // ����
	EncodeValue<unsigned int> charm; // ħ��
	EncodeValue<unsigned int> trick; // ����
	EncodeValue<unsigned int> effectiveness; // ս����

	EncodeValue<unsigned int> ragePoint;		//// ����ŭ�� 
	EncodeValue<unsigned int> totalRangePoint;	//// ������ŭ��ֵ
	EncodeValue<unsigned int> secRagePoint;		//// �ڶ�ֻ����ŭ�� 
	EncodeValue<unsigned int> secTotalRangePoint;	//// �ڶ�ֻ������ŭ��ֵ

	bool rageBasicInited;


	MonsterBattleInfo GetMonsterBattleInfo();
	void Set(const MonsterBattleInfo& info);
	void Set(const BasicUserBattleInfo& bi);

	void ResetRagePoint();//���þ���ŭ�����ص����ǵ�ʱ��

};

class MONSTERINFO: public INFOID, public BATTLEINFO
{
public:
	// TODO  : 
	MONSTERINFO();

	void Set(const MonsterInfo& info);
};

/// user base information
class USERINFO : public INFOID, public BATTLEINFO
{
public:

	USERINFO();

	void Set(const BasicUserInfo& info);
	void Set(const BasicUserBattleInfo& bi);

	char userSession[SESSION_LENGTH];
	char szName[20];	
	char ip[30];
	char lastServerName[30];
	char accessToken[128];
	unsigned int serverId;
	unsigned int port;
	long createdTime;

	uint64_t tokenId;
	unsigned int level;
	unsigned int exp;
	unsigned int nextExp;
	unsigned int mapId;
	unsigned int xPos;
	unsigned int yPos;
	unsigned int orient;
	unsigned int type;
	// add more data parameters
	unsigned int battleId;
	
	unsigned int battleSide;

	unsigned int m_spriteEnergy;	//����
	EncodeValue<unsigned int> m_gold;			//���
	EncodeValue<unsigned int> m_diamond;			//��ʯ
	unsigned int m_fragStone;		//����ʯ
	unsigned int m_spriteChip;		//��ʯ����
	unsigned int m_soulStone;		//��ʯ
	unsigned int m_reputation;		//����
	unsigned int m_stamina;			//����
	unsigned int m_alchemyBagUnlockPos;		//��ʯ�����ѽ�������
	unsigned int m_alchemyStorageUnlockPos;	//��ʯ�ֿ��ѽ�������
	unsigned int m_searchSpriteNpc;	//Ѱ��NPC
	unsigned int m_equipLvUpMaxTimes;		//װ���������ʱ��
	unsigned int m_equipLvFlag;				//װ�������Ƿ񵽶�: 0 δ�����ʱ�䣬�ɼ���ǿ��, ��0 �ѵ����ʱ�䣬CD����ǰ�޷�ǿ��
	unsigned int m_equipLvUpCd;				//װ��ǿ����ʣ��ʱ��
	long m_lastPPVEChatTime;		//��һ��PPVE�Զ�����ʱ��

	unsigned int m_gemRecastTimes;			//��ʯ��������
	unsigned int m_player_exploit;			//��ҹ�ѫ
	unsigned int m_playerExploerExperience; //�������
	unsigned int m_playerGemAnima;			//��ʯ����
    unsigned int m_enterManorTimes;
	unsigned int m_autofightUnderCd;				//auto fight��ʣ��ʱ��
	long m_lastStaminaRestoreTime;  //��һ�������ָ�ʱ��

    unsigned int m_continueloginTime;
    unsigned int m_loginRewardTime;
    unsigned int m_vipRewardTime;
    unsigned int m_payRewardTime;
    unsigned int m_buyDiamondRewardTime;
    unsigned int m_buyManorTimes;
    
    unsigned int m_pvaiRewardTime;
    unsigned int m_palyHoldExp;
    
	unsigned int m_newMailNum; // ���ʼ�����
	unsigned int m_attachMailNum; // �и������ʼ�����
	unsigned int m_totalMailNum; // ���ʼ�����

	unsigned int m_autofightNormalCd;				//auto fight��ʣ��ʱ��
	unsigned int m_autofightJingYingCd;				//auto fight��ʣ��ʱ��
    
	unsigned int pay_money;  //msg CSNotifyLevelConfInfoRsp field
	unsigned int mine_money; //bang zhang kai qi money
	unsigned int train_money;//msg CSNotifyLevelConfInfoRsp field
	unsigned int suspend_limit_exp;//msg CSNotifyLevelConfInfoRsp field
	unsigned int current_title;
	EncodeValue<unsigned int> m_vip;//current vip level jackniu
	bool first_login;
	bool b_hasEnoughEquipFrag;
	bool b_hasEnouchFairyFlag;
	bool b_hasTargetIconFlag;
	bool b_reputationExchangeFlag;

	unsigned int m_pvpDuelTimesNum;
	unsigned int m_pvpDueledTimesNum;
	unsigned int m_pvpRed;
	long m_pvpRedTimer;

    long m_junior_explore_time;
    long m_senior_explore_time;

    unsigned int m_spec_left_times;
    unsigned int m_green_extract_times;
    
    unsigned int m_diamond_acc;
    long m_shopRefreshTime;
    unsigned int m_refreshTimes;
    unsigned int m_treasure_explore_times;
    unsigned int m_treasure_explore_mapIndex;
    unsigned int m_treasure_explore_success_rate;
    unsigned int m_treausre_already_get_index;
    unsigned int m_treasure_levelup_flag;
    unsigned int m_worldboss_forbid_roles;
    unsigned int m_worldboss_revive_by_cd;
    unsigned int m_worldboss_revive_by_diamond;
    unsigned int m_guild_bless_times;
    unsigned int m_guild_contribute_times;
    unsigned int m_guild_contributes;
    unsigned int m_guild_join_cd_time;

    unsigned int m_get91_dailyBonus;
    unsigned int m_get91_vipBonus;
    unsigned int m_get91_firstChargeBonus;
    unsigned int m_91Vip;

	std::string guildName;
	GUILD_ID m_guildId;
};



class UserData : public TSingleton<UserData>
{
public :
	UserData();

	static const USERINFO & GetUserInfo();
	
	/// get user name
	static const char *  getUserName();
	static void setUserName(const char* newName);

	/// get user id
	static PLAYER_ID getUserId();

	static const char*	getUserSession();

	static uint64_t getTokenId();

	static unsigned int GetUserLevel();

	static unsigned int GetUserExp();

	static unsigned int GetUserMapId();

	static unsigned int GetUserXPos();

	static unsigned int GetUserYPos();

	static unsigned int GetUserOrient();

	static unsigned int GetUserType();

	static unsigned int GetSpriteEnergy();

	static unsigned int GetGold();
	
	static unsigned int GetDiamond();

	static unsigned int GetUserChip();

	static unsigned int GetVipLevel();

	static unsigned int GetLastPort();

	static const char* GetLastIP();

	static const char* GetLastServerName();

	static unsigned int getHeroHp();

	static unsigned int getHeroTotalHp();
    
    static unsigned int getEnterManorTimes();
    
    
    static unsigned int getBuyManorTimes();
    
	static unsigned int getRagePoint();
	static unsigned int getTotalRagePoint();
	static unsigned int getSecRagePoint();
	static unsigned int getSecTotalRagePoint();

	
    static unsigned int getContinueloginTime();
    static unsigned int getLoginRewardTime();
    static unsigned int getVipRewardTime();
    static unsigned int getPayRewardTime();
    static unsigned int getBuyDiamondRewardTime();
    static unsigned int getPvaiRewardTime();
    static unsigned int getPalyHoldExp();

    static unsigned int getUserEffectiveness();
    
	static void SetUserInfo(USERINFO info);

	//local server ��ʱ����
	static void SetBasicUserInfo(BasicUserInfo info);
	BasicUserInfo GetBasicUserInfo(){return mBasicUserInfo;}

	void SetUserInfo(PLAYER_ID id, USERINFO& info);
	USERINFO* GetUserInfo(PLAYER_ID id);

	std::list<PLAYER_ID>* GetOtherUserId();
	void clearOtherUserInfo();
	void removeOtherUser(PLAYER_ID id);
protected:
	USERINFO m_stUserinfo;

	//���ط�������Ҫ�õ� ��ʱ����
	BasicUserInfo mBasicUserInfo;
	
	std::map<PLAYER_ID, USERINFO> m_userInfoList;
};


// --------------------------------------------------------------------------------------------

class EntityInfo : public TSingleton<EntityInfo>
{
public:
	
	void Set(INFOID* pInfo);
	INFOID* GetInfo(PLAYER_ID id);

	void Clear(void);

protected:
	std::map<PLAYER_ID, INFOID*> m_infoList;
};

#endif