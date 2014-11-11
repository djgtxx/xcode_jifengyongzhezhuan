//
//  IEvent.h
//  iSeer
//
//  Created by b a on 12-5-17.
//  Copyright (c) 2012�� __MyCompanyName__. All rights reserved.
//

#ifndef iSeer_IEvent_h
#define iSeer_IEvent_h

#include <vector>
#include <map>

#include "EventID.h"

/// 
// class IEvent
// 
class IEvent
{
public:
    virtual unsigned int GetID() = 0;
    virtual void*GetData() = 0;     
};

///
// class IEventHandler
//
class IEventHandler
{
public:
    virtual void HandleEvent(EVENTID id, IEvent* pkEvent) = 0;
    
};


///
// class IEventCenter
// 
class IEventCenter
{
public:
    /**
     * @brief ע���¼�������
     * @param uiEvent,   �¼����
     * @param pkHandler, �¼�������
     * @return bool, true: ע��ɹ�, false : ʧ��
     * @
     */
    virtual bool RegisterEvent(EVENTID uiEvent, IEventHandler* pkHandler) = 0;
    
    
    /**
     * @brief ��ע���¼�������
     * @param uiEvent,   �¼����
     * @param pkHandler, �¼�������
     * @return bool, true: ע��ɹ�, false : ʧ��
     * @
     */
    virtual void RemoveEvent(EVENTID uiEvent, IEventHandler* pkHandler) = 0;
    
    /**
     * @brief ע��Root�¼�������
     * @param pkHandler, �¼�������
     * @return void, 
     * @note  ������е��¼�͸��root Handlerer
     */
    virtual void SetRootEvent(IEventHandler* pkRootHandler) = 0; 
};



typedef std::vector<IEventHandler*> VecEventHandler;
typedef std::map<EVENTID, VecEventHandler>EventID2Handlers;



class CEventCenter : public IEventCenter
{
   
public: 
    CEventCenter();
    
    
    /**
     * @brief ע���¼�������
     * @param uiEvent,   �¼����
     * @param pkHandler, �¼�������
     * @return bool, true: ע��ɹ�, false : ʧ��
     * @
     */
    virtual bool RegisterEvent(EVENTID uiEvent, IEventHandler* pkHandler);
    
    
    /**
     * @brief ��ע���¼�������
     * @param uiEvent,   �¼����
     * @param pkHandler, �¼�������
     * @return bool, true: ע��ɹ�, false : ʧ��
     * @
     */
    virtual void RemoveEvent(EVENTID uiEvent, IEventHandler* pkHandler); 
    
    
    /**
     * @brief ע��Root�¼�������
     * @param pkHandler, �¼�������
     * @return void, 
     * @note  ������е��¼�͸��root Handlerer
     */
    virtual void SetRootEvent(IEventHandler* pkRootHandler); 
    
    
    /**
     * @brief ���ע���¼�������
     * @return void,
     * @
     */ 
    virtual void ClearAllHandlers();
    
protected:
    virtual void DispatchEvent(EVENTID uiEvent, IEvent& pEvent);
    
    
protected:
    EventID2Handlers  m_mapGameEventID2Handlers;  
    
    IEventHandler* m_pRootHandler;
};



class PkgEvent : public IEvent
{
public :
    PkgEvent(unsigned int ID, void* data)
    {
        m_pPkgData = data;    
        m_uiCMD = ID;
    }
    
    
    /** 
     * @brief: ��ȡ�¼����
     * @param: void
     * @return:unsigned int
     */     
    virtual unsigned int GetID(){return m_uiCMD;};
    
    /** 
     * @brief: ��ȡ�¼����
     * @param: void
     * @return:void* , ���ݶ���
     */ 
    virtual void* GetData() {return m_pPkgData;};
    
protected:
    void* m_pPkgData;
    unsigned int m_uiCMD;
};

#endif
