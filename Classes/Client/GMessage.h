// TAOMEE GAME TECHNOLOGIES PROPRIETARY INFORMATION
//
// This software is supplied under the terms of a license agreement or
// nondisclosure agreement with Taomee Game Technologies and may not 
// be copied or disclosed except in accordance with the terms of that 
// agreement.
//
//      Copyright (c) 2012-2015 Taomee Game Technologies. 
//      All Rights Reserved.
//
// Taomee Game Technologies, Shanghai, China
// http://www.taomee.com
//
#pragma once


//// define GLOBAL message 
#define  GM_CLOSE_PPVELAYER      0x10000001   /// close ppve message
#define  GM_CLOSE_PVPLAYER       0X10000002   /// close pvp message

#define  GM_APPLICATION_RESUME						0x10000003   /// resume from background
#define  GM_APPLICATION_ENTER_BACKGROUND			0x10000004   /// enter background when a phone call coming in

/// download map resources failed, the reason maybe be network disconnected
#define  GM_DOWNLOAD_MAP_FAIL		0x10000005
#define  GM_NETWORK_ERROR			0x10000006

/// userdata update msg
#define  GM_ATTR_COIN_UPDATE			0x10000007			//���������
#define  GM_ATTR_SP_UPDATE				0x10000008			//���ܸ���
#define  GM_ATTR_SP_CHIP_UPDATE			0x10000009			//��ʯ��Ƭ
#define  GM_ATTR_SP_DIAMOND_UPDATE		0x10000010			//שʯ
#define  GM_ATTR_HERO_LEVEL_UPDATE		0x10000011			//��ҵȼ�
#define  GM_ATTR_PHYSICAL_ATTACK_UPDATE		0x10000012		//������
#define  GM_ATTR_MAGIC_ATTACK_UPDATE		0x10000013		//ħ������
#define  GM_ATTR_SKILL_ATTACK_UPDATE		0x10000014		//���ܹ���
#define  GM_ATTR_PHYSICAL_DEFENCE_UPDATE	0x10000015		//�������
#define  GM_ATTR_MAGIC_DEFENCE_UPDATE		0x10000016		//ħ������
#define  GM_ATTR_SKILL_DEFENCE_UPDATE		0x10000017		//���ܷ���
#define  GM_ATTR_HEALTH_POINT_UPDATE		0x10000018		//����ֵ
#define  GM_ATTR_ACCURATE_UPDATE			0x10000019		//��׼
#define  GM_ATTR_DODGE_UPDATE				0x10000020		//����
#define  GM_ATTR_WRECK_UPDATE				0x10000021		//�ƻ�
#define  GM_ATTR_PARRY_UPDATE				0x10000022		//��
#define  GM_ATTR_CRITICAL_STRIKE_UPDATE		0x10000023		//����
#define  GM_ATTR_TENACITY_UPDATE			0x10000024		//����
#define  GM_ATTR_SLAY_UPDATE				0x10000025		//��ɱ
#define  GM_ATTR_SPEED_UPDATE				0x10000026		//����
#define  GM_ATTR_PROFICIENCY_UPDATE			0x10000027		//Ǳ��
#define  GM_ATTR_ABILITY_ALL_UPDATE			0x10000028		//ս��
#define  GM_ATTR_COURAGE_UPDATE				0x10000029		//����
#define  GM_ATTR_CHARM_UPDATE				0x10000030		//ħ��
#define  GM_ATTR_TRICK_UPDATE				0x10000031		//����
#define	 GM_ATTR_STAMINA_UPDATE				0x10000032		//����
#define	 GM_ATTR_REPUTATION_UPDATE			0x10000033		//����
#define	 GM_ATTR_EXP_UPDATE					0x10000034		//����
#define  GM_ATTR_PLAYER_EXPOLIT				0x10000035		//��ѫ
#define  GM_ATTR_PLAYER_EXPLOER_EXP			0x10000036		//��������
#define  GM_ATTR_GEM_RECAST					0x10000037		//��ʯ�����������
#define	 GM_ATTR_PLAYER_GEM_ANIMA			0x10000038		//��ʯ������

#define  GM_ATTR_EQUIP_LVUP_UESED_TIMES			0x10000039		//����ʣ�����
#define  GM_ATTR_EQUIP_LVUP_CD				0x10000040		//����CD�ı�

#define  GM_NETWORK_DISCONNCT				0x10000041		//���������ж�


#define  GM_CLOSE_TALENTLAYER    0X10000042  /// close talent message
#define  GM_CLOSE_AUTOONHOOK     0X10000043  /// close autoOnHook message

#define	 GM_LUA_LAYER_CLOSE		 0X10000044

#define  GM_E_ENTER_MAINLAND      0x10000045   /// ��������
#define  GM_E_ENTER_FB			0x10000046   /// ���븱��

#define  GM_ATTR_BUY_BAG_CAPACITY			0x10000047   /// ��������������
#define  GM_ATTR_BUY_STORE_CAPACITY			0x10000048   /// �ֿ����������
#define  GM_ATTR_BUY_SS_BAG_CAPACITY		0x10000049   /// ��ʯ����������

#define  GM_ATTR_AUTO_FIGHT_CD				0x10000050		//auto fight cool down�ı�
#define  GM_ATTR_BAO_ZHANG_COIN_CHANGE				0x10000051		//yong zhe bang zhang   coin change
#define  GM_ATTR_VIP_LEVEL_CHANGE				0x10000052		// level change

#define  GM_E_ENTER_MAINLAND_COLOR_LAYER_OVER      0x10000053   /// �������Ǻ�����ʧ
#define  GM_ATTR_SERVER_TIME_SYNCED				0x10000054		// have get server time

#define  GM_E_ENTER_FIRST_LOGIN_STATE      0x10000055   //  ��һ�ν��������Զ�������
#define	 GM_ATTR_FRAG_STONE			0x10000056		//����ʯ
#define	 GM_ATTR_FRAG_CAN_CONPOSE			0x10000057		//�Ƿ���װ����Ƭ�ɺϳ�
#define	 GM_FAIRY_SELECT_DONE				0x10000058		// ����ѡ�����

#define  GM_ATTR_SP_SOUL_STONE_UPDATE     0x10000059      // ��ʯ����
#define  GM_ATTR_FAIRY_EFFECTIVENESS      0x10000060      // ����ս����
#define  GM_ATTR_FAIRY_FETTER		      0x10000061      // ������Я
#define  GM_ATTR_NEW_EQUIP_CHANGE		  0x10000062      // ��װ����Ϣ
#define  GM_ATTR_SPRITE_EXTRACT           0x10000063      // ��ѳ鿨��Ϣ
#define  GM_ATTR_DIAMOND_ACCU             0x10000064      // �ܳ�ֵ���

#define	 GM_ATTR_FARIY_FLAG_ENOUGH			0x10000065		// �Ƿ��о�����Ƭ�ɺϳ�
#define	 GM_ATTR_NEW_FAIRY_INFO				0x10000066		// �¾�����Ϣ
#define  GM_ATTR_PLAY_UCVIP_REFRESH         0x10000067      // UC��Ա��Ϣˢ��
#define  GM_OPEN_UCVIP                      0x10000068      // ����UC��Ա
#define  GM_UPDATE_EXCHANGE_PARAMETER       0x10000069      // ��Ʒ�۸����
#define  GM_UPDATE_SHOP_REFRESH_TIMES       0x10000070      // ˢ�������̵���Ѵ���
#define  GM_UPDATE_TARGET_ICON				0x10000071      // �ɳ�Ŀ���ⲿ��ʾICON
#define  GM_UPDATE_MARKET_TIME_INFO		    0x10000072      
#define  GM_UPDATE_GUILD_LIST               0x10000073      // ���¹����б�
#define  GM_MONTHCARD_GET_SUCCESS			0x10000074
#define  GM_CREATE_GUILD_SUCCESS            0x10000075      // ��������ɹ�
#define  GM_UPDATE_GUILD_INFO               0x10000076      // ������Ϣ����
#define  GM_UPDATE_GUILD_MEMBER             0x10000077      // �����Ա�б����
#define  GM_UPDATE_USER_EQUIP_TITLE         0x10000078      
#define  GM_CHANGE_USER_GUILD				0x10000079      // ������˳�����
#define  GM_GET_GUILD_RECORD_INFO           0x10000080      // ��ȡ�����¼
#define  GM_GET_PLAYER_CHANGE_NAME          0x10000081      // �û�����
#define  GM_GET_NEW_SKILL		            0x10000082      // �¼���

// Note: �������Message
#define  GM_E_TASK_FIRST_ID_STATE         0x10000100   /// �õ����ȼ���ߵ�����
////////////////////////////

#define	 GM_UPDATE_AUTO_BATTLE_TIMES				0x10000110		//ɨ����������




