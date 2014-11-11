//
//  Event.cpp
//  iSeer
//
//  Created by b a on 12-5-17.
//  Copyright (c) 2012�� __MyCompanyName__. All rights reserved.
//

#include <iostream>
#include "Event.h"


CEventCenter::CEventCenter()
{
    m_pRootHandler = NULL;
}

/**
 * @brief ע���¼�������
 * @param uiEvent,   �¼����
 * @param pkHandler, �¼�������
 * @return bool, true: ע��ɹ�, false : ʧ��
 * @
 */
bool CEventCenter::RegisterEvent(EVENTID uiEvent, IEventHandler* pkHandler)
{
   	// һ���¼�ID��Ӧ��hander�б��У���ͬ��ָ��Ҫ���˵�
	EventID2Handlers::iterator mitEvent2Handlers = 
    m_mapGameEventID2Handlers.find(uiEvent);
	if(mitEvent2Handlers != m_mapGameEventID2Handlers.end())
	{
		VecEventHandler::iterator vitHandler = 
        mitEvent2Handlers->second.begin();
		while(vitHandler != mitEvent2Handlers->second.end())
		{
			if(*vitHandler == pkHandler)
			{
                return false;
				break;
			}
			++vitHandler;
		}
        
		if(vitHandler == mitEvent2Handlers->second.end())
		{
			mitEvent2Handlers->second.push_back(pkHandler);
		}
	}
	else
	{
		VecEventHandler vecEventHandler;
		vecEventHandler.push_back(pkHandler);
		m_mapGameEventID2Handlers[uiEvent] = vecEventHandler;
	}
    
    return true;
}

/**
 * @brief ע��Root�¼�������
 * @param pkHandler, �¼�������
 * @return void, 
 * @note  ������е��¼�͸��root Handlerer
 */
void CEventCenter::SetRootEvent(IEventHandler* pkRootHandler)
{
    m_pRootHandler = pkRootHandler;
}


/**
 * @brief ��ע���¼�������
 * @param uiEvent,   �¼����
 * @param pkHandler, �¼�������
 * @return bool, true: ע��ɹ�, false : ʧ��
 * @
 */
void CEventCenter::RemoveEvent(EVENTID uiEvent, IEventHandler* pkHandler)
{
    EventID2Handlers::iterator mitEvent2Handlers = 
    m_mapGameEventID2Handlers.find(uiEvent);
	if(mitEvent2Handlers != m_mapGameEventID2Handlers.end())
	{
		VecEventHandler::iterator vitHandler = 
        mitEvent2Handlers->second.begin();
		while(vitHandler != mitEvent2Handlers->second.end())
		{
			if(*vitHandler == pkHandler)
			{
				mitEvent2Handlers->second.erase(vitHandler);
				break;
			}
			++vitHandler;
		}
	}
}


void CEventCenter::DispatchEvent(EVENTID uiEvent, IEvent& pEvent)
{
    if (m_pRootHandler != NULL)
        m_pRootHandler->HandleEvent(uiEvent, &pEvent);
    
    EventID2Handlers::iterator mitEvent2Handlers = m_mapGameEventID2Handlers.find(uiEvent); 
    if(mitEvent2Handlers != m_mapGameEventID2Handlers.end())
	{
		VecEventHandler::iterator vitHandler = 
        mitEvent2Handlers->second.begin();
		while(vitHandler != mitEvent2Handlers->second.end())
		{
			IEventHandler* pkHandler = (*vitHandler);
            pkHandler->HandleEvent(uiEvent, &pEvent);
			++vitHandler;
		}
	}
}

void CEventCenter::ClearAllHandlers()
{
    m_mapGameEventID2Handlers.clear();
}
