#pragma once

#include "Singleton_t.h"
#include "cocos2d.h"
#include "TimeProtocol.h"

USING_NS_CC;

typedef set<TimeProtocol*> TimeObSet;
typedef map<int, TimeObSet> TimeObMap;

typedef set<int> LuaObSet;
typedef map<int, LuaObSet> LuaObMap;

typedef map<int, long> CounterMap;

class TimeManager: public TSingleton<TimeManager>,public CCObject
{
public:
	TimeManager();
	~TimeManager();
	
	//ͬ������ȡ������ʱ��
	void syncServerTime(unsigned int serTime);
	long getCurServerTime();
	bool isInited(){return this->initFlag;}

	//��������
	string secondsToString(long seconds);

	//C++��ʱ�����
	bool registerTimer(TimeProtocol * observer, int counterId, long endTime);
	bool unregisterTimer(TimeProtocol * observer, int counterId);
	bool attachTimer(TimeProtocol * observer, int counterId);

	//Lua��ʱ�����
	int registerLuaTimer(int handler, int counterId, long endTime);
	bool unregisterLuaTimer(int handler, int counterId);
	int attachLuaTimer(int handler, int counterId);
	void setTimeZone(int val){timeZone =val ;}
	int  getTimeZone(){return timeZone;}
	//��ʱ����������ͣ������
	bool startTimer(int counterId, long endTime);
	bool stopTimer(int counterId);	
	bool renewTimer(int counterId, long endTime);

	//����ʱ��
	bool hasTimer(int counterId);
	bool hasObserver(TimeProtocol * observer, int counterId);
	bool hasLuaObserver(int handler, int counterId);

	virtual void update(float dt);

	void ResetData();
    
    //CC_SYNTHESIZE(long, m_shopFreshTime, shopFreshTime)
private:
	void updateObservers(long delta);
	void updateLuaObservers(long delta);
	#ifdef OUR_DEBUG
	void updateMem(float dt);
    #endif
	//����ͬ��ϵͳʱ��
	long serverMinusLocalTime;

	//���µı���ʱ�䣬����������֪ͨ
	long latestLocalTime;

	//�Ƿ�ͬ����ϵͳʱ��
	bool initFlag;
	int  timeZone ;

	TimeObMap timeObMap;	
	LuaObMap luaObMap;

	CounterMap counterMap;

	//���ټ��
	long lastSyncServerTime;
	int acceCount;
};
