LJ    +   H   �    4   @  loadSetting    4   >    H  CanRun�  /+      T�G  4   >    T �4  > G  2   ,  4  % % > 4  % % 4 >% %	 '��> 4  % % 4 >%
 %	 '��> /  +      T�Q �4  > 4  (  > T �G   ��nx_pauseloopHaoKiet
30361onFullBoss
30409nx_currentaddListenadmin_zdn\zdn_listenerLeaveTeamadmin_zdn\zdn_logic_skillnx_execute	StopCanRun��̙�����   /  4   % % > 4  > 4   % % 4 >% % > 4   % % 4 >%	 % > 4   %
 % 4 >% > G   �on-task-stopTriggerEvent admin_zdn\zdn_event_manager
30361onFullBoss
30409nx_currentremoveListenadmin_zdn\zdn_listenerStopFindPathStopAutoAttackadmin_zdn\zdn_logic_skillnx_execute�  " �4   >    T�G  4  > +  7  T �4  % % 4 >% > +     T �G  4  +  7> G  4 	 +  7
+  7+  7> +   T �4  % % 4 >% > +     T �G  4  +  7
+  7+  7> G  4  >    T�4  4 > '   T �4  % % > G  T �4  > 5  4  % % 4 >% > +     T �G  4  >    T�4  % % 4 >% % > 4   >  T�4 >4 ' >G  4  > 4  % % 4 >% % % > 4   >  T�4 % % >4 4  >'  T�4	 +  7
+  7+  7>'  T�4 +  7
+  7+  7>G  4 >5  4 % %!   >G  � ��FlexAttackObjTimerGoToCenterisInRangeisAttackableisNotDeadXuongNguanx_pauseQuitBossScenenx_is_validisNotInBlackListisBossGetNearestObjadmin_zdn\zdn_logic_basepickDeadBossItemTimerInitPauseAttackadmin_zdn\zdn_logic_skillTimerWaitBossShowTimerDiffIsInBossSceneGoToPosition	PosZ	PosY	PosXGetDistanceGoToMapByPublicHomePointon-task-interruptnx_currentTriggerEvent admin_zdn\zdn_event_managernx_executeMapGetCurMapIsMapLoading�    $4   % % 4 >% % > 4   >  T�) H 4   >  T�) H 4  % %	 >4
   >  T�4   >) H addBlackListpickDeadBossPauseAttackadmin_zdn\zdn_logic_skillisNotDeadnx_is_validisNotInBlackListisBossnx_currentGetNearestObjadmin_zdn\zdn_logic_basenx_execute�  ,4  >  T�4 4 >'  T�4 >4 % % >4 ' >) H ) H T�4 >5 4	   >(   T�4
   >T�4 % % 7 >) H 
Identcustom_selectGoToObjGetDistanceToObjTimerInitnx_pausecustom_close_drop_boxcustom_sendernx_executepickItemTimerPickDeadBossTimerDiffisShowPick��̙����t    
4   % > 4   >  T�7 H Visiblenx_is_valid,form_stage_main\form_pick\form_droppicknx_value�    14   % > 4   >  T�G    7 4 'P > =4  >  T�G   7>4  >D�4 	 >  T	�4 
 7	% >	 = 	 T�4
 %	 %
  >BN�G  custom_pickup_single_itemcustom_sendernx_executeitem_exchange_xljs_markConfigIDQueryProp
pairsGetViewObjListnx_stringGetViewnx_is_validgame_clientnx_valueY  4    >  T�4 7+  7 >G  �
Identinsert
tableisNotInBlackListT  4    7 % > =   T�) T�) H NpcTypeQueryPropnx_number�   C4   % >   7 >4  >  T�) H  7% >4  >4 '  > T�) H '   ' I"� 7%	 
 ' >4 4		 
 >	%

 >8	
	  T	�4	 8
% >	8
	

  T
�4
 7

4	 8	>% >
	
  T
�)
 H
 K�) H ui_jhtime_round_	findstring,;nx_stringutil_split_stringQueryRecordnx_intInteractTraceRecGetRecordRowsnx_is_validGetPlayergame_clientnx_value�   24   4 % % % > =    T'�4   % >4  >D�4  %	 >4	 	 >  T	�+  8	:	
+  4	 8
>	:	+  4	 8
>	:	+  4	 8
>	:	) H BN�) H �	PosZ	PosYnx_number	PosXMapisPositionValid,
pairs;util_split_stringPositionHaoKietIniReadUserConfignx_stringQ  4    7 % > = 	  T�) T�) H 	DeadQueryPropnx_number�   4  % >4  % > 7>4  >  T�4  >  T�) H  7   @ CanAttackTargetnx_is_validGetPlayergame_client
fightnx_valueq  4    +  7+  7+  7>'2   T�) T�) H �	PosZ	PosY	PosXGetDistanceObjToPositionI  7  4 +  >D� T�) H BN�) H �
pairs
Ident%   4    > H isNotDead�   w4   4 > '   T �G  4  > 5  4  % % > 4  +  7+  7+  7	+  7
4 % % > = 4 % % % > TE�4 4  >% >4  >D9�4 4	 
 >	%
 >8	+
  7

	
 T	�4	 8
>	4
 7

+  7>
	
 T	�4	 8
>	4
 7

+  7	>
	
 T	
�4	 8
>	4
 7

+  7
>
	
 T	�4	 
  >	%
 $ 
	4	 
  >	4
 88888>
$ 
	BN�4 % %   >4 >  T�4 >4 ' >G  �nx_pause	StoploadSettingIniWriteUserConfig
floor	mathnx_number,
pairs;nx_stringutil_split_stringResetTimeHaoKietIniReadUserConfigGetNextDayStartTimestampadmin_zdn\zdn_logic_base	PosZ	PosY	PosXMapgenerateRecordPauseAttackadmin_zdn\zdn_logic_skillnx_executeTimerInitTimerOnFullBossTimerDiff�     %  4 4 7	 > = %  4	 4
 7

 >
 =	 %
  4 4 7 > = %  4  >$H 
floor	mathnx_string,8    4   4 ' > G  g_msg_giveupsend_server_msg�   V8 8 8 8 4  8 > T�) T�)   T�) H 4 % % %	 > T=�4 4  	 >%	 >4 	 >D1�4 4   >%	 >8 T(�4
 8>4 7 > T�4
 8>4 7 > T�4
 8>4 7 > T�4 % % >4
 8> T�) T�) H BN�) H  GetCurrentDayStartTimestampadmin_zdn\zdn_logic_basenx_execute
floor	mathnx_number,
pairs;util_split_stringResetTimeHaoKietIniReadUserConfig1nx_string�  4 C4   % > 4   % > 4   % > 4   % > 4   % > )  '2 2  2  1 5 1 5	 1
 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1  5! 1" 5# 1$ 5% 1& 5' 1( 5) 1* 5+ 1, 5- 1. 5/ 10 51 12 53 0  �G  isPositionValid QuitBossScene generateRecord onFullBoss isDead isNotInBlackList isInRange isAttackable isNotDead loadSetting IsInBossScene isBoss addBlackList pickItem isShowPick pickDeadBoss pickDeadBossItem loopHaoKiet 	Stop 
Start IsTaskDone CanRun IsRunning admin_zdn\zdn_lib_movingadmin_zdn\zdn_util$form_stage_main\form_tvt\defineshare\client_custom_defineutil_functionsrequire 