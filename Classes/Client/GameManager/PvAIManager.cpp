#include "OnlineNetworkManager.h"
#include "PvAIManager.h"
#include "GameManager.h"
#include "SkillDispMgr.h"
#include "LevelManager.h"
#include "BaseAttackState.h"
#include "LevelLayer.h"
#include "TXGUIHeader.h"
#include "UserData.h"
#include "Localization.h"
#include "LuaTinkerManager.h"
#include "GameFontManager.h"
#include "MainMenuLayer.h"
#include "TimeManager.h"
#include "UIManager.h"

#define AUTO_ATTACK_CD 0.2f
#define A_TEXT_LABEL_TAG 12000
#define A_NAME_LABEL_TAG 13000

PvAIManager::PvAIManager()
	:aiPlayer(NULL)
	,lastAIPlayer(NULL)
	,aiAutoAttack(false)
	,aiAutoAttackCDTime(0.0f)
	,inited(false)
	,coolDownEndTime(0)
	,inPvAIBattle(false)
	,remainCount(10)
	,buyCount(0)
    ,heroRank(-1)
{
	aiPlayerId.setPlayId(0,0,0);
}

PvAIManager::~PvAIManager()
{
}

void PvAIManager::Update(float dt)
{
	if (aiAutoAttackCDTime < AUTO_ATTACK_CD)
	{
		aiAutoAttackCDTime += dt;
	}
	else if (aiAutoAttack)
	{
		if (aiPlayer)
		{
			moveToHero();
		}		
		aiAutoAttackCDTime = 0.0f;
	}
}

void PvAIManager::sendPvAIReq(int buttonIndex)
{
	if(buttonIndex - 1 < aiPlayerVec.size())
	{
		this->aiPlayerId = aiPlayerVec[buttonIndex - 1].id;
		OnlineNetworkManager::sShareInstance()->sendPvAIReq(aiPlayerId);
		OnlineNetworkManager::sShareInstance()->sendGetUserSkillReqMessage(aiPlayerId);
	}
	
}

void PvAIManager::setAIAutoAttack(bool autoAttack)
{	
	this->aiAutoAttack = autoAttack;
	if (this->aiAutoAttack)
	{
		LevelLayer * layer = LevelManager::sShareInstance()->getCurrentLevelLayer();
		if (layer && aiPlayerId.getID() != 0)
		{
			aiPlayer = layer->getPlayer(aiPlayerId);
			lastAIPlayer = aiPlayer;
			if (aiPlayer)
			{
				aiPlayer->SetMoveType(MOVE_BY_MOUSE);
			}			
		}
	}
	else
	{
		if (aiPlayer)
		{
			aiPlayer->moveToTarget(aiPlayer->getPosition(), aiPlayer->getPosition());
			//ֹͣ�Զ�����ʱͬʱ��ai����ÿգ���ζ��֮���޷�����ai���
			aiPlayer = NULL;
		}		
	}
}

//�������ü���
void PvAIManager::setAISkillsId(vector<int> equipSkills)
{
	attackSkillVec.clear();
	buffSkillVec.clear();

	//��ʼ������vector
	SkillDispMgr * skillMgr = SkillDispMgr::Get();

	if (aiPlayer)
	{
		int normalAttackId = skillMgr->GetNormalAttackID(aiPlayer->GetID(), aiPlayer->getType());
		attackSkillVec.push_back(normalAttackId);
	}

	for (size_t i = 0; i < equipSkills.size(); i++)
	{
		//bool isUnlock = skillMgr->IsEquipSkill(skillTmp[i]);
		const SKILL_INFO * info = skillMgr->GetSkillInfo(equipSkills[i]);

		//��ͨ����Ĭ��δ����


		if (info->partID == 1)
		{
			/* if (isUnlock)*/
			{
				if (info->bBuff)
				{
					buffSkillVec.push_back(equipSkills[i]);
				}
				else
				{
					attackSkillVec.push_back(equipSkills[i]);
				}
			}
		}
	}
}

//�����˺�����
void PvAIManager::onEventLocalHurt(CSPlayerHitPlayerReq attackReq)
{
	for(int i = 0; i < attackReq.users_size(); i++)
	{
		const AttackPlayerInfo& info = attackReq.users(i);
			
		//unsigned int uid = info.userid();
		PLAYER_ID playId;
		playId.setPlayId(info.userid(),info.reg_time(),info.channel_id());
		unsigned int blood = info.blood();
		unsigned int type = info.hurt_type();
		// TODO : 
		unsigned int ragePoint = 0;
		bool isFairy = true;
		const SKILL_INFO* pSkillInfo = SkillDispMgr::Get()->GetSkillInfo(attackReq.action_id());
		if(pSkillInfo)
		{
			ragePoint = pSkillInfo->ragePoint;
			isFairy = false;
		}
		
		SpriteSeer * player = NULL;
		SpriteSeer* hero = GameManager::Get()->getHero();
		if (hero && hero->GetID() == playId)
		{
			player = hero;
		}
		else
		{
			LevelLayer* layer = LevelManager::sShareInstance()->getCurrentLevelLayer();
			if (layer && layer->m_othersPlayerInfo.find(playId) != layer->m_othersPlayerInfo.end())
			{
				player = layer->m_othersPlayerInfo.find(playId)->second.seer;
			}
		}

		if (player)
		{
			CCPoint damagePoint = ccpAdd(player->getPosition(),player->getAttachPoint(kType_PLAYER_NAME));
			switch(type)
			{
			case 1: // ����
				GameManager::Get()->GetSceneLayer()->getMainMenuLayer()->HandleAttackMissEffect(damagePoint);
				break;
			case 2: // ��
				player->ByAttacked(blood, ragePoint,false,isFairy);
				GameManager::Get()->GetSceneLayer()->getMainMenuLayer()->HandleAttackBlockEffect(damagePoint);
				break;
			case 3: // ����
				player->ByAttacked(blood, ragePoint, true,isFairy);
				break;
			default:
				player->ByAttacked(blood, ragePoint,false,isFairy);
				break;
			}
		}
	}
}

void PvAIManager::moveToHero()
{
	SpriteSeer * hero = GameManager::Get()->getHero();

	SkillDispMgr * skillMgr = SkillDispMgr::Get();

	int skillId = getBestSkill();
	if (aiPlayer && skillId)
	{
		for (size_t i = 0; i < attackSkillVec.size(); i++)
		{
			if (skillId == attackSkillVec[i])
			{
				attackSkillVec.erase(attackSkillVec.begin() + i);
				attackSkillVec.push_back(skillId);
				break;
			}
		}

		for (size_t i = 0; i < buffSkillVec.size(); i++)
		{
			if (skillId == buffSkillVec[i])
			{
				buffSkillVec.erase(buffSkillVec.begin() + i);
				buffSkillVec.push_back(skillId);
				break;
			}
		}

		if( hero && hero->CanAim())
		{
			if (skillMgr->GetSkillInfo(skillId)->type != ToNormalAttack)
			{
				CCPoint vec = ccpSub(hero->getPosition(), aiPlayer->getPosition());
				if (vec.x != 0 || vec.y != 0)
				{
					vec = ccpNormalize(vec);
				}				
				aiPlayer->setDirection(vec);

				//˲�����⴦��
				if (4046101 == skillId)
				{
					aiPlayer->setDirection(ccp(-vec.x, -vec.y));
				}

				if(!aiPlayer->DoSkillAttack(skillId))
				{
					if (hero)
					{
						if( aiPlayer->canMove)
							aiPlayer->moveToTarget(hero->getPosition(), aiPlayer->getPosition());
					}
				}
			}
			else
			{
				CCPoint vec = ccpSub(hero->getPosition(), aiPlayer->getPosition());
				if (vec.x != 0 || vec.y != 0)
				{
					vec = ccpNormalize(vec);
				}				
				aiPlayer->setDirection(vec);
				aiPlayer->DoNormalAttack();
			}
		}
		
	}
	else if (aiPlayer && hero)
	{
		if(hero->CanAim())
		{
			CCPoint pt = hero->getPosition();
			CCPoint pixPos = aiPlayer->getPosition();
			if (LevelManager::sShareInstance()->isPointReachable(pt))
			{
				aiPlayer->moveToTarget(pt, pixPos);
			}
			//�����������������Ϊ�������󣬲�������
		}		
	}

	return;
}

int PvAIManager::getBestSkill()
{
	int skillId = 0;
	bool canDoSkill = false;
	std::set<int> conflictSkillSet;
	std::vector<int> canDoSkillVec;

	SpriteSeer * hero = GameManager::Get()->getHero();
	if (!hero)
	{
		return skillId;
	}

	SkillDispMgr * skillMgr = SkillDispMgr::Get();

	//��������ͷŵļ����б��Լ��뵱ǰ���ܳ�ͻ�ļ����б������ж������
	for (size_t i = 0; i < attackSkillVec.size(); i++)
	{
		const SKILL_INFO * info = skillMgr->GetSkillInfo(attackSkillVec[i]);
		if (aiPlayer && aiPlayer->m_pScheduler && aiPlayer->m_pStateMachine->CheckStateRuning(info->type))
		{
			conflictSkillSet.insert(info->skillConflict);
		}
	}

	//��ȡ�����ͷŲ��ڹ����������Ҳ���ͻ�ļ��ܣ���������
	for (size_t i = 0; i < attackSkillVec.size(); i++)
	{
		const SKILL_INFO * info = skillMgr->GetSkillInfo(attackSkillVec[i]);

		if (aiPlayer && !skillMgr->IsCD(aiPlayerId, attackSkillVec[i]) &&
			(ccpDistance(aiPlayer->getPosition(), hero->getPosition()) < info->longDistanceAttackRange) )
		{
			if (conflictSkillSet.find(attackSkillVec[i]) == conflictSkillSet.end())
			{
				canDoSkillVec.push_back(attackSkillVec[i]);
			}			
		}		
	}

	//buff����
	for (size_t i = 0; i < buffSkillVec.size(); i++)
	{
		const SKILL_INFO * info = skillMgr->GetSkillInfo(buffSkillVec[i]);

		if (!skillMgr->IsCD(aiPlayerId, buffSkillVec[i]))
		{
			if (conflictSkillSet.find(buffSkillVec[i]) == conflictSkillSet.end())
			{
				canDoSkillVec.push_back(buffSkillVec[i]);
			}	
		}		
	}

	//���������ȼ�����
	int maxPriority = -1;
	for (size_t i = 0; i < canDoSkillVec.size(); i++)
	{
		const SKILL_INFO * info = skillMgr->GetSkillInfo(canDoSkillVec[i]);
		int curPriority = info->skillPriority;
		if (curPriority > maxPriority)
		{
			maxPriority = curPriority;
			skillId = canDoSkillVec[i];
		}		
	}

	return skillId;
}

void PvAIManager::onMsgPvAIReward(int accuCoin, int accuReputation, int oneCoin, int oneReputation)
{
	CCLOG("PvAIManager::onMsgPvAIReward : accuCoin : %d, accuReputation : %d, oneCoin : %d, oneReputation : %d", accuCoin, accuReputation, oneCoin, oneReputation);
	this->accuCoin = accuCoin;
	this->accuReputation = accuReputation;
	this->oneCoin = oneCoin;
	this->oneReputation = oneReputation;
	refreshPvAILayer();
}

void PvAIManager::refreshPvAILayer()
{
	UIManager *manager = UIManager::sharedManager();
	pvaiLayout = manager->getUILayout("PvAILayout");

	//ASSERT(pvaiLayout, "pvaiLayout not exist");

	if (pvaiLayout)
	{
		//����ǳ�
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiMcName")->setString(UserData::getUserName());

		//�������
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiMcRank")->setString(
			strWithNum(Localizatioin::getLocalization("M_PVAI_RANK"), heroRank).c_str());

		//�������
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiMcReputation")->setString(strWithNum(Localizatioin::getLocalization("M_PVAI_REPUTATION"), UserData::GetUserInfo().m_reputation).c_str());

		//ʣ����ս����
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiTodayLastTime")->setString(strWithNum(Localizatioin::getLocalization("M_PVAI_LASTTIME"), remainCount).c_str());

		//��ǰ����
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiNowRankNum")->setString(strWithNum("", heroRank).c_str());

		//ÿСʱ��ҽ���
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiRewardCoin1")->setString(MainMenuLayer::GetNumByFormat(this->oneCoin));

		//ÿСʱ��������
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiRewardReputation1")->setString(strWithNum("", this->oneReputation).c_str());

		//�ۼƽ�ҽ���
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiRewardCoin2")->setString(MainMenuLayer::GetNumByFormat(this->accuCoin));

		//�ۼ���������
		pvaiLayout->FindChildObjectByName<UILabel>("pvaiRewardReputation2")->setString(strWithNum("", this->accuReputation).c_str());

		//�����־�б�
		float fontSize = GameFontManager::smallFontSize();
		int logCount = aiLogInfoVec.size();
		int minLogCount = min(logCount, 4);
		//���ض�����Ŀ
		for (int i = 0; i < 4; i++)
		{
			pvaiLayout->FindChildObjectByName<UILabel>(strWithNum("pvaiChallenge", i+1))->setVisible(i < minLogCount ? true : false);
			pvaiLayout->FindChildObjectByName<UILabel>(strWithNum("pvaiChallengeResult", i+1))->setVisible(i < minLogCount ? true : false);
		}

		for (int i = 0; i < minLogCount; i++)
		{
			float factor = UIManager::sharedManager()->getScaleFactor();

			UILabel *attackOrgLabel = pvaiLayout->FindChildObjectByName<UILabel>(strWithNum("pvaiChallenge", i+1));
			UIContainer * container = pvaiLayout->FindChildObjectByName<UIContainer>("pvaiLayerContainer");
			attackOrgLabel->setVisible(false);
			CCPoint orgPos = attackOrgLabel->getPosition();
			CCPoint orgLeftPos = ccp(orgPos.x - attackOrgLabel->getLabelTTF()->getContentSize().width * factor / 2, orgPos.y);
			
			//ɾ�����еı�ǩ
			container->getCurrentNode()->removeChildByTag(A_TEXT_LABEL_TAG + i);
			container->getCurrentNode()->removeChildByTag(A_NAME_LABEL_TAG + i);

			//��ս����
			if (aiLogInfoVec[i].direct)
			{
				//��������
				string attackText = Localizatioin::getLocalization("M_PVAI_FIGHT1");
				string attackName = aiLogInfoVec[i].name;
				UILabelTTF * attackTextLabel = UILabelTTF::create(attackText.c_str(), KJLinXin, fontSize * factor, CCSizeZero,kCCTextAlignmentLeft,kCCVerticalTextAlignmentBottom);
				UILabelTTF * attackNameLabel = UILabelTTF::create(attackName.c_str(), KJLinXin, fontSize * factor, CCSizeZero,kCCTextAlignmentLeft,kCCVerticalTextAlignmentBottom);				

				attackTextLabel->setPosition(ccp(orgLeftPos.x + attackTextLabel->getContentSize().width / 2, orgLeftPos.y));
				attackNameLabel->setPosition(ccp(orgLeftPos.x + attackTextLabel->getContentSize().width + attackNameLabel->getContentSize().width/ 2, orgLeftPos.y));

				UILabel * aTextLabel = new UILabel(attackTextLabel, container->getCurrentNode());
				UILabel * aNameLabel = new UILabel(attackNameLabel, container->getCurrentNode());

				attackTextLabel->setTag(A_TEXT_LABEL_TAG + i);
				attackNameLabel->setTag(A_NAME_LABEL_TAG + i);

				aNameLabel->setColor(KAILogNameColor);
			}
			else
			{
				//������
				string defenceName = aiLogInfoVec[i].name;
				string defenceText = Localizatioin::getLocalization("M_PVAI_FIGHT2");
				UILabelTTF * defenceTextLabel = UILabelTTF::create(defenceText.c_str(), KJLinXin, fontSize * factor, CCSizeZero,kCCTextAlignmentLeft,kCCVerticalTextAlignmentBottom);
				UILabelTTF * defenceNameLabel = UILabelTTF::create(defenceName.c_str(), KJLinXin, fontSize * factor, CCSizeZero,kCCTextAlignmentLeft,kCCVerticalTextAlignmentBottom);

				defenceNameLabel->setPosition(ccp(orgLeftPos.x + defenceNameLabel->getContentSize().width / 2, orgLeftPos.y));
				defenceTextLabel->setPosition(ccp(orgLeftPos.x + defenceNameLabel->getContentSize().width + defenceTextLabel->getContentSize().width / 2, orgLeftPos.y));

				UILabel * aTextLabel = new UILabel(defenceTextLabel, container->getCurrentNode());
				UILabel * aNameLabel = new UILabel(defenceNameLabel, container->getCurrentNode());

				defenceTextLabel->setTag(A_TEXT_LABEL_TAG + i);
				defenceNameLabel->setTag(A_NAME_LABEL_TAG + i);

				aNameLabel->setColor(KAILogNameColor);
			}

			//��ս���
			UILabel *resultLabel = pvaiLayout->FindChildObjectByName<UILabel>(strWithNum("pvaiChallengeResult", i+1));

			if (aiLogInfoVec[i].win == aiLogInfoVec[i].direct)
			{				
				resultLabel->setString(Localizatioin::getLocalization("M_PVAI_WIN"));
				resultLabel->setColor(ccYELLOW);
				resultLabel->setVisible(true);
			}
			else
			{
				resultLabel->setString(Localizatioin::getLocalization("M_PVAI_LOST"));
				resultLabel->setColor(ccRED);
				resultLabel->setVisible(true);
			}
		}
	}
}

void PvAIManager::resetData()
{
	aiPlayer = NULL;
	aiAutoAttack = false;
	aiAutoAttackCDTime = 0.0f;
	aiPlayerId.setPlayId(0,0,0);
	inited = false;
	//coolDownEndTime = 0;
	inPvAIBattle = false;

}

AIPlayerInfo& AIPlayerInfo::operator = (const AIPlayerInfo& playId)
{
    name = playId.name;
    level = playId.level;
    rank = playId.rank;
    type = playId.type;
    id = playId.id;
	aiStatus = playId.aiStatus;
	return *this;
}