/* This rule file intends to give hint messages to those who are using hi-based IPC */

SK_RULE( hiBeginProcess
	t
	SK_HINT( HI2IPC_1
	  "The function hiBeginProcess() is out-of-date. Use ipcBeginProcess() instead.\n")
)

SK_RULE( hiSkillProcess
	t
	SK_HINT( HI2IPC_2
	  "The function hiSkillProcess() is out-of-date. Use ipcSkillProcess() instead.\n")
)

SK_RULE( hiBatchProcess
	t
	SK_HINT( HI2IPC_3
	  "The function hiBatchProcess() is out-of-date. Use ipcBatchProcess() instead.\n")
)

SK_RULE( hiKillChild
	t
	SK_HINT( HI2IPC_4
	  "The function hiKillChild() is out-of-date. Use ipcKillProcess() instead.\n")
)

SK_RULE( hiStopChild
	t
	SK_HINT( HI2IPC_5
	  "The function hiStopChild() is out-of-date. Use ipcStopProcess() instead.\n")
)

SK_RULE( hiContChild
	t
	SK_HINT( HI2IPC_6
	  "The function hiContChild() is out-of-date. Use ipcContProcess() instead.\n")
)

SK_RULE( hiKillAllProcs
	t
	SK_HINT( HI2IPC_7
	  "The function hiKillAllProcs() is out-of-date. Use ipcKillAllProcesses() instead.\n")
)

SK_RULE( hiIsAliveChild
	t
	SK_HINT( HI2IPC_8
	  "The function hiIsAliveChild() is out-of-date. Use ipcIsAliveProcess() instead.\n")
)

SK_RULE( hiIsActiveChild
	t
	SK_HINT( HI2IPC_9
	  "The function hiIsActiveChild() is out-of-date. Use ipcIsActiveProcess() instead.\n")
)

SK_RULE( hiReadChild
	t
	SK_HINT( HI2IPC_10
	  "The function hiReadChild() is out-of-date. Use ipcReadProcess() instead.\n")
)

SK_RULE( hiWriteChild
	t
	SK_HINT( HI2IPC_11
	  "The function hiWriteChild() is out-of-date. Use ipcWriteProcess() instead.\n")
)

SK_RULE( hiGetExitStatus
	t
	SK_HINT( HI2IPC_12
	  "The function hiGetExitStatus() is out-of-date. Use ipcGetExitStatus() instead.\n")
)

SK_RULE( hiSoftInterrupt
	t
	SK_HINT( HI2IPC_13
	  "The function hiSoftInterrupt() is out-of-date. Use ipcSoftInterrupt() instead.\n")
)

SK_RULE( hiSleep
	t
	SK_HINT( HI2IPC_14
	  "The function hiSleep() is out-of-date. Use ipcSleep() instead.\n")
)

SK_RULE( hiWait
	t
	SK_HINT( HI2IPC_15
	  "The function hiWait() is out-of-date. Use ipcWait() instead.\n")
)

SK_RULE( hiWaitForChild
	t
	SK_HINT( HI2IPC_16
	  "The function hiWaitForChild() is out-of-date. Use ipcWaitForProcess() instead.\n")
)

SK_RULE( hiGetChildPid
	t
	SK_HINT( HI2IPC_17
	  "The function hiGetChildPid() is out-of-date. Use ipcGetProcessPid() instead.\n")
)

SK_RULE( hiActivateBatch
	t
	SK_HINT( HI2IPC_18
	  "The function hiActivateBatch() is out-of-date. Use ipcActivateBatch() instead.\n")
)

SK_RULE( hiActivateMessages
	t
	SK_HINT( HI2IPC_19
	  "The function hiActivateMessages() is out-of-date. Use ipcActivateMessages() instead.\n")
)

SK_RULE( hiSetPriority
	t
	SK_HINT( HI2IPC_20
	  "The function hiSetPriority() is out-of-date. Use ipcSetPriority() instead.\n")
)

SK_RULE( hiGetPriority
	t
	SK_HINT( HI2IPC_21
	  "The function hiGetPriority() is out-of-date. Use ipcGetPriority() instead.\n")
)

SK_RULE( hiGetPid
	t
	SK_HINT( HI2IPC_22
	  "The function hiGetPid() is out-of-date. Use ipcGetPid() instead.\n")
)

SK_RULE( hiCloseChild
	t
	SK_HINT( HI2IPC_23
	  "The function hiCloseChild() is out-of-date. Use ipcCloseProcess() instead.\n")
)

SK_RULE( hiIPCDebug
	t
	SK_HINT( HI2IPC_24
	  "The function hiIPCDebug() is out-of-date. Use ipcIPCDebug() instead.\n")
)

SK_REGISTER( HI2IPC_1 )
SK_REGISTER( HI2IPC_2 )
SK_REGISTER( HI2IPC_3 )
SK_REGISTER( HI2IPC_4 )
SK_REGISTER( HI2IPC_5 )
SK_REGISTER( HI2IPC_6 )
SK_REGISTER( HI2IPC_7 )
SK_REGISTER( HI2IPC_8 )
SK_REGISTER( HI2IPC_9 )
SK_REGISTER( HI2IPC_10 )
SK_REGISTER( HI2IPC_11 )
SK_REGISTER( HI2IPC_12 )
SK_REGISTER( HI2IPC_13 )
SK_REGISTER( HI2IPC_14 )
SK_REGISTER( HI2IPC_15 )
SK_REGISTER( HI2IPC_16 )
SK_REGISTER( HI2IPC_17 )
SK_REGISTER( HI2IPC_18 )
SK_REGISTER( HI2IPC_19 )
SK_REGISTER( HI2IPC_20 )
SK_REGISTER( HI2IPC_21 )
SK_REGISTER( HI2IPC_22 )
SK_REGISTER( HI2IPC_23 )
SK_REGISTER( HI2IPC_24 )
