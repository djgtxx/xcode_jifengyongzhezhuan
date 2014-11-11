//
//  ResourcesUpdateManager.h
//  UpateResourceDemo
//
//  Created by Delle  on 13-7-11.
//
//

#ifndef __UpdateInfoFromServer__
#define __UpdateInfoFromServer__

#include <iostream>
#include <string>
#include "cocos2d.h"
#include "json_res.h"
#include "vector"
using namespace std;

struct ServerInfo
{
	std::string tServerName;
	std::string tServerIp;
	std::string tServerPort;

	ServerInfo():tServerName(""),tServerPort(""),tServerIp(""){}
};

class UpdateInfoFromServer
{
public:
	static UpdateInfoFromServer *sharedInstance();
	~UpdateInfoFromServer();
	
	/**
	* Instruction : ����������Ϣ�� ��γ�������
	* @param 
	*/	
	bool downloadConfigFileList(const char* channelId,const char* mainVersion,const char* subVersion,int type);
	std::string GetDownLoadInfoString(){return m_strFileList;}
	bool parseRcvMessageFromServer();	
	std::string GetApkUrl(){return m_apkUrl;}
	std::string GetCdnUrl(){return m_cdnUrl;}
	 // ��ȡurl�б�m_lstCdnUrl�е����һ����ַ
	std::string GetEndOfCdnUrlList();            
	const std::vector<ServerInfo> & GetServerInfo() {return m_vecServerInfo;}
	static void removeSubStringFromString(std::string subString,std::string &sourceString);

	void setFileList(string fileList){m_strFileList = fileList;};
private:
	UpdateInfoFromServer();

	/**
	* Instruction : URL download. ��������
	* @param 
	*/	
	bool downloadConfigFileListOneTime(const char* url,const char* postMessage);
	bool parseServerInfo(const Json::Value &serverInfo);	
	static size_t configFileDownLoadCallback(char* ptr, size_t size, size_t nmemb, void* context);
private:
	static UpdateInfoFromServer* instance;
	Json::Value m_jvJsonValue;
	std::string m_strFileList;
	int m_nRepeatTimes;
	std::string m_apkUrl;
	std::string m_cdnUrl;
	std::list<string> m_lstCdnUrl;    // ��Ŵӷ�������ȡ�ĸ�����Դ��url
	std::vector<ServerInfo> m_vecServerInfo;
};

#endif //__UpdateInfoFromServer__
