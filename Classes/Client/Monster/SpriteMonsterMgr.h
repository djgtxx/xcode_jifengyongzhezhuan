#ifndef SPRITE_MONSTER_MGR_H
#define SPRITE_MONSTER_MGR_H

#include "Singleton_t.h"
#include "SpriteMonster.h"

#include <map>
using namespace std;

typedef struct SkillSoundInfo
{
	int skillId;
	int soundId;
	float delayTime;
	float continueTime;
	bool isLoop;
	bool waitingForPlay;
}SkillSoundInfo;

class SpriteMonsterMgr : public TSingleton<SpriteMonsterMgr>
{
	friend class SpriteMonster;
public:    
	SpriteMonsterMgr();
	virtual ~SpriteMonsterMgr(); 

	///  create monster with parameters
    SpriteMonster*	CreateMonster(MonsterInitInfo info);

	void  CreateCacheMonster(int typeId);
    
	/// called by LevelLayer
	void Update(float dt);

	/// get a monster from its id
	SpriteMonster* GetMonster(int s_id);

	const map<int, SpriteMonster*>& GetAllMonster(void) const {return m_tabMonsters;}

	//�������ɼ�����
	SpriteMonster * getNearestMonster();

	int getMonsterCount(){return m_tabMonsters.size();}

	//boss��ɱ����
	bool isLastBoss(SpriteMonster * monster);

	//���Ź���������Ч
	bool playMonsterDieSound(int typeId);

	//���Ź�����Ч
	bool playMonsterSkillSound(int skillId);

	//����bossѪ�����
	void updateSpecialMonsterHPLayer(int id, int nowHp, int totalHp, int type);

	void resetData();

protected:
	/// add monster to the table
	bool Add(SpriteMonster * monster);

		/// remove one monster
	void Remove(SpriteMonster * monster);

protected:
	map<int, SpriteMonster*> m_tabMonsters;
	map<int, set<SpriteMonster*> > cacheMonsters;
	map<int, SkillSoundInfo> skillSoundMap;

	bool isPlayingDieSound;
	int nowPlayingSoundId;
	
	bool specialMonsterHpInited;

	//boss ��ɱ����
	bool inSlow;
	bool hasSlowed;
};


#endif
