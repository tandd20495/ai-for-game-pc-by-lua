LJ    +   H   �f   +      T�G  4   >    T�/  4  > T �4  > G   �	StopstartTaskManagerloadConfig�  	 )/  +     '   ' I�4  + 6684 % % 	 %
 4 > =4 % % 	 %
 4 > =4  % >K�4 % % 4 >% >G   ��TriggerEvent	Stopon-task-interruptnx_currenton-task-stopUnsubscribe admin_zdn\zdn_event_managernx_executeTASK_LISTb   +      T 
�4  +  % >    T�4  +  % > G  �nx_execute
Startnx_find_script�  	 /+      T�4   > ,  4  > G  4     '   ' I�4 4 6% >  T�4 4 6% >  T�4 6, 4 4 6% >4 % 4 6$>G  K�- G   ��
Stop Consolenx_executeIsRunningnx_find_scriptCAN_RUN_LOGIC_LIST	Stopnx_current�   l2   ,   2   ,  4   % % % >   T>�4 4   >% >4  >D2�4  %	 >8  T�'  ;'  ;' ;'; ;4	 4	
 8
>	4
 8>

 T
�)
 T�)
 8888>4 4	
 8
>	6	8  T	
�4	 4

 8>
6	
	8		4
 	 % >
BN�4 4  % % % > =  T�) T�) , 4 4  % % % > =  T�) T�) , +   '   T�) H ) H ����StopOnDieStopOnDoneLoadConfignx_executeTASK_LIST1nx_numberaddToTodoList,
pairs;nx_stringutil_split_string	Task
TroLyIniReadUserConfig� 
   T�4  7+    >2  : 4  >:4  >:4  >:4  >:4  7+ 	 >G  ��endTimeMntendTimeHrstartTimeMntnx_numberstartTimeHrtaskIndexinsert
table!    4   > G  checkNextTask� 
   +   '  ' I�4  +  668  T�4  +	  6		6	8T�K�4  % $>4 >G  �checkNextTask stoppedConsoleTASK_LIST�  
 z4   % > 4  > 4  >    T�4   % > 4  % % > G  +      '   ' I�+  64  >  T�4	 684  %
 4		 6		8		$	>4  %	 >G  K�+   T$�4 >  T �Q�'   ' I�+  64  >  T�4	 684  %
 4		 6		8		$	>4  %	 >G  K�4 ' >T�4  % >+   T�4 >G  +   T	�4 % % >  T�4 >G  4 >  T	�Q�+   T�G  4 ' >T�4 >G  � ���checkNextTaskanyTaskAvailableIsPlayerDeadadmin_zdn\zdn_logic_skill	StopAll task is done.nx_pauseneedToWaitNext task: TASK_LISTcanRunTask
Startadmin_zdn\zdn_logic_noi_tunx_executeNext task: Cắn nội tucanRunNoiTustopAllTaskSilentlyCheck next taskConsole\   +      '   ' I
�+  64   >  T�) H K�) H �canRunTask�  	 +      4  >'   ' I�4 +  6684  % >  T�4  % >K�4 >G  �subscribeAllTaskEvent	StopIsRunningnx_executeTASK_LISTunsubscribeAllTaskEvent�   +      '   ' I�4  +  6684 % % 	 %
 4 > =4 % % 	 %
 4 > =K�G  �on-task-interruptnx_currenton-task-stopUnsubscribe admin_zdn\zdn_event_managernx_executeTASK_LIST�  	 +      '   ' I�4  +  6684 % % 	 %
 4 >% >4 % % 	 %
 4 >% >K�G  �onTaskInterrupton-task-interruptonTaskStopnx_currenton-task-stopSubscribe admin_zdn\zdn_event_managernx_executeTASK_LIST�  	 +      '   ' I�4  +  6684  % >  T�) H K�) H �IsTaskDonenx_executeTASK_LIST� 
 =+    T�G  4  + >'  T�G  4 >  T�4   % >G  4 >, +  '  ' I�+ 64 68  T
�4 	 >  T�4 	  %
 >G  4 	 >  T	�4 %		 >4 	  %
 >G  K�G   ���Task interruptedConsolecanRunTaskisInTaskTimeTASK_LISTTimerInit	Stopnx_executecanRunNoiTuTimerDiff�  $+   '  ' I�+  67   T�4 74 %	 %
 > = 4 74	 %
 % >	 = 4	 
  77	7
7@	 K�) H �endTimeMntendTimeHrstartTimeMntstartTimeHrisBetweenGetCurrentMinuteGetCurrentHouradmin_zdn\zdn_logic_basenx_execute
floor	mathtaskIndexd   4     	 
 >  T�4    	 
 >H isBelowEndTimeisBeyondStartTime?      T�) H   T� T�) T�) H ) H ?      T�) H   T� T�) T�) H ) H d   4  6 84  % >  T�4   >H isInTaskTimeCanRunnx_executeTASK_LIST�  	 +      '   ' I�4  +  668 T�4 +  6>  T�) H 4  % @ K�) H �CanRunnx_executeisInTaskTimeadmin_zdn\zdn_logic_noi_tuTASK_LIST�  2 A4   % > 4   % > 4   % > 4   % > )  2  % 2  '  ) ) 1 5 1 5	 1
 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1 5 1  5! 1" 5# 1$ 5% 1& 5' 1( 5) 1* 5+ 1, 5- 1. 5/ 10 51 0  �G  canRunNoiTu canRunTask isBelowEndTime isBeyondStartTime isBetween isInTaskTime onTaskInterrupt needToWait subscribeAllTaskEvent unsubscribeAllTaskEvent stopAllTaskSilently anyTaskAvailable checkNextTask onTaskStop startTaskManager addToTodoList loadConfig StopGlobalTask ContinueGlobalTask 	Stop 
Start IsRunning &admin_zdn\zdn_define\logic_define%admin_zdn\zdn_define\task_defineadmin_zdn\zdn_utilutil_functionsrequire 