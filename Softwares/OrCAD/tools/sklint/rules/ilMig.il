SK_RULE( listFunctions
        SK_CHANGED_IN("446")
        SK_INFO( listFunctions strcat(
                "\n\tThe semantics of this function is changed in 4.4.6.\n"
                "\tBy default, it lists the functions found in the cdsFinder\n"
                "\tdatabases under the two official cdsFinder database locations,\n"
                "\tas well as the directories as specified in the CDS_FINDER_PATH\n"
                "\tUNIX environment variable. But if the second (optional) argument\n"
                "\tis specified to t (e.g. listFunctions(t_pattern t)), it lists\n"
                "\tall isCallable Cadence public functions and user-defined SKILL\n"
                "\tfunctions that contain the given substring or match the given\n"
                "\tregular expression.\n" )
        )
)
SK_REGISTER( listFunctions )

SK_RULE( printFunctions
        SK_CHANGED_IN("446")
        SK_INFO( printFunctions strcat(
                "\n\tThe semantics of this function is changed in 4.4.6.\n"
                "\tBy default, it prints the functions found in the cdsFinder\n"
                "\tdatabases under the two official cdsFinder database locations,\n"
                "\tas well as the directories as specified in the CDS_FINDER_PATH\n"
                "\tUNIX environment variable. But if the third (optional) argument\n"
                "\tis specified to t (e.g. printFunctions(t_pattern nil t)), it\n"
                "\tlists all isCallable Cadence public functions and user-defined\n"
                "\tSKILL functions that contain the given substring or match the \n"
                "\tgiven regular expression.\n" )
        )
)
SK_REGISTER( printFunctions )

SK_RULE( _iliStdObjectp
	t ; force this message
	SK_WARNING( _iliStdObjectp strcat(
		"This function is PRIVATE. \n" 
		"Please use its equivalent form (classp x 'standardObject) instead. \n" 
		)
	)
)
SK_REGISTER( _iliStdObjectp )

SK_RULE( printstring
	t ; force this message
	SK_WARNING( printstring strcat(
		"This function is PRIVATE and may have been removed/renamed. \n" 
		"Please use its equivalent form (sprintf nil \"%%L\" x) instead. \n" 
		)
	)
)
SK_REGISTER( printstring )

SK_RULE( set_car
	t ; force this message
	SK_WARNING( set_car strcat(
		"This function is obsolete and may have been removed. \n" 
		"Please use the PUBLIC function setcar instead. \n" 
		)
	)
)
SK_REGISTER( set_car )

SK_RULE( set_cdr
	t ; force this message
	SK_WARNING( set_cdr strcat(
		"This function is obsolete and may have been removed. \n" 
		"Please use the PUBLIC function setcdr instead. \n" 
		)
	)
)
SK_REGISTER( set_cdr )

SK_RULE( list_to_vector
	t ; force this message
	SK_WARNING( list_to_vector strcat(
		"This function is obsolete and may have been removed. \n" 
		"Please use the PUBLIC function listToVector instead. \n" 
		)
	)
)
SK_REGISTER( list_to_vector )

SK_RULE( vector_to_list
	t ; force this message
	SK_WARNING( vector_to_list strcat(
		"This function is obsolete and may have been removed. \n" 
		"Please use the PUBLIC function vectorToList instead. \n" 
		)
	)
)
SK_REGISTER( vector_to_list )

SK_RULE( terpri
	t ; force this message
	SK_WARNING( terpri strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function newline instead. \n" 
		)
	)
)
SK_REGISTER( terpri )

SK_RULE( ilEval
	t ; force this message
	SK_WARNING( ilEval strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function eval instead. \n" 
		)
	)
)
SK_REGISTER( ilEval )

SK_RULE( scEval
	t ; force this message
	SK_WARNING( scEval strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function eval instead. \n" 
		)
	)
)
SK_REGISTER( scEval )

SK_RULE( ppfunction
	t ; force this message
	SK_WARNING( ppfunction strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function pprint instead. \n" 
		)
	)
)
SK_REGISTER( ppfunction )

SK_RULE( boolean?
	t ; force this message
	SK_WARNING( boolean? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function booleanp instead. \n" 
		)
	)
)
SK_REGISTER( boolean? )

SK_RULE( eq?
	t ; force this message
	SK_WARNING( eq? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function eq instead. \n" 
		)
	)
)
SK_REGISTER( eq? )

SK_RULE( equal?
	t ; force this message
	SK_WARNING( equal? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function equal instead. \n" 
		)
	)
)
SK_REGISTER( equal? )

SK_RULE( eqv?
	t ; force this message
	SK_WARNING( eqv? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function eqv instead. \n" 
		)
	)
)
SK_REGISTER( eqv? )

SK_RULE( even?
	t ; force this message
	SK_WARNING( even? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function evenp instead. \n" 
		)
	)
)
SK_REGISTER( even? )

SK_RULE( integer?
	t ; force this message
	SK_WARNING( integer? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function integerp instead. \n" 
		)
	)
)
SK_REGISTER( integer? )

SK_RULE( list?
	t ; force this message
	SK_WARNING( list? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function listp instead. \n" 
		)
	)
)
SK_REGISTER( list? )

SK_RULE( negative?
	t ; force this message
	SK_WARNING( negative? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function negativep instead. \n" 
		)
	)
)
SK_REGISTER( negative? )

SK_RULE( null?
	t ; force this message
	SK_WARNING( null? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function null instead. \n" 
		)
	)
)
SK_REGISTER( null? )

SK_RULE( odd?
	t ; force this message
	SK_WARNING( odd? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function oddp instead. \n" 
		)
	)
)
SK_REGISTER( odd? )

SK_RULE( pair?
	t ; force this message
	SK_WARNING( pair? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function pairp instead. \n" 
		)
	)
)
SK_REGISTER( pair? )

SK_RULE( real?
	t ; force this message
	SK_WARNING( real? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function realp instead. \n" 
		)
	)
)
SK_REGISTER( real? )

SK_RULE( symbol?
	t ; force this message
	SK_WARNING( symbol? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function symbolp instead. \n" 
		)
	)
)
SK_REGISTER( symbol? )

SK_RULE( vector?
	t ; force this message
	SK_WARNING( vector? strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function arrayp instead. \n" 
		)
	)
)
SK_REGISTER( vector? )

SK_RULE( stringToLower
	t ; force this message
	SK_WARNING( stringToLower strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function lowerCase instead. \n" 
		)
	)
)
SK_REGISTER( stringToLower )

SK_RULE( stringToUpper
	t ; force this message
	SK_WARNING( stringToUpper strcat(
		"This function is PRIVATE. \n" 
		"Please use the PUBLIC function upperCase instead. \n" 
		)
	)
)
SK_REGISTER( stringToUpper )

SK_RULE( cmanCreateContext     
	t ; force this message
	SK_ERROR( cmanCreateContext      strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanCreateContext      )

SK_RULE( cmanDestroyContext   
	t ; force this message
	SK_ERROR( cmanDestroyContext    strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanDestroyContext    )

SK_RULE( cmanDestroyMsg      
	t ; force this message
	SK_ERROR( cmanDestroyMsg       strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanDestroyMsg       )

SK_RULE( cmanDestroyTag     
	t ; force this message
	SK_ERROR( cmanDestroyTag      strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanDestroyTag      )

SK_RULE( cmanExportDataHandler
	t ; force this message
	SK_ERROR( cmanExportDataHandler strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanExportDataHandler )

SK_RULE( cmanExportDataString 
	t ; force this message
	SK_ERROR( cmanExportDataString  strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanExportDataString  )

SK_RULE( cmanFreeExportedData
	t ; force this message
	SK_ERROR( cmanFreeExportedData strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanFreeExportedData )

SK_RULE( cmanImportDataString
	t ; force this message
	SK_ERROR( cmanImportDataString strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanImportDataString )

SK_RULE( cmanRegMsgHandler               
	t ; force this message
	SK_ERROR( cmanRegMsgHandler                strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanRegMsgHandler                )

SK_RULE( cmanReleaseMsg                 
	t ; force this message
	SK_ERROR( cmanReleaseMsg                  strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanReleaseMsg                  )

SK_RULE( cmanRetagData                 
	t ; force this message
	SK_ERROR( cmanRetagData                  strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanRetagData                  )

SK_RULE( cmanSendMsg                  
	t ; force this message
	SK_ERROR( cmanSendMsg                   strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanSendMsg                   )

SK_RULE( cmanSendMsgNextPriority     
	t ; force this message
	SK_ERROR( cmanSendMsgNextPriority      strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanSendMsgNextPriority      )

SK_RULE( cmanSendMsgWithData        
	t ; force this message
	SK_ERROR( cmanSendMsgWithData         strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanSendMsgWithData         )

SK_RULE( cmanSetCrashMsg           
	t ; force this message
	SK_ERROR( cmanSetCrashMsg            strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanSetCrashMsg            )

SK_RULE( cmanStartTool            
	t ; force this message
	SK_ERROR( cmanStartTool             strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanStartTool             )

SK_RULE( cmanUnregMsgHandler     
	t ; force this message
	SK_ERROR( cmanUnregMsgHandler      strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanUnregMsgHandler      )

SK_RULE( cmanUpdateDataString   
	t ; force this message
	SK_ERROR( cmanUpdateDataString    strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanUpdateDataString    )

SK_RULE( cmanDisinterestNotify           
	t ; force this message
	SK_ERROR( cmanDisinterestNotify            strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanDisinterestNotify            )

SK_RULE( cmanExportString               
	t ; force this message
	SK_ERROR( cmanExportString                strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanExportString                )

SK_RULE( cmanImportString              
	t ; force this message
	SK_ERROR( cmanImportString               strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanImportString               )

SK_RULE( cmanInterestNotify            
	t ; force this message
	SK_ERROR( cmanInterestNotify             strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanInterestNotify             )

SK_RULE( cmanNotify                   
	t ; force this message
	SK_ERROR( cmanNotify                    strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanNotify                    )

SK_RULE( cmanToolStart               
	t ; force this message
	SK_ERROR( cmanToolStart                strcat(
		"This function has been deleted. Equivalent functionality \n" 
		"can be achieved by using Cadence's Message Passing \n" 
		"Subsystem (MPS). Please contact your Cadence Support \n" 
		"Representative for more information.\n" 
		)
	)
)
SK_REGISTER( cmanToolStart                )

SK_RULE( ilUpdateInstanceForRedefinedClass
	t ; force this message
	SK_WARNING( ilUpdateInstanceForRedefinedClass strcat(
		"This method has been deleted. \n" 
		"Please use the PUBLIC method updateInstanceForRedefinedClass instead. \n" 
		)
	)
)
SK_REGISTER( ilUpdateInstanceForRedefinedClass )
