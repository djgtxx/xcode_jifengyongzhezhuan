//
//  Engine.h
//  iSeer
//
//  Created by b a on 12-5-30.
//  Copyright (c) 2012�� __MyCompanyName__. All rights reserved.
//

#include "Engine.h"
#include "TouchChecker.h"
#include "Event.h"
#include "stdlib.h"

#include "EnginePlayerManager.h"
#include "AspriteManager.h"

TouchChecker* Engine::m_pkTouchChecker = new TouchChecker();
CEventCenter* Engine::m_pkEventCenter = NULL;
Engine::DebugINF Engine::ms_kDebuginf;
     
void  Engine::_SDMInit()
{
    //to do ...
    m_pkEventCenter = new CEventCenter();
}

     
void  Engine::_SDMShutDown()
{
    // to do...
    if (m_pkEventCenter)
	{
		m_pkEventCenter->ClearAllHandlers();
		delete m_pkEventCenter;
		m_pkEventCenter = NULL;
	}

	if (m_pkTouchChecker)
	{
		delete m_pkTouchChecker;
		m_pkTouchChecker = NULL;
	}

	EnginePlayerManager::purgeInstance();
	AspriteManager::purgeInstance();
}
    
/** 
 * @brief: ��ȡ�ܷ������¼��ļ����
 * @param: void
 * @return:TouchChecker, 
 */      
TouchChecker* Engine::GetChecker()
{
    return m_pkTouchChecker;
}

CEventCenter* Engine::GetEventCenter()
{
	return m_pkEventCenter;
}

/** 
 * @brief: ��ȡ�ܷ������¼�
 * @param: void
 * @return:bool, true: for enable, otherwise false
 */ 
bool Engine::CanTouchNow()
{
    if (m_pkTouchChecker)
        return m_pkTouchChecker->CanTouchNow();
    
    return true;
}

Engine::DebugINF& Engine::GetDebugInf()
{
	return ms_kDebuginf;
}