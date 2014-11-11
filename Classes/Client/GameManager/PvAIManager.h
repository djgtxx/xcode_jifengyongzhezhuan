#pragma once

#include "Singleton_t.h"
#include "SpriteSeer.h"
#include "UILayout.h"
#include "UserData.h"

typedef struct AIPlayerInfo
{
	string name;
	int level;
	int rank;
	int type;
	PLAYER_ID id;
	int aiStatus;
    AIPlayerInfo& operator = (const AIPlayerInfo& playId);
}AIPlayerInfo;

typedef struct AILogInfo
{
	string name;
	bool direct;//true ������false����
	bool win;
}AILogInfo;

typedef struct AILayerBasicInfo
{
	int remainCount;
	long coolDownTime;
	int buyCount;
}AILayerBasicInfo;

class PvAIManager : public TSingleton<PvAIManager>
{
public:
	PvAIManager();
	~PvAIManager();

	//����������ת
	void sendPvAIReq(int buttonIndex);

	void onMsgPvAIReward(int accuCoin, int accuReputation, int oneCoin, int oneReputation);

	//����������Ϣ
	void setHeroRank(int rank){this->heroRank = rank;}
    int getHeroRank(){ return this->heroRank;}

	void setAIPlayerId(PLAYER_ID uid){this->aiPlayerId = uid;}
	PLAYER_ID getAIPlayerId(){return aiPlayerId;}

	void setAIPlayerVec(vector<AIPlayerInfo> infos){this->aiPlayerVec = infos;}
	void setAILogInfoVec(vector<AILogInfo> logs){this->aiLogInfoVec = logs;}

	void setRemainCount(int count){this->remainCount = count;}
	int getRemainCount(){return this->remainCount;}

	void setBuyCount(int count){this->buyCount = count;}
	int getBuyCount(){return this->buyCount;}

	void setAISkillsId(vector<int> equipSkills);

	void setAIAutoAttack(bool autoAttack);

	void onEventLocalHurt(CSPlayerHitPlayerReq attackReq);

	//����cd����ʱ�䣬�״δ���Timerʱʹ��
	void setCoolDownEndTime(long endTime){this->coolDownEndTime = endTime;}
	long getCoolDownEndTime(){return this->coolDownEndTime;}

	//�ж�SpriteSeer�Ƿ�Ϊai
	bool isAIPlayer(SpriteSeer * player){return player == aiPlayer;}
	SpriteSeer * getAIPlayer(){return aiPlayer;}

	//�����һ��ai player ����ai������ʹ��
	SpriteSeer * getLastAIPlayer(){return lastAIPlayer;}

	//��������
	void refreshPvAILayer();
	void Update(float dt);

	string strWithNum(string str, int number)
	{
		stringstream strStream;
		strStream << str << number;
		return strStream.str();
	}

	void resetData();
private:
	void moveToHero();

	int getBestSkill();

private:
	//���������Ϣ
	int heroRank;

	int accuCoin;
	int accuReputation;
	int oneCoin;
	int oneReputation;

	SpriteSeer * aiPlayer;
	SpriteSeer * lastAIPlayer;

	//std::vector<int> skills;
	std::vector<int> attackSkillVec;
	std::vector<int> buffSkillVec;

	float aiAutoAttackCDTime;
	bool aiAutoAttack;
	PLAYER_ID aiPlayerId;

	vector<AIPlayerInfo> aiPlayerVec;
	vector<AILogInfo> aiLogInfoVec;

	TXGUI::UILayout * pvaiLayout;
	bool inited;
	long coolDownEndTime;
	bool inPvAIBattle;

	//������Ϣ���
	int remainCount;
	int buyCount;
};