//
//  GameAudioManager.h
//  iSeer
//
//  Created by razer tong on 12-3-20.
//  Copyright (c) 2012�� __MyCompanyName__. All rights reserved.
//

#ifndef iSeer_GameAudioManager_h
#define iSeer_GameAudioManager_h

#include "cocos2d.h"
#include "SimpleAudioEngine.h"
#include "CCUserDefault.h"

//ui
typedef enum
{
	NORMAL_ATTACK, // ��ͨ����

}KEffectID;



class GameAudioManager 
{
private:
	static GameAudioManager* pSharedManager; 
	int m_bIndex;//ѭ�����ŵ�index 1,2�л���3Ϊֹͣ���ű����֡�4 loop
	char *m_tempName[2];

	//effect buff
	char *m_bBuff;

	//��Ч����
	bool m_bEffectSwitch;

	//�������ֿ���
	bool m_pBgmSwitch;

	bool m_messageSwitch;

	unsigned int m_userID;      //for 91
	std::string  m_nickName;    //for 91

private:

	//����ļ���
	const char *getFileName(KEffectID eid) const;

public:

	GameAudioManager();
	virtual ~GameAudioManager();

	// static instance
	static GameAudioManager* sharedManager();
	static void Destroy();
	
	/// do some initialization 
	void InitDevice();

	/// clear audio device
	void ShutDown();


	//�޸��˿�ܡ���CDAudioManager�ص�
	void playBGM() ;

	void playBGMWithMap(unsigned int musicId);

	void playLoadingBGM();

	void playStartGameAnimationSound();

	void stopPlayBGM();

	bool isBGMPlaying();

	//����˵������Ч
	void playEffectWithID(const int eid,const float delay =0) ;

	//���ܵ���Ч
	void playEffectWithID( const char *fileName,const float delay=0) ;
	
	//ui����Ч //��׽����Ч
	void playEffect(const KEffectID eid,bool isLoop,const bool isStopBGM =false) ;
	void playEffect(unsigned int soundID,bool isLoop,const float delay=0);

	// Note: Ԥ������Ч
	void preLoadMonsterEffect(unsigned int monsterId);
	void preLoadEffect(unsigned int soundID);

	void stopEffect(unsigned int soundID);

	//������Ч
	void setIsEffectSwitchOn(bool isOn) ;

	void setMessageSwitch(bool isOn);

	unsigned int getNine1UserID()  { return m_userID; }
	void setNine1UserID(unsigned int userid);
	std::string getNine1Nickname() { return m_nickName; }
	void setNine1Nickname(std::string str);

	//���
	bool getIsEffectSwitchOn();

	bool isEffectIsPlaying(unsigned int nSoundId);

	bool getIsBgmSwitchOn();

	bool getTrainSwitch() { return m_messageSwitch; }

	void stopAllEffect();

	void setBackgroundMusicVolume(float volume);

	 void setEffectsVolume(float volume);

	 // Note: ��ɫ����Ԥ����
	 void LoadLevelMonsterAudio(unsigned int levelId,unsigned int mapId);
	 void LoadLevelHeroCommonAudio(unsigned int heroTypeId);
protected:
	std::set<unsigned int> m_loadedMonsterAudios;
	std::set<unsigned int> m_loadedHeroAudios;
};


#endif
