#pragma once
//��Ϸ���ݣ����ù���
#include "Singleton_t.h"
#include "PhysicsLayer.h"

typedef struct TaskPosition{
	int cityId;
	int npcId;
	CCPoint position;
	TaskPosition(){
		npcId = -1;
	}
}TaskPosition;

class GameDataManager : public TSingleton<GameDataManager>
{
public:
	GameDataManager();
	virtual ~GameDataManager();

	//������ʽ
	Move_Type getHeroMoveType(){return heroMoveType;}
	void setHeroMoveType(Move_Type type);

	//�Զ�����״̬
	bool getHeroAutoAttack(){return heroAutoAttack;}
	void setHeroAutoAttack(bool autoAttack);

	//����ϵͳ���ͼѰ·
	TaskPosition getTaskPosition(){return taskPos;}
	void setTaskPosition(TaskPosition taskPosition){this->taskPos = taskPosition;}

	void sendEliteTranspointValidReq();
	void checkEliteTranspointValid(unsigned int id);
	bool IsEliteTranspointValid(){return mIsOpenEliteTranspoint;}
	void resetEliteTranspointValid(){mIsOpenEliteTranspoint=false;}
	void TrackEliteValid();
private:
	Move_Type heroMoveType;
	bool heroAutoAttack;
	TaskPosition taskPos;
	bool mIsOpenEliteTranspoint;
};