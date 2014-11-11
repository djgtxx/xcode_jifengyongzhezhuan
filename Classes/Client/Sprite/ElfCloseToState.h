/************************************************************************/
/* �ļ�����������׷������״̬                                           */
/************************************************************************/

#pragma once
#include "FAbstractTransition.h"
#include "BaseAttackState.h"
#include "ElfBaseState.h"

class SpriteElf;
class SpriteSeer;

class ElfCloseToState : public ElfBaseState
{
public:
	ElfCloseToState(BaseElfEvt *pEvt);
	virtual ~ElfCloseToState(void);

	virtual void Reset();

	virtual bool Entered();

	virtual void Update(float dt);

	virtual void Exited();

	float GetGoTime()
	{
		return m_fGoTime;
	}

	bool IsInOuterCircle(float distance);
protected:
	float m_fGoTime;
	float m_accTotalTime;
	float m_accelateRate;
	float m_maxSpeed;
	// Note: m_followPointType����ĸ���� 0 ��� 1 �Ҳ�
	unsigned int	  m_followPointType;
	// Note: ������ٸ���Ȧ
	float m_outerCircleRadius;
	float m_startSpeedCoefficient;
};