#ifndef SPRITE_MONSTER_H
#define SPRITE_MONSTER_H

#include "BoneSpriteMoveable.h"
#include "simplefsm.h"
#include "cs_battle.pb.h"
#include "UserData.h"

//using namespace cocos2d;
#define SHADOW_TAG 10001
#define ELITE_TAG  10002

enum MONSTER_STATE
{
	MONSTER_STATE_INITIALIZE,
	MONSTER_STATE_IDLE,
	MONSTER_STATE_RUN,
	MONSTER_STATE_ATTACK,
	MONSTER_STATE_HURT,
	MONSTER_STATE_DEAD,
};

typedef struct MonsterInitInfo
{
	int uid;
	const char * monsterName;
	int typeId;
	int totalHp;
	CCPoint pos;
	float speed;
	bool isBoss;
	bool isElite;
	bool isAlliance;
	unsigned int m_level;
	unsigned int hp_line;

	bool useCache;
}MonsterInitInfo;

typedef struct SkillInfo
{
	int skillId;
	int monsterId;
	int type;
	unsigned int effectId;
	unsigned int playType;
	CCPoint startPosition;
	CCPoint endPosition;
	CCPoint virPosition;
	float speed;
	float delayTime;
	vector<float> shakeTimeVec;
}SkillInfo;

typedef struct BuffInfo
{
	int skillId;
	int effectId;
	int delayTime;
	int deadTime;	
}BuffInfo;

enum ATTACK_TYPE
{
	ATTACK_TYPE_NONE,
	ATTACK_TYPE_NEAR,
	ATTACK_TYPE_FAR,
	ATTACK_TYPE_STAND,
	ATTACK_TYPE_RUSH,
	ATTACK_TYPE_SUMMON,
	ATTACK_TYPE_CONTINUE,
	ATTACK_TYPE_BUFF,
	ATTACK_TYPE_BLINK,
	ATTACK_TYPE_SPIN,
	ATTACK_TYPE_HIDE,
	ATTACK_TYPE_JUMP,
};

class SpriteMonster : public BoneSpriteMoveable
{
	friend class SpriteMonsterMgr;
public:   
	virtual ~SpriteMonster(); 
	//״̬��
	struct Rule:public SimpleStateMachine
	{
		Rule(){_this = NULL;}
		SpriteMonster * _this;
	protected:
		virtual bool States(StateMachineEvent event, int state);
	}fsm_rule;

	//��������
	void moveByPoints(const std::vector<CCPoint>& points);
	CCPoint moveToPoint(CCPoint desPoint,float speed);
	
	//�ص�����
	void ccCallChangeDirection(CCNode * node, void * data);
	void ccCallChangeState(CCNode * node, void * data);
	void ccCallShake(CCNode * node,void * data);
	void ccCallRushByInfo();
	void ccCallJumpByInfo();
	void ccCallBuffStart();
	void ccCallBuffEnd();

	void changeDirection(CCPoint direct);

	//Ѫ������
	unsigned int getBlood(){return this->blood;}
	void setBlood(unsigned int blood){this->blood = blood;}
	unsigned int getTotalBlood(){return this->m_TotalHp;}
	unsigned int getLevel(){return this->m_level;}
	unsigned int getHPLine(){return this->hp_line;}

	//�¼�����
	virtual void onEventMsgMove(const std::vector<CCPoint>& points);
	virtual void onEventMsgAttack(CCPoint serverPos, CCPoint direction, int animId, SkillInfo info);
	virtual void onEventMsgBuff(int animId, BuffInfo info, MonsterBattleInfo battleInfo);
	virtual void onEventMsgDead();
	virtual CCPoint onEventAttacked(CCPoint desPoint);

	//��������
	CC_SYNTHESIZE(float ,attackContinueTime, AttackContinueTime);
	CC_SYNTHESIZE(float ,attackSpeed, AttackSpeed);
	CC_SYNTHESIZE(bool ,canBeAttacked, CanBeAttacked);
	CC_SYNTHESIZE(CCPoint ,blinkPoint, BlinkPoint);
	CC_SYNTHESIZE(bool ,canBeFocus,	CanBeFocus);

	DIRECTION_MONSTER pointToDirection(CCPoint direct);	
	virtual void Update(float fTime,bool &bDeleteSelf, bool &isDead);
	virtual void PlayAttackedEffect(bool isCrit);
	virtual void animationHandler(const char* _aniType, const char* _aniID, const char* _frameID);
	
	void setJumpDownPosition(CCPoint pos){this->jumpInfo.endPosition = pos;}

	//�Ƿ��ѷ�
	bool getIsAlliance(){return this->isAlliance;}
	
protected:

    SpriteMonster(MonsterInitInfo info);    
    
	bool createTexture(unsigned int typeId);
	
	bool initWithInfoAndShow(MonsterInitInfo info);

protected:
	void removeSelf();

	virtual void setAttackAnimation(int animId, DIRECTION_MONSTER direction);
	void setAnimFromStateAndDirection(MONSTER_STATE state, DIRECTION_MONSTER direction);
	void setAnimFromStateAndDirection(int state, DIRECTION_MONSTER direction);
	void handleAttackEnd(int animId);

	float speed;

	unsigned int blood;

	DIRECTION_MONSTER direction;

	CCPoint m_oldPos;

	unsigned int m_TotalHp;

	bool isBoss;
	bool isElite;
	bool isAlliance;

	unsigned int m_level;
	unsigned int hp_line;

	float totalScheduleTimer;
	float selfScheduleTimer;

	//�ṩ��ccCallFunc�Ĳ���
	int mtpState;
	int mbpState1;
	int mbpState2;
	int dtiState;
	CCPoint mbpDir1;
	CCPoint mbpDir2;
	CCPoint mbpDir3[30];

	//����Ĺ������������ڹ�����ɺ��л���idle״̬
	std::vector<int> extraAnims;	
	EffectSprite* m_attackedEffectSprite;
	

	//int lastAnimId;
	//bool lastFlip;

	bool showAnim;
	
	SkillInfo rushInfo;
	SkillInfo jumpInfo;

	//����doAction�ĸ��ֽ��
	CCNode * attackContinueNode;
	CCNode * shakeNode;
	CCNode * jumpNode;
	CCNode * buffNode;
	CCNode * rushNode;
	CCNode * rushEndNode;

	//buff
	EffectSprite * buffEffectSprite;
	MonsterBattleInfo normalBattleInfo;
	MonsterBattleInfo buffBattleInfo;

	bool inBuff;

	//����������Ч
	EffectSprite * attackTypeEffectSprite;

	//boss��ɱ����
	bool isDead;
};


#endif
