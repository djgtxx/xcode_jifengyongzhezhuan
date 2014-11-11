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
#pragma once
#include <map>
#include <string>
#include "PhysicsLayer.h"
#include "StateEventType.h"
#include "SASpriteDefine.h"
#include "UserData.h"
#include "EncodeValue.hpp"

typedef enum Skill_Phase
{
	PHASE_UNKNOWN	= -1,
	PHASE_PERFORM	= 1,
	PHASE_SHOW	= 2,
	PHASE_IMPACT= 3,
} SKILL_PHASE;


typedef enum Spell_Show_Type	
{
	SHOW_IMMEDIATE,     // ��Ŀ�괦˲�����
	SHOW_FLYINGTO,      // ��ʩ���߷���Ŀ����
	SHOW_CONTINUOUS,    // ���������
} SPELL_SHOW_TYPE;

class BasicUserBattleInfo;
class UserSkillPart;
class UserSkillInfo;

struct ClientBasicUserBattleInfo {
	EncodeValue<unsigned int> physical_attack ; // ������
	EncodeValue<unsigned int> magic_attack; // ħ������
	EncodeValue<unsigned int> skill_attack; // ���ܹ���
	EncodeValue<unsigned int> physical_defence; // �������
	EncodeValue<unsigned int> magic_defence ; // ħ������
	EncodeValue<unsigned int> skill_defence; // ���ܷ���
	EncodeValue<unsigned int> health_point; // ����ֵ
	EncodeValue<unsigned int> accurate ; // ��׼
	EncodeValue<unsigned int> dodge ; // ����
	EncodeValue<unsigned int> wreck; // �ƻ�
	EncodeValue<unsigned int> parry; // ��
	EncodeValue<unsigned int> critical_strike; // ����
	EncodeValue<unsigned int> tenacity; // ����
	EncodeValue<unsigned int> slay; // ��ɱ
	EncodeValue<unsigned int> courage; // ����
	EncodeValue<unsigned int> charm; // ħ��
	EncodeValue<unsigned int> trick; // ����
	EncodeValue<unsigned int> speed; // ����
	EncodeValue<unsigned int> proficiency; // Ǳ��
	EncodeValue<unsigned int> current_hp ; // ����ֵ

	ClientBasicUserBattleInfo(void){}
	ClientBasicUserBattleInfo(const BasicUserBattleInfo& info);

	const ClientBasicUserBattleInfo& operator = (const BasicUserBattleInfo& info);
};

struct ClientUserSkillPart 
{
	EncodeValue<unsigned int> part;
	ClientBasicUserBattleInfo exp_battle_info;

	EncodeValue<float> continue_time;
	EncodeValue<unsigned int> can_attack_number;
	EncodeValue<unsigned int> hurt;
	EncodeValue<float> continue_time2;

	ClientUserSkillPart(){}
	ClientUserSkillPart(const UserSkillPart& info);

	const ClientUserSkillPart& operator = (const UserSkillPart& info);
};

struct ClientUserSkillInfo 
{
	EncodeValue<unsigned int> skill_id;
	EncodeValue<unsigned int> level;
	EncodeValue<unsigned int> part;
	EncodeValue<unsigned int> skill_level;
	EncodeValue<unsigned int> money;
	EncodeValue<unsigned int> exploit;
	EncodeValue<float> own_cd;
	EncodeValue<float> share_cd;

	std::vector<ClientUserSkillPart>		parts;

	EncodeValue<unsigned int> max_level;

	ClientUserSkillInfo(void){}
	ClientUserSkillInfo(const UserSkillInfo & rhs);

	const ClientUserSkillInfo& operator = (const UserSkillInfo& info);
	
};



typedef struct tagDispData
{
	/// sound 
	unsigned int SoundId;
	/// effect Id
	unsigned int EffectId;
}DISP_DATA, *LPDISP_DATA;
typedef const DISP_DATA*   LPCDISP_DATA;


typedef struct tagPerform_Phase
{
	float       fTotalTime;
	DISP_DATA   DispData;

	tagPerform_Phase()
	{
		fTotalTime  = 0.0f;
	}

	~tagPerform_Phase() {};
} PERFORM_PHASE, *LPPERFORM_PHASE;
typedef const PERFORM_PHASE*   LPCPERFORM_PHASE;



typedef struct tagShow_Phase
{
	// Public data
	SPELL_SHOW_TYPE emShowType;
	unsigned int    SoundId;

	// Immediate show data
	unsigned int  CasterEffectId;
	unsigned int  CasterEffectPos;
	unsigned int  TargetEffectId;

	int  TargetEffectPos;

	// Flying show data
	unsigned int    FlyingEffectId;
	int  StartPos;
	int  TargetPos;
	float   fFlyingSpeed;

	tagShow_Phase()
	{
		emShowType  = SHOW_IMMEDIATE;
		SoundId  = 0;

		FlyingEffectId = 0;
		fFlyingSpeed = 0.0f;

		CasterEffectId = 0;
		TargetEffectId = 0;

		StartPos = 0;
		TargetPos = 0;
	}
} SHOW_PHASE, *LPSHOW_PHASE;
typedef const SHOW_PHASE*   LPCSHOW_PHASE;


typedef struct tagImpact_Phase
{
	float       fTotalTime;
	DISP_DATA   DispData;
	unsigned   int  ABoxAnimationId;

	tagImpact_Phase()
	{
		fTotalTime  = 0.0f;
	}

	~tagImpact_Phase() {};
} IMPACT_PHASE, *LPIMPACT_PHASE;
typedef const IMPACT_PHASE* LPCIMPACT_PHASE;


typedef struct tagSkillInfo
{
	struct ANIMATION_INFO
	{
		unsigned int animationID;
		bool isFlipX;
		bool isFlipY;
		ANIMATION_INFO()
			: animationID(-1)
			,isFlipX(false)
			,isFlipY(false)
		{
			
		}
		
	};

	tagSkillInfo(void)
		:Id(0)
		,partID(0)
		,linkSkillId(0)
		,linkTime(0.0f)
		,displacement(0)
		,beatBackDistance(0)
		,isSpecial(false)
		,canCommonBreak(false)
		,canSpecialBreak(false)
		,damage(0)
		,criticalRate(0.0f)
		,attackNumber(0)
		,canControl(false)
		,continueTime(0.0f)
		,whichTime(0)
		,type(ToNormalAttack)
		,iShakeCamera(0)
		,bCameraStartTime(0.0f)
		,fCoolTime(0.0f)
		,SoundId(0)
		,bSoundLoop(false)
		,aim(E_AIM_NONE)
		,effectId(0)
		,linkEffectId(0)
		,longDistanceAttackRange(0)
		,bAdaptationDistance(false)
		,bBasedOnFrame(false)
		,roleType(kTypeFighter_Boy)
		,girleVoiceID(0)
		,boyVoiceID(0)
		,ragePoint(0)
		,bInvincible(false)
		,skillPriority(0)
		,skillConflict(0)
		,bRotateEffect(false)
		,effectZOrder(E_DYNAMIC)
	{

	}

	enum ATTACK_TYPE
	{
		E_NORMAL = 1,
		E_MAGIC,
		E_SKILL,
		E_FAIRY_SKILL,

		E_DODGE,	// ����
		E_PARRY,	// ��
		E_STRIKE,	// ����
	};

	enum AIM_TYPE
	{
		E_AIM_NONE,
		E_AIM_ENEMY,
		E_AIM_HERO
	};

	enum EFFECT_Z_ORDER
	{
		E_DYNAMIC,
		E_BEHIDE_HERO,
		E_FRONT_HERO
	};

	// skill Id
	int Id;
	EventType type;

	int partID;
	int linkSkillId;

	ANIMATION_INFO animation[4];
	
	float linkTime;
	int displacement;
	int beatBackDistance;
	bool isSpecial;
	bool canCommonBreak;
	bool canSpecialBreak;
	int damage;
	float criticalRate;

	// ���Ǹü��ܹ����п��Ի��еĴ���
	int attackNumber;

	// �����ͷŹ������Ƿ�����ƶ���0Ϊ���У�1Ϊ���ԣ�
	bool canControl;

	// �ü��ܿɳ���ʱ��
	float continueTime;

	// �����γ�λ��ʱ���ٶ����ĸ�ʱ����ƣ�1Ϊ����ʱ�䣬2Ϊcontinue_time��������
	int whichTime;

	/// skill description
	char   SkillDesp[512];


	/// camera effect
	int   iShakeCamera;
	float  bCameraStartTime;
	float  fCoolTime;
	
	int SoundId;

	bool bSoundLoop;
	AIM_TYPE aim;

	int effectId;
	int linkEffectId;
	int effectsoundID;

	std::string actionName;
	std::string actionIcon;

	int longDistanceAttackRange;
	float longDistanceEffectSpeed;
	bool bShowFarWay;	// ��ĳ���ط�˲�����
	bool bDisappear;
	float alpha;

	float ownCD;
	float shareCD;

	bool bAdaptationDistance;

	bool bBasedOnFrame;

	RoleJobType roleType;

	bool bBuff;

	ATTACK_TYPE attackType;

	unsigned int firstSkillID;

	unsigned int boyVoiceID;
	unsigned int girleVoiceID;
	unsigned int ragePoint;

	bool bInvincible;

	int skillPriority;
	int skillConflict;

	EFFECT_Z_ORDER effectZOrder;
	bool bRotateEffect;

	/// states of skill 
	PERFORM_PHASE  Perform;
	SHOW_PHASE  Show;
	IMPACT_PHASE  Impact;

}SKILL_INFO, *LPSKILL_INFO;
typedef const SKILL_INFO*   LPCSKILL_INFO;


typedef struct tagSkillSlotInfo
{
	unsigned int slotIndex;
	unsigned int skillId;

	tagSkillSlotInfo(){
		slotIndex = 0;
		skillId = 0;
	}
}SKILL_SLOT_INFO, *LPSKILL_SLOT_INFO;
typedef const SKILL_SLOT_INFO*   LPCSKILL_SLOT_INFO;

struct FAIRY_SKILL_INFO : public INFOID, public BATTLEINFO
{
	enum TYPE
	{
		E_ATTACK,
		E_BUFFER,

	};

	enum ASSIST_EFFECT_TYPE
	{
		E_EFFECT_UnKnow = 0,
		E_EFFECT_ATTACK,
		E_EFFECT_DEFEND,
		E_EFFECT_HP
	};

	enum STYLE
	{
		E_SkillAttack = 0,
		E_NormalAttack,
		E_AssistAttack,
	};

	enum AIM
	{
		E_HERO,
		E_ENEMY,
		E_FULL_SCREEN,

	};

	enum EFFECT_Z_ORDER
	{
		E_DYNAMIC,
		E_BEHIDE_HERO,
		E_FRONT_HERO
	};

	FAIRY_SKILL_INFO(void)
		: fairy_ID(0)
		, type(E_ATTACK)
		, style(E_SkillAttack)
		, assistEffectType(E_EFFECT_UnKnow)
		, aim(E_HERO)
		, bLock(false)
		, attack_number(0)
		, continueTime(0.0f)
		, effectID(0)
		, longDistanceAttackRange(0)
		, longDistanceEffectSpeed(0)
		, soundID(0)
		, effectSoundID(0)
		, hurt(0)
		, hurtAddValue(0)
		, effectZOrder(E_DYNAMIC)
		, ownCD(0.0f)
		, isEffectDisappearWhenHit(false)
		, isBasedOnCd(false)
		, bloodDownPercent(0)
		,effectAmi(100000)
	{
		enemyNumAtRange.first = 0;
		enemyNumAtRange.second = 0;
	}

	unsigned int  fairy_ID;
	TYPE type;
	STYLE style;
	ASSIST_EFFECT_TYPE assistEffectType;
	AIM aim;
	bool bLock;
	tagSkillInfo::ANIMATION_INFO animation[4];
	int attack_number;
	float continueTime;
	int effectID;
	int longDistanceAttackRange;
	int longDistanceEffectSpeed;
	int soundID;
	int effectSoundID;
	int hurt;
	int hurtAddValue;
	int effectAmi ;
	// Note: ���������������
	bool isEffectDisappearWhenHit;
	bool isBasedOnCd;
	float bloodDownPercent;
	std::pair<unsigned int,unsigned int> enemyNumAtRange;

	EFFECT_Z_ORDER effectZOrder;

	float ownCD;

};